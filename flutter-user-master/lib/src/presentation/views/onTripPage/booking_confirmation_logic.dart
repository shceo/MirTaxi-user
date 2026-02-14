part of 'booking_confirmation.dart';

extension _BookingConfirmationLogic on _BookingConfirmationState {
  void initBookingConfirmationState() {
    WidgetsBinding.instance.addObserver(this);
    promoCode = '';
    mapPadding = 0.0;
    promoStatus = null;
    serviceNotAvailable = false;
    tripReqError = false;
    myBearings.clear();
    noDriverFound = false;
    etaDetails.clear();
    getLocs();
    _syncArrivalWaitingTimer();
  }

  void onBookingConfirmationLifecycle(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (_controller != null && mapStyle.isNotEmpty) {
        _controller?.setMapStyle(mapStyle);
      }
      getUserDetails().whenComplete(_syncArrivalWaitingTimer);
      if (timers == null &&
          userRequestData.isNotEmpty &&
          userRequestData['accepted_at'] == null) {
        timer();
      }
      if (timerLocation == null && locationAllowed == true) {
        getCurrentLocation();
      }
    }
  }

  void disposeBookingConfirmationState() {
    if (timers != null) {
      timers.cancel;
    }
    _arrivalWaitingTimer?.cancel();
    _arrivalWaitingTimer = null;

    animationController?.dispose();
  }

  DateTime? _parseRequestDateTime(dynamic raw) {
    if (raw == null) {
      return null;
    }
    if (raw is DateTime) {
      return raw.toLocal();
    }
    if (raw is num) {
      final value = raw.toInt();
      if (value <= 0) {
        return null;
      }
      final isMilliseconds = value > 1000000000000;
      final millis = isMilliseconds ? value : value * 1000;
      return DateTime.fromMillisecondsSinceEpoch(millis).toLocal();
    }
    final text = raw.toString().trim();
    if (text.isEmpty) {
      return null;
    }
    final parsed = DateTime.tryParse(text);
    if (parsed != null) {
      return parsed.toLocal();
    }
    final normalized = DateTime.tryParse(text.replaceFirst(' ', 'T'));
    return normalized?.toLocal();
  }

  bool _isTripStartedNow() {
    final value = userRequestData['is_trip_start'];
    return value == 1 || value == true;
  }

  bool _isTripCompletedNow() {
    final value = userRequestData['is_completed'];
    return value == 1 || value == true;
  }

  bool _isDriverArrivedNow() {
    if (userRequestData.isEmpty || userRequestData['accepted_at'] == null) {
      return false;
    }
    return userRequestData['arrived_at'] != null ||
        userRequestData['is_driver_arrived'] == 1 ||
        userRequestData['is_driver_arrived'] == true;
  }

  bool _shouldShowArrivalWaitingTimer() {
    if (!_isDriverArrivedNow()) {
      return false;
    }
    if (_isTripStartedNow() || _isTripCompletedNow()) {
      return false;
    }
    return true;
  }

  int _currentArrivalWaitingSeconds() {
    final parsedFromRequest = _parseRequestDateTime(userRequestData['arrived_at']) ??
        _parseRequestDateTime(userRequestData['driver_arrived_at']);
    if (parsedFromRequest != null) {
      _arrivalWaitingStartTime = parsedFromRequest;
    } else {
      _arrivalWaitingStartTime ??= DateTime.now();
    }
    final start = _arrivalWaitingStartTime;
    if (start == null) {
      return 0;
    }
    final seconds = DateTime.now().difference(start).inSeconds;
    return seconds < 0 ? 0 : seconds;
  }

  String _formatArrivalWaitMmSs(int totalSeconds) {
    final safeSeconds = totalSeconds < 0 ? 0 : totalSeconds;
    final mm = (safeSeconds ~/ 60).toString().padLeft(2, '0');
    final ss = (safeSeconds % 60).toString().padLeft(2, '0');
    return '$mm:$ss';
  }

  void _syncArrivalWaitingTimer() {
    final shouldRun = _shouldShowArrivalWaitingTimer();

    if (!shouldRun) {
      _arrivalWaitingTimer?.cancel();
      _arrivalWaitingTimer = null;
      _arrivalWaitingStartTime = null;
      _arrivalWaitingSeconds = 0;
      return;
    }

    _arrivalWaitingSeconds = _currentArrivalWaitingSeconds();

    if (_arrivalWaitingTimer != null) {
      return;
    }

    _arrivalWaitingTimer =
        Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (!mounted) {
        timer.cancel();
        _arrivalWaitingTimer = null;
        return;
      }

      if (!_shouldShowArrivalWaitingTimer()) {
        timer.cancel();
        _arrivalWaitingTimer = null;
        _arrivalWaitingStartTime = null;
        _updateState(() {
          _arrivalWaitingSeconds = 0;
        });
        return;
      }

      final next = _currentArrivalWaitingSeconds();
      _updateState(() {
        _arrivalWaitingSeconds = next;
      });
    });
  }

  void _backToMaps() {
    if (_navigatingBackToMaps) return;
    _navigatingBackToMaps = true;

    addressList.removeWhere((element) => element.id == 'drop');
    etaDetails.clear();
    promoStatus = null;
    _rideLaterSuccess = false;
    myMarker.clear();
    polyline = null;
    polyList.clear();
    clearRouteSegments();

    if (!mounted) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const Maps()),
        (route) => false,
      );
    });
  }

