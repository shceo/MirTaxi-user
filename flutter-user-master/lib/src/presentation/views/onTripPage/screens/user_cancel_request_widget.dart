import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tagyourtaxi_driver/src/core/services/functions.dart';
import 'package:tagyourtaxi_driver/src/presentation/styles/styles.dart';
import 'package:tagyourtaxi_driver/src/presentation/translations/translation.dart';
import 'package:tagyourtaxi_driver/src/presentation/widgets/widgets.dart';

class UserCancelRequestWidget extends StatelessWidget {
  final Function() onTap;

  const UserCancelRequestWidget({super.key, required this.onTap});

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
              Container(
                width: media.width * 0.9,
                padding: EdgeInsets.all(media.width * 0.05),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12), color: page),
                child: Column(
                  children: [
                    Text(
                      languages[choosenLanguage]['text_cancelsuccess'],
                      style: GoogleFonts.roboto(
                          fontSize: media.width * fourteen,
                          fontWeight: FontWeight.w600,
                          color: textColor),
                    ),
                    SizedBox(
                      height: media.width * 0.05,
                    ),
                    Button(
                        onTap: () {
                          onTap();
                        },
                        text: languages[choosenLanguage]['text_ok'])
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
