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
                duration:
                    const Duration(milliseconds: 200),
                padding:
                    EdgeInsets.all(media.width * 0.05),
                height: (_bottomChooseMethod == false &&
                        widget.type != 1)
                    ? media.width * 0.8
                    : (_bottomChooseMethod == false &&
                            widget.type == 1)
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
                        userRequestData:
                            userRequestData,
                        addressList: addressList),
                    Expanded(
                      child: SelectTaxiWidget(
                          minutes: minutes,
                          type: widget.type,
                          etaDetails: etaDetails,
                          select: (i){
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
                              if (etaDetails[
                                          choosenVehicle]
                                      [
                                      'has_discount'] ==
                                  false) {
                                result =
                                    await createRequest();
                              } else {
                                result =
                                    await createRequestWithPromo();
                              }
                            } else {
                              if (rentalOption[
                                          choosenVehicle]
                                      [
                                      'has_discount'] ==
                                  false) {
                                result =
                                    await createRentalRequest();
                              } else {
                                result =
                                    await createRentalRequestWithPromo();
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
              padding:
                  EdgeInsets.all(media.width * 0.05),
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
                        shape: BoxShape.circle,
                        color: Color(0xffFEF2F2)),
                    alignment: Alignment.center,
                    child: Container(
                      height: media.width * 0.14,
                      width: media.width * 0.14,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xffFF0000)),
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
                        fontSize:
                            media.width * eighteen,
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
              padding:
                  EdgeInsets.all(media.width * 0.05),
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
                        shape: BoxShape.circle,
                        color: Color(0xffFEF2F2)),
                    alignment: Alignment.center,
                    child: Container(
                      height: media.width * 0.14,
                      width: media.width * 0.14,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xffFF0000)),
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
                    child: Text(
                        context.l10n.text_internal_server_error,
                        style: GoogleFonts.roboto(
                            fontSize:
                                media.width * eighteen,
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
              padding:
                  EdgeInsets.all(media.width * 0.05),
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
                        shape: BoxShape.circle,
                        color: Color(0xffFEF2F2)),
                    alignment: Alignment.center,
                    child: Container(
                      height: media.width * 0.14,
                      width: media.width * 0.14,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xffFF0000)),
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
                    child: Text(
                        context.l10n.text_no_service,
                        style: GoogleFonts.roboto(
                            fontSize:
                                media.width * eighteen,
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

  Widget buildAcceptedStatusBanner(Size media) {
    return (userRequestData['accepted_at'] != null)
        ? Positioned(
            top:
                MediaQuery.of(context).padding.top + 25,
            child: Container(
              padding: EdgeInsets.fromLTRB(
                  media.width * 0.05,
                  media.width * 0.025,
                  media.width * 0.05,
                  media.width * 0.025),
              decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 2,
                        color: Colors.black
                            .withOpacity(0.2),
                        spreadRadius: 2)
                  ],
                  color: page),
              child: Row(
                children: [
                  Container(
                    height: 10,
                    width: 10,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 2,
                              color: Colors.black
                                  .withOpacity(0.2),
                              spreadRadius: 2)
                        ],
                        color: (userRequestData[
                                        'accepted_at'] !=
                                    null &&
                                userRequestData[
                                        'arrived_at'] ==
                                    null)
                            ? const Color(0xff2E67D5)
                            : (userRequestData['accepted_at'] !=
                                        null &&
                                    userRequestData[
                                            'arrived_at'] !=
                                        null &&
                                    userRequestData[
                                            'is_trip_start'] ==
                                        0)
                                ? const Color(
                                    0xff319900)
                                : (userRequestData[
                                                'accepted_at'] !=
                                            null &&
                                        userRequestData[
                                                'arrived_at'] !=
                                            null &&
                                        userRequestData[
                                                'is_trip_start'] !=
                                            0)
                                    ? const Color(
                                        0xffFF0000)
                                    : Colors
                                        .transparent),
                  ),
                  SizedBox(
                    width: media.width * 0.02,
                  ),
                  Text(
                      (userRequestData['accepted_at'] != null &&
                              userRequestData[
                                      'arrived_at'] ==
                                  null &&
                              _dist != null)
                          ? context.l10n.text_arrive_eta +
                              ' ' +
                              double.parse(((_dist * 2))
                                      .toString())
                                  .round()
                                  .toString() +
                              ' ' +
                              context.l10n.text_mins
                          : (userRequestData[
                                          'accepted_at'] !=
                                      null &&
                                  userRequestData['arrived_at'] !=
                                      null &&
                                  userRequestData['is_trip_start'] ==
                                      0)
                              ? context.l10n.text_arrived
                              : (userRequestData['accepted_at'] !=
                                          null &&
                                      userRequestData['arrived_at'] !=
                                          null &&
                                      userRequestData['is_trip_start'] !=
                                          null)
                                  ? context.l10n.text_onride
                                  : '',
                      style: GoogleFonts.roboto(
                        fontSize: media.width * twelve,
                        color: (userRequestData[
                                        'accepted_at'] !=
                                    null &&
                                userRequestData[
                                        'arrived_at'] ==
                                    null)
                            ? const Color(0xff2E67D5)
                            : (userRequestData['accepted_at'] !=
                                        null &&
                                    userRequestData[
                                            'arrived_at'] !=
                                        null &&
                                    userRequestData[
                                            'is_trip_start'] ==
                                        0)
                                ? const Color(
                                    0xff319900)
                                : (userRequestData[
                                                'accepted_at'] !=
                                            null &&
                                        userRequestData[
                                                'arrived_at'] !=
                                            null &&
                                        userRequestData[
                                                'is_trip_start'] ==
                                            1)
                                    ? const Color(
                                        0xffFF0000)
                                    : Colors
                                        .transparent,
                      ))
                ],
              ),
            ))
        : Container();
  }

  Widget buildFindingDriverPanel(Size media) {
    if (userRequestData.isNotEmpty &&
            userRequestData['is_later'] == null &&
            userRequestData['accepted_at'] == null ||
        userRequestData.isNotEmpty &&
            userRequestData['is_later'] == 0 &&
            userRequestData['accepted_at'] == null) {
      return Positioned(
        bottom: 0,
        child: Container(
          width: media.width * 1,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12)),
            color: page,
          ),
          padding: EdgeInsets.all(media.width * 0.05),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      context.l10n.text_findingdriver +
                          ' >',
                      style: GoogleFonts.roboto(
                        fontSize:
                            media.width * eighteen,
                        color: textColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 130),
                  (timing != null)
                      ? Text(
                          Duration(seconds: timing)
                              .toString()
                              .substring(3, 7),
                          style: GoogleFonts.roboto(
                            fontSize:
                                media.width * eighteen,
                            color: textColor,
                          ),
                        )
                      : Container(),
                ],
              ),
              SizedBox(
                height: media.height * 0.02,
              ),
              // SizedBox(
              //   height: media.width * 0.4,
              //   child: Image.asset(
              //     'assets/images/waiting_time.gif',
              //     fit: BoxFit.contain,
              //   ),
              // ),
              // SizedBox(
              //   height: media.height * 0.02,
              // ),
              Container(
                height: media.width * 0.02,
                width: media.width * 0.9,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                      media.width * 0.01),
                  color: Colors.grey
                      .withValues(alpha: 0.5),
                ),
                alignment: Alignment.centerLeft,
                child: Container(
                  height: media.width * 0.02,
                  width: (media.width *
                      0.9 *
                      (timing /
                          userDetails[
                              'maximum_time_for_find_drivers_for_regular_ride'])),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                        media.width * 0.01),
                    color: const Color.fromRGBO(
                        0, 247, 1, 1),
                  ),
                ),
              ),
              SizedBox(
                height: media.height * 0.02,
              ),
              SizedBox(
                height: media.height * 0.02,
              ),
              Text(
                context.l10n.text_finddriverdesc,
                style: GoogleFonts.roboto(
                  fontSize: media.width * twelve,
                  color: textColor,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: media.height * 0.02,
              ),
              GestureDetector(
                onTap: () {
                  cancelRequest();
                },
                child: Container(
                  color: Colors.transparent,
                  child: SvgPicture.asset(
                    'assets/icons/close.svg',
                  ),
                ),
              ),
              SizedBox(
                height: media.height * 0.01,
              ),
              Text(
                context.l10n.text_cancel,
                style: GoogleFonts.roboto(
                  fontSize: media.width * fourteen,
                  color: Colors.grey,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: media.height * 0.02,
              ),
            ],
          ),
        ),
      );
    }
    return Container();
  }

  Widget buildOnTripPanel(Size media) {
    return (userRequestData.isNotEmpty &&
            userRequestData['accepted_at'] != null)
        ? Positioned(
            bottom: 0,
            child: GestureDetector(
              onPanUpdate: (val) {
                if (val.delta.dy > 0 &&
                    _ontripBottom == true) {
                  _updateState(() {
                    _ontripBottom = false;
                  });
                }
                if (val.delta.dy < 0 &&
                    _ontripBottom == false) {
                  _updateState(() {
                    _ontripBottom = true;
                  });
                }
              },
              child: Container(
                padding:
                    EdgeInsets.all(media.width * 0.05),
                width: media.width * 1,
                decoration: BoxDecoration(
                  color: page,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: SingleChildScrollView(
                  physics:
                      const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      // SizedBox(height: media.width*0.02,),
                      SvgPicture.asset(
                        'assets/icons/bottom.svg',
                      ),

                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,
                              children: [
                                Text(
                                  "${userRequestData['driverDetail']['data']['car_color']} ${userRequestData['driverDetail']['data']['car_make_name']} ${userRequestData['driverDetail']['data']['car_model_name']}",
                                  style: GoogleFonts
                                      .roboto(
                                    fontSize:
                                        media.width *
                                            eighteen,
                                    color: const Color
                                        .fromRGBO(
                                        82, 82, 82, 1),
                                    fontWeight:
                                        FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: media.width * 0.070,
                            decoration: BoxDecoration(
                              color:
                                  const Color.fromRGBO(
                                      237, 238, 242, 1),
                              borderRadius:
                                  BorderRadius.circular(
                                      5),
                            ),
                            padding:
                                EdgeInsets.fromLTRB(
                                    media.width * 0.02,
                                    media.width * 0.01,
                                    media.width * 0.02,
                                    media.width * 0.01),
                            child: Text(
                              userRequestData[
                                      'driverDetail'][
                                  'data']['car_number'],
                              style: GoogleFonts.roboto(
                                fontSize: media.width *
                                    eighteen,
                                fontWeight:
                                    FontWeight.w400,
                                color: textColor,
                              ),
                            ),
                          ),
                          SizedBox(
                              height:
                                  media.width * 0.03),
                        ],
                      ),
                      SizedBox(
                        height: media.width * 0.05,
                      ),
                      Container(
                        height: 1,
                        width: MediaQuery.of(context)
                            .size
                            .width,
                        color: const Color.fromRGBO(
                            201, 201, 201, 1),
                      ),
                      SizedBox(
                        height: media.width * 0.05,
                      ),
                      Row(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        mainAxisAlignment:
                            MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              SizedBox(
                                height:
                                    media.width * 0.16,
                                width:
                                    media.width * 0.18,
                                child: Stack(
                                  children: [
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: Container(
                                        height: media
                                                .width *
                                            0.16,
                                        width: media
                                                .width *
                                            0.16,
                                        decoration:
                                            BoxDecoration(
                                          shape: BoxShape
                                              .circle,
                                          image:
                                              DecorationImage(
                                            image:
                                                NetworkImage(
                                              userRequestData['driverDetail']
                                                      [
                                                      'data']
                                                  [
                                                  'profile_picture'],
                                            ),
                                            fit: BoxFit
                                                .cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      child: Container(
                                        padding: const EdgeInsets
                                            .symmetric(
                                            horizontal:
                                                5,
                                            vertical:
                                                2),
                                        decoration:
                                            BoxDecoration(
                                          borderRadius:
                                              BorderRadius
                                                  .circular(
                                                      10),
                                          color: Colors
                                              .white,
                                          boxShadow: const [
                                            BoxShadow(
                                              offset:
                                                  Offset(
                                                      0,
                                                      0),
                                              blurRadius:
                                                  4,
                                              color: Color
                                                  .fromRGBO(
                                                      0,
                                                      0,
                                                      0,
                                                      0.25),
                                            ),
                                          ],
                                        ),
                                        child: Text(
                                          userRequestData['driverDetail']
                                                      [
                                                      'data']
                                                  [
                                                  'rating']
                                              .toString(),
                                          style:
                                              GoogleFonts
                                                  .roboto(
                                            fontSize: media
                                                    .width *
                                                twelve,
                                            color:
                                                textColor,
                                            fontWeight:
                                                FontWeight
                                                    .w400,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                userRequestData[
                                        'driverDetail']
                                    ['data']['name'],
                                style:
                                    GoogleFonts.roboto(
                                  fontSize:
                                      media.width *
                                          fourteen,
                                  fontWeight:
                                      FontWeight.w400,
                                  color: const Color
                                      .fromRGBO(
                                      139, 139, 139, 1),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 32),
                          Column(
                            mainAxisAlignment:
                                MainAxisAlignment.start,
                            children: [
                              InkWell(
                                onTap: () {
                                  makingPhoneCall(
                                      userRequestData[
                                                  'driverDetail']
                                              ['data']
                                          ['mobile']);
                                },
                                child: SizedBox(
                                  height: media.width *
                                      0.16,
                                  width: media.width *
                                      0.16,
                                  child: SvgPicture.asset(
                                      'assets/icons/call.svg'),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Позвонить',
                                style:
                                    GoogleFonts.roboto(
                                  fontSize:
                                      media.width *
                                          fourteen,
                                  fontWeight:
                                      FontWeight.w400,
                                  color: const Color
                                      .fromRGBO(
                                      139, 139, 139, 1),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: media.width * 0.05,
                      ),
                      AddressViewWidget(
                        userRequestData:
                            userRequestData,
                      ),
                      SizedBox(
                        height: media.width * 0.05,
                      ),
                      (userRequestData[
                                  'is_trip_start'] !=
                              1)
                          ? Row(
                              mainAxisAlignment:
                                  MainAxisAlignment
                                      .center,
                              children: [
                                (userRequestData[
                                            'is_trip_start'] !=
                                        1)
                                    ? InkWell(
                                        onTap:
                                            () async {
                                          _updateState(() {
                                            _isLoading =
                                                true;
                                          });
                                          var reason = await cancelReason(
                                              (userRequestData['is_driver_arrived'] ==
                                                      0)
                                                  ? 'before'
                                                  : 'after');
                                          if (reason ==
                                              true) {
                                            _updateState(
                                                () {
                                              _cancellingError =
                                                  '';
                                              _cancelling =
                                                  true;
                                            });
                                          }
                                          _updateState(() {
                                            _isLoading =
                                                false;
                                          });
                                        },
                                        child: Column(
                                          children: [
                                            SvgPicture
                                                .asset(
                                              'assets/icons/close.svg',
                                            ),
                                            SizedBox(
                                              height: media
                                                      .width *
                                                  0.02,
                                            ),
                                            Text(
                                              context.l10n.text_cancel,
                                              style: GoogleFonts.roboto(
                                                  fontSize: media.width *
                                                      ten,
                                                  fontWeight: FontWeight
                                                      .w600,
                                                  color:
                                                      textColor),
                                            )
                                          ],
                                        ),
                                      )
                                    : Container(),
                              ],
                            )
                          : Container(),
                    ],
                  ),
                ),
              ),
            ),
          )
        : Container();

  }
}
