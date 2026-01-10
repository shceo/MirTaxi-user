import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tagyourtaxi_driver/src/core/services/functions.dart';
import 'package:tagyourtaxi_driver/src/presentation/styles/styles.dart';
import 'package:tagyourtaxi_driver/src/l10n/l10n.dart';
import 'package:tagyourtaxi_driver/src/presentation/views/onTripPage/screens/stack/stack_six_content.dart';

class StackSixWidget extends StatelessWidget {
  final int bottom;
  final bool dropaddress;
  final bool pickaddress;
  final bool isMapMoving;
  final Function(DragUpdateDetails)? onChange1;
  final Function() onChange2;
  final Function(String) onChange3;
  final Function(int i) onChange4;
  final Function(int i) onChange5;
  final Function(int i) onChange6;
  final Function() onChange7;

  const StackSixWidget({
    super.key,
    required this.bottom,
    required this.dropaddress,
    required this.pickaddress,
    required this.isMapMoving,
    required this.onChange1,
    required this.onChange2,
    required this.onChange3,
    required this.onChange4,
    required this.onChange5,
    required this.onChange6,
    required this.onChange7,
  });

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    final hideOffset = media.width * 0.46;
    final isHidden = isMapMoving && bottom == 0;
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      bottom: isHidden ? -hideOffset : 0,
      child: GestureDetector(
        onPanUpdate: (val) => onChange1!(val),
        child: AnimatedContainer(
          padding: EdgeInsets.fromLTRB(
              media.width * 0.05, media.width * 0.03, media.width * 0.05, 0),
          duration: const Duration(milliseconds: 200),
          height: (bottom == 0)
              ? media.width * 0.8
              : media.height * 1 -
                  (MediaQuery.of(context).padding.top +
                      12.5 +
                      media.width * 0.12),
          width: media.width * 1,
          decoration: BoxDecoration(
            color: page,
            boxShadow: bottom == 0
                ? [
                    BoxShadow(
                      blurRadius: 4,
                      color: Colors.black.withValues(alpha: 0.25),
                      offset: const Offset(0, 1),
                    ),
                  ]
                : [],
            borderRadius: BorderRadius.only(
              topLeft: bottom == 0 ? const Radius.circular(24) : Radius.zero,
              topRight: bottom == 0 ? const Radius.circular(24) : Radius.zero,
            ),
          ),
          child: Column(
            children: [
              if (bottom == 0)
                Container(
                  height: media.width * 0.01,
                  width: media.width * 0.2,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(media.width * 0.01),
                    color: Colors.grey,
                  ),
                ),
              SizedBox(height: media.width * 0.03),
              if (bottom == 0)
                GestureDetector(
                  onTap: () => onChange2(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: const Color.fromRGBO(255, 220, 113, 1),
                    ),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/flag.svg',
                          height: media.width * 0.05,
                          width: media.width * 0.05,
                        ),
                        const Spacer(),
                        Text(
                          'Куда едем?',
                          style: GoogleFonts.roboto(
                            fontSize: media.width * twenty,
                            color: const Color.fromRGBO(0, 0, 0, 1),
                          ),
                        ),
                        const Spacer(),
                        SvgPicture.asset(
                          'assets/icons/right.svg',
                          height: media.width * 0.04,
                          width: media.width * 0.04,
                        ),
                      ],
                    ),
                  ),
                )
              else if (dropaddress == true)
                Container(
                  padding: EdgeInsets.fromLTRB(
                    media.width * 0.03,
                    media.width * 0.01,
                    media.width * 0.03,
                    media.width * 0,
                  ),
                  height: media.width *
                      ((dropaddress == true && bottom == 1) ? 0.1 : 0.16),
                  width: media.width * 0.9,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey.withValues(alpha: 0.5),
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(media.width * 0.02),
                    color: Colors.grey.withValues(alpha: 0.5),
                  ),
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      SizedBox(width: media.width * 0.02),
                      Expanded(
                        child: TextField(
                          autofocus: true,
                          decoration: InputDecoration(
                            contentPadding: (languageDirection == 'rtl')
                                ? EdgeInsets.only(bottom: media.width * 0.035)
                                : EdgeInsets.only(bottom: media.width * 0.047),
                            border: InputBorder.none,
                            hintText: context.l10n.text_4lettersforautofill,
                            hintStyle: GoogleFonts.roboto(
                              fontSize: media.width * twelve,
                              color: hintColor,
                            ),
                          ),
                          maxLines: 1,
                          onChanged: (val) => onChange3(val),
                        ),
                      ),
                    ],
                  ),
                ),
              Expanded(
                child: (bottom == 0)
                    ? StackSixCollapsedContent(
                        onChange4: onChange4,
                        onChange5: onChange5,
                        onChange6: onChange6,
                      )
                    : StackSixExpandedContent(
                        pickaddress: pickaddress,
                        dropaddress: dropaddress,
                        onChange4: onChange4,
                        onChange5: onChange5,
                        onChange6: onChange6,
                        onChange7: onChange7,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