//running timer
  timer() {
    timing = userRequestData['maximum_time_for_find_drivers_for_regular_ride'];

    if (mounted) {
      timers = Timer.periodic(const Duration(seconds: 1), (timer) async {
        if (userRequestData.isNotEmpty &&
            userDetails['accepted_at'] == null &&
            timing > 0) {
          timing--;
          valueNotifierBook.incrementNotifier();
        } else if (userRequestData.isNotEmpty &&
            userRequestData['accepted_at'] == null &&
            timing == 0) {
          await cancelRequest();
          _updateState(() {
            noDriverFound = true;
          });

          timers.cancel();
        } else {
          timers.cancel();
        }
      });
    }
  }

//create icon

  _capturePng(GlobalKey iconKeys) async {
    dynamic bitmap;

    try {
      RenderRepaintBoundary boundary =
          iconKeys.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 2.0);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      var pngBytes = byteData!.buffer.asUint8List();
      bitmap = BitmapDescriptor.fromBytes(pngBytes);
      // return pngBytes;
    } catch (e) {
      debugPrint(e.toString());
    }
    return bitmap;
  }

  addDropMarker() async {
    var testIcon = await _capturePng(iconDropKey);
    if (testIcon != null) {
      final point = (userRequestData.isEmpty)
          ? addressList.firstWhere((element) => element.id == 'drop').latlng
          : Point(
              latitude: userRequestData['drop_lat'],
              longitude: userRequestData['drop_lng'],
            );
      _updateState(() {
        myMarker.add(
          _buildPlacemark(
            markerId: 'pointdrop',
            point: point,
            icon: testIcon,
          ),
        );
      });
    }

    if (widget.type != 1) {
      Point pickPoint;
      Point dropPoint;
      if (userRequestData.isNotEmpty) {
        pickPoint = Point(
          latitude: userRequestData['pick_lat'],
          longitude: userRequestData['pick_lng'],
        );
        dropPoint = Point(
          latitude: userRequestData['drop_lat'],
          longitude: userRequestData['drop_lng'],
        );
      } else {
        pickPoint = addressList
            .firstWhere((element) => element.id == 'pickup')
            .latlng;
        dropPoint = addressList
            .firstWhere((element) => element.id == 'drop')
            .latlng;
      }
      final bounds = BoundingBox(
        southWest: Point(
          latitude: math.min(pickPoint.latitude, dropPoint.latitude),
          longitude: math.min(pickPoint.longitude, dropPoint.longitude),
        ),
        northEast: Point(
          latitude: math.max(pickPoint.latitude, dropPoint.latitude),
          longitude: math.max(pickPoint.longitude, dropPoint.longitude),
        ),
      );
      _controller?.moveCamera(
        CameraUpdate.newGeometry(Geometry.fromBoundingBox(bounds)),
        animation: const MapAnimation(type: MapAnimationType.smooth, duration: 0.5),
      );
    }
  }

  addMarker() async {
    var testIcon = await _capturePng(iconKey);
    if (testIcon != null) {
      final point = (userRequestData.isEmpty)
          ? addressList.firstWhere((element) => element.id == 'pickup').latlng
          : Point(
              latitude: userRequestData['pick_lat'],
              longitude: userRequestData['pick_lng'],
            );
      _updateState(() {
        myMarker.add(
          _buildPlacemark(
            markerId: 'pointpick',
            point: point,
            icon: testIcon,
          ),
        );
      });
    }
  }

