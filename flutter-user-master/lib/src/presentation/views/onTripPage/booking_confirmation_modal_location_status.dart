part of 'booking_confirmation.dart';

extension _BookingConfirmationLocationStatusModal on _BookingConfirmationState {
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
}
