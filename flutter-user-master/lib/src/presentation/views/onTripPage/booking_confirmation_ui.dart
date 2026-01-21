part of 'booking_confirmation.dart';

extension _BookingConfirmationUi on _BookingConfirmationState {
  Widget buildBookingConfirmationView(BuildContext context) {
    GeoHasher geo = GeoHasher();

    double lat = 0.0144927536231884;
    double lon = 0.0181818181818182;
    double lowerLat = (userRequestData.isEmpty && addressList.isNotEmpty)
        ? addressList
                .firstWhere((element) => element.id == 'pickup')
                .latlng
                .latitude -
            (lat * 1.24)
        : (userRequestData.isNotEmpty && addressList.isEmpty)
            ? userRequestData['pick_lat'] - (lat * 1.24)
            : 0.0;
    double lowerLon = (userRequestData.isEmpty && addressList.isNotEmpty)
        ? addressList
                .firstWhere((element) => element.id == 'pickup')
                .latlng
                .longitude -
            (lon * 1.24)
        : (userRequestData.isNotEmpty && addressList.isEmpty)
            ? userRequestData['pick_lng'] - (lon * 1.24)
            : 0.0;

    double greaterLat = (userRequestData.isEmpty && addressList.isNotEmpty)
        ? addressList
                .firstWhere((element) => element.id == 'pickup')
                .latlng
                .latitude +
            (lat * 1.24)
        : (userRequestData.isNotEmpty && addressList.isEmpty)
            ? userRequestData['pick_lat'] - (lat * 1.24)
            : 0.0;
    double greaterLon = (userRequestData.isEmpty && addressList.isNotEmpty)
        ? addressList
                .firstWhere((element) => element.id == 'pickup')
                .latlng
                .longitude +
            (lon * 1.24)
        : (userRequestData.isNotEmpty && addressList.isEmpty)
            ? userRequestData['pick_lng'] - (lat * 1.24)
            : 0.0;
    var lower = geo.encode(lowerLon, lowerLat);
    var higher = geo.encode(greaterLon, greaterLat);

    var fdb = FirebaseDatabase.instance
        .ref('drivers')
        .orderByChild('g')
        .startAt(lower)
        .endAt(higher);

    var media = MediaQuery.of(context).size;
    return PopScope(
      canPop: userRequestData.isEmpty ? true : false,
      onPopInvokedWithResult: (s, d) async {
        if (userRequestData.isEmpty) {
          etaDetails.clear();
          promoKey.clear();
          promoStatus = null;
          _rideLaterSuccess = false;
          // addressList.clear();
          myMarker.clear();
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const Maps()),
              (route) => false);
        }
      },
      child: Material(
        child: Directionality(
          textDirection: (languageDirection == 'rtl')
              ? ui.TextDirection.rtl
              : ui.TextDirection.ltr,
          child: Container(
            height: media.height * 0.5,
            width: media.width * 1,
            color: page,
            child: ValueListenableBuilder(
              valueListenable: valueNotifierBook.value,
              builder: (context, value, child) {
                if (_controller != null) {
                  mapPadding = media.width * 1;
                }
                if (requestCancelledByDriver == true ||
                    cancelRequestByUser == true) {
                  myMarker.clear();
                  polyline = null;
                  polyList.clear();
                  addressList.removeWhere((element) => element.id == 'drop');
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const Maps()),
                        (route) => false);
                  });
                }
                if (userRequestData['is_completed'] == 1) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Invoice()),
                        (route) => false);
                  });
                }
                if (userRequestData.isNotEmpty &&
                    timers == null &&
                    userRequestData['accepted_at'] == null) {
                  timer();
                }
                return StreamBuilder<DatabaseEvent>(
                  stream: (userRequestData['driverDetail'] == null &&
                          pinLocationIcon != null)
                      ? fdb.onValue
                      : null,
                  builder: (context, AsyncSnapshot<DatabaseEvent> event) {
                    if (event.hasData) {
                      if (event.data!.snapshot.value != null) {
                        if (userRequestData['accepted_at'] == null) {
                          DataSnapshot snapshots = event.data!.snapshot;
                          // ignore: unnecessary_null_comparison
                          if (snapshots != null) {
                            driversData = [];
                            // ignore: avoid_function_literals_in_foreach_calls
                            snapshots.children.forEach((element) {
                              driversData.add(element.value);
                            });
                            // ignore: avoid_function_literals_in_foreach_calls
                            driversData.forEach((e) {
                              if (e['is_active'] == 1 &&
                                  e['is_available'] == true) {
                                DateTime dt =
                                    DateTime.fromMillisecondsSinceEpoch(
                                        e['updated_at']);
                                if (DateTime.now().difference(dt).inMinutes <=
                                    2) {
                                  final markerId = 'car${e['id']}';
                                  final existingIndex = myMarker.indexWhere(
                                      (element) =>
                                          element.mapId.value == markerId);
                                  final icon =
                                      (e['vehicle_type_icon'] == 'motor_bike')
                                          ? pinLocationIcon2
                                          : pinLocationIcon;
                                  final bearing =
                                      (myBearings[e['id'].toString()] != null)
                                          ? myBearings[e['id'].toString()]
                                          : 0.0;
                                  final nextPoint = Point(
                                    latitude: e['l'][0],
                                    longitude: e['l'][1],
                                  );
                                  if (existingIndex == -1) {
                                    myMarker.add(
                                      _buildPlacemark(
                                        markerId: markerId,
                                        point: nextPoint,
                                        icon: icon,
                                        direction: bearing,
                                      ),
                                    );
                                  } else if (_controller != null) {
                                    final existing = myMarker[existingIndex];
                                    final dist = calculateDistance(
                                        existing.point.latitude,
                                        existing.point.longitude,
                                        e['l'][0],
                                        e['l'][1]);
                                    if (dist > 100) {
                                      if (existing.point.latitude !=
                                              e['l'][0] ||
                                          existing.point.longitude !=
                                              e['l'][1]) {
                                        animationController =
                                            AnimationController(
                                          duration: const Duration(
                                              milliseconds: 1500),
                                          //Animation duration of marker

                                          vsync: this, //From the widget
                                        );
                                        animateCar(
                                          existing.point.latitude,
                                          existing.point.longitude,
                                          e['l'][0],
                                          e['l'][1],
                                          _mapMarkerSink,
                                          this,
                                          _controller,
                                          markerId,
                                          e['id'],
                                          icon,
                                        );
                                      }
                                    }
                                  }
                                }
                              } else {
                                if (myMarker
                                    .where((element) =>
                                        element.mapId.value ==
                                        'car${e['id']}')
                                    .isNotEmpty) {
                                  myMarker.removeWhere((element) =>
                                      element.mapId.value ==
                                      'car${e['id']}');
                                }
                              }
                            });
                          }
                        }
                      }
                    }

                    return StreamBuilder<DatabaseEvent>(
                      stream: (userRequestData['driverDetail'] != null &&
                              pinLocationIcon != null)
                          ? FirebaseDatabase.instance
                              .ref(
                                  'drivers/${userRequestData['driverDetail']['data']['id']}')
                              .onValue
                          : null,
                      builder: (context, AsyncSnapshot<DatabaseEvent> event) {
                        if (event.hasData) {
                          if (event.data!.snapshot.value != null) {
                            if (userRequestData['accepted_at'] != null) {
                              driversData.clear();
                              if (myMarker.length > 3) {
                                myMarker.removeWhere(
                                    (element) => element.mapId.value.contains('car'));
                              }

                              DataSnapshot snapshots = event.data!.snapshot;
                              // ignore: unnecessary_null_comparison
                              if (snapshots != null) {
                                driverData =
                                    jsonDecode(jsonEncode(snapshots.value));
                                if (driverData != {}) {
                                  if (userRequestData['arrived_at'] == null) {
                                    var distCalc = calculateDistance(
                                        userRequestData['pick_lat'],
                                        userRequestData['pick_lng'],
                                        driverData['l'][0],
                                        driverData['l'][1]);
                                    _dist = double.parse(
                                        (distCalc / 1000).toString());
                                  }
                                  final markerId =
                                      'car${driverData['id']}';
                                  final existingIndex = myMarker.indexWhere(
                                      (element) =>
                                          element.mapId.value == markerId);
                                  final icon =
                                      (driverData['vehicle_type_icon'] ==
                                              'motor_bike')
                                          ? pinLocationIcon2
                                          : pinLocationIcon;
                                  final bearing = (myBearings[
                                              driverData['id'].toString()] !=
                                          null)
                                      ? myBearings[driverData['id'].toString()]
                                      : 0.0;
                                  final nextPoint = Point(
                                    latitude: driverData['l'][0],
                                    longitude: driverData['l'][1],
                                  );
                                  if (existingIndex == -1) {
                                    myMarker.add(
                                      _buildPlacemark(
                                        markerId: markerId,
                                        point: nextPoint,
                                        icon: icon,
                                        direction: bearing,
                                      ),
                                    );
                                  } else if (_controller != null) {
                                    final existing = myMarker[existingIndex];
                                    final dist = calculateDistance(
                                        existing.point.latitude,
                                        existing.point.longitude,
                                        driverData['l'][0],
                                        driverData['l'][1]);
                                    if (dist > 100) {
                                      if (existing.point.latitude !=
                                              driverData['l'][0] ||
                                          existing.point.longitude !=
                                              driverData['l'][1]) {
                                        animationController =
                                            AnimationController(
                                          duration: const Duration(
                                              milliseconds: 1500),
                                          //Animation duration of marker

                                          vsync: this, //From the widget
                                        );

                                        animateCar(
                                          existing.point.latitude,
                                          existing.point.longitude,
                                          driverData['l'][0],
                                          driverData['l'][1],
                                          _mapMarkerSink,
                                          this,
                                          _controller,
                                          markerId,
                                          driverData['id'],
                                          icon,
                                        );
                                      }
                                    }
                                  }
                                }
                              }
                            }
                          }
                        }
                        final bookingList =
                            (widget.type != 1) ? etaDetails : rentalOption;
                        final showBookingPanel = addressList.isNotEmpty &&
                            bookingList.isNotEmpty &&
                            userRequestData.isEmpty &&
                            noDriverFound == false &&
                            tripReqError == false &&
                            lowWalletBalance == false;
                        final bookingButtonsBottom = media.width * 0.8 + 12;
                        final floatingButtonsBottom = showBookingPanel
                            ? bookingButtonsBottom
                            : (widget.type != 1)
                                ? media.width * 1.1
                                : media.width * 1.15;

                        return Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              height: media.height * 1,
                              width: media.width * 1,
                              //get drivers location updates
                              child: StreamBuilder<List<PlacemarkMapObject>>(
                                stream: mapMarkerStream,
                                builder: (context, snapshot) {
                                  final mapObjects = <MapObject>[
                                    ...myMarker,
                                    if (polyline != null)
                                      PolylineMapObject(
                                        mapId: const MapObjectId('route'),
                                        polyline: polyline!,
                                        strokeColor: const Color(0xffFD9898),
                                        strokeWidth: 4,
                                      ),
                                  ];
                                  return YandexMap(
                                    mapType: MapType.vector,
                                    onMapCreated: _onMapCreated,
                                    cameraBounds: const CameraBounds(
                                      minZoom: 0.0,
                                      maxZoom: 20.0,
                                    ),
                                    mapObjects: mapObjects,
                                  );
                                },
                              ),
                            ),
                            (userRequestData['accepted_at'] == null)
                                ? buildTopBackButton(
                                    media,
                                    bottom: showBookingPanel
                                        ? bookingButtonsBottom
                                        : null,
                                    onTap: () {
                                      addressList.removeWhere(
                                          (element) => element.id == 'drop');
                                      etaDetails.clear();
                                      promoKey.clear();
                                      promoStatus = null;

                                      _rideLaterSuccess = false;
                                      myMarker.clear();
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const Maps()),
                                          (route) => false);
                                    },
                                  )
                                : Container(),
                            Positioned(
                              bottom: floatingButtonsBottom,
                              child: SizedBox(
                                width: media.width * 0.9,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    (userRequestData.isNotEmpty &&
                                            userRequestData['is_trip_start'] ==
                                                1)
                                        ? InkWell(
                                            onTap: () async {
                                              _updateState(() {
                                                showSos = true;
                                              });
                                            },
                                            child: Container(
                                              height: media.width * 0.1,
                                              width: media.width * 0.1,
                                              decoration: BoxDecoration(
                                                  boxShadow: [
                                                    BoxShadow(
                                                      blurRadius: 2,
                                                      color: Colors.black
                                                          .withValues(
                                                              alpha: 0.2),
                                                      spreadRadius: 2,
                                                    ),
                                                  ],
                                                  color: buttonColor,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          media.width * 0.02)),
                                              alignment: Alignment.center,
                                              child: Text(
                                                'SOS',
                                                style: GoogleFonts.roboto(
                                                    fontSize:
                                                        media.width * fourteen,
                                                    color: page),
                                              ),
                                            ),
                                          )
                                        : Container(),
                                    SizedBox(
                                      height: media.width * 0.05,
                                    ),
                                    (bookingList.isNotEmpty ||
                                            userRequestData.isNotEmpty)
                                        ? InkWell(
                                            onTap: () async {
                                              if (locationAllowed == true) {
                                                if (currentLocation != null) {
                                                  final loc = currentLocation;
                                                  if (loc == null) {
                                                    return;
                                                  }
                                                  center = loc;

                                                  _controller?.moveCamera(
                                                    CameraUpdate
                                                        .newCameraPosition(
                                                      CameraPosition(
                                                        target: center,
                                                        zoom: 18.0,
                                                      ),
                                                    ),
                                                  );
                                                }
                                              } else {
                                                if (serviceEnabled == true) {
                                                  _updateState(() {
                                                    _locationDenied = true;
                                                  });
                                                } else {
                                                  await location
                                                      .requestService();
                                                  if (await geolocs
                                                      .GeolocatorPlatform
                                                      .instance
                                                      .isLocationServiceEnabled()) {
                                                    _updateState(() {
                                                      _locationDenied = true;
                                                    });
                                                  }
                                                }
                                              }
                                            },
                                            child: Container(
                                              height: media.width * 0.1,
                                              width: media.width * 0.1,
                                              decoration: BoxDecoration(
                                                  boxShadow: [
                                                    BoxShadow(
                                                        blurRadius: 2,
                                                        color: Colors.black
                                                            .withOpacity(0.2),
                                                        spreadRadius: 2)
                                                  ],
                                                  color: page,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          media.width * 0.02)),
                                              child: const Icon(
                                                  Icons.my_location_sharp),
                                            ),
                                          )
                                        : Container(),
                                  ],
                                ),
                              ),
                            ),

                            //show bottom nav bar for choosing ride type and vehicles
                            showBookingPanel
                                ? buildBookingBottomPanel(media)
                                : Container(),
                            //show vehicle info
                            buildVehicleInfoModal(media),
                            //no driver found
                            buildNoDriverFoundPanel(media),
                            //internal server error
                            buildTripRequestErrorPanel(media),
                            //service not available
                            buildServiceNotAvailablePanel(media),
                            //choose payment method
                            buildChoosePaymentModal(media),
                            //bottom nav bar after request accepted
                            buildAcceptedStatusBanner(media),
                            //finding driver panel
                            buildFindingDriverPanel(media),
                            //on trip panel
                            buildOnTripPanel(media),
                            //cancel request
                            buildCancelRequestModal(media),
                            //date picker for ride later
                            buildDateTimePickerModal(media),
                            //confirm ride later
                            buildConfirmRideLaterModal(media),
                            //ride later success
                            buildRideLaterSuccessModal(media),
                            //sos popup
                            buildSosModal(media),
                            //location denied
                            buildLocationDeniedModal(media),
                            //loader
                            buildLoadingOverlay(),
                            //no internet
                            buildNoInternetOverlay(),
                            //pick drop marker
                            Positioned(
                              top: media.height * 1.5,
                              child: RepaintBoundary(
                                  key: iconKey,
                                  child: Column(
                                    children: [
                                      Container(
                                        width: media.width * 0.5,
                                        height: media.width * 0.12,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: page),
                                        child: Row(
                                          children: [
                                            Container(
                                              height: media.width * 0.12,
                                              width: media.width * 0.12,
                                              decoration: BoxDecoration(
                                                  borderRadius: (languageDirection ==
                                                          'ltr')
                                                      ? const BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  10),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  10))
                                                      : const BorderRadius.only(
                                                          topRight:
                                                              Radius.circular(
                                                                  10),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  10)),
                                                  color:
                                                      const Color(0xff222222)),
                                              alignment: Alignment.center,
                                              child: const Icon(
                                                Icons.star,
                                                color: Color(0xff319900),
                                              ),
                                            ),
                                            Expanded(
                                                child: Container(
                                              padding: EdgeInsets.only(
                                                  left: media.width * 0.02,
                                                  right: media.width * 0.02),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    context.l10n.text_pickpoint,
                                                    style: GoogleFonts.roboto(
                                                        fontSize: media.width *
                                                            twelve,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  (userRequestData.isNotEmpty)
                                                      ? Text(
                                                          userRequestData[
                                                              'pick_address'],
                                                          maxLines: 1,
                                                          overflow:
                                                              TextOverflow.fade,
                                                          softWrap: false,
                                                          style: GoogleFonts
                                                              .roboto(
                                                                  fontSize: media
                                                                          .width *
                                                                      twelve),
                                                        )
                                                      : (addressList
                                                              .where(
                                                                  (element) =>
                                                                      element
                                                                          .id ==
                                                                      'pickup')
                                                              .isNotEmpty)
                                                          ? Text(
                                                              addressList
                                                                  .firstWhere((element) =>
                                                                      element
                                                                          .id ==
                                                                      'pickup')
                                                                  .address,
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .fade,
                                                              softWrap: false,
                                                              style: GoogleFonts.roboto(
                                                                  fontSize: media
                                                                          .width *
                                                                      twelve),
                                                            )
                                                          : Container(),
                                                ],
                                              ),
                                            ))
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                                image: AssetImage(
                                                    'assets/images/userloc.png'),
                                                fit: BoxFit.contain)),
                                        height: media.width * 0.05,
                                        width: media.width * 0.05,
                                      )
                                    ],
                                  )),
                            ),
                            (widget.type != 1)
                                ? Positioned(
                                    top: media.height * 2,
                                    child: RepaintBoundary(
                                        key: iconDropKey,
                                        child: Column(
                                          children: [
                                            Container(
                                              width: media.width * 0.5,
                                              height: media.width * 0.12,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: page),
                                              child: Row(
                                                children: [
                                                  Container(
                                                    height: media.width * 0.12,
                                                    width: media.width * 0.12,
                                                    decoration: BoxDecoration(
                                                        borderRadius: (languageDirection ==
                                                                'ltr')
                                                            ? const BorderRadius.only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        10),
                                                                bottomLeft:
                                                                    Radius.circular(
                                                                        10))
                                                            : const BorderRadius.only(
                                                                topRight: Radius
                                                                    .circular(
                                                                        10),
                                                                bottomRight:
                                                                    Radius.circular(
                                                                        10)),
                                                        color: const Color(
                                                            0xff222222)),
                                                    alignment: Alignment.center,
                                                    child: const Icon(
                                                      Icons.star,
                                                      color: Color(0xffE60000),
                                                    ),
                                                  ),
                                                  Expanded(
                                                      child: Container(
                                                    padding: EdgeInsets.only(
                                                        left:
                                                            media.width * 0.02,
                                                        right:
                                                            media.width * 0.02),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          context.l10n.text_droppoint,
                                                          style: GoogleFonts.roboto(
                                                              fontSize:
                                                                  media.width *
                                                                      twelve,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        (userRequestData
                                                                    .isNotEmpty &&
                                                                userRequestData[
                                                                        'drop_address'] !=
                                                                    null)
                                                            ? Text(
                                                                userRequestData[
                                                                    'drop_address'],
                                                                maxLines: 1,
                                                                overflow:
                                                                    TextOverflow
                                                                        .fade,
                                                                softWrap: false,
                                                                style: GoogleFonts.roboto(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    fontSize: media
                                                                            .width *
                                                                        twelve),
                                                              )
                                                            : (addressList
                                                                    .where((element) =>
                                                                        element
                                                                            .id ==
                                                                        'drop')
                                                                    .isNotEmpty)
                                                                ? Text(
                                                                    addressList
                                                                        .firstWhere((element) =>
                                                                            element.id ==
                                                                            'drop')
                                                                        .address,
                                                                    maxLines: 1,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .fade,
                                                                    softWrap:
                                                                        false,
                                                                    style: GoogleFonts.roboto(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w600,
                                                                        fontSize:
                                                                            media.width *
                                                                                twelve),
                                                                  )
                                                                : Container(),
                                                      ],
                                                    ),
                                                  ))
                                                ],
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                              decoration: const BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  image: DecorationImage(
                                                      image: AssetImage(
                                                          'assets/images/droploc.png'),
                                                      fit: BoxFit.contain)),
                                              height: media.width * 0.05,
                                              width: media.width * 0.05,
                                            )
                                          ],
                                        )))
                                : Container()
                          ],
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }

}