//add drop marker
  addPickDropMarker() async {
    addMarker();
    if (widget.type == null || (userRequestData.isNotEmpty)
        ? userRequestData['is_rental'] != true
        : 11 == 5) {
      addDropMarker();
      getPolylines();
    } else if (widget.type == 1 || widget.type == 2) {
      if (userRequestData.isNotEmpty) {
        _controller?.moveCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: Point(
                latitude: userRequestData['pick_lat'],
                longitude: userRequestData['pick_lng'],
              ),
            ),
          ),
        );
      } else {
        _controller?.moveCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: addressList
                  .firstWhere((element) => element.id == 'pickup')
                  .latlng,
            ),
          ),
        );
      }
    }
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

//get location permission and location details
  getLocs() async {
    _updateState(() {
      _center = (userRequestData.isEmpty)
          ? addressList.firstWhere((element) => element.id == 'pickup').latlng
          : Point(
              latitude: userRequestData['pick_lat'],
              longitude: userRequestData['pick_lng'],
            );
    });
    if (await geolocs.GeolocatorPlatform.instance.isLocationServiceEnabled()) {
      serviceEnabled = true;
    } else {
      serviceEnabled = false;
    }
    final Uint8List markerIcon =
        await getBytesFromAsset('assets/images/top-taxi.png', 40);
    pinLocationIcon = BitmapDescriptor.fromBytes(markerIcon);
    final Uint8List markerIcon2 =
        await getBytesFromAsset('assets/images/bike.png', 40);
    pinLocationIcon2 = BitmapDescriptor.fromBytes(markerIcon2);

    choosenVehicle = null;
    _dist = null;

    if (widget.type != 1) {
      etaRequest();
    } else {
      rentalEta();
    }

    permission = await location.hasPermission();

    if (permission == PermissionStatus.denied ||
        permission == PermissionStatus.deniedForever) {
      _updateState(() {
        locationAllowed = false;
      });
    } else if (permission == PermissionStatus.granted ||
        permission == PermissionStatus.grantedLimited) {
      // var loc = await location.getLocation();
      locationAllowed = true;
      if (timerLocation == null && locationAllowed == true) {
        getCurrentLocation();
      }
      _updateState(() {});
    }
    Future.delayed(const Duration(milliseconds: 2000), () async {
      await addPickDropMarker();
    });
  }

  void _onMapCreated(YandexMapController controller) async {
    _updateState(() {
      _controller = controller;
    });
    _controller?.toggleUserLayer(visible: true);
    _controller?.moveCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: _center, zoom: 11.0),
      ),
    );
    if (mapStyle.isNotEmpty) {
      _controller?.setMapStyle(mapStyle);
    }
    // await getBounds();

// Future.delayed(const Duration(seconds: 1)).then((value) {

