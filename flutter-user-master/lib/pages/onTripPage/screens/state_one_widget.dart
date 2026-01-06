import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tagyourtaxi_driver/functions/functions.dart';
import 'package:tagyourtaxi_driver/styles/styles.dart';
import 'package:tagyourtaxi_driver/translations/translation.dart';

class StateOneWidget extends StatelessWidget {
  final Function() onTap;

  const StateOneWidget({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Container(
      height: media.height * 1,
      width: media.width * 1,
      alignment: Alignment.center,
      child: Container(
        padding: EdgeInsets.all(media.width * 0.05),
        width: media.width * 0.6,
        height: media.width * 0.3,
        decoration: BoxDecoration(
          color: page,
          boxShadow: [
            BoxShadow(
              blurRadius: 5,
              color: Colors.black.withValues(alpha: 0.1),
              spreadRadius: 2,
            )
          ],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              languages[choosenLanguage]['text_enable_location'],
              style: GoogleFonts.roboto(
                fontSize: media.width * sixteen,
                color: textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: () {
                  onTap();
                },
                child: Text(
                  languages[choosenLanguage]['text_ok'],
                  style: GoogleFonts.roboto(
                    fontWeight: FontWeight.bold,
                    fontSize: media.width * twenty,
                    color: buttonColor,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
