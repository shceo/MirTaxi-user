part of 'booking_confirmation.dart';

extension _BookingConfirmationPaymentModal on _BookingConfirmationState {
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
}
