import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tagyourtaxi_driver/src/data/models/http_result.dart';
import 'package:tagyourtaxi_driver/src/core/services/functions.dart';
import 'package:tagyourtaxi_driver/src/presentation/styles/styles.dart';
import 'package:tagyourtaxi_driver/src/l10n/l10n.dart';
import 'package:tagyourtaxi_driver/src/presentation/viewmodels/auth_view_model.dart';
import 'package:tagyourtaxi_driver/src/presentation/views/loadingPage/loading.dart';
import 'package:tagyourtaxi_driver/src/presentation/views/login/otp_page.dart';
import 'package:tagyourtaxi_driver/src/presentation/views/noInternet/nointernet.dart';
import 'package:tagyourtaxi_driver/src/presentation/widgets/widgets.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController controller = TextEditingController();
  late final AuthViewModel _viewModel;
  String _selectedLanguage = 'en';

  @override
  void initState() {
    super.initState();
    _viewModel = AuthViewModel();
    _viewModel.loadCountries();
    _selectedLanguage = choosenLanguage.isNotEmpty ? choosenLanguage : 'en';
    updateAppLanguage(_selectedLanguage);
  }

  @override
  void dispose() {
    _viewModel.dispose();
    controller.dispose();
    super.dispose();
  }

  void _navigateToOtp() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const Otp()));
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Material(
      child: Directionality(
        textDirection: (languageDirection == 'rtl') ? TextDirection.rtl : TextDirection.ltr,
        child: AnimatedBuilder(
          animation: _viewModel,
          builder: (context, _) {
            final canSubmit = _viewModel.canSubmitPhone(controller.text);
            return Stack(
              children: [
                if (_viewModel.hasCountries)
                  Container(
                    color: backColor,
                    padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                    height: media.height * 1,
                    width: media.width * 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 100),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/logo.png',
                              height: 110,
                              width: 224,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: media.height * 0.159,
                        ),
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.all(12),
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: const [
                                BoxShadow(
                                  offset: Offset(0, 1),
                                  blurRadius: 4,
                                  color: Color.fromRGBO(0, 0, 0, 0.25),
                                )
                              ],
                            ),
                            child: Column(
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    context.l10n.text_phone_number,
                                    style: GoogleFonts.roboto(
                                        fontSize: media.width * sixteen,
                                        fontWeight: FontWeight.w600,
                                        color: textColor),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  padding: const EdgeInsets.only(bottom: 5),
                                  height: 55,
                                  width: media.width * 1 - (media.width * 0.08 * 2),
                                  decoration: BoxDecoration(border: Border(bottom: BorderSide(color: underline))),
                                  child: Row(
                                    children: [
                                      InkWell(
                                        onTap: () async {},
                                        child: Container(
                                          height: 50,
                                          alignment: Alignment.center,
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Image.network(countries[phcode]['flag']),
                                              SizedBox(
                                                width: media.width * 0.02,
                                              ),
                                              Text(
                                                countries[phcode]['dial_code'].toString(),
                                                style: GoogleFonts.roboto(
                                                    fontSize: media.width * sixteen, color: textColor),
                                              ),
                                              const SizedBox(
                                                width: 2,
                                              ),
                                              const Icon(Icons.keyboard_arrow_down)
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Container(
                                        width: 1,
                                        height: media.width * 0.0693,
                                        color: buttonColor,
                                      ),
                                      const SizedBox(width: 10),
                                      Container(
                                        height: 50,
                                        alignment: Alignment.center,
                                        width: media.width * 0.5,
                                        child: TextFormField(
                                          controller: controller,
                                          onChanged: (val) {
                                            setState(() {
                                              phnumber = controller.text;
                                            });
                                            if (controller.text.length == countries[phcode]['dial_max_length']) {
                                              FocusManager.instance.primaryFocus?.unfocus();
                                            }
                                          },
                                          maxLength: countries[phcode]['dial_max_length'],
                                          style: GoogleFonts.roboto(
                                              fontSize: media.width * sixteen, color: textColor, letterSpacing: 1),
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            hintText: context.l10n.text_phone_number,
                                            counterText: '',
                                            hintStyle: GoogleFonts.roboto(
                                                fontSize: media.width * sixteen, color: textColor.withOpacity(0.7)),
                                            border: InputBorder.none,
                                            enabledBorder: InputBorder.none,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(height: media.height * 0.02),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    context.l10n.text_choose_language,
                                    style: GoogleFonts.roboto(
                                        fontSize: media.width * fourteen,
                                        fontWeight: FontWeight.w600,
                                        color: textColor),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Expanded(
                                  child: SingleChildScrollView(
                                    physics: const BouncingScrollPhysics(),
                                    child: Column(
                                      children: languagesCode
                                          .map((value) {
                                            final code = value['code'].toString();
                                            final name = value['name'].toString();
                                            final isSelected = _selectedLanguage == code;
                                            return InkWell(
                                              onTap: () {
                                                setState(() {
                                                  _selectedLanguage = code;
                                                  updateAppLanguage(code);
                                                });
                                              },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(vertical: media.width * 0.02),
                                                decoration: BoxDecoration(
                                                  border: Border(
                                                    bottom: BorderSide(color: underline),
                                                  ),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          name,
                                                          style: GoogleFonts.roboto(
                                                              fontSize: media.width * sixteen,
                                                              color: textColor),
                                                        ),
                                                        const SizedBox(height: 2),
                                                        Text(
                                                          code.toUpperCase(),
                                                          style: GoogleFonts.roboto(
                                                              fontSize: media.width * twelve,
                                                              color: textColor.withOpacity(0.6)),
                                                        ),
                                                      ],
                                                    ),
                                                    Container(
                                                      height: media.width * 0.07,
                                                      width: media.width * 0.07,
                                                      decoration: BoxDecoration(
                                                          shape: BoxShape.circle,
                                                          border: Border.all(
                                                              color: const Color(0xff222222), width: 1.2)),
                                                      alignment: Alignment.center,
                                                      child: isSelected
                                                          ? Container(
                                                              height: media.width * 0.04,
                                                              width: media.width * 0.04,
                                                              decoration: const BoxDecoration(
                                                                  shape: BoxShape.circle, color: Color(0xff222222)),
                                                            )
                                                          : Container(),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            );
                                          })
                                          .toList(),
                                    ),
                                  ),
                                ),
                                SizedBox(height: media.height * 0.02),
                                if (canSubmit)
                                  Container(
                                    width: media.width * 1 - media.width * 0.08,
                                    alignment: Alignment.center,
                                    child: Button(
                                      onTap: () async {
                                        FocusManager.instance.primaryFocus?.unfocus();
                                        updateAppLanguage(_selectedLanguage);
                                        HttpResult val = await _viewModel.requestOtp(controller.text);
                                        if (val.isSuccess) {
                                          phoneAuthCheck = false;
                                          _navigateToOtp();
                                        }
                                      },
                                      text: context.l10n.text_login,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  Container(
                    height: media.height * 1,
                    width: media.width * 1,
                    color: page,
                  ),

                //No internet
                (_viewModel.hasInternet == false)
                    ? Positioned(
                        top: 0,
                        child: NoInternet(onTap: () {
                          _viewModel.retryFetchCountries();
                        }))
                    : Container(),

                //loader
                (_viewModel.isLoading == true) ? const Positioned(top: 0, child: Loading()) : Container()
              ],
            );
          },
        ),
      ),
    );
  }
}
