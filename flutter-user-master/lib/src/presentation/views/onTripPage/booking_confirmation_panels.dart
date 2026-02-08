part of 'booking_confirmation.dart';

extension _BookingConfirmationPanels on _BookingConfirmationState {
  Widget buildChooseMethodPanel(Size media, Query fdb) {
    return (addressList.isNotEmpty &&
            etaDetails.isNotEmpty &&
            userRequestData.isEmpty &&
            noDriverFound == false &&
            tripReqError == false &&
            lowWalletBalance == false)
        ? Positioned(
            bottom: 0,
            child: GestureDetector(
              onPanUpdate: (val) {
                if (val.delta.dy > 0) {
                  _updateState(() {
                    _bottomChooseMethod = false;
                  });
                }
                if (val.delta.dy < 0) {
                  _updateState(() {
                    _bottomChooseMethod = true;
                  });
                }
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.all(media.width * 0.05),
                height: (_bottomChooseMethod == false && widget.type != 1)
                    ? media.width * 0.8
                    : (_bottomChooseMethod == false && widget.type == 1)
                        ? media.width * 1.1
                        : media.height * 0.9,
                width: media.width * 1,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                  color: page,
                ),
                child: Column(
                  children: [
                    AddressWidget(
                        userRequestData: userRequestData,
                        addressList: addressList),
                    Expanded(
                      child: SelectTaxiWidget(
                          minutes: minutes,
                          type: widget.type,
                          etaDetails: etaDetails,
                          select: (i) {
                            //1
                            _updateState(() {
                              choosenVehicle = i;
                            });
                          },
                          fdb: fdb),
                    ),

                    // (_bottomChooseMethod == true && widget.type != 1)
                    //     ? Container(
                    //         padding: EdgeInsets.all(media.width * 0.034),
                    //         margin: EdgeInsets.only(
                    //           bottom: media.height * 0.03,
                    //         ),
                    //         height: media.width * 0.21,
                    //         width: media.width * 0.9,
                    //         decoration: BoxDecoration(
                    //           border: Border.all(
                    //             color: borderLines,
                    //             width: 1.2,
                    //           ),
                    //           borderRadius: BorderRadius.circular(12),
                    //         ),
                    //         child: Row(
                    //           children: [
                    //             Column(
                    //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //               children: [
                    //                 Container(
                    //                   height: media.width * 0.025,
                    //                   width: media.width * 0.025,
                    //                   alignment: Alignment.center,
                    //                   decoration: BoxDecoration(
                    //                       shape: BoxShape.circle,
                    //                       color:
                    //                           const Color(0xff319900).withOpacity(0.3)),
                    //                   child: Container(
                    //                     height: media.width * 0.01,
                    //                     width: media.width * 0.01,
                    //                     decoration: const BoxDecoration(
                    //                         shape: BoxShape.circle,
                    //                         color: Color(0xff319900)),
                    //                   ),
                    //                 ),
                    //                 Column(
                    //                   children: [
                    //                     Container(
                    //                       height: media.width * 0.01,
                    //                       width: media.width * 0.001,
                    //                       color: const Color(0xff319900),
                    //                     ),
                    //                     SizedBox(
                    //                       height: media.width * 0.002,
                    //                     ),
                    //                     Container(
                    //                       height: media.width * 0.01,
                    //                       width: media.width * 0.001,
                    //                       color: const Color(0xff319900),
                    //                     ),
                    //                     SizedBox(
                    //                       height: media.width * 0.002,
                    //                     ),
                    //                     Container(
                    //                       height: media.width * 0.01,
                    //                       width: media.width * 0.001,
                    //                       color: const Color(0xff319900),
                    //                     ),
                    //                     SizedBox(
                    //                       height: media.width * 0.002,
                    //                     ),
                    //                     Container(
                    //                       height: media.width * 0.01,
                    //                       width: media.width * 0.001,
                    //                       color: const Color(0xff319900),
                    //                     ),
                    //                   ],
                    //                 ),
                    //                 Container(
                    //                   height: media.width * 0.025,
                    //                   width: media.width * 0.025,
                    //                   alignment: Alignment.center,
                    //                   decoration: BoxDecoration(
                    //                       shape: BoxShape.circle,
                    //                       color:
                    //                           const Color(0xffFF0000).withOpacity(0.3)),
                    //                   child: Container(
                    //                     height: media.width * 0.01,
                    //                     width: media.width * 0.01,
                    //                     decoration: const BoxDecoration(
                    //                         shape: BoxShape.circle,
                    //                         color: Color(0xffFF0000)),
                    //                   ),
                    //                 ),
                    //               ],
                    //             ),
                    //             SizedBox(
                    //               width: media.width * 0.03,
                    //             ),

                    //     ],
                    //   ),
                    // )
                    //     : Container(),
                    // (choosenVehicle != null && widget.type != 1)
                    //     ? InkWell(
                    //         onTap: () {
                    //           _updateState(() {
                    //             _choosePayment = true;
                    //           });
                    //         },
                    //         child: Container(
                    //           padding: EdgeInsets.all(media.width * 0.02),
                    //           height: media.width * 0.2,
                    //           width: media.width * 0.9,
                    //           decoration: BoxDecoration(
                    //               border: Border.all(color: borderLines, width: 1.2),
                    //               borderRadius: BorderRadius.circular(12)),
                    //           child: Column(
                    //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //             crossAxisAlignment: CrossAxisAlignment.start,
                    //             children: [
                    //               Text(
                    //                 context.l10n.text_payingvia,
                    //                 style: GoogleFonts.roboto(
                    //                   fontSize: media.width * twelve,
                    //                   color: const Color(0xff666666),
                    //                 ),
                    //               ),
                    //               Row(
                    //                 children: [
                    //                   SizedBox(
                    //                     width: media.width * 0.06,
                    //                     child: (etaDetails[choosenVehicle]['payment_type']
                    //                                 .toString()
                    //                                 .split(',')
                    //                                 .toList()[payingVia] ==
                    //                             'cash')
                    //                         ? Image.asset(
                    //                             'assets/images/cash.png',
                    //                             fit: BoxFit.contain,
                    //                           )
                    //                         : (etaDetails[choosenVehicle]['payment_type']
                    //                                     .toString()
                    //                                     .split(',')
                    //                                     .toList()[payingVia] ==
                    //                                 'wallet')
                    //                             ? Image.asset(
                    //                                 'assets/images/wallet.png',
                    //                                 fit: BoxFit.contain,
                    //                               )
                    //                             : (etaDetails[choosenVehicle]
                    //                                             ['payment_type']
                    //                                         .toString()
                    //                                         .split(',')
                    //                                         .toList()[payingVia] ==
                    //                                     'card')
                    //                                 ? Image.asset(
                    //                                     'assets/images/card.png',
                    //                                     fit: BoxFit.contain,
                    //                                   )
                    //                                 : (etaDetails[choosenVehicle]
                    //                                                 ['payment_type']
                    //                                             .toString()
                    //                                             .split(',')
                    //                                             .toList()[payingVia] ==
                    //                                         'upi')
                    //                                     ? Image.asset(
                    //                                         'assets/images/upi.png',
                    //                                         fit: BoxFit.contain,
                    //                                       )
                    //                                     : Container(),
                    //                   ),
                    //                   SizedBox(
                    //                     width: media.width * 0.05,
                    //                   ),
                    //                   Column(
                    //                     crossAxisAlignment: CrossAxisAlignment.start,
                    //                     children: [
                    //                       Text(
                    //                         etaDetails[choosenVehicle]['payment_type']
                    //                             .toString()
                    //                             .split(',')
                    //                             .toList()[payingVia]
                    //                             .toString(),
                    //                         style: GoogleFonts.roboto(
                    //                             fontSize: media.width * fourteen,
                    //                             fontWeight: FontWeight.w600),
                    //                       ),
                    //                       (etaDetails[choosenVehicle]['has_discount'] ==
                    //                               false)
                    //                           ? Text(
                    //                               (etaDetails[choosenVehicle]
                    //                                               ['payment_type']
                    //                                           .toString()
                    //                                           .split(',')
                    //                                           .toList()[payingVia] ==
                    //                                       'cash')
                    //                                   ? languages[choosenLanguage]
                    //                                       ['text_paycash']
                    //                                   : (etaDetails[choosenVehicle]
                    //                                                   ['payment_type']
                    //                                               .toString()
                    //                                               .split(',')
                    //                                               .toList()[payingVia] ==
                    //                                           'wallet')
                    //                                       ? languages[choosenLanguage]
                    //                                           ['text_paywallet']
                    //                                       : (etaDetails[choosenVehicle]
                    //                                                           ['payment_type']
                    //                                                       .toString()
                    //                                                       .split(',')
                    //                                                       .toList()[
                    //                                                   payingVia] ==
                    //                                               'card')
                    //                                           ? languages[choosenLanguage]
                    //                                               ['text_paycard']
                    //                                           : (etaDetails[choosenVehicle]['payment_type']
                    //                                                           .toString()
                    //                                                           .split(',')
                    //                                                           .toList()[
                    //                                                       payingVia] ==
                    //                                                   'upi')
                    //                                               ? languages[choosenLanguage]
                    //                                                   ['text_payupi']
                    //                                               : '',
                    //                               style: GoogleFonts.roboto(
                    //                                 fontSize: media.width * ten,
                    //                               ),
                    //                             )
                    //                           : Text(
                    //                               languages[choosenLanguage]
                    //                                   ['text_promoaccepted'],
                    //                               style: GoogleFonts.roboto(
                    //                                 color: const Color(0xff319900),
                    //                                 fontSize: media.width * ten,
                    //                               ),
                    //                             )
                    //                     ],
                    //                   ),
                    //                   Expanded(
                    //                       child: Row(
                    //                     mainAxisAlignment: MainAxisAlignment.end,
                    //                     children: const [
                    //                       Icon(
                    //                         Icons.arrow_forward_ios,
                    //                       ),
                    //                     ],
                    //                   ))
                    //                 ],
                    //               )
                    //             ],
                    //           ),
                    //         ),
                    //       )
                    //     : (choosenVehicle != null && widget.type == 1)
                    //         ? InkWell(
                    //             onTap: () {
                    //               _updateState(() {
                    //                 _choosePayment = true;
                    //               });
                    //             },
                    //             child: Container(
                    //               padding: EdgeInsets.all(media.width * 0.02),
                    //               height: media.width * 0.2,
                    //               width: media.width * 0.9,
                    //               decoration: BoxDecoration(
                    //                   border: Border.all(color: borderLines, width: 1.2),
                    //                   borderRadius: BorderRadius.circular(12)),
                    //               child: Column(
                    //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //                 crossAxisAlignment: CrossAxisAlignment.start,
                    //                 children: [
                    //                   Text(
                    //                     context.l10n.text_payingvia,
                    //                     style: GoogleFonts.roboto(
                    //                       fontSize: media.width * twelve,
                    //                       color: const Color(0xff666666),
                    //                     ),
                    //                   ),
                    //                   Row(
                    //                     children: [
                    //                       SizedBox(
                    //                         width: media.width * 0.06,
                    //                         child: (rentalOption[choosenVehicle]
                    //                                         ['payment_type']
                    //                                     .toString()
                    //                                     .split(',')
                    //                                     .toList()[payingVia] ==
                    //                                 'cash')
                    //                             ? Image.asset(
                    //                                 'assets/images/cash.png',
                    //                                 fit: BoxFit.contain,
                    //                               )
                    //                             : (rentalOption[choosenVehicle]
                    //                                             ['payment_type']
                    //                                         .toString()
                    //                                         .split(',')
                    //                                         .toList()[payingVia] ==
                    //                                     'wallet')
                    //                                 ? Image.asset(
                    //                                     'assets/images/wallet.png',
                    //                                     fit: BoxFit.contain,
                    //                                   )
                    //                                 : (rentalOption[choosenVehicle]
                    //                                                 ['payment_type']
                    //                                             .toString()
                    //                                             .split(',')
                    //                                             .toList()[payingVia] ==
                    //                                         'card')
                    //                                     ? Image.asset(
                    //                                         'assets/images/card.png',
                    //                                         fit: BoxFit.contain,
                    //                                       )
                    //                                     : (rentalOption[choosenVehicle]
                    //                                                     ['payment_type']
                    //                                                 .toString()
                    //                                                 .split(',')
                    //                                                 .toList()[payingVia] ==
                    //                                             'upi')
                    //                                         ? Image.asset(
                    //                                             'assets/images/upi.png',
                    //                                             fit: BoxFit.contain,
                    //                                           )
                    //                                         : Container(),
                    //                       ),
                    //                       SizedBox(
                    //                         width: media.width * 0.05,
                    //                       ),
                    //                       Column(
                    //                         crossAxisAlignment: CrossAxisAlignment.start,
                    //                         children: [
                    //                           Text(
                    //                             rentalOption[choosenVehicle]
                    //                                     ['payment_type']
                    //                                 .toString()
                    //                                 .split(',')
                    //                                 .toList()[payingVia]
                    //                                 .toString(),
                    //                             style: GoogleFonts.roboto(
                    //                                 fontSize: media.width * fourteen,
                    //                                 fontWeight: FontWeight.w600),
                    //                           ),
                    //                           (rentalOption[choosenVehicle]
                    //                                       ['has_discount'] ==
                    //                                   false)
                    //                               ? Text(
                    //                                   (rentalOption[choosenVehicle]
                    //                                                   ['payment_type']
                    //                                               .toString()
                    //                                               .split(',')
                    //                                               .toList()[payingVia] ==
                    //                                           'cash')
                    //                                       ? languages[choosenLanguage]
                    //                                           ['text_paycash']
                    //                                       : (rentalOption[choosenVehicle]
                    //                                                           ['payment_type']
                    //                                                       .toString()
                    //                                                       .split(',')
                    //                                                       .toList()[
                    //                                                   payingVia] ==
                    //                                               'wallet')
                    //                                           ? languages[choosenLanguage]
                    //                                               ['text_paywallet']
                    //                                           : (rentalOption[choosenVehicle]['payment_type']
                    //                                                           .toString()
                    //                                                           .split(',')
                    //                                                           .toList()[
                    //                                                       payingVia] ==
                    //                                                   'card')
                    //                                               ? languages[choosenLanguage]
                    //                                                   ['text_paycard']
                    //                                               : (rentalOption[choosenVehicle]
                    //                                                               ['payment_type']
                    //                                                           .toString()
                    //                                                           .split(',')
                    //                                                           .toList()[payingVia] ==
                    //                                                       'upi')
                    //                                                   ? context.l10n.text_payupi
                    //                                                   : '',
                    //                                   style: GoogleFonts.roboto(
                    //                                     fontSize: media.width * ten,
                    //                                   ),
                    //                                 )
                    //                               : Text(
                    //                                   languages[choosenLanguage]
                    //                                       ['text_promoaccepted'],
                    //                                   style: GoogleFonts.roboto(
                    //                                     color: const Color(0xff319900),
                    //                                     fontSize: media.width * ten,
                    //                                   ),
                    //                                 )
                    //                         ],
                    //                       ),
                    //                       Expanded(
                    //                           child: Row(
                    //                         mainAxisAlignment: MainAxisAlignment.end,
                    //                         children: const [
                    //                           Icon(
                    //                             Icons.arrow_forward_ios,
                    //                           ),
                    //                         ],
                    //                       ))
                    //                     ],
                    //                   )
                    //                 ],
                    //               ),
                    //             ),
                    //           )
                    //         : Container(),
                    // (choosenVehicle != null)
                    //     ? SizedBox(
                    //         height: media.width * 0.05,
                    //       )
                    //     : Container(),

                    Button(
                        color: buttonColor,
                        onTap: () async {
                          _updateState(() {
                            _isLoading = true;
                          });
                          dynamic result;
                          if (choosenVehicle != null) {
                            if (widget.type != 1) {
                              if (etaDetails[choosenVehicle]['has_discount'] ==
                                  false) {
                                result = await createRequest();
                              } else {
                                result = await createRequestWithPromo();
                              }
                            } else {
                              if (rentalOption[choosenVehicle]
                                      ['has_discount'] ==
                                  false) {
                                result = await createRentalRequest();
                              } else {
                                result = await createRentalRequestWithPromo();
                              }
                            }
                          }
                          if (result == 'success') {
                            timer();
                          }
                          _updateState(() {
                            _isLoading = false;
                          });
                        },
                        text: context.l10n.text_ridenow),
                  ],
                ),
              ),
            ),
          )
        : Container();
  }

  Widget buildNoDriverFoundPanel(Size media) {
    return (noDriverFound == true)
        ? Positioned(
            bottom: 0,
            child: Container(
              width: media.width * 1,
              padding: EdgeInsets.all(media.width * 0.05),
              decoration: BoxDecoration(
                  color: page,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12))),
              child: Column(
                children: [
                  Container(
                    height: media.width * 0.18,
                    width: media.width * 0.18,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Color(0xffFEF2F2)),
                    alignment: Alignment.center,
                    child: Container(
                      height: media.width * 0.14,
                      width: media.width * 0.14,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Color(0xffFF0000)),
                      child: const Center(
                        child: Icon(
                          Icons.error,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: media.width * 0.05,
                  ),
                  Text(
                    context.l10n.text_nodriver,
                    style: GoogleFonts.roboto(
                        fontSize: media.width * eighteen,
                        fontWeight: FontWeight.w600,
                        color: textColor),
                  ),
                  SizedBox(
                    height: media.width * 0.05,
                  ),
                  Button(
                      onTap: () {
                        _updateState(() {
                          noDriverFound = false;
                        });
                      },
                      text: context.l10n.text_tryagain)
                ],
              ),
            ))
        : Container();
  }

  Widget buildTripRequestErrorPanel(Size media) {
    return (tripReqError == true)
        ? Positioned(
            bottom: 0,
            child: Container(
              width: media.width * 1,
              padding: EdgeInsets.all(media.width * 0.05),
              decoration: BoxDecoration(
                  color: page,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12))),
              child: Column(
                children: [
                  Container(
                    height: media.width * 0.18,
                    width: media.width * 0.18,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Color(0xffFEF2F2)),
                    alignment: Alignment.center,
                    child: Container(
                      height: media.width * 0.14,
                      width: media.width * 0.14,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Color(0xffFF0000)),
                      child: const Center(
                        child: Icon(
                          Icons.error,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: media.width * 0.05,
                  ),
                  SizedBox(
                    width: media.width * 0.8,
                    child: Text(context.l10n.text_internal_server_error,
                        style: GoogleFonts.roboto(
                            fontSize: media.width * eighteen,
                            fontWeight: FontWeight.w600,
                            color: textColor),
                        textAlign: TextAlign.center),
                  ),
                  SizedBox(
                    height: media.width * 0.05,
                  ),
                  Button(
                      onTap: () {
                        _updateState(() {
                          tripReqError = false;
                        });
                      },
                      text: context.l10n.text_tryagain)
                ],
              ),
            ))
        : Container();
  }

  Widget buildServiceNotAvailablePanel(Size media) {
    return (serviceNotAvailable == true)
        ? Positioned(
            bottom: 0,
            child: Container(
              width: media.width * 1,
              padding: EdgeInsets.all(media.width * 0.05),
              decoration: BoxDecoration(
                  color: page,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12))),
              child: Column(
                children: [
                  Container(
                    height: media.width * 0.18,
                    width: media.width * 0.18,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Color(0xffFEF2F2)),
                    alignment: Alignment.center,
                    child: Container(
                      height: media.width * 0.14,
                      width: media.width * 0.14,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Color(0xffFF0000)),
                      child: const Center(
                        child: Icon(
                          Icons.error,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: media.width * 0.05,
                  ),
                  SizedBox(
                    width: media.width * 0.8,
                    child: Text(context.l10n.text_no_service,
                        style: GoogleFonts.roboto(
                            fontSize: media.width * eighteen,
                            fontWeight: FontWeight.w600,
                            color: textColor),
                        textAlign: TextAlign.center),
                  ),
                  SizedBox(
                    height: media.width * 0.05,
                  ),
                  Button(
                      onTap: () async {
                        _updateState(() {
                          serviceNotAvailable = false;
                        });
                        if (widget.type != 1) {
                          await etaRequest();
                        } else {
                          await rentalEta();
                        }
                        _updateState(() {});
                      },
                      text: context.l10n.text_tryagain)
                ],
              ),
            ))
        : Container();
  }
}
