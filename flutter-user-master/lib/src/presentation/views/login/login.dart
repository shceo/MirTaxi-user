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

  String _langShort(String code) {
    final c = code.toLowerCase();
    if (c == 'uz' || c == 'uzb') return "O'zbek";
    if (c == 'ru' || c == 'rus') return "Rus";
    if (c == 'en') return "En";
    return code.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;

    return Material(
      child: Directionality(
        textDirection: (languageDirection == 'rtl') ? TextDirection.rtl : TextDirection.ltr,
        child: AnimatedBuilder(
          animation: Listenable.merge([_viewModel, controller]),
          builder: (context, _) {
            final canSubmit = _viewModel.canSubmitPhone(controller.text);

            return Stack(
              children: [
                if (_viewModel.hasCountries)
                  Container(
                    color: const Color(0xFFF3F4F6),
                    padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                    width: media.width,
                    height: media.height,
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(minHeight: constraints.maxHeight),
                            child: IntrinsicHeight(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                child: Column(
                                  children: [
                                    const SizedBox(height: 10),
                                    Center(
                                      child: Image.asset(
                                        'assets/images/logo.png',
                                        height: 130,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    const SizedBox(height: 18),
                                    Expanded(
                                      child: Align(
                                        alignment: Alignment.bottomCenter,
                                        child: ConstrainedBox(
                                          constraints: const BoxConstraints(maxWidth: 430),
                                          child: _LoginCard(
                                            titlePhone: context.l10n.text_phone_number,
                                            titleLang: context.l10n.text_choose_language,
                                            buttonText: context.l10n.text_login,
                                            canSubmit: canSubmit,
                                            selectedLanguage: _selectedLanguage,
                                            onSelectLanguage: (code) {
                                              setState(() {
                                                _selectedLanguage = code;
                                                updateAppLanguage(code);
                                              });
                                            },
                                            phoneController: controller,
                                            langShort: _langShort,
                                            onSubmit: () async {
                                              FocusManager.instance.primaryFocus?.unfocus();
                                              updateAppLanguage(_selectedLanguage);
                                              HttpResult val = await _viewModel.requestOtp(controller.text);
                                              if (val.isSuccess) {
                                                phoneAuthCheck = false;
                                                _navigateToOtp();
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                else
                  Container(
                    width: media.width,
                    height: media.height,
                    color: page,
                  ),
                (_viewModel.hasInternet == false)
                    ? Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: NoInternet(
                          onTap: () {
                            _viewModel.retryFetchCountries();
                          },
                        ),
                      )
                    : const SizedBox.shrink(),
                (_viewModel.isLoading == true)
                    ? const Positioned(top: 0, left: 0, right: 0, child: Loading())
                    : const SizedBox.shrink(),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _LoginCard extends StatelessWidget {
  const _LoginCard({
    required this.titlePhone,
    required this.titleLang,
    required this.buttonText,
    required this.canSubmit,
    required this.selectedLanguage,
    required this.onSelectLanguage,
    required this.phoneController,
    required this.onSubmit,
    required this.langShort,
  });

  final String titlePhone;
  final String titleLang;
  final String buttonText;

  final bool canSubmit;
  final String selectedLanguage;
  final void Function(String code) onSelectLanguage;

  final TextEditingController phoneController;
  final VoidCallback onSubmit;

  final String Function(String code) langShort;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;

    final titleStyle = GoogleFonts.roboto(
      fontSize: 16,
      fontWeight: FontWeight.w700,
      color: const Color(0xFF6B7280),
    );

    final divider = const Divider(height: 1, thickness: 1, color: Color(0xFFE5E7EB));

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            offset: Offset(0, 10),
            blurRadius: 30,
            color: Color.fromRGBO(0, 0, 0, 0.10),
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(titlePhone, style: titleStyle),
          const SizedBox(height: 10),
          _PhoneField(controller: phoneController),
          const SizedBox(height: 16),
          Text(titleLang, style: titleStyle.copyWith(fontSize: 15)),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFFE5E7EB), width: 1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (int i = 0; i < languagesCode.length; i++) ...[
                    _LanguageRow(
                      title: languagesCode[i]['name'].toString(),
                      subtitle: langShort(languagesCode[i]['code'].toString()),
                      selected: selectedLanguage == languagesCode[i]['code'].toString(),
                      onTap: () => onSelectLanguage(languagesCode[i]['code'].toString()),
                    ),
                    if (i != languagesCode.length - 1) divider,
                  ]
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          IgnorePointer(
            ignoring: !canSubmit,
            child: Opacity(
              opacity: canSubmit ? 1 : 0.55,
              child: SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: onSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF6D365),
                    foregroundColor: const Color(0xFF111827),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    buttonText,
                    style: t.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PhoneField extends StatelessWidget {
  const _PhoneField({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final dial = countries[phcode]['dial_code'].toString();

    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD1D5DB), width: 1),
      ),
      child: Row(
        children: [
          InkWell(
            onTap: () async {},
            child: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Text(
                dial,
                style: GoogleFonts.roboto(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF111827),
                ),
              ),
            ),
          ),
          Container(width: 1, height: 26, color: const Color(0xFFE5E7EB)),
          const SizedBox(width: 10),
          Expanded(
            child: TextFormField(
              controller: controller,
              onChanged: (val) {
                phnumber = controller.text;
                if (controller.text.length == countries[phcode]['dial_max_length']) {
                  FocusManager.instance.primaryFocus?.unfocus();
                }
              },
              maxLength: countries[phcode]['dial_max_length'],
              style: GoogleFonts.roboto(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF111827),
                letterSpacing: 1,
              ),
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: '94 555 77 77',
                counterText: '',
                hintStyle: GoogleFonts.roboto(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF9CA3AF),
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LanguageRow extends StatelessWidget {
  const _LanguageRow({
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.roboto(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF111827),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.roboto(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF9CA3AF),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Container(
              height: 26,
              width: 26,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? const Color(0xFF22C55E) : const Color(0xFFE5E7EB),
              ),
              alignment: Alignment.center,
              child: selected
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
