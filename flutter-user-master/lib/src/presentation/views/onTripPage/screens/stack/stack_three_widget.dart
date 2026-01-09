import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tagyourtaxi_driver/src/core/services/app_state.dart';
import 'package:tagyourtaxi_driver/src/core/services/functions.dart';
import 'package:tagyourtaxi_driver/src/data/models/address_list.dart';
import 'package:tagyourtaxi_driver/src/presentation/styles/styles.dart';
import 'package:tagyourtaxi_driver/src/presentation/translations/translation.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class StackThreeWidget extends StatelessWidget {
  final int bottom;
  final bool pickaddress;
  final Function() changePosition;
  final Function(String) addDirections;
  final Function() pickup;

  const StackThreeWidget({
    super.key,
    required this.bottom,
    required this.pickaddress,
    required this.changePosition,
    required this.addDirections,
    required this.pickup,
  });

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Positioned(
      top: 0,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        width: media.width * 1,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
          color: (bottom == 0) ? null : page,
        ),
        padding:
            EdgeInsets.only(top: MediaQuery.of(context).padding.top + 12.5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            InkWell(
              onTap: () => changePosition(),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                margin: EdgeInsets.only(
                    left: media.width * 0.05,
                    right: media.width * 0.05,
                    bottom: media.width * 0.05),
                padding: EdgeInsets.fromLTRB(media.width * 0.03,
                    media.width * 0.01, media.width * 0.03, media.width * 0.01),
                width: (bottom == 0) ? media.width * 0.75 : media.width * 0.9,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.fromRGBO(255, 255, 255, 1),
                      Color.fromRGBO(255, 255, 255, 0.2),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(media.width * 0.02),
                ),
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Text(
                      'Ваш адрес >',
                      style: GoogleFonts.roboto(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: textColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      children: [
                        SizedBox(width: media.width * 0.02),
                        (pickaddress == true && bottom == 1)
                            ? Expanded(
                                child: TextField(
                                  autofocus: true,
                                  decoration: InputDecoration(
                                    contentPadding: (languageDirection == 'rtl')
                                        ? EdgeInsets.only(
                                            bottom: media.width * 0.035)
                                        : EdgeInsets.only(
                                            bottom: media.width * 0.047),
                                    hintText: languages[choosenLanguage]
                                        ['text_4lettersforautofill'],
                                    hintStyle: GoogleFonts.roboto(
                                        fontSize: media.width * twelve,
                                        color: hintColor),
                                    border: InputBorder.none,
                                  ),
                                  maxLines: 1,
                                  onChanged: addDirections,
                                ),
                              )
                            : Expanded(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: media.width * 0.55,
                                      child: Text(
                                        (addressList
                                                .where((element) =>
                                                    element.id == 'pickup')
                                                .isNotEmpty)
                                            ? addressList
                                                .firstWhere(
                                                  (element) =>
                                                      element.id == 'pickup',
                                                  orElse: () => AddressList(
                                                    id: '',
                                                    address: '',
                                                    latlng:
                                                        const Point(
                                                            latitude: 0.0,
                                                            longitude: 0.0),
                                                  ),
                                                )
                                                .address
                                            : languages[choosenLanguage]
                                                ['text_4lettersforautofill'],
                                        style: GoogleFonts.roboto(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: textColor,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    if (addressList
                                            .where((element) =>
                                                element.id == 'pickup')
                                            .isNotEmpty &&
                                        favAddress.length < 4)
                                      InkWell(
                                        onTap: () => pickup(),
                                        child: Icon(
                                          Icons.favorite_outline,
                                          size: media.width * 0.05,
                                          color: favAddress
                                                  .where(
                                                    (element) =>
                                                        element[
                                                            'pick_address'] ==
                                                        addressList
                                                            .firstWhere(
                                                                (element) =>
                                                                    element
                                                                        .id ==
                                                                    'pickup')
                                                            .address,
                                                  )
                                                  .isEmpty
                                              ? Colors.black
                                              : buttonColor,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
