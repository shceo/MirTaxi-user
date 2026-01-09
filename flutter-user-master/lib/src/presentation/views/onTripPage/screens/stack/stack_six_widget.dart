import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tagyourtaxi_driver/src/core/services/functions.dart';
import 'package:tagyourtaxi_driver/src/presentation/styles/styles.dart';
import 'package:tagyourtaxi_driver/src/l10n/l10n.dart';
import 'package:tagyourtaxi_driver/src/presentation/widgets/app/app_svg_icon.dart';

class StackSixWidget extends StatelessWidget {
  final int bottom;
  final bool dropaddress;
  final bool pickaddress;
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
    var media = MediaQuery.of(context).size;
    return Positioned(
      bottom: 0,
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
              if (!(dropaddress == true && bottom == 1))
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
              else
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
              if (lastAddress.isNotEmpty && bottom == 0)
                Container(
                  margin: const EdgeInsets.only(top: 16),
                  child: Column(
                    children: [
                      for (int i = 0;
                          i < (lastAddress.length > 3 ? 3 : lastAddress.length);
                          i++)
                        InkWell(
                          onTap: () => onChange6(i),
                          child: Container(
                            width: media.width * 0.9,
                            padding: EdgeInsets.only(
                                top: media.width * 0.04,
                                bottom: media.width * 0.04),
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  width: 1,
                                  color: Color.fromRGBO(201, 201, 201, 1),
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const AppSvgAsset('assets/icons/location.svg'),
                                SizedBox(
                                  width: media.width * 0.8,
                                  child: Text(
                                    lastAddress[i].dropAddress,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.roboto(
                                      fontSize: media.width * twenty,
                                      color: textColor,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.zero,
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      if (addAutoFill.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: addAutoFill
                              .asMap()
                              .map(
                                (i, value) {
                                  return MapEntry(
                                    i,
                                    (i < 5)
                                        ? Container(
                                            padding: EdgeInsets.fromLTRB(
                                                0,
                                                media.width * 0.04,
                                                0,
                                                media.width * 0.04),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                  height: media.width * 0.1,
                                                  width: media.width * 0.1,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.grey[200],
                                                  ),
                                                  child: const Icon(
                                                    Icons.access_time,
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () => onChange4(i),
                                                  child: SizedBox(
                                                    width: media.width * 0.7,
                                                    child: Text(
                                                      addAutoFill[i]
                                                          ['description'],
                                                      style: GoogleFonts.roboto(
                                                        fontSize: media.width *
                                                            twelve,
                                                        color: textColor,
                                                      ),
                                                      maxLines: 2,
                                                    ),
                                                  ),
                                                ),
                                                if (favAddress.length < 4)
                                                  InkWell(
                                                    onTap: () => onChange5(i),
                                                    child: Icon(
                                                      Icons.favorite_outline,
                                                      size: media.width * 0.05,
                                                      color: favAddress
                                                              .where((element) =>
                                                                  element[
                                                                      'pick_address'] ==
                                                                  addAutoFill[i]
                                                                      [
                                                                      'description'])
                                                              .isNotEmpty
                                                          ? buttonColor
                                                          : Colors.black,
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          )
                                        : Container(),
                                  );
                                },
                              )
                              .values
                              .toList(),
                        ),
                      if (bottom == 1) SizedBox(height: media.width * 0.05),
                      if (favAddress.isNotEmpty && bottom == 1)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: media.width * 0.9,
                              child: Text(
                                (pickaddress == true)
                                    ? context.l10n.text_pick_suggestion
                                    : context.l10n.text_drop_suggestion,
                                style: GoogleFonts.roboto(
                                  fontSize: media.width * sixteen,
                                  color: textColor,
                                  fontWeight: FontWeight.bold,
                                ),
                                textDirection: (languageDirection == 'rtl')
                                    ? TextDirection.rtl
                                    : TextDirection.ltr,
                              ),
                            ),
                            Column(
                              children: favAddress
                                  .asMap()
                                  .map(
                                    (i, value) {
                                      return MapEntry(
                                        i,
                                        InkWell(
                                          onTap: () => onChange6(i),
                                          child: Container(
                                            width: media.width * 0.9,
                                            padding: EdgeInsets.only(
                                                top: media.width * 0.03,
                                                bottom: media.width * 0.03),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  favAddress[i]['address_name'],
                                                  style: GoogleFonts.roboto(
                                                      fontSize: media.width *
                                                          fourteen,
                                                      color: textColor),
                                                ),
                                                SizedBox(
                                                  height: media.width * 0.03,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    (favAddress[i][
                                                                'address_name'] ==
                                                            'Home')
                                                        ? Image.asset(
                                                            'assets/images/home.png',
                                                            color: Colors.black,
                                                            width: media.width *
                                                                0.075,
                                                          )
                                                        : (favAddress[i][
                                                                    'address_name'] ==
                                                                'Work')
                                                            ? Image.asset(
                                                                'assets/images/briefcase.png',
                                                                color: Colors
                                                                    .black,
                                                                width: media
                                                                        .width *
                                                                    0.075,
                                                              )
                                                            : Image.asset(
                                                                'assets/images/navigation.png',
                                                                color: Colors
                                                                    .black,
                                                                width: media
                                                                        .width *
                                                                    0.075,
                                                              ),
                                                    SizedBox(
                                                      width: media.width * 0.8,
                                                      child: Text(
                                                        favAddress[i]
                                                            ['pick_address'],
                                                        style:
                                                            GoogleFonts.roboto(
                                                          fontSize:
                                                              media.width *
                                                                  twelve,
                                                          color: textColor,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  )
                                  .values
                                  .toList(),
                            ),
                          ],
                        ),
                      if (bottom == 1) SizedBox(height: media.width * 0.05),
                      if (bottom == 1)
                        InkWell(
                          onTap: () => onChange7(),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: const Color.fromRGBO(255, 220, 113, 1),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: media.width * 0.05,
                                  child: Image.asset(
                                    (dropaddress == true)
                                        ? 'assets/images/dropmarker.png'
                                        : 'assets/images/pickupmarker.png',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                SizedBox(
                                  width: media.width * 0.025,
                                ),
                                Text(
                                  context.l10n.text_chooseonmap,
                                  style: GoogleFonts.roboto(
                                    fontSize: media.width * fourteen,
                                    color: textColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
