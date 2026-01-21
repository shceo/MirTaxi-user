part of 'booking_confirmation.dart';

extension _BookingConfirmationSosModal on _BookingConfirmationState {
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
}
