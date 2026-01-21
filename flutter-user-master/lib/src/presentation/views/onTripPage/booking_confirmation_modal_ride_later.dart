part of 'booking_confirmation.dart';

extension _BookingConfirmationRideLaterModal on _BookingConfirmationState {
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
}