//         animateCar(
//           11.0589596,
//            76.9967165,
//            11.1589596,
//            76.9967165,
//            _mapMarkerSink,
//            this,
//            _controller,
//            MarkerId('car')
//            );

//       });
    // print(CameraPosition.zoom)
  }

  /*
  // Google Maps camera bounds check (disabled; switched to Yandex MapKit)
  void check(CameraUpdate u, GoogleMapController c) async {
    c.animateCamera(u);
    _controller!.animateCamera(u);
    LatLngBounds l1 = await c.getVisibleRegion();
    LatLngBounds l2 = await c.getVisibleRegion();
    if (l1.southwest.latitude == -90 || l2.southwest.latitude == -90) {
      check(u, c);
    }
  }
  */

  double getBearing(Point begin, Point end) {
    double lat = (begin.latitude - end.latitude).abs();

    double lng = (begin.longitude - end.longitude).abs();

    if (begin.latitude < end.latitude && begin.longitude < end.longitude) {
      return vector.degrees(math.atan(lng / lat));
    } else if (begin.latitude >= end.latitude &&
        begin.longitude < end.longitude) {
      return (90 - vector.degrees(math.atan(lng / lat))) + 90;
    } else if (begin.latitude >= end.latitude &&
        begin.longitude >= end.longitude) {
      return vector.degrees(math.atan(lng / lat)) + 180;
    } else if (begin.latitude < end.latitude &&
        begin.longitude >= end.longitude) {
      return (90 - vector.degrees(math.atan(lng / lat))) + 270;
    }

    return -1;
  }

  PlacemarkMapObject _buildPlacemark({
    required String markerId,
    required Point point,
    required BitmapDescriptor icon,
    double direction = 0.0,
  }) {
    return PlacemarkMapObject(
      mapId: MapObjectId(markerId),
      point: point,
      direction: direction,
      opacity: 1,
      icon: PlacemarkIcon.single(
        PlacemarkIconStyle(
          image: icon,
          anchor: const Offset(0.5, 0.5),
          rotationType: RotationType.rotate,
          isFlat: true,
        ),
      ),
    );
  }

  animateCar(
      double fromLat, //Starting latitude

      double fromLong, //Starting longitude

      double toLat, //Ending latitude

      double toLong, //Ending longitude

      StreamSink<List<PlacemarkMapObject>> mapMarkerSink,
      //Stream build of map to update the UI

      TickerProvider provider,
      //Ticker provider of the widget. This is used for animation

      YandexMapController? controller, //Map controller of our widget

      markerid,
      markerBearing,
      icon) async {
    final double bearing = getBearing(
      Point(latitude: fromLat, longitude: fromLong),
      Point(latitude: toLat, longitude: toLong),
    );

    myBearings[markerBearing.toString()] = bearing;

    var carMarker = _buildPlacemark(
      markerId: markerid,
      point: Point(latitude: fromLat, longitude: fromLong),
      icon: icon,
    );

    myMarker.add(carMarker);

    mapMarkerSink.add(List<PlacemarkMapObject>.from(myMarker));

    Tween<double> tween = Tween(begin: 0, end: 1);

    _animation = tween.animate(animationController)
      ..addListener(() async {
        myMarker.removeWhere((element) =>
            element.mapId == MapObjectId(markerid.toString()));

        final v = _animation!.value;

        double lng = v * toLong + (1 - v) * fromLong;

        double lat = v * toLat + (1 - v) * fromLat;

        Point newPos = Point(latitude: lat, longitude: lng);

        //New marker location

        carMarker = _buildPlacemark(
          markerId: markerid,
          point: newPos,
          icon: icon,
          direction: bearing,
        );

        //Adding new marker to our list and updating the google map UI.

        myMarker.add(carMarker);

        mapMarkerSink.add(List<PlacemarkMapObject>.from(myMarker));
      });

    //Starting the animation

    animationController.forward();
  }
}
