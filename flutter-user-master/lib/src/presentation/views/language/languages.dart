import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tagyourtaxi_driver/src/presentation/views/loadingPage/loading.dart';
import 'package:tagyourtaxi_driver/src/presentation/views/login/login.dart';
import 'package:tagyourtaxi_driver/src/presentation/styles/styles.dart';
import 'package:tagyourtaxi_driver/src/l10n/l10n.dart';
import 'package:tagyourtaxi_driver/src/core/services/functions.dart';
import 'package:tagyourtaxi_driver/src/presentation/widgets/widgets.dart';

class Languages extends StatefulWidget {
  const Languages({Key? key}) : super(key: key);

  @override
  State<Languages> createState() => _LanguagesState();
}

class _LanguagesState extends State<Languages> {

  bool _isLoading = false;
  @override
  void initState() {
    choosenLanguage = choosenLanguage.isNotEmpty ? choosenLanguage : 'en';
    languageDirection =
        (choosenLanguage == 'ar' || choosenLanguage == 'ur' || choosenLanguage == 'iw')
            ? 'rtl'
            : 'ltr';
    super.initState();
  }

//navigate
  navigate() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const Login()));
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Material(
        child: Directionality(
      textDirection:
          (languageDirection == 'rtl') ? TextDirection.rtl : TextDirection.ltr,
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(media.width * 0.05, media.width * 0.05,
                media.width * 0.05, media.width * 0.05),
            height: media.height * 1,
            width: media.width * 1,
            color: page,
            child: Column(
              children: [
                Container(
                  height: media.width * 0.11 + MediaQuery.of(context).padding.top,
                  width: media.width * 1,
                  padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                  color: topBar,
                  child: Stack(
                    children: [
                      Container(
                        height: media.width * 0.11,
                        width: media.width * 1,
                        alignment: Alignment.center,
                        child: Text(
                          (choosenLanguage.isEmpty)
                              ? 'Choose Language'
                              : context.l10n.text_choose_language,
                          style: GoogleFonts.roboto(
                              color: textColor,
                              fontSize: media.width * sixteen,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: media.width * 0.05,
                ),
                SizedBox(
                  width: media.width * 0.9,
                  height: media.height * 0.16,
                  child: Image.asset(
                    'assets/images/selectLanguage.png',
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(
                  height: media.width * 0.1,
                ),
                //languages list
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: languagesCode
                          .map(
                            (value) => InkWell(
                              onTap: () {
                                setState(() {
                                  updateAppLanguage(value['code']);
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.all(media.width * 0.025),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      value['name'].toString(),
                                      style: GoogleFonts.roboto(
                                          fontSize: media.width * sixteen,
                                          color: textColor),
                                    ),
                                    Container(
                                      height: media.width * 0.05,
                                      width: media.width * 0.05,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              color: const Color(0xff222222),
                                              width: 1.2)),
                                      alignment: Alignment.center,
                                      child: (choosenLanguage == value['code'])
                                          ? Container(
                                              height: media.width * 0.03,
                                              width: media.width * 0.03,
                                              decoration: const BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Color(0xff222222)),
                                            )
                                          : Container(),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                //button
                (choosenLanguage != '')
                    ? Button(
                        onTap: () async {
                          setState(() {
                              _isLoading = true;
                            });
                          updateAppLanguage(choosenLanguage);
                          await getlangid();
                          setState(() {
                              _isLoading = false;
                            });
                          navigate();
                        },
                        text: context.l10n.text_confirm)
                    : Container(),
              ],
            ),
          ),

          //loader
            (_isLoading == true)
                        ? const Positioned(top: 0, child: Loading())
                        : Container()
        ],
      ),
    ));
  }
}
