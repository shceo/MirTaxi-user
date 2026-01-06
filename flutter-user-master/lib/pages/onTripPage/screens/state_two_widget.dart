import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tagyourtaxi_driver/functions/functions.dart';
import 'package:tagyourtaxi_driver/styles/styles.dart';
import 'package:tagyourtaxi_driver/translations/translation.dart';
import 'package:tagyourtaxi_driver/widgets/widgets.dart';

class StateTwoWidget extends StatelessWidget {
  final Function() onTap;

  const StateTwoWidget({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.all(media.width * 0.025),
      height: media.height * 1,
      width: media.width * 1,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: media.height * 0.31,
            child: Image.asset(
              'assets/images/allow_location_permission.png',
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(
            height: media.width * 0.05,
          ),
          Text(
            languages[choosenLanguage]['text_trustedtaxi'],
            style: GoogleFonts.roboto(
                fontSize: media.width * eighteen, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: media.width * 0.025,
          ),
          Text(
            languages[choosenLanguage]['text_allowpermission1'],
            style: GoogleFonts.roboto(
              fontSize: media.width * fourteen,
            ),
          ),
          Text(
            languages[choosenLanguage]['text_allowpermission2'],
            style: GoogleFonts.roboto(
              fontSize: media.width * fourteen,
            ),
          ),
          SizedBox(
            height: media.width * 0.05,
          ),
          Container(
            padding: EdgeInsets.all(media.width * 0.05),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: media.width * 0.075,
                  width: media.width * 0.075,
                  child: const Icon(Icons.location_on_outlined),
                ),
                SizedBox(
                  width: media.width * 0.025,
                ),
                SizedBox(
                  width: media.width * 0.7,
                  child: Text(
                    languages[choosenLanguage]['text_loc_permission_user'],
                    style: GoogleFonts.roboto(
                      fontSize: media.width * fourteen,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(media.width * 0.05),
            child: Button(
              onTap: () {
                onTap();
              },
              text: languages[choosenLanguage]['text_continue'],
            ),
          ),
        ],
      ),
    );
  }
}
