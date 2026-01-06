import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tagyourtaxi_driver/functions/functions.dart';
import 'package:tagyourtaxi_driver/pages/onTripPage/map_page.dart';
import 'package:tagyourtaxi_driver/styles/styles.dart';
import 'package:tagyourtaxi_driver/translations/translation.dart';
import 'package:tagyourtaxi_driver/widgets/widgets.dart';

class AddFavAddressWidget extends StatelessWidget {
  final Function(String name) onChangeFavName;
  final Function(String name) onChangeFavNameText;
  final Function(bool change) onChangeFavAddress;
  final Function() button;

  const AddFavAddressWidget(
      {super.key,
      required this.onChangeFavName,
      required this.onChangeFavAddress,
      required this.onChangeFavNameText,
      required this.button});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Positioned(
        top: 0,
        child: Container(
          height: media.height * 1,
          width: media.width * 1,
          color: Colors.transparent.withValues(alpha: 0.6),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: media.width * 0.9,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      height: media.width * 0.1,
                      width: media.width * 0.1,
                      decoration:
                          BoxDecoration(shape: BoxShape.circle, color: page),
                      child: InkWell(
                        onTap: () {
                          onChangeFavName('');
                          onChangeFavAddress(false);
                        },
                        child: const Icon(Icons.cancel_outlined),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: media.width * 0.05,
              ),
              Container(
                padding: EdgeInsets.all(media.width * 0.05),
                width: media.width * 0.9,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12), color: page),
                child: Column(
                  children: [
                    Text(
                      languages[choosenLanguage]['text_saveaddressas'],
                      style: GoogleFonts.roboto(
                          fontSize: media.width * sixteen,
                          color: textColor,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: media.width * 0.025,
                    ),
                    Text(
                      favSelectedAddress,
                      style: GoogleFonts.roboto(
                          fontSize: media.width * twelve, color: textColor),
                    ),
                    SizedBox(
                      height: media.width * 0.025,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            FocusManager.instance.primaryFocus?.unfocus();
                            onChangeFavName('Home');
                          },
                          child: Container(
                            padding: EdgeInsets.all(media.width * 0.01),
                            child: Row(
                              children: [
                                Container(
                                  height: media.height * 0.05,
                                  width: media.width * 0.05,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.black,
                                      width: 1.2,
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: (favName == 'Home')
                                      ? Container(
                                          height: media.width * 0.03,
                                          width: media.width * 0.03,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.black,
                                          ),
                                        )
                                      : Container(),
                                ),
                                SizedBox(
                                  width: media.width * 0.01,
                                ),
                                Text(languages[choosenLanguage]['text_home'])
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            FocusManager.instance.primaryFocus?.unfocus();
                            onChangeFavName('Work');
                          },
                          child: Container(
                            padding: EdgeInsets.all(media.width * 0.01),
                            child: Row(
                              children: [
                                Container(
                                  height: media.height * 0.05,
                                  width: media.width * 0.05,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.black,
                                      width: 1.2,
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: (favName == 'Work')
                                      ? Container(
                                          height: media.width * 0.03,
                                          width: media.width * 0.03,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.black,
                                          ),
                                        )
                                      : Container(),
                                ),
                                SizedBox(
                                  width: media.width * 0.01,
                                ),
                                Text(languages[choosenLanguage]['text_work'])
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            FocusManager.instance.primaryFocus?.unfocus();
                            onChangeFavName('Others');
                          },
                          child: Container(
                            padding: EdgeInsets.all(media.width * 0.01),
                            child: Row(
                              children: [
                                Container(
                                  height: media.height * 0.05,
                                  width: media.width * 0.05,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: Colors.black, width: 1.2)),
                                  alignment: Alignment.center,
                                  child: (favName == 'Others')
                                      ? Container(
                                          height: media.width * 0.03,
                                          width: media.width * 0.03,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.black,
                                          ),
                                        )
                                      : Container(),
                                ),
                                SizedBox(
                                  width: media.width * 0.01,
                                ),
                                Text(languages[choosenLanguage]['text_others'])
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    (favName == 'Others')
                        ? Container(
                            padding: EdgeInsets.all(media.width * 0.025),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border:
                                    Border.all(color: borderLines, width: 1.2)),
                            child: TextField(
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: languages[choosenLanguage]
                                      ['text_enterfavname'],
                                  hintStyle: GoogleFonts.roboto(
                                      fontSize: media.width * twelve,
                                      color: hintColor)),
                              maxLines: 1,
                              onChanged: (val) {
                                onChangeFavNameText(val);
                              },
                            ),
                          )
                        : Container(),
                    SizedBox(
                      height: media.width * 0.05,
                    ),
                    Button(
                        onTap: () => button(),
                        text: languages[choosenLanguage]['text_confirm'])
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
