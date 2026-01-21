part of 'booking_confirmation.dart';

extension _BookingConfirmationCancelModal on _BookingConfirmationState {
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
}
