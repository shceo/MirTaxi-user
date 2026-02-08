part of 'booking_confirmation.dart';

extension _BookingConfirmationCancelModal on _BookingConfirmationState {
  void _closeCancelModal() {
    _updateState(() {
      _cancelling = false;
      _cancelModalFromFindingDriver = false;
      _cancellingError = '';
      _cancelReason = '';
      _cancelCustomReason = '';
    });
  }

  Widget buildCancelRequestModal(Size media) {
    if (_cancelling != true) return const SizedBox.shrink();

    if (_cancelModalFromFindingDriver == true) {
      return _buildFindingDriverCancelSheet(media);
    }

    return _buildDefaultCancelDialog(media);
  }

  Widget _buildFindingDriverCancelSheet(Size media) {
    return Positioned.fill(
      child: Stack(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              if (_isLoading == true) return;
              _closeCancelModal();
            },
            child: Container(color: Colors.transparent.withOpacity(0.6)),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              top: false,
              child: Container(
                height: media.height * 0.55,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: page,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                padding: EdgeInsets.fromLTRB(
                  media.width * 0.06,
                  media.width * 0.03,
                  media.width * 0.06,
                  media.width * 0.04,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: media.width * 0.12,
                        height: media.width * 0.012,
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.35),
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                    ),
                    SizedBox(height: media.height * 0.012),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${context.l10n.text_cancelRideReason}?',
                            style: GoogleFonts.roboto(
                              fontSize: media.width * 0.048,
                              color: textColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            if (_isLoading == true) return;
                            _closeCancelModal();
                          },
                          child: Icon(Icons.close, color: textColor),
                        ),
                      ],
                    ),
                    SizedBox(height: media.height * 0.015),
                    Expanded(
                      child: ListView.separated(
                        itemCount: cancelReasonsList.length,
                        separatorBuilder: (_, __) => Divider(
                          color: borderLines.withOpacity(0.6),
                          height: 1,
                        ),
                        itemBuilder: (context, i) {
                          final reason =
                              cancelReasonsList[i]['reason'].toString();
                          final selected = _cancelReason == reason;
                          return InkWell(
                            onTap: () => _updateState(() {
                              _cancellingError = '';
                              _cancelReason = reason;
                            }),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: media.width * 0.02,
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    height: media.height * 0.05,
                                    width: media.width * 0.05,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: textColor,
                                        width: 1.2,
                                      ),
                                    ),
                                    alignment: Alignment.center,
                                    child: selected
                                        ? Container(
                                            height: media.width * 0.03,
                                            width: media.width * 0.03,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: textColor,
                                            ),
                                          )
                                        : const SizedBox.shrink(),
                                  ),
                                  SizedBox(width: media.width * 0.04),
                                  Expanded(
                                    child: Text(
                                      reason,
                                      style: GoogleFonts.roboto(
                                        fontSize: media.width * fourteen,
                                        color: textColor,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    if (_cancellingError.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.only(bottom: media.width * 0.02),
                        child: Text(
                          _cancellingError,
                          style: GoogleFonts.roboto(
                            fontSize: media.width * twelve,
                            color: Colors.red,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    Button(
                      width: double.infinity,
                      onTap: () async {
                        if (_isLoading == true) return;
                        _updateState(() => _isLoading = true);

                        if (_cancelReason.isEmpty) {
                          _updateState(() {
                            _cancellingError =
                                context.l10n.text_add_cancel_reason;
                            _isLoading = false;
                          });
                          return;
                        }

                        _updateState(() => _cancellingError = '');
                        await cancelRequestWithReason(_cancelReason);

                        if (!mounted) return;
                        _updateState(() {
                          _cancelling = false;
                          _cancelModalFromFindingDriver = false;
                          _isLoading = false;
                        });
                      },
                      text: context.l10n.text_submit,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultCancelDialog(Size media) {
    return Positioned.fill(
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
              decoration: BoxDecoration(
                color: page,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Container(
                    height: media.width * 0.18,
                    width: media.width * 0.18,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xffFEF2F2),
                    ),
                    alignment: Alignment.center,
                    child: Container(
                      height: media.width * 0.14,
                      width: media.width * 0.14,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xffFF0000),
                      ),
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
                        .map((i, value) {
                          return MapEntry(
                            i,
                            InkWell(
                              onTap: () => _updateState(
                                () => _cancelReason =
                                    cancelReasonsList[i]['reason'],
                              ),
                              child: Container(
                                padding: EdgeInsets.all(media.width * 0.01),
                                child: Row(
                                  children: [
                                    Container(
                                      height: media.height * 0.05,
                                      width: media.width * 0.05,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.black,
                                          width: 1.2,
                                        ),
                                      ),
                                      alignment: Alignment.center,
                                      child: (_cancelReason ==
                                              cancelReasonsList[i]['reason'])
                                          ? Container(
                                              height: media.width * 0.03,
                                              width: media.width * 0.03,
                                              decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.black,
                                              ),
                                            )
                                          : Container(),
                                    ),
                                    SizedBox(width: media.width * 0.05),
                                    SizedBox(
                                      width: media.width * 0.65,
                                      child:
                                          Text(cancelReasonsList[i]['reason']),
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
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border:
                                  Border.all(color: Colors.black, width: 1.2),
                            ),
                            alignment: Alignment.center,
                            child: (_cancelReason == 'others')
                                ? Container(
                                    height: media.width * 0.03,
                                    width: media.width * 0.03,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.black,
                                    ),
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
                          margin: EdgeInsets.fromLTRB(
                            0,
                            media.width * 0.025,
                            0,
                            media.width * 0.025,
                          ),
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
                              hintStyle: GoogleFonts.roboto(
                                fontSize: media.width * twelve,
                              ),
                            ),
                            maxLines: 4,
                            minLines: 2,
                            onChanged: (val) => _updateState(
                              () => _cancelCustomReason = val,
                            ),
                          ),
                        )
                      : Container(),
                  (_cancellingError != '')
                      ? Container(
                          padding: EdgeInsets.only(
                            top: media.width * 0.02,
                            bottom: media.width * 0.02,
                          ),
                          width: media.width * 0.9,
                          child: Text(
                            _cancellingError,
                            style: GoogleFonts.roboto(
                              fontSize: media.width * twelve,
                              color: Colors.red,
                            ),
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
                          if (_isLoading == true) return;
                          _updateState(() => _isLoading = true);

                          if (_cancelReason != '') {
                            if (_cancelReason == 'others') {
                              if (_cancelCustomReason != '' &&
                                  _cancelCustomReason.isNotEmpty) {
                                _cancellingError = '';
                                await cancelRequestWithReason(
                                    _cancelCustomReason);
                                _updateState(() {
                                  _cancelling = false;
                                  _cancelModalFromFindingDriver = false;
                                });
                              } else {
                                _updateState(
                                  () => _cancellingError =
                                      context.l10n.text_add_cancel_reason,
                                );
                              }
                            } else {
                              await cancelRequestWithReason(_cancelReason);
                              _updateState(() {
                                _cancelling = false;
                                _cancelModalFromFindingDriver = false;
                              });
                            }
                          }

                          _updateState(() => _isLoading = false);
                        },
                        text: context.l10n.text_cancel,
                      ),
                      Button(
                        width: media.width * 0.39,
                        onTap: _closeCancelModal,
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
    );
  }
}
