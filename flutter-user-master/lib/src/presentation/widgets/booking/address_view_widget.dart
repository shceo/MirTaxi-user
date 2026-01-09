import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tagyourtaxi_driver/src/core/services/app_state.dart';
import 'package:tagyourtaxi_driver/src/presentation/styles/styles.dart';

class AddressViewWidget extends StatelessWidget {
  final dynamic userRequestData;

  const AddressViewWidget({super.key, this.userRequestData});

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: borderLines, width: 1.2),
        borderRadius: BorderRadius.circular(12),
      ),
      width: media.width * 0.9,
      child: Column(
        children: [
          (userRequestData['is_rental'] != true && userRequestData['drop_address'] != null)
              ? Container(
                  padding: EdgeInsets.all(media.width * 0.034),
                  height: media.width * 0.21,
                  child: Row(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            height: media.width * 0.025,
                            width: media.width * 0.025,
                            alignment: Alignment.center,
                            decoration:
                                BoxDecoration(shape: BoxShape.circle, color: const Color(0xff319900).withOpacity(0.3)),
                            child: Container(
                              height: media.width * 0.01,
                              width: media.width * 0.01,
                              decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xff319900)),
                            ),
                          ),
                          Column(
                            children: [
                              Container(
                                height: media.width * 0.01,
                                width: media.width * 0.001,
                                color: const Color(0xff319900),
                              ),
                              SizedBox(
                                height: media.width * 0.002,
                              ),
                              Container(
                                height: media.width * 0.01,
                                width: media.width * 0.001,
                                color: const Color(0xff319900),
                              ),
                              SizedBox(
                                height: media.width * 0.002,
                              ),
                              Container(
                                height: media.width * 0.01,
                                width: media.width * 0.001,
                                color: const Color(0xff319900),
                              ),
                              SizedBox(
                                height: media.width * 0.002,
                              ),
                              Container(
                                height: media.width * 0.01,
                                width: media.width * 0.001,
                                color: const Color(0xff319900),
                              ),
                            ],
                          ),
                          Container(
                            height: media.width * 0.025,
                            width: media.width * 0.025,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xffFF0000).withValues(alpha: 0.3),
                            ),
                            child: Container(
                              height: media.width * 0.01,
                              width: media.width * 0.01,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xffFF0000),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: media.width * 0.03,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          (userRequestData.isNotEmpty)
                              ? SizedBox(
                                  width: media.width * 0.75,
                                  child: Text(
                                    userRequestData['pick_address'],
                                    style: GoogleFonts.roboto(fontSize: media.width * twelve, color: textColor),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )
                              : (addressList.where((e) => e.id == 'drop').isNotEmpty)
                                  ? SizedBox(
                                      width: media.width * 0.75,
                                      child: Text(
                                        addressList.firstWhere((element) => element.id == 'pickup').address,
                                        style: GoogleFonts.roboto(fontSize: media.width * twelve, color: textColor),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    )
                                  : Container(),
                          Container(
                            height: 1,
                            width: media.width * 0.75,
                            color: borderLines,
                          ),
                          (userRequestData.isNotEmpty)
                              ? SizedBox(
                                  width: media.width * 0.75,
                                  child: Text(
                                    userRequestData['drop_address'],
                                    style: GoogleFonts.roboto(fontSize: media.width * twelve, color: textColor),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )
                              : (addressList.where((e) => e.id == 'drop').isNotEmpty)
                                  ? SizedBox(
                                      width: media.width * 0.75,
                                      child: Text(
                                        addressList.firstWhere((element) => element.id == 'drop').address,
                                        style: GoogleFonts.roboto(fontSize: media.width * twelve, color: textColor),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    )
                                  : Container(),
                        ],
                      )
                    ],
                  ),
                )
              : Container(
                  height: media.width * 0.1,
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: media.width * 0.025,
                        width: media.width * 0.025,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xff319900).withValues(alpha: 0.3),
                        ),
                        child: Container(
                          height: media.width * 0.01,
                          width: media.width * 0.01,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xff319900),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: media.width * 0.05,
                      ),
                      (userRequestData.isNotEmpty)
                          ? SizedBox(
                              width: media.width * 0.75,
                              child: Text(
                                userRequestData['pick_address'],
                                style: GoogleFonts.roboto(fontSize: media.width * twelve, color: textColor),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            )
                          : (addressList.where((e) => e.id == 'pickup').isNotEmpty)
                              ? SizedBox(
                                  width: media.width * 0.75,
                                  child: Text(
                                    addressList.firstWhere((element) => element.id == 'pickup').address,
                                    style: GoogleFonts.roboto(fontSize: media.width * twelve, color: textColor),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )
                              : Container(),
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}
