part of 'booking_confirmation.dart';

extension _BookingConfirmationOnTripPanel on _BookingConfirmationState {
  Widget buildAcceptedStatusBanner(Size media) {
    return (userRequestData['accepted_at'] != null)
        ? Positioned(
            top: MediaQuery.of(context).padding.top + 25,
            child: Container(
              padding: EdgeInsets.fromLTRB(
                media.width * 0.05,
                media.width * 0.025,
                media.width * 0.05,
                media.width * 0.025,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 2,
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 2,
                  )
                ],
                color: page,
              ),
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
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 2,
                        )
                      ],
                      color: (userRequestData['accepted_at'] != null &&
                              userRequestData['arrived_at'] == null)
                          ? const Color(0xff2E67D5)
                          : (userRequestData['accepted_at'] != null &&
                                  userRequestData['arrived_at'] != null &&
                                  userRequestData['is_trip_start'] == 0)
                              ? const Color(0xff319900)
                              : (userRequestData['accepted_at'] != null &&
                                      userRequestData['arrived_at'] != null &&
                                      userRequestData['is_trip_start'] != 0)
                                  ? const Color(0xffFF0000)
                                  : Colors.transparent,
                    ),
                  ),
                  SizedBox(
                    width: media.width * 0.02,
                  ),
                  Text(
                    (userRequestData['accepted_at'] != null &&
                            userRequestData['arrived_at'] == null &&
                            _dist != null)
                        ? context.l10n.text_arrive_eta +
                            ' ' +
                            double.parse(((_dist * 2)).toString())
                                .round()
                                .toString() +
                            ' ' +
                            context.l10n.text_mins
                        : (userRequestData['accepted_at'] != null &&
                                userRequestData['arrived_at'] != null &&
                                userRequestData['is_trip_start'] == 0)
                            ? context.l10n.text_arrived
                            : (userRequestData['accepted_at'] != null &&
                                    userRequestData['arrived_at'] != null &&
                                    userRequestData['is_trip_start'] != null)
                                ? context.l10n.text_onride
                                : '',
                    style: GoogleFonts.roboto(
                      fontSize: media.width * twelve,
                      color: (userRequestData['accepted_at'] != null &&
                              userRequestData['arrived_at'] == null)
                          ? const Color(0xff2E67D5)
                          : (userRequestData['accepted_at'] != null &&
                                  userRequestData['arrived_at'] != null &&
                                  userRequestData['is_trip_start'] == 0)
                              ? const Color(0xff319900)
                              : (userRequestData['accepted_at'] != null &&
                                      userRequestData['arrived_at'] != null &&
                                      userRequestData['is_trip_start'] == 1)
                                  ? const Color(0xffFF0000)
                                  : Colors.transparent,
                    ),
                  )
                ],
              ),
            ),
          )
        : Container();
  }

  Widget buildOnTripPanel(Size media) {
    return (userRequestData.isNotEmpty &&
            userRequestData['accepted_at'] != null)
        ? Positioned(
            bottom: 0,
            child: GestureDetector(
              onPanUpdate: (val) {
                if (val.delta.dy > 0 && _ontripBottom == true) {
                  _updateState(() {
                    _ontripBottom = false;
                  });
                }
                if (val.delta.dy < 0 && _ontripBottom == false) {
                  _updateState(() {
                    _ontripBottom = true;
                  });
                }
              },
              child: Container(
                padding: EdgeInsets.all(media.width * 0.05),
                width: media.width * 1,
                decoration: BoxDecoration(
                  color: page,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      // SizedBox(height: media.width*0.02,),
                      SvgPicture.asset(
                        'assets/icons/bottom.svg',
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${userRequestData['driverDetail']['data']['car_color']} ${userRequestData['driverDetail']['data']['car_make_name']} ${userRequestData['driverDetail']['data']['car_model_name']}",
                                  style: GoogleFonts.roboto(
                                    fontSize: media.width * eighteen,
                                    color: const Color.fromRGBO(82, 82, 82, 1),
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: media.width * 0.070,
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(237, 238, 242, 1),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            padding: EdgeInsets.fromLTRB(
                              media.width * 0.02,
                              media.width * 0.01,
                              media.width * 0.02,
                              media.width * 0.01,
                            ),
                            child: Text(
                              userRequestData['driverDetail']['data']
                                  ['car_number'],
                              style: GoogleFonts.roboto(
                                fontSize: media.width * eighteen,
                                fontWeight: FontWeight.w400,
                                color: textColor,
                              ),
                            ),
                          ),
                          SizedBox(height: media.width * 0.03),
                        ],
                      ),
                      SizedBox(
                        height: media.width * 0.05,
                      ),
                      Container(
                        height: 1,
                        width: MediaQuery.of(context).size.width,
                        color: const Color.fromRGBO(201, 201, 201, 1),
                      ),
                      SizedBox(
                        height: media.width * 0.05,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              SizedBox(
                                height: media.width * 0.16,
                                width: media.width * 0.18,
                                child: Stack(
                                  children: [
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: Container(
                                        height: media.width * 0.16,
                                        width: media.width * 0.16,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                            image: NetworkImage(
                                              userRequestData['driverDetail']
                                                  ['data']['profile_picture'],
                                            ),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 5,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.white,
                                          boxShadow: const [
                                            BoxShadow(
                                              offset: Offset(0, 0),
                                              blurRadius: 4,
                                              color: Color.fromRGBO(
                                                0,
                                                0,
                                                0,
                                                0.25,
                                              ),
                                            ),
                                          ],
                                        ),
                                        child: Text(
                                          userRequestData['driverDetail']
                                                  ['data']['rating']
                                              .toString(),
                                          style: GoogleFonts.roboto(
                                            fontSize: media.width * twelve,
                                            color: textColor,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                userRequestData['driverDetail']['data']['name'],
                                style: GoogleFonts.roboto(
                                  fontSize: media.width * fourteen,
                                  fontWeight: FontWeight.w400,
                                  color: const Color.fromRGBO(139, 139, 139, 1),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 32),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              InkWell(
                                onTap: () {
                                  makingPhoneCall(
                                    userRequestData['driverDetail']['data']
                                        ['mobile'],
                                  );
                                },
                                child: SizedBox(
                                  height: media.width * 0.16,
                                  width: media.width * 0.16,
                                  child:
                                      SvgPicture.asset('assets/icons/call.svg'),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Позвонить',
                                style: GoogleFonts.roboto(
                                  fontSize: media.width * fourteen,
                                  fontWeight: FontWeight.w400,
                                  color: const Color.fromRGBO(139, 139, 139, 1),
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
                        userRequestData: userRequestData,
                      ),
                      SizedBox(
                        height: media.width * 0.05,
                      ),
                      (userRequestData['is_trip_start'] != 1)
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                (userRequestData['is_trip_start'] != 1)
                                    ? InkWell(
                                        onTap: () async {
                                          _updateState(() {
                                            _isLoading = true;
                                          });
                                          var reason = await cancelReason(
                                            (userRequestData[
                                                        'is_driver_arrived'] ==
                                                    0)
                                                ? 'before'
                                                : 'after',
                                          );
                                          if (reason == true) {
                                            _updateState(() {
                                              _cancellingError = '';
                                              _cancelling = true;
                                            });
                                          }
                                          _updateState(() {
                                            _isLoading = false;
                                          });
                                        },
                                        child: Column(
                                          children: [
                                            SvgPicture.asset(
                                              'assets/icons/close.svg',
                                            ),
                                            SizedBox(
                                              height: media.width * 0.02,
                                            ),
                                            Text(
                                              context.l10n.text_cancel,
                                              style: GoogleFonts.roboto(
                                                fontSize: media.width * ten,
                                                fontWeight: FontWeight.w600,
                                                color: textColor,
                                              ),
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
