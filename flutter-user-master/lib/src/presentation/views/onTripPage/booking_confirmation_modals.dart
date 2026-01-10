part of 'booking_confirmation.dart';

extension _BookingConfirmationModals on _BookingConfirmationState {
  Widget buildVehicleInfoModal(Size media) {
    return (_showInfo == true)
        ? Positioned(
            top: 0,
            child: Container(
              padding: EdgeInsets.only(
                  bottom: media.width * 0.05),
              height: media.height * 1,
              width: media.width * 1,
              color:
                  Colors.transparent.withOpacity(0.6),
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: media.width * 0.9,
                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () {
                            _updateState(() {
                              _showInfo = false;
                              _showInfoInt = null;
                            });
                          },
                          child: Container(
                            height: media.width * 0.1,
                            width: media.width * 0.1,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: page),
                            child: const Icon(
                                Icons.cancel_outlined),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: media.width * 0.05),
                  Container(
                    width: media.width * 0.9,
                    decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(12),
                        color: page),
                    padding: EdgeInsets.all(
                        media.width * 0.05),
                    child: (widget.type != 1)
                        ? Column(
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,
                            children: [
                              Text(
                                etaDetails[_showInfoInt]
                                    ['name'],
                                style:
                                    GoogleFonts.roboto(
                                        fontSize: media
                                                .width *
                                            sixteen,
                                        color:
                                            textColor,
                                        fontWeight:
                                            FontWeight
                                                .w600),
                              ),
                              SizedBox(
                                height:
                                    media.width * 0.025,
                              ),
                              Text(
                                etaDetails[_showInfoInt]
                                    ['description'],
                                style:
                                    GoogleFonts.roboto(
                                  fontSize:
                                      media.width *
                                          fourteen,
                                  color: textColor,
                                ),
                              ),
                              SizedBox(
                                  height: media.width *
                                      0.05),
                              Text(
                                context.l10n.text_supported_vehicles,
                                style:
                                    GoogleFonts.roboto(
                                        fontSize: media
                                                .width *
                                            sixteen,
                                        color:
                                            textColor,
                                        fontWeight:
                                            FontWeight
                                                .w600),
                              ),
                              SizedBox(
                                height:
                                    media.width * 0.025,
                              ),
                              Text(
                                etaDetails[_showInfoInt]
                                    [
                                    'supported_vehicles'],
                                style:
                                    GoogleFonts.roboto(
                                  fontSize:
                                      media.width *
                                          fourteen,
                                  color: textColor,
                                ),
                              ),
                              SizedBox(
                                  height: media.width *
                                      0.05),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment
                                        .spaceBetween,
                                children: [
                                  SizedBox(
                                    width: media.width *
                                        0.4,
                                    child: Text(
                                      context.l10n.text_estimated_amount,
                                      style: GoogleFonts.roboto(
                                          fontSize: media
                                                  .width *
                                              sixteen,
                                          color:
                                              textColor,
                                          fontWeight:
                                              FontWeight
                                                  .w600),
                                    ),
                                  ),
                                  (etaDetails[_showInfoInt]
                                              [
                                              'has_discount'] !=
                                          true)
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment
                                                  .end,
                                          children: [
                                            Text(
                                              etaDetails[_showInfoInt]
                                                      [
                                                      'currency'] +
                                                  ' ' +
                                                  etaDetails[_showInfoInt]['total']
                                                      .toStringAsFixed(2),
                                              style: GoogleFonts.roboto(
                                                  fontSize: media.width *
                                                      fourteen,
                                                  color:
                                                      textColor,
                                                  fontWeight:
                                                      FontWeight.w600),
                                            ),
                                          ],
                                        )
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment
                                                  .end,
                                          children: [
                                            Text(
                                              etaDetails[_showInfoInt]
                                                      [
                                                      'currency'] +
                                                  ' ',
                                              style: GoogleFonts.roboto(
                                                  fontSize: media.width *
                                                      fourteen,
                                                  color:
                                                      textColor,
                                                  fontWeight:
                                                      FontWeight.w600),
                                            ),
                                            Text(
                                              etaDetails[_showInfoInt]
                                                      [
                                                      'total']
                                                  .toStringAsFixed(
                                                      2),
                                              style: GoogleFonts.roboto(
                                                  fontSize: media.width *
                                                      fourteen,
                                                  color:
                                                      textColor,
                                                  fontWeight: FontWeight
                                                      .w600,
                                                  decoration:
                                                      TextDecoration.lineThrough),
                                            ),
                                            Text(
                                              ' ${etaDetails[_showInfoInt]['discounted_totel'].toStringAsFixed(2)}',
                                              style: GoogleFonts.roboto(
                                                  fontSize: media.width *
                                                      fourteen,
                                                  color:
                                                      textColor,
                                                  fontWeight:
                                                      FontWeight.w600),
                                            )
                                          ],
                                        )
                                ],
                              )
                            ],
                          )
                        : Column(
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,
                            children: [
                              Text(
                                rentalOption[
                                        _showInfoInt]
                                    ['name'],
                                style:
                                    GoogleFonts.roboto(
                                        fontSize: media
                                                .width *
                                            sixteen,
                                        color:
                                            textColor,
                                        fontWeight:
                                            FontWeight
                                                .w600),
                              ),
                              SizedBox(
                                height:
                                    media.width * 0.025,
                              ),
                              Text(
                                rentalOption[
                                        _showInfoInt]
                                    ['description'],
                                style:
                                    GoogleFonts.roboto(
                                  fontSize:
                                      media.width *
                                          fourteen,
                                  color: textColor,
                                ),
                              ),
                              SizedBox(
                                  height: media.width *
                                      0.05),
                              Text(
                                context.l10n.text_supported_vehicles,
                                style:
                                    GoogleFonts.roboto(
                                        fontSize: media
                                                .width *
                                            sixteen,
                                        color:
                                            textColor,
                                        fontWeight:
                                            FontWeight
                                                .w600),
                              ),
                              SizedBox(
                                height:
                                    media.width * 0.025,
                              ),
                              Text(
                                rentalOption[
                                        _showInfoInt][
                                    'supported_vehicles'],
                                style:
                                    GoogleFonts.roboto(
                                  fontSize:
                                      media.width *
                                          fourteen,
                                  color: textColor,
                                ),
                              ),
                              SizedBox(
                                  height: media.width *
                                      0.05),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment
                                        .spaceBetween,
                                children: [
                                  Text(
                                    context.l10n.text_estimated_amount,
                                    style: GoogleFonts.roboto(
                                        fontSize: media
                                                .width *
                                            sixteen,
                                        color:
                                            textColor,
                                        fontWeight:
                                            FontWeight
                                                .w600),
                                  ),
                                  (rentalOption[_showInfoInt]
                                              [
                                              'has_discount'] !=
                                          true)
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment
                                                  .end,
                                          children: [
                                            Text(
                                              rentalOption[_showInfoInt]
                                                      [
                                                      'currency'] +
                                                  ' ' +
                                                  rentalOption[_showInfoInt]['fare_amount']
                                                      .toStringAsFixed(2),
                                              style: GoogleFonts.roboto(
                                                  fontSize: media.width *
                                                      fourteen,
                                                  color:
                                                      textColor,
                                                  fontWeight:
                                                      FontWeight.w600),
                                            ),
                                          ],
                                        )
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment
                                                  .end,
                                          children: [
                                            Text(
                                              rentalOption[
                                                      _showInfoInt]
                                                  [
                                                  'currency'],
                                              style: GoogleFonts.roboto(
                                                  fontSize: media.width *
                                                      fourteen,
                                                  color:
                                                      textColor,
                                                  fontWeight:
                                                      FontWeight.w600),
                                            ),
                                            Text(
                                              ' ${rentalOption[_showInfoInt]['fare_amount'].toStringAsFixed(2)}',
                                              style: GoogleFonts.roboto(
                                                  fontSize: media.width *
                                                      fourteen,
                                                  color:
                                                      textColor,
                                                  fontWeight: FontWeight
                                                      .w600,
                                                  decoration:
                                                      TextDecoration.lineThrough),
                                            ),
                                            Text(
                                              ' ${rentalOption[_showInfoInt]['discounted_totel'].toStringAsFixed(2)}',
                                              style: GoogleFonts.roboto(
                                                  fontSize: media.width *
                                                      fourteen,
                                                  color:
                                                      textColor,
                                                  fontWeight:
                                                      FontWeight.w600),
                                            ),
                                          ],
                                        )
                                ],
                              )
                            ],
                          ),
                  )
                ],
              ),
            ),
          )
        : Container();

  }

  Widget buildChoosePaymentModal(Size media) {
    return (_choosePayment == true)
        ? Positioned(
            top: 0,
            child: Container(
              height: media.height * 1,
              width: media.width * 1,
              color:
                  Colors.transparent.withOpacity(0.6),
              child: Scaffold(
                backgroundColor: Colors.transparent,
                body: SingleChildScrollView(
                  physics:
                      const BouncingScrollPhysics(),
                  child: SizedBox(
                    height: media.height * 1,
                    width: media.width * 1,
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.center,
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: media.width * 0.9,
                          child: Row(
                            mainAxisAlignment:
                                MainAxisAlignment.end,
                            children: [
                              InkWell(
                                onTap: () {
                                  _updateState(() {
                                    _choosePayment =
                                        false;
                                    promoKey.clear();
                                  });
                                },
                                child: Container(
                                  height:
                                      media.width * 0.1,
                                  width:
                                      media.width * 0.1,
                                  decoration:
                                      BoxDecoration(
                                          shape: BoxShape
                                              .circle,
                                          color: page),
                                  child: const Icon(Icons
                                      .cancel_outlined),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: media.width * 0.05,
                        ),
                        Container(
                          width: media.width * 0.9,
                          decoration: BoxDecoration(
                            color: page,
                            borderRadius:
                                BorderRadius.circular(
                                    12),
                          ),
                          padding: EdgeInsets.all(
                              media.width * 0.05),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,
                            children: [
                              Text(
                                context.l10n.text_paymentmethod,
                                style:
                                    GoogleFonts.roboto(
                                        fontSize: media
                                                .width *
                                            twenty,
                                        fontWeight:
                                            FontWeight
                                                .w600,
                                        color:
                                            textColor),
                              ),
                              SizedBox(
                                height: media.height *
                                    0.015,
                              ),
                              Text(
                                context.l10n.text_choose_paynoworlater,
                                style:
                                    GoogleFonts.roboto(
                                        fontSize: media
                                                .width *
                                            twelve,
                                        fontWeight:
                                            FontWeight
                                                .w600,
                                        color:
                                            textColor),
                              ),
                              SizedBox(
                                height: media.height *
                                    0.015,
                              ),
                              (widget.type != 1)
                                  ? Column(
                                      children: etaDetails[
                                                  choosenVehicle]
                                              [
                                              'payment_type']
                                          .toString()
                                          .split(',')
                                          .toList()
                                          .asMap()
                                          .map((i,
                                              value) {
                                            return MapEntry(
                                                i,
                                                InkWell(
                                                  onTap:
                                                      () {
                                                    _updateState(() {
                                                      payingVia = i;
                                                    });
                                                  },
                                                  child:
                                                      Container(
                                                    padding:
                                                        EdgeInsets.all(media.width * 0.02),
                                                    width:
                                                        media.width * 0.9,
                                                    child:
                                                        Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            SizedBox(
                                                              width: media.width * 0.06,
                                                              child: (etaDetails[choosenVehicle]['payment_type'].toString().split(',').toList()[i] == 'cash')
                                                                  ? Image.asset(
                                                                      'assets/images/cash.png',
                                                                      fit: BoxFit.contain,
                                                                    )
                                                                  : (etaDetails[choosenVehicle]['payment_type'].toString().split(',').toList()[i] == 'wallet')
                                                                      ? Image.asset(
                                                                          'assets/images/wallet.png',
                                                                          fit: BoxFit.contain,
                                                                        )
                                                                      : (etaDetails[choosenVehicle]['payment_type'].toString().split(',').toList()[i] == 'card')
                                                                          ? Image.asset(
                                                                              'assets/images/card.png',
                                                                              fit: BoxFit.contain,
                                                                            )
                                                                          : (etaDetails[choosenVehicle]['payment_type'].toString().split(',').toList()[i] == 'upi')
                                                                              ? Image.asset(
                                                                                  'assets/images/upi.png',
                                                                                  fit: BoxFit.contain,
                                                                                )
                                                                              : Container(),
                                                            ),
                                                            SizedBox(
                                                              width: media.width * 0.05,
                                                            ),
                                                            Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Text(
                                                                  etaDetails[choosenVehicle]['payment_type'].toString().split(',').toList()[i].toString(),
                                                                  style: GoogleFonts.roboto(fontSize: media.width * fourteen, fontWeight: FontWeight.w600),
                                                                ),
                                                                Text(
                                                                  (etaDetails[choosenVehicle]['payment_type'].toString().split(',').toList()[i] == 'cash')
                                                                      ? context.l10n.text_paycash
                                                                      : (etaDetails[choosenVehicle]['payment_type'].toString().split(',').toList()[i] == 'wallet')
                                                                          ? context.l10n.text_paywallet
                                                                          : (etaDetails[choosenVehicle]['payment_type'].toString().split(',').toList()[i] == 'card')
                                                                              ? context.l10n.text_paycard
                                                                              : (etaDetails[choosenVehicle]['payment_type'].toString().split(',').toList()[i] == 'upi')
                                                                                  ? context.l10n.text_payupi
                                                                                  : '',
                                                                  style: GoogleFonts.roboto(
                                                                    fontSize: media.width * ten,
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                            Expanded(
                                                                child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.end,
                                                              children: [
                                                                Container(
                                                                  height: media.width * 0.05,
                                                                  width: media.width * 0.05,
                                                                  decoration: BoxDecoration(shape: BoxShape.circle, color: page, border: Border.all(color: Colors.black, width: 1.2)),
                                                                  alignment: Alignment.center,
                                                                  child: (payingVia == i) ? Container(height: media.width * 0.03, width: media.width * 0.03, decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle)) : Container(),
                                                                )
                                                              ],
                                                            ))
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ));
                                          })
                                          .values
                                          .toList(),
                                    )
                                  : Column(
                                      children: rentalOption[
                                                  choosenVehicle]
                                              [
                                              'payment_type']
                                          .toString()
                                          .split(',')
                                          .toList()
                                          .asMap()
                                          .map((i,
                                              value) {
                                            return MapEntry(
                                                i,
                                                InkWell(
                                                  onTap:
                                                      () {
                                                    _updateState(() {
                                                      payingVia = i;
                                                    });
                                                  },
                                                  child:
                                                      Container(
                                                    padding:
                                                        EdgeInsets.all(media.width * 0.02),
                                                    width:
                                                        media.width * 0.9,
                                                    child:
                                                        Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            SizedBox(
                                                              width: media.width * 0.06,
                                                              child: (rentalOption[choosenVehicle]['payment_type'].toString().split(',').toList()[i] == 'cash')
                                                                  ? Image.asset(
                                                                      'assets/images/cash.png',
                                                                      fit: BoxFit.contain,
                                                                    )
                                                                  : (rentalOption[choosenVehicle]['payment_type'].toString().split(',').toList()[i] == 'wallet')
                                                                      ? Image.asset(
                                                                          'assets/images/wallet.png',
                                                                          fit: BoxFit.contain,
                                                                        )
                                                                      : (rentalOption[choosenVehicle]['payment_type'].toString().split(',').toList()[i] == 'card')
                                                                          ? Image.asset(
                                                                              'assets/images/card.png',
                                                                              fit: BoxFit.contain,
                                                                            )
                                                                          : (rentalOption[choosenVehicle]['payment_type'].toString().split(',').toList()[i] == 'upi')
                                                                              ? Image.asset(
                                                                                  'assets/images/upi.png',
                                                                                  fit: BoxFit.contain,
                                                                                )
                                                                              : Container(),
                                                            ),
                                                            SizedBox(
                                                              width: media.width * 0.05,
                                                            ),
                                                            Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Text(
                                                                  rentalOption[choosenVehicle]['payment_type'].toString().split(',').toList()[i].toString(),
                                                                  style: GoogleFonts.roboto(fontSize: media.width * fourteen, fontWeight: FontWeight.w600),
                                                                ),
                                                                Text(
                                                                  (rentalOption[choosenVehicle]['payment_type'].toString().split(',').toList()[i] == 'cash')
                                                                      ? context.l10n.text_paycash
                                                                      : (rentalOption[choosenVehicle]['payment_type'].toString().split(',').toList()[i] == 'wallet')
                                                                          ? context.l10n.text_paywallet
                                                                          : (rentalOption[choosenVehicle]['payment_type'].toString().split(',').toList()[i] == 'card')
                                                                              ? context.l10n.text_paycard
                                                                              : (rentalOption[choosenVehicle]['payment_type'].toString().split(',').toList()[i] == 'upi')
                                                                                  ? context.l10n.text_payupi
                                                                                  : '',
                                                                  style: GoogleFonts.roboto(
                                                                    fontSize: media.width * ten,
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                            Expanded(
                                                                child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.end,
                                                              children: [
                                                                Container(
                                                                  height: media.width * 0.05,
                                                                  width: media.width * 0.05,
                                                                  decoration: BoxDecoration(shape: BoxShape.circle, color: page, border: Border.all(color: Colors.black, width: 1.2)),
                                                                  alignment: Alignment.center,
                                                                  child: (payingVia == i) ? Container(height: media.width * 0.03, width: media.width * 0.03, decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle)) : Container(),
                                                                )
                                                              ],
                                                            ))
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ));
                                          })
                                          .values
                                          .toList(),
                                    ),
                              SizedBox(
                                height:
                                    media.height * 0.02,
                              ),
                              Container(
                                decoration:
                                    BoxDecoration(
                                  borderRadius:
                                      BorderRadius
                                          .circular(12),
                                  border: Border.all(
                                      color:
                                          borderLines,
                                      width: 1.2),
                                ),
                                padding:
                                    EdgeInsets.fromLTRB(
                                        media.width *
                                            0.025,
                                        0,
                                        media.width *
                                            0.025,
                                        0),
                                width:
                                    media.width * 0.9,
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width:
                                          media.width *
                                              0.06,
                                      child: Image.asset(
                                          'assets/images/promocode.png',
                                          fit: BoxFit
                                              .contain),
                                    ),
                                    SizedBox(
                                      width:
                                          media.width *
                                              0.05,
                                    ),
                                    Expanded(
                                      child: (promoStatus ==
                                              null)
                                          ? TextField(
                                              controller:
                                                  promoKey,
                                              onChanged:
                                                  (val) {
                                                _updateState(
                                                    () {
                                                  promoCode =
                                                      val;
                                                });
                                              },
                                              decoration: InputDecoration(
                                                  border: InputBorder
                                                      .none,
                                                  hintText: context.l10n.text_enterpromo,
                                                  hintStyle: GoogleFonts.roboto(
                                                      fontSize: media.width * twelve,
                                                      color: hintColor)),
                                            )
                                          : (promoStatus ==
                                                  1)
                                              ? Container(
                                                  padding: EdgeInsets.fromLTRB(
                                                      0,
                                                      media.width * 0.045,
                                                      0,
                                                      media.width * 0.045),
                                                  child:
                                                      Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Column(
                                                        children: [
                                                          Text(promoKey.text, style: GoogleFonts.roboto(fontSize: media.width * ten, color: const Color(0xff319900))),
                                                          Text(context.l10n.text_promoaccepted, style: GoogleFonts.roboto(fontSize: media.width * ten, color: const Color(0xff319900))),
                                                        ],
                                                      ),
                                                      InkWell(
                                                        onTap: () async {
                                                          _updateState(() {
                                                            _isLoading = true;
                                                          });
                                                          dynamic result;
                                                          if (widget.type != 1) {
                                                            result = await etaRequest();
                                                          } else {
                                                            result = await rentalEta();
                                                          }
                                                          _updateState(() {
                                                            _isLoading = false;
                                                            if (result == true) {
                                                              promoStatus = null;
                                                              promoCode = '';
                                                            }
                                                          });
                                                        },
                                                        child: Text(context.l10n.text_remove, style: GoogleFonts.roboto(fontSize: media.width * twelve, color: const Color(0xff319900))),
                                                      )
                                                    ],
                                                  ),
                                                )
                                              : (promoStatus ==
                                                      2)
                                                  ? Container(
                                                      padding: EdgeInsets.fromLTRB(0, media.width * 0.045, 0, media.width * 0.045),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          Text(promoKey.text, style: GoogleFonts.roboto(fontSize: media.width * twelve, color: const Color(0xffFF0000))),
                                                          InkWell(
                                                            onTap: () {
                                                              _updateState(() {
                                                                promoStatus = null;
                                                                promoCode = '';
                                                                promoKey.clear();
                                                                // promoKey.text = promoCode;
                                                                if (widget.type != 1) {
                                                                  etaRequest();
                                                                } else {
                                                                  rentalEta();
                                                                }
                                                              });
                                                            },
                                                            child: Text(context.l10n.text_remove, style: GoogleFonts.roboto(fontSize: media.width * twelve, color: const Color(0xffFF0000))),
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                  : Container(),
                                    )
                                  ],
                                ),
                              ),

                              //promo code status
                              (promoStatus == 2)
                                  ? Container(
                                      width:
                                          media.width *
                                              0.9,
                                      alignment:
                                          Alignment
                                              .center,
                                      padding: EdgeInsets
                                          .only(
                                              top: media
                                                      .height *
                                                  0.02),
                                      child: Text(
                                          context.l10n.text_promorejected,
                                          style: GoogleFonts.roboto(
                                              fontSize:
                                                  media.width *
                                                      ten,
                                              color: const Color(
                                                  0xffFF0000))),
                                    )
                                  : Container(),
                              SizedBox(
                                height:
                                    media.height * 0.02,
                              ),
                              Button(
                                  onTap: () async {
                                    if (promoCode ==
                                        '') {
                                      _updateState(() {
                                        _choosePayment =
                                            false;
                                      });
                                    } else {
                                      _updateState(() {
                                        _isLoading =
                                            true;
                                      });
                                      if (widget.type !=
                                          1) {
                                        await etaRequestWithPromo();
                                      } else {
                                        await rentalRequestWithPromo();
                                      }
                                      _updateState(() {
                                        _isLoading =
                                            false;
                                      });
                                    }
                                  },
                                  text: context.l10n.text_confirm)
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ))
        : Container();

  }

  Widget buildCancelRequestModal(Size media) {
    return (_cancelling == true)
        ? Positioned(
            child: Container(
              height: media.height * 1,
              width: media.width * 1,
              color:
                  Colors.transparent.withOpacity(0.6),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(
                        media.width * 0.05),
                    width: media.width * 0.9,
                    decoration: BoxDecoration(
                        color: page,
                        borderRadius:
                            BorderRadius.circular(12)),
                    child: Column(children: [
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
                          decoration:
                              const BoxDecoration(
                                  shape:
                                      BoxShape.circle,
                                  color: Color(
                                      0xffFF0000)),
                          child: const Center(
                            child: Icon(
                              Icons.cancel_outlined,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Column(
                        children: cancelReasonsList
                            .asMap()
                            .map(
                              (i, value) {
                                return MapEntry(
                                  i,
                                  InkWell(
                                    onTap: () {
                                      _updateState(() {
                                        _cancelReason =
                                            cancelReasonsList[
                                                    i][
                                                'reason'];
                                      });
                                    },
                                    child: Container(
                                      padding: EdgeInsets
                                          .all(media
                                                  .width *
                                              0.01),
                                      child: Row(
                                        children: [
                                          Container(
                                            height: media
                                                    .height *
                                                0.05,
                                            width: media
                                                    .width *
                                                0.05,
                                            decoration: BoxDecoration(
                                                shape: BoxShape
                                                    .circle,
                                                border: Border.all(
                                                    color:
                                                        Colors.black,
                                                    width: 1.2)),
                                            alignment:
                                                Alignment
                                                    .center,
                                            child: (_cancelReason ==
                                                    cancelReasonsList[i]['reason'])
                                                ? Container(
                                                    height:
                                                        media.width * 0.03,
                                                    width:
                                                        media.width * 0.03,
                                                    decoration:
                                                        const BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Colors.black,
                                                    ),
                                                  )
                                                : Container(),
                                          ),
                                          SizedBox(
                                            width: media
                                                    .width *
                                                0.05,
                                          ),
                                          SizedBox(
                                            width: media
                                                    .width *
                                                0.65,
                                            child: Text(
                                              cancelReasonsList[
                                                      i]
                                                  [
                                                  'reason'],
                                            ),
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
                      InkWell(
                        onTap: () {
                          _updateState(() {
                            _cancelReason = 'others';
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.all(
                              media.width * 0.01),
                          child: Row(
                            children: [
                              Container(
                                height:
                                    media.height * 0.05,
                                width:
                                    media.width * 0.05,
                                decoration: BoxDecoration(
                                    shape:
                                        BoxShape.circle,
                                    border: Border.all(
                                        color: Colors
                                            .black,
                                        width: 1.2)),
                                alignment:
                                    Alignment.center,
                                child: (_cancelReason ==
                                        'others')
                                    ? Container(
                                        height: media
                                                .width *
                                            0.03,
                                        width: media
                                                .width *
                                            0.03,
                                        decoration:
                                            const BoxDecoration(
                                          shape: BoxShape
                                              .circle,
                                          color: Colors
                                              .black,
                                        ),
                                      )
                                    : Container(),
                              ),
                              SizedBox(
                                width:
                                    media.width * 0.05,
                              ),
                              Text(context.l10n.text_others)
                            ],
                          ),
                        ),
                      ),
                      (_cancelReason == 'others')
                          ? Container(
                              margin:
                                  EdgeInsets.fromLTRB(
                                      0,
                                      media.width *
                                          0.025,
                                      0,
                                      media.width *
                                          0.025),
                              padding: EdgeInsets.all(
                                  media.width * 0.05),
                              // height: media.width*0.2,
                              width: media.width * 0.9,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color:
                                          borderLines,
                                      width: 1.2),
                                  borderRadius:
                                      BorderRadius
                                          .circular(
                                              12)),
                              child: TextField(
                                decoration: InputDecoration(
                                    border: InputBorder
                                        .none,
                                    hintText: context.l10n.text_cancelRideReason,
                                    hintStyle: GoogleFonts.roboto(
                                        fontSize: media
                                                .width *
                                            twelve)),
                                maxLines: 4,
                                minLines: 2,
                                onChanged: (val) {
                                  _updateState(() {
                                    _cancelCustomReason =
                                        val;
                                  });
                                },
                              ),
                            )
                          : Container(),
                      (_cancellingError != '')
                          ? Container(
                              padding: EdgeInsets.only(
                                  top: media.width *
                                      0.02,
                                  bottom: media.width *
                                      0.02),
                              width: media.width * 0.9,
                              child: Text(
                                _cancellingError,
                                style:
                                    GoogleFonts.roboto(
                                  fontSize:
                                      media.width *
                                          twelve,
                                  color: Colors.red,
                                ),
                              ),
                            )
                          : Container(),
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment
                                .spaceBetween,
                        children: [
                          Button(
                              color: page,
                              textcolor: buttonColor,
                              width: media.width * 0.39,
                              onTap: () async {
                                _updateState(() {
                                  _isLoading = true;
                                });
                                if (_cancelReason !=
                                    '') {
                                  if (_cancelReason ==
                                      'others') {
                                    if (_cancelCustomReason !=
                                            '' &&
                                        _cancelCustomReason
                                            .isNotEmpty) {
                                      _cancellingError =
                                          '';
                                      await cancelRequestWithReason(
                                          _cancelCustomReason);
                                      _updateState(() {
                                        _cancelling =
                                            false;
                                      });
                                    } else {
                                      _updateState(() {
                                        _cancellingError =
                                            context.l10n.text_add_cancel_reason;
                                      });
                                    }
                                  } else {
                                    await cancelRequestWithReason(
                                        _cancelReason);
                                    _updateState(() {
                                      _cancelling =
                                          false;
                                    });
                                  }
                                } else {}
                                _updateState(() {
                                  _isLoading = false;
                                });
                              },
                              text: context.l10n.text_cancel),
                          Button(
                              width: media.width * 0.39,
                              onTap: () {
                                _updateState(() {
                                  _cancelling = false;
                                });
                              },
                              text: context.l10n.tex_dontcancel)
                        ],
                      )
                    ]),
                  ),
                ],
              ),
            ),
          )
        : Container();

  }

  Widget buildDateTimePickerModal(Size media) {
    return (_dateTimePicker == true)
        ? Positioned(
            top: 0,
            child: Container(
              height: media.height * 1,
              width: media.width * 1,
              color:
                  Colors.transparent.withOpacity(0.6),
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: media.width * 0.9,
                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment.end,
                      children: [
                        Container(
                            height: media.height * 0.1,
                            width: media.width * 0.1,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: page),
                            child: InkWell(
                                onTap: () {
                                  _updateState(() {
                                    _dateTimePicker =
                                        false;
                                  });
                                },
                                child: const Icon(Icons
                                    .cancel_outlined))),
                      ],
                    ),
                  ),
                  Container(
                    height: media.width * 0.5,
                    width: media.width * 0.9,
                    decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(12),
                        color: page),
                    child: CupertinoDatePicker(
                        minimumDate: DateTime.now().add(
                            Duration(
                                minutes: int.parse(
                                    userDetails[
                                        'user_can_make_a_ride_after_x_miniutes']))),
                        initialDateTime: DateTime.now()
                            .add(Duration(
                                minutes: int.parse(
                                    userDetails[
                                        'user_can_make_a_ride_after_x_miniutes']))),
                        maximumDate: DateTime.now().add(
                            const Duration(days: 4)),
                        onDateTimeChanged: (val) {
                          choosenDateTime = val;
                        }),
                  ),
                  Container(
                      padding: EdgeInsets.all(
                          media.width * 0.05),
                      child: Button(
                          onTap: () {
                            _updateState(() {
                              _dateTimePicker = false;
                              _confirmRideLater = true;
                            });
                          },
                          text:
                              context.l10n.text_confirm))
                ],
              ),
            ))
        : Container();

  }

  Widget buildConfirmRideLaterModal(Size media) {
    return (_confirmRideLater == true)
        ? Positioned(
            child: Container(
              height: media.height * 1,
              width: media.width * 1,
              color:
                  Colors.transparent.withOpacity(0.6),
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: media.width * 0.9,
                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment.end,
                      children: [
                        Container(
                            height: media.height * 0.1,
                            width: media.width * 0.1,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: page),
                            child: InkWell(
                                onTap: () {
                                  _updateState(() {
                                    _dateTimePicker =
                                        true;
                                    _confirmRideLater =
                                        false;
                                  });
                                },
                                child: const Icon(Icons
                                    .cancel_outlined))),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(
                        media.width * 0.05),
                    width: media.width * 0.9,
                    decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(12),
                        color: page),
                    child: Column(
                      children: [
                        Text(
                          context.l10n.text_confirmridelater,
                          style: GoogleFonts.roboto(
                              fontSize: media.width *
                                  fourteen,
                              color: textColor),
                        ),
                        SizedBox(
                          height: media.width * 0.05,
                        ),
                        Text(
                          DateFormat()
                              .format(choosenDateTime)
                              .toString(),
                          style: GoogleFonts.roboto(
                              fontSize:
                                  media.width * sixteen,
                              color: textColor,
                              fontWeight:
                                  FontWeight.w600),
                        ),
                        SizedBox(
                          height: media.width * 0.05,
                        ),
                        Button(
                            onTap: () async {
                              if (widget.type != 1) {
                                if (etaDetails[
                                            choosenVehicle]
                                        [
                                        'has_discount'] ==
                                    false) {
                                  dynamic val;
                                  _updateState(() {
                                    _isLoading = true;
                                  });

                                  val =
                                      await createRequestLater();
                                  _updateState(() {
                                    if (val ==
                                        'success') {
                                      _isLoading =
                                          false;
                                      _confirmRideLater =
                                          false;
                                      _rideLaterSuccess =
                                          true;
                                    }
                                  });
                                } else {
                                  dynamic val;
                                  _updateState(() {
                                    _isLoading = true;
                                  });

                                  val =
                                      await createRequestLaterPromo();
                                  _updateState(() {
                                    if (val ==
                                        'success') {
                                      _isLoading =
                                          false;

                                      _confirmRideLater =
                                          false;
                                      _rideLaterSuccess =
                                          true;
                                    }
                                  });
                                }
                              } else {
                                if (rentalOption[
                                            choosenVehicle]
                                        [
                                        'has_discount'] ==
                                    false) {
                                  dynamic val;
                                  _updateState(() {
                                    _isLoading = true;
                                  });

                                  val =
                                      await createRentalRequestLater();
                                  _updateState(() {
                                    if (val ==
                                        'success') {
                                      _isLoading =
                                          false;
                                      _confirmRideLater =
                                          false;
                                      _rideLaterSuccess =
                                          true;
                                    }
                                  });
                                } else {
                                  dynamic val;
                                  _updateState(() {
                                    _isLoading = true;
                                  });

                                  val =
                                      await createRentalRequestLaterPromo();
                                  _updateState(() {
                                    if (val ==
                                        'success') {
                                      _isLoading =
                                          false;

                                      _confirmRideLater =
                                          false;
                                      _rideLaterSuccess =
                                          true;
                                    }
                                  });
                                }
                                _updateState(() {
                                  _isLoading = false;
                                });
                              }
                            },
                            text: context.l10n.text_confirm)
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        : Container();

  }

  Widget buildRideLaterSuccessModal(Size media) {
    return (_rideLaterSuccess == true)
        ? Positioned(
            child: Container(
            height: media.height * 1,
            width: media.width * 1,
            color: Colors.transparent.withOpacity(0.6),
            child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: [
                  Container(
                    width: media.width * 0.9,
                    decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(12),
                        color: page),
                    padding: EdgeInsets.all(
                        media.width * 0.05),
                    child: Column(
                      children: [
                        Text(
                          context.l10n.text_rideLaterSuccess,
                          style: GoogleFonts.roboto(
                              fontSize: media.width *
                                  fourteen,
                              color: textColor,
                              fontWeight:
                                  FontWeight.w600),
                        ),
                        SizedBox(
                          height: media.width * 0.05,
                        ),
                        Button(
                            onTap: () {
                              addressList.removeWhere(
                                  (element) =>
                                      element.id ==
                                      'drop');
                              _rideLaterSuccess = false;
                              // addressList.clear();
                              myMarker.clear();
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const Maps()),
                                  (route) => false);
                            },
                            text: context.l10n.text_confirm)
                      ],
                    ),
                  )
                ]),
          ))
        : Container();

  }

  Widget buildSosModal(Size media) {
    return (showSos == true)
        ? Positioned(
            top: 0,
            child: Container(
              height: media.height * 1,
              width: media.width * 1,
              color:
                  Colors.transparent.withOpacity(0.6),
              child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: media.width * 0.7,
                      child: Row(
                        mainAxisAlignment:
                            MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () {
                              _updateState(() {
                                notifyCompleted = false;
                                showSos = false;
                              });
                            },
                            child: Container(
                              height: media.width * 0.1,
                              width: media.width * 0.1,
                              decoration: BoxDecoration(
                                  shape:
                                      BoxShape.circle,
                                  color: page),
                              child: const Icon(Icons
                                  .cancel_outlined),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: media.width * 0.05,
                    ),
                    Container(
                      padding: EdgeInsets.all(
                          media.width * 0.05),
                      height: media.height * 0.5,
                      width: media.width * 0.7,
                      decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(12),
                          color: page),
                      child: SingleChildScrollView(
                          physics:
                              const BouncingScrollPhysics(),
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,
                            children: [
                              InkWell(
                                onTap: () async {
                                  _updateState(() {
                                    notifyCompleted =
                                        false;
                                  });
                                  var val =
                                      await notifyAdmin();
                                  if (val == true) {
                                    _updateState(() {
                                      notifyCompleted =
                                          true;
                                    });
                                  }
                                },
                                child: Container(
                                  padding:
                                      EdgeInsets.all(
                                          media.width *
                                              0.05),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment
                                            .spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment
                                                .start,
                                        children: [
                                          Text(
                                            context.l10n.text_notifyadmin,
                                            style: GoogleFonts.roboto(
                                                fontSize:
                                                    media.width *
                                                        sixteen,
                                                color:
                                                    textColor,
                                                fontWeight:
                                                    FontWeight.w600),
                                          ),
                                          (notifyCompleted ==
                                                  true)
                                              ? Container(
                                                  padding:
                                                      EdgeInsets.only(top: media.width * 0.01),
                                                  child:
                                                      Text(
                                                    context.l10n.text_notifysuccess,
                                                    style:
                                                        GoogleFonts.roboto(
                                                      fontSize: media.width * twelve,
                                                      color: const Color(0xff319900),
                                                    ),
                                                  ),
                                                )
                                              : Container()
                                        ],
                                      ),
                                      const Icon(Icons
                                          .notification_add)
                                    ],
                                  ),
                                ),
                              ),
                              (sosData.isNotEmpty)
                                  ? Column(
                                      children: sosData
                                          .asMap()
                                          .map((i,
                                              value) {
                                            return MapEntry(
                                                i,
                                                InkWell(
                                                  onTap:
                                                      () {
                                                    makingPhoneCall(sosData[i]['number'].toString().replaceAll(' ',
                                                        ''));
                                                  },
                                                  child:
                                                      Container(
                                                    padding:
                                                        EdgeInsets.all(media.width * 0.05),
                                                    child:
                                                        Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            SizedBox(
                                                              width: media.width * 0.4,
                                                              child: Text(
                                                                sosData[i]['name'],
                                                                style: GoogleFonts.roboto(fontSize: media.width * fourteen, color: textColor, fontWeight: FontWeight.w600),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: media.width * 0.01,
                                                            ),
                                                            Text(
                                                              sosData[i]['number'],
                                                              style: GoogleFonts.roboto(
                                                                fontSize: media.width * twelve,
                                                                color: textColor,
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                        const Icon(Icons.call)
                                                      ],
                                                    ),
                                                  ),
                                                ));
                                          })
                                          .values
                                          .toList(),
                                    )
                                  : Container(
                                      width:
                                          media.width *
                                              0.7,
                                      alignment:
                                          Alignment
                                              .center,
                                      child: Text(
                                        context.l10n.text_no_data_found,
                                        style: GoogleFonts.roboto(
                                            fontSize: media
                                                    .width *
                                                eighteen,
                                            fontWeight:
                                                FontWeight
                                                    .w600,
                                            color:
                                                textColor),
                                      ),
                                    ),
                            ],
                          )),
                    )
                  ]),
            ))
        : Container();

  }

  Widget buildLocationDeniedModal(Size media) {
    return (_locationDenied == true)
        ? Positioned(
            child: Container(
            height: media.height * 1,
            width: media.width * 1,
            color: Colors.transparent.withOpacity(0.6),
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: media.width * 0.9,
                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          _updateState(() {
                            _locationDenied = false;
                          });
                        },
                        child: Container(
                          height: media.height * 0.05,
                          width: media.height * 0.05,
                          decoration: BoxDecoration(
                            color: page,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.cancel,
                              color: buttonColor),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: media.width * 0.025),
                Container(
                  padding: EdgeInsets.all(
                      media.width * 0.05),
                  width: media.width * 0.9,
                  decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(12),
                      color: page,
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 2.0,
                            spreadRadius: 2.0,
                            color: Colors.black
                                .withOpacity(0.2))
                      ]),
                  child: Column(
                    children: [
                      SizedBox(
                          width: media.width * 0.8,
                          child: Text(
                            context.l10n.text_open_loc_settings,
                            style: GoogleFonts.roboto(
                                fontSize: media.width *
                                    sixteen,
                                color: textColor,
                                fontWeight:
                                    FontWeight.w600),
                          )),
                      SizedBox(
                          height: media.width * 0.05),
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment
                                .spaceBetween,
                        children: [
                          InkWell(
                              onTap: () async {
                                await perm
                                    .openAppSettings();
                              },
                              child: Text(
                                context.l10n.text_open_settings,
                                style:
                                    GoogleFonts.roboto(
                                        fontSize: media
                                                .width *
                                            sixteen,
                                        color:
                                            buttonColor,
                                        fontWeight:
                                            FontWeight
                                                .w600),
                              )),
                          InkWell(
                              onTap: () async {
                                _updateState(() {
                                  _locationDenied =
                                      false;
                                  _isLoading = true;
                                });

                                if (timerLocation ==
                                        null &&
                                    locationAllowed ==
                                        true) {
                                  getCurrentLocation();
                                }
                              },
                              child: Text(
                                context.l10n.text_done,
                                style:
                                    GoogleFonts.roboto(
                                        fontSize: media
                                                .width *
                                            sixteen,
                                        color:
                                            buttonColor,
                                        fontWeight:
                                            FontWeight
                                                .w600),
                              ))
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ))
        : Container();

  }

  Widget buildLoadingOverlay() {
    return (_isLoading == true)
        ? const Positioned(top: 0, child: Loading())
        : Container();

  }

  Widget buildNoInternetOverlay() {
    return (internet == false)
        ? Positioned(
            top: 0,
            child: NoInternet(
              onTap: () {
                _updateState(() {
                  internetTrue();
                });
              },
            ))
        : Container();

  }
}
