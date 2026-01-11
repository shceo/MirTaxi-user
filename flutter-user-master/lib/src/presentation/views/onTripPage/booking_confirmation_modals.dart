part of 'booking_confirmation.dart';

extension _BookingConfirmationModals on _BookingConfirmationState {
  Widget buildTopBackButton(Size media, {double? bottom, VoidCallback? onTap}) {
    final top = MediaQuery.of(context).padding.top;
    return Positioned(
      top: bottom == null ? top + 12 : null,
      bottom: bottom,
      left: 12,
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onTap ?? () => Navigator.maybePop(context),
        child: Container(
          height: 44,
          width: 44,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, 6),
                blurRadius: 14,
                color: Colors.black.withOpacity(0.18),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: const Icon(Icons.arrow_back, color: Colors.black),
        ),
      ),
    );
  }

  Widget buildBookingBottomPanel(Size media) {
    final list = (widget.type != 1) ? etaDetails : rentalOption;

    final pick = _bcShort(_bcAddressById('pickup'));
    final drop = _bcShort(_bcAddressById('drop'));
    final routeText = (pick.isNotEmpty && drop.isNotEmpty) ? '$pick > $drop' : (pick.isNotEmpty ? pick : (drop.isNotEmpty ? drop : '—'));

    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: SafeArea(
        top: false,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, -6),
                blurRadius: 18,
                color: Colors.black.withOpacity(0.10),
              ),
            ],
          ),
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _BcRow(
                leading: const Icon(Icons.radio_button_unchecked, size: 18, color: Colors.black),
                title: pick.isNotEmpty ? pick : '—',
                trailing: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF2F5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'Подъезд',
                    style: GoogleFonts.roboto(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF111827),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Divider(height: 1, thickness: 1, color: Color(0xFFE5E7EB)),
              const SizedBox(height: 10),
              _BcRow(
                leading: const Icon(Icons.alt_route_rounded, size: 20, color: Colors.black),
                title: routeText,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _bcTripEtaText(),
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF9CA3AF),
                      ),
                    ),
                    const SizedBox(width: 12),
                    InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () {},
                      child: Container(
                        height: 28,
                        width: 28,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F4F6),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        alignment: Alignment.center,
                        child: const Icon(Icons.add, size: 18, color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              const Divider(height: 1, thickness: 1, color: Color(0xFFE5E7EB)),
              const SizedBox(height: 10),
              SizedBox(
                height: 92,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: list.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 10),
                  itemBuilder: (context, i) {
                    final item = list[i];
                    final isSelected = i == choosenVehicle;
                    return _BcVehicleCard(
                      isSelected: isSelected,
                      etaText: _bcVehicleEta(item),
                      name: _bcVehicleName(item),
                      price: _bcVehiclePrice(item),
                      image: _bcVehicleImage(item),
                      onTap: () => _updateState(() => choosenVehicle = i),
                      onInfo: () => _updateState(() {
                        _showInfo = true;
                        _showInfoInt = i;
                      }),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => _updateState(() => _choosePayment = true),
                    child: const SizedBox(
                      height: 48,
                      width: 48,
                      child: Center(
                        child: Icon(Icons.account_balance_wallet_rounded, size: 26, color: Color(0xFF22C55E)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () => _updateState(() => _choosePayment = true),
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(255, 220, 113, 1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Заказать',
                          style: GoogleFonts.roboto(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {},
                    child: const SizedBox(
                      height: 48,
                      width: 48,
                      child: Center(
                        child: Icon(Icons.tune, size: 24, color: Colors.black),
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
  }

  Widget buildVehicleInfoModal(Size media) {
    if (_showInfo != true) return Container();
    final idx = _showInfoInt;
    if (idx == null) return Container();

    final data = (widget.type != 1) ? etaDetails : rentalOption;
    if (idx < 0 || idx >= data.length) return Container();

    final item = data[idx];
    final isRental = widget.type == 1;

    final name = (item['name'] ?? '').toString();
    final desc = (item['description'] ?? '').toString();
    final supported = (item['supported_vehicles'] ?? '').toString();

    final hasDiscount = item['has_discount'] == true;
    final currency = (item['currency'] ?? '').toString();
    final baseAmount = isRental ? item['fare_amount'] : item['total'];
    final discountAmount = item['discounted_totel'] ?? item['discounted_total'];

    return Positioned(
      top: 0,
      child: Container(
        padding: EdgeInsets.only(bottom: media.width * 0.05),
        height: media.height,
        width: media.width,
        color: Colors.transparent.withOpacity(0.6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              width: media.width * 0.9,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
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
                      decoration: BoxDecoration(shape: BoxShape.circle, color: page),
                      child: const Icon(Icons.cancel_outlined),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: media.width * 0.05),
            Container(
              width: media.width * 0.9,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: page),
              padding: EdgeInsets.all(media.width * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: GoogleFonts.roboto(
                      fontSize: media.width * sixteen,
                      color: textColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: media.width * 0.025),
                  Text(
                    desc,
                    style: GoogleFonts.roboto(
                      fontSize: media.width * fourteen,
                      color: textColor,
                    ),
                  ),
                  SizedBox(height: media.width * 0.05),
                  Text(
                    context.l10n.text_supported_vehicles,
                    style: GoogleFonts.roboto(
                      fontSize: media.width * sixteen,
                      color: textColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: media.width * 0.025),
                  Text(
                    supported,
                    style: GoogleFonts.roboto(
                      fontSize: media.width * fourteen,
                      color: textColor,
                    ),
                  ),
                  SizedBox(height: media.width * 0.05),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: media.width * 0.4,
                        child: Text(
                          context.l10n.text_estimated_amount,
                          style: GoogleFonts.roboto(
                            fontSize: media.width * sixteen,
                            color: textColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      if (!hasDiscount)
                        Text(
                          '$currency ${_bcMoney(baseAmount)}',
                          style: GoogleFonts.roboto(
                            fontSize: media.width * fourteen,
                            color: textColor,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      else
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              '$currency ',
                              style: GoogleFonts.roboto(
                                fontSize: media.width * fourteen,
                                color: textColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              _bcMoney(baseAmount),
                              style: GoogleFonts.roboto(
                                fontSize: media.width * fourteen,
                                color: textColor,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                            Text(
                              ' ${_bcMoney(discountAmount)}',
                              style: GoogleFonts.roboto(
                                fontSize: media.width * fourteen,
                                color: textColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildChoosePaymentModal(Size media) {
    if (_choosePayment != true) return Container();

    final isRental = widget.type == 1;
    final current = isRental ? rentalOption[choosenVehicle] : etaDetails[choosenVehicle];
    final types = (current['payment_type'] ?? '').toString().split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();

    return Positioned(
      top: 0,
      child: Container(
        height: media.height,
        width: media.width,
        color: Colors.transparent.withOpacity(0.6),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: SizedBox(
              height: media.height,
              width: media.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: media.width * 0.9,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () {
                            _updateState(() {
                              _choosePayment = false;
                              promoKey.clear();
                            });
                          },
                          child: Container(
                            height: media.width * 0.1,
                            width: media.width * 0.1,
                            decoration: BoxDecoration(shape: BoxShape.circle, color: page),
                            child: const Icon(Icons.cancel_outlined),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: media.width * 0.05),
                  Container(
                    width: media.width * 0.9,
                    decoration: BoxDecoration(
                      color: page,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.all(media.width * 0.05),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.l10n.text_paymentmethod,
                          style: GoogleFonts.roboto(
                            fontSize: media.width * twenty,
                            fontWeight: FontWeight.w600,
                            color: textColor,
                          ),
                        ),
                        SizedBox(height: media.height * 0.015),
                        Text(
                          context.l10n.text_choose_paynoworlater,
                          style: GoogleFonts.roboto(
                            fontSize: media.width * twelve,
                            fontWeight: FontWeight.w600,
                            color: textColor,
                          ),
                        ),
                        SizedBox(height: media.height * 0.015),
                        Column(
                          children: types.asMap().entries.map((e) {
                            final i = e.key;
                            final value = e.value;

                            return InkWell(
                              onTap: () => _updateState(() => payingVia = i),
                              child: Container(
                                padding: EdgeInsets.all(media.width * 0.02),
                                width: media.width * 0.9,
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: media.width * 0.06,
                                      child: _bcPaymentIcon(value),
                                    ),
                                    SizedBox(width: media.width * 0.05),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          value,
                                          style: GoogleFonts.roboto(
                                            fontSize: media.width * fourteen,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          _bcPaymentHint(value),
                                          style: GoogleFonts.roboto(fontSize: media.width * ten),
                                        ),
                                      ],
                                    ),
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Container(
                                            height: media.width * 0.05,
                                            width: media.width * 0.05,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: page,
                                              border: Border.all(color: Colors.black, width: 1.2),
                                            ),
                                            alignment: Alignment.center,
                                            child: (payingVia == i)
                                                ? Container(
                                                    height: media.width * 0.03,
                                                    width: media.width * 0.03,
                                                    decoration: const BoxDecoration(
                                                      color: Colors.black,
                                                      shape: BoxShape.circle,
                                                    ),
                                                  )
                                                : Container(),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        SizedBox(height: media.height * 0.02),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: borderLines, width: 1.2),
                          ),
                          padding: EdgeInsets.fromLTRB(media.width * 0.025, 0, media.width * 0.025, 0),
                          width: media.width * 0.9,
                          child: Row(
                            children: [
                              SizedBox(
                                width: media.width * 0.06,
                                child: Image.asset('assets/images/promocode.png', fit: BoxFit.contain),
                              ),
                              SizedBox(width: media.width * 0.05),
                              Expanded(
                                child: (promoStatus == null)
                                    ? TextField(
                                        controller: promoKey,
                                        onChanged: (val) => _updateState(() => promoCode = val),
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: context.l10n.text_enterpromo,
                                          hintStyle: GoogleFonts.roboto(
                                            fontSize: media.width * twelve,
                                            color: hintColor,
                                          ),
                                        ),
                                      )
                                    : (promoStatus == 1)
                                        ? Container(
                                            padding: EdgeInsets.fromLTRB(0, media.width * 0.045, 0, media.width * 0.045),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Column(
                                                  children: [
                                                    Text(
                                                      promoKey.text,
                                                      style: GoogleFonts.roboto(fontSize: media.width * ten, color: const Color(0xff319900)),
                                                    ),
                                                    Text(
                                                      context.l10n.text_promoaccepted,
                                                      style: GoogleFonts.roboto(fontSize: media.width * ten, color: const Color(0xff319900)),
                                                    ),
                                                  ],
                                                ),
                                                InkWell(
                                                  onTap: () async {
                                                    _updateState(() => _isLoading = true);
                                                    dynamic result;
                                                    if (!isRental) {
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
                                                  child: Text(
                                                    context.l10n.text_remove,
                                                    style: GoogleFonts.roboto(fontSize: media.width * twelve, color: const Color(0xff319900)),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        : (promoStatus == 2)
                                            ? Container(
                                                padding: EdgeInsets.fromLTRB(0, media.width * 0.045, 0, media.width * 0.045),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                      promoKey.text,
                                                      style: GoogleFonts.roboto(fontSize: media.width * twelve, color: const Color(0xffFF0000)),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        _updateState(() {
                                                          promoStatus = null;
                                                          promoCode = '';
                                                          promoKey.clear();
                                                          if (!isRental) {
                                                            etaRequest();
                                                          } else {
                                                            rentalEta();
                                                          }
                                                        });
                                                      },
                                                      child: Text(
                                                        context.l10n.text_remove,
                                                        style: GoogleFonts.roboto(fontSize: media.width * twelve, color: const Color(0xffFF0000)),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : Container(),
                              ),
                            ],
                          ),
                        ),
                        if (promoStatus == 2)
                          Container(
                            width: media.width * 0.9,
                            alignment: Alignment.center,
                            padding: EdgeInsets.only(top: media.height * 0.02),
                            child: Text(
                              context.l10n.text_promorejected,
                              style: GoogleFonts.roboto(fontSize: media.width * ten, color: const Color(0xffFF0000)),
                            ),
                          ),
                        SizedBox(height: media.height * 0.02),
                        Button(
                          onTap: () async {
                            if (promoCode == '') {
                              _updateState(() => _choosePayment = false);
                              return;
                            }
                            _updateState(() => _isLoading = true);
                            if (!isRental) {
                              await etaRequestWithPromo();
                            } else {
                              await rentalRequestWithPromo();
                            }
                            _updateState(() => _isLoading = false);
                          },
                          text: context.l10n.text_confirm,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCancelRequestModal(Size media) {
    return (_cancelling == true)
        ? Positioned(
            child: Container(
              height: media.height * 1,
              width: media.width * 1,
              color: Colors.transparent.withOpacity(0.6),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(media.width * 0.05),
                    width: media.width * 0.9,
                    decoration: BoxDecoration(color: page, borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      children: [
                        Container(
                          height: media.width * 0.18,
                          width: media.width * 0.18,
                          decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xffFEF2F2)),
                          alignment: Alignment.center,
                          child: Container(
                            height: media.width * 0.14,
                            width: media.width * 0.14,
                            decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xffFF0000)),
                            child: const Center(
                              child: Icon(Icons.cancel_outlined, color: Colors.white),
                            ),
                          ),
                        ),
                        Column(
                          children: cancelReasonsList
                              .asMap()
                              .map((i, value) {
                                return MapEntry(
                                  i,
                                  InkWell(
                                    onTap: () => _updateState(() => _cancelReason = cancelReasonsList[i]['reason']),
                                    child: Container(
                                      padding: EdgeInsets.all(media.width * 0.01),
                                      child: Row(
                                        children: [
                                          Container(
                                            height: media.height * 0.05,
                                            width: media.width * 0.05,
                                            decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.black, width: 1.2)),
                                            alignment: Alignment.center,
                                            child: (_cancelReason == cancelReasonsList[i]['reason'])
                                                ? Container(
                                                    height: media.width * 0.03,
                                                    width: media.width * 0.03,
                                                    decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.black),
                                                  )
                                                : Container(),
                                          ),
                                          SizedBox(width: media.width * 0.05),
                                          SizedBox(
                                            width: media.width * 0.65,
                                            child: Text(cancelReasonsList[i]['reason']),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              })
                              .values
                              .toList(),
                        ),
                        InkWell(
                          onTap: () => _updateState(() => _cancelReason = 'others'),
                          child: Container(
                            padding: EdgeInsets.all(media.width * 0.01),
                            child: Row(
                              children: [
                                Container(
                                  height: media.height * 0.05,
                                  width: media.width * 0.05,
                                  decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.black, width: 1.2)),
                                  alignment: Alignment.center,
                                  child: (_cancelReason == 'others')
                                      ? Container(
                                          height: media.width * 0.03,
                                          width: media.width * 0.03,
                                          decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.black),
                                        )
                                      : Container(),
                                ),
                                SizedBox(width: media.width * 0.05),
                                Text(context.l10n.text_others),
                              ],
                            ),
                          ),
                        ),
                        (_cancelReason == 'others')
                            ? Container(
                                margin: EdgeInsets.fromLTRB(0, media.width * 0.025, 0, media.width * 0.025),
                                padding: EdgeInsets.all(media.width * 0.05),
                                width: media.width * 0.9,
                                decoration: BoxDecoration(
                                  border: Border.all(color: borderLines, width: 1.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: TextField(
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: context.l10n.text_cancelRideReason,
                                    hintStyle: GoogleFonts.roboto(fontSize: media.width * twelve),
                                  ),
                                  maxLines: 4,
                                  minLines: 2,
                                  onChanged: (val) => _updateState(() => _cancelCustomReason = val),
                                ),
                              )
                            : Container(),
                        (_cancellingError != '')
                            ? Container(
                                padding: EdgeInsets.only(top: media.width * 0.02, bottom: media.width * 0.02),
                                width: media.width * 0.9,
                                child: Text(
                                  _cancellingError,
                                  style: GoogleFonts.roboto(fontSize: media.width * twelve, color: Colors.red),
                                ),
                              )
                            : Container(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Button(
                              color: page,
                              textcolor: buttonColor,
                              width: media.width * 0.39,
                              onTap: () async {
                                _updateState(() => _isLoading = true);

                                if (_cancelReason != '') {
                                  if (_cancelReason == 'others') {
                                    if (_cancelCustomReason != '' && _cancelCustomReason.isNotEmpty) {
                                      _cancellingError = '';
                                      await cancelRequestWithReason(_cancelCustomReason);
                                      _updateState(() => _cancelling = false);
                                    } else {
                                      _updateState(() => _cancellingError = context.l10n.text_add_cancel_reason);
                                    }
                                  } else {
                                    await cancelRequestWithReason(_cancelReason);
                                    _updateState(() => _cancelling = false);
                                  }
                                }

                                _updateState(() => _isLoading = false);
                              },
                              text: context.l10n.text_cancel,
                            ),
                            Button(
                              width: media.width * 0.39,
                              onTap: () => _updateState(() => _cancelling = false),
                              text: context.l10n.tex_dontcancel,
                            ),
                          ],
                        ),
                      ],
                    ),
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
              color: Colors.transparent.withOpacity(0.6),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: media.width * 0.9,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          height: media.height * 0.1,
                          width: media.width * 0.1,
                          decoration: BoxDecoration(shape: BoxShape.circle, color: page),
                          child: InkWell(
                            onTap: () => _updateState(() => _dateTimePicker = false),
                            child: const Icon(Icons.cancel_outlined),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: media.width * 0.5,
                    width: media.width * 0.9,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: page),
                    child: CupertinoDatePicker(
                      minimumDate: DateTime.now().add(
                        Duration(minutes: int.parse(userDetails['user_can_make_a_ride_after_x_miniutes'])),
                      ),
                      initialDateTime: DateTime.now().add(
                        Duration(minutes: int.parse(userDetails['user_can_make_a_ride_after_x_miniutes'])),
                      ),
                      maximumDate: DateTime.now().add(const Duration(days: 4)),
                      onDateTimeChanged: (val) => choosenDateTime = val,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(media.width * 0.05),
                    child: Button(
                      onTap: () {
                        _updateState(() {
                          _dateTimePicker = false;
                          _confirmRideLater = true;
                        });
                      },
                      text: context.l10n.text_confirm,
                    ),
                  ),
                ],
              ),
            ),
          )
        : Container();
  }

  Widget buildConfirmRideLaterModal(Size media) {
    return (_confirmRideLater == true)
        ? Positioned(
            child: Container(
              height: media.height * 1,
              width: media.width * 1,
              color: Colors.transparent.withOpacity(0.6),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: media.width * 0.9,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          height: media.height * 0.1,
                          width: media.width * 0.1,
                          decoration: BoxDecoration(shape: BoxShape.circle, color: page),
                          child: InkWell(
                            onTap: () {
                              _updateState(() {
                                _dateTimePicker = true;
                                _confirmRideLater = false;
                              });
                            },
                            child: const Icon(Icons.cancel_outlined),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(media.width * 0.05),
                    width: media.width * 0.9,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: page),
                    child: Column(
                      children: [
                        Text(
                          context.l10n.text_confirmridelater,
                          style: GoogleFonts.roboto(fontSize: media.width * fourteen, color: textColor),
                        ),
                        SizedBox(height: media.width * 0.05),
                        Text(
                          DateFormat().format(choosenDateTime).toString(),
                          style: GoogleFonts.roboto(
                            fontSize: media.width * sixteen,
                            color: textColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: media.width * 0.05),
                        Button(
                          onTap: () async {
                            final isRental = widget.type == 1;

                            if (!isRental) {
                              if (etaDetails[choosenVehicle]['has_discount'] == false) {
                                _updateState(() => _isLoading = true);
                                final val = await createRequestLater();
                                _updateState(() {
                                  if (val == 'success') {
                                    _isLoading = false;
                                    _confirmRideLater = false;
                                    _rideLaterSuccess = true;
                                  }
                                });
                              } else {
                                _updateState(() => _isLoading = true);
                                final val = await createRequestLaterPromo();
                                _updateState(() {
                                  if (val == 'success') {
                                    _isLoading = false;
                                    _confirmRideLater = false;
                                    _rideLaterSuccess = true;
                                  }
                                });
                              }
                            } else {
                              if (rentalOption[choosenVehicle]['has_discount'] == false) {
                                _updateState(() => _isLoading = true);
                                final val = await createRentalRequestLater();
                                _updateState(() {
                                  if (val == 'success') {
                                    _isLoading = false;
                                    _confirmRideLater = false;
                                    _rideLaterSuccess = true;
                                  }
                                });
                              } else {
                                _updateState(() => _isLoading = true);
                                final val = await createRentalRequestLaterPromo();
                                _updateState(() {
                                  if (val == 'success') {
                                    _isLoading = false;
                                    _confirmRideLater = false;
                                    _rideLaterSuccess = true;
                                  }
                                });
                              }
                              _updateState(() => _isLoading = false);
                            }
                          },
                          text: context.l10n.text_confirm,
                        ),
                      ],
                    ),
                  ),
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: media.width * 0.9,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: page),
                    padding: EdgeInsets.all(media.width * 0.05),
                    child: Column(
                      children: [
                        Text(
                          context.l10n.text_rideLaterSuccess,
                          style: GoogleFonts.roboto(
                            fontSize: media.width * fourteen,
                            color: textColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: media.width * 0.05),
                        Button(
                          onTap: () {
                            addressList.removeWhere((element) => element.id == 'drop');
                            _rideLaterSuccess = false;
                            myMarker.clear();
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => const Maps()),
                              (route) => false,
                            );
                          },
                          text: context.l10n.text_confirm,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        : Container();
  }

  Widget buildSosModal(Size media) {
    return (showSos == true)
        ? Positioned(
            top: 0,
            child: Container(
              height: media.height * 1,
              width: media.width * 1,
              color: Colors.transparent.withOpacity(0.6),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: media.width * 0.7,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
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
                            decoration: BoxDecoration(shape: BoxShape.circle, color: page),
                            child: const Icon(Icons.cancel_outlined),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: media.width * 0.05),
                  Container(
                    padding: EdgeInsets.all(media.width * 0.05),
                    height: media.height * 0.5,
                    width: media.width * 0.7,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: page),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () async {
                              _updateState(() => notifyCompleted = false);
                              final val = await notifyAdmin();
                              if (val == true) _updateState(() => notifyCompleted = true);
                            },
                            child: Container(
                              padding: EdgeInsets.all(media.width * 0.05),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        context.l10n.text_notifyadmin,
                                        style: GoogleFonts.roboto(
                                          fontSize: media.width * sixteen,
                                          color: textColor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      (notifyCompleted == true)
                                          ? Container(
                                              padding: EdgeInsets.only(top: media.width * 0.01),
                                              child: Text(
                                                context.l10n.text_notifysuccess,
                                                style: GoogleFonts.roboto(
                                                  fontSize: media.width * twelve,
                                                  color: const Color(0xff319900),
                                                ),
                                              ),
                                            )
                                          : Container(),
                                    ],
                                  ),
                                  const Icon(Icons.notification_add),
                                ],
                              ),
                            ),
                          ),
                          (sosData.isNotEmpty)
                              ? Column(
                                  children: sosData
                                      .asMap()
                                      .map((i, value) {
                                        return MapEntry(
                                          i,
                                          InkWell(
                                            onTap: () => makingPhoneCall(
                                              sosData[i]['number'].toString().replaceAll(' ', ''),
                                            ),
                                            child: Container(
                                              padding: EdgeInsets.all(media.width * 0.05),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      SizedBox(
                                                        width: media.width * 0.4,
                                                        child: Text(
                                                          sosData[i]['name'],
                                                          style: GoogleFonts.roboto(
                                                            fontSize: media.width * fourteen,
                                                            color: textColor,
                                                            fontWeight: FontWeight.w600,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(height: media.width * 0.01),
                                                      Text(
                                                        sosData[i]['number'],
                                                        style: GoogleFonts.roboto(
                                                          fontSize: media.width * twelve,
                                                          color: textColor,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const Icon(Icons.call),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      })
                                      .values
                                      .toList(),
                                )
                              : Container(
                                  width: media.width * 0.7,
                                  alignment: Alignment.center,
                                  child: Text(
                                    context.l10n.text_no_data_found,
                                    style: GoogleFonts.roboto(
                                      fontSize: media.width * eighteen,
                                      fontWeight: FontWeight.w600,
                                      color: textColor,
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
          )
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: media.width * 0.9,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () => _updateState(() => _locationDenied = false),
                          child: Container(
                            height: media.height * 0.05,
                            width: media.height * 0.05,
                            decoration: BoxDecoration(color: page, shape: BoxShape.circle),
                            child: Icon(Icons.cancel, color: buttonColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: media.width * 0.025),
                  Container(
                    padding: EdgeInsets.all(media.width * 0.05),
                    width: media.width * 0.9,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: page,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 2.0,
                          spreadRadius: 2.0,
                          color: Colors.black.withOpacity(0.2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          width: media.width * 0.8,
                          child: Text(
                            context.l10n.text_open_loc_settings,
                            style: GoogleFonts.roboto(
                              fontSize: media.width * sixteen,
                              color: textColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(height: media.width * 0.05),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () async => perm.openAppSettings(),
                              child: Text(
                                context.l10n.text_open_settings,
                                style: GoogleFonts.roboto(
                                  fontSize: media.width * sixteen,
                                  color: buttonColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                _updateState(() {
                                  _locationDenied = false;
                                  _isLoading = true;
                                });

                                if (timerLocation == null && locationAllowed == true) {
                                  getCurrentLocation();
                                }
                              },
                              child: Text(
                                context.l10n.text_done,
                                style: GoogleFonts.roboto(
                                  fontSize: media.width * sixteen,
                                  color: buttonColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        : Container();
  }

  Widget buildLoadingOverlay() {
    return (_isLoading == true) ? const Positioned(top: 0, child: Loading()) : Container();
  }

  Widget buildNoInternetOverlay() {
    return (internet == false)
        ? Positioned(
            top: 0,
            child: NoInternet(
              onTap: () => _updateState(() => internetTrue()),
            ),
          )
        : Container();
  }

  String _bcAddressById(String id) {
    try {
      final found = addressList.firstWhere((e) => (e as dynamic).id == id);
      final d = found as dynamic;
      final v = d.address ?? d.placeName ?? d.name ?? '';
      return v.toString();
    } catch (_) {
      return '';
    }
  }

  String _bcShort(String s) {
    final t = s.trim();
    if (t.isEmpty) return '';
    final first = t.split(',').first.trim();
    return first.isNotEmpty ? first : t;
  }

  String _bcTripEtaText() {
    try {
      final data = (widget.type != 1) ? etaDetails[choosenVehicle] : rentalOption[choosenVehicle];
      final v = data['trip_eta'] ?? data['eta'] ?? data['eta_minutes'] ?? data['time'] ?? data['duration'];
      if (v == null) return '—';
      if (v is num) return '${v.round()} мин';
      final s = v.toString().trim();
      if (s.isEmpty) return '—';
      return s.contains('мин') ? s : '$s мин';
    } catch (_) {
      return '5 мин';
    }
  }

  String _bcVehicleEta(dynamic item) {
    try {
      final v = item['eta'] ?? item['eta_minutes'] ?? item['time'] ?? item['duration'] ?? item['trip_eta'];
      if (v == null) return '';
      if (v is num) return '${v.round()} мин';
      final s = v.toString().trim();
      if (s.isEmpty) return '';
      return s.contains('мин') ? s : '$s мин';
    } catch (_) {
      return '';
    }
  }

  String _bcVehicleName(dynamic item) {
    try {
      final s = (item['name'] ?? item['vehicle_type'] ?? item['title'] ?? '').toString().trim();
      return s.isEmpty ? '—' : s;
    } catch (_) {
      return '—';
    }
  }

  String _bcVehiclePrice(dynamic item) {
    try {
      final currency = (item['currency'] ?? '').toString().trim();
      final hasDiscount = item['has_discount'] == true;
      final raw = hasDiscount ? (item['discounted_totel'] ?? item['discounted_total']) : (item['total'] ?? item['fare_amount']);
      final price = _bcMoney(raw);
      if (currency.isEmpty) return price;
      return '$price $currency';
    } catch (_) {
      return '';
    }
  }

  String _bcMoney(dynamic v) {
    if (v == null) return '0';
    if (v is num) {
      if (v >= 100) return v.toStringAsFixed(0);
      return v.toStringAsFixed(2);
    }
    final s = v.toString().trim();
    if (s.isEmpty) return '0';
    final n = double.tryParse(s.replaceAll(' ', '').replaceAll(',', '.'));
    if (n == null) return s;
    if (n >= 100) return n.toStringAsFixed(0);
    return n.toStringAsFixed(2);
  }

  Widget _bcVehicleImage(dynamic item) {
    try {
      final v = item['image'] ?? item['icon'] ?? item['vehicle_image'];
      if (v is String) {
        final s = v.trim();
        if (s.startsWith('http')) return Image.network(s, fit: BoxFit.contain);
        if (s.isNotEmpty) return Image.asset(s, fit: BoxFit.contain);
      }
      return const Icon(Icons.directions_car, size: 26, color: Colors.black);
    } catch (_) {
      return const Icon(Icons.directions_car, size: 26, color: Colors.black);
    }
  }

  Widget _bcPaymentIcon(String type) {
    final t = type.toLowerCase().trim();
    if (t == 'cash') return Image.asset('assets/images/cash.png', fit: BoxFit.contain);
    if (t == 'wallet') return Image.asset('assets/images/wallet.png', fit: BoxFit.contain);
    if (t == 'card') return Image.asset('assets/images/card.png', fit: BoxFit.contain);
    if (t == 'upi') return Image.asset('assets/images/upi.png', fit: BoxFit.contain);
    return const Icon(Icons.payment, size: 18);
  }

  String _bcPaymentHint(String type) {
    final t = type.toLowerCase().trim();
    if (t == 'cash') return context.l10n.text_paycash;
    if (t == 'wallet') return context.l10n.text_paywallet;
    if (t == 'card') return context.l10n.text_paycard;
    if (t == 'upi') return context.l10n.text_payupi;
    return '';
  }
}

class _BcRow extends StatelessWidget {
  final Widget leading;
  final String title;
  final Widget trailing;

  const _BcRow({required this.leading, required this.title, required this.trailing});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        leading,
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.roboto(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF111827),
            ),
          ),
        ),
        const SizedBox(width: 10),
        trailing,
      ],
    );
  }
}

class _BcVehicleCard extends StatelessWidget {
  final bool isSelected;
  final String etaText;
  final String name;
  final String price;
  final Widget image;
  final VoidCallback onTap;
  final VoidCallback onInfo;

  const _BcVehicleCard({
    required this.isSelected,
    required this.etaText,
    required this.name,
    required this.price,
    required this.image,
    required this.onTap,
    required this.onInfo,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        width: 112,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.black : const Color(0xFFE5E7EB),
            width: isSelected ? 1.6 : 1,
          ),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 6),
              blurRadius: 12,
              color: Colors.black.withOpacity(0.06),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (etaText.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      etaText,
                      style: GoogleFonts.roboto(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.black),
                    ),
                  )
                else
                  const SizedBox(height: 20),
                const Spacer(),
                InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: onInfo,
                  child: const SizedBox(
                    height: 24,
                    width: 24,
                    child: Icon(Icons.info_outline, size: 18, color: Colors.black54),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            SizedBox(height: 26, child: Center(child: image)),
            const SizedBox(height: 6),
            Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.roboto(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.black),
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                const Icon(Icons.bolt, size: 14, color: Colors.black),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    price,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.roboto(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.black),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
