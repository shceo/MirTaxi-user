import 'dart:math' as math;
import 'package:tagyourtaxi_driver/src/presentation/views/onTripPage/booking_confirmation.dart';
import 'package:tagyourtaxi_driver/src/presentation/views/onTripPage/drop_loc_select.dart';
import 'package:tagyourtaxi_driver/src/presentation/views/login/login.dart';
import 'package:tagyourtaxi_driver/src/presentation/views/noInternet/nointernet.dart';
import 'package:tagyourtaxi_driver/src/presentation/views/onTripPage/screens/add_fav_address_widget.dart';
import 'package:tagyourtaxi_driver/src/presentation/views/onTripPage/screens/driver_cancel_request_widget.dart';
import 'package:tagyourtaxi_driver/src/presentation/views/onTripPage/screens/state_one_widget.dart';
import 'package:tagyourtaxi_driver/src/presentation/views/onTripPage/screens/state_three_widget.dart';
import 'package:tagyourtaxi_driver/src/presentation/views/onTripPage/screens/state_two_widget.dart';
import 'package:tagyourtaxi_driver/src/presentation/views/onTripPage/screens/user_cancel_request_widget.dart';
import 'package:tagyourtaxi_driver/src/l10n/l10n.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tagyourtaxi_driver/src/core/services/app_state.dart';
import 'package:tagyourtaxi_driver/src/core/services/functions.dart';
import 'package:tagyourtaxi_driver/src/data/models/address_list.dart';
import 'package:tagyourtaxi_driver/src/core/utils/geohash.dart';
import 'package:tagyourtaxi_driver/src/presentation/views/loadingPage/loading.dart';
import 'package:tagyourtaxi_driver/src/presentation/styles/styles.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import 'dart:async';
import 'package:location/location.dart';
import 'package:tagyourtaxi_driver/src/presentation/widgets/widgets.dart';
import 'dart:ui' as ui;
import '../navDrawer/nav_drawer.dart';
import 'package:geolocator/geolocator.dart' as geolocs;
import 'package:permission_handler/permission_handler.dart' as perm;
import 'package:vector_math/vector_math.dart' as vector;

class Maps extends StatefulWidget {
  const Maps({Key? key}) : super(key: key);

  @override
  State<Maps> createState() => _MapsState();
}

dynamic serviceEnabled;
dynamic favLat;
dynamic favLng;

class _MapsState extends State<Maps>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  Point _centerLocation =
      const Point(latitude: 41.4219057, longitude: -102.0840772);

  dynamic animationController;
  dynamic _sessionToken;
  bool _loading = false;
  bool _pickaddress = false;
  bool _dropaddress = false;
  bool _dropLocationMap = false;
  bool _locationDenied = false;
  bool _isMapMoving = false;
  int gettingPerm = 0;
  Animation<double>? _animation;

  late PermissionStatus permission;
  Location location = Location();
  String state = '';
  YandexMapController? _controller;
  Map myBearings = {};

  late BitmapDescriptor pinLocationIcon;
  dynamic pinLocationIcon2;
  dynamic userLocationIcon;
  bool favAddressAdd = false;
  bool contactus = false;
  final _mapMarkerSC = StreamController<List<PlacemarkMapObject>>();

  StreamSink<List<PlacemarkMapObject>> get _mapMarkerSink =>
      _mapMarkerSC.sink;

  Stream<List<PlacemarkMapObject>> get carMarkerStream => _mapMarkerSC.stream;

  void _onMapCreated(YandexMapController controller) {
    setState(() {
      _controller = controller;
    });
    _controller?.toggleUserLayer(visible: true);
    _controller?.moveCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: center, zoom: 14.0),
      ),
    );
    if (mapStyle.isNotEmpty) {
      _controller?.setMapStyle(mapStyle);
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    print('++++++++++++');

    getLastAddress();

    getLocs();
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (_controller != null && mapStyle.isNotEmpty) {
        _controller?.setMapStyle(mapStyle);
      }
      if (timerLocation == null && locationAllowed == true) {
        getCurrentLocation();
      }
    }
  }

  @override
  void dispose() {
    animationController?.dispose();

    super.dispose();
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

//navigate
  navigate() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => BookingConfirmation()));
  }

  void _setMapMoving(bool isMoving) {
    if (_isMapMoving == isMoving) return;
    if (!mounted) return;
    setState(() {
      _isMapMoving = isMoving;
    });
  }

//get location permission and location details
  getLocs() async {
    myBearings.clear;
    addressList.clear();
    serviceEnabled = await location.serviceEnabled();
    polyline = null;
    polyList.clear();
    final Uint8List markerIcon =
        await getBytesFromAsset('assets/images/top-taxi.png', 40);
    final Uint8List bikeIcons =
        await getBytesFromAsset('assets/images/bike.png', 40);
    pinLocationIcon = BitmapDescriptor.fromBytes(markerIcon);
    pinLocationIcon2 = BitmapDescriptor.fromBytes(bikeIcons);

    permission = await location.hasPermission();

    if (permission == PermissionStatus.denied ||
        permission == PermissionStatus.deniedForever ||
        serviceEnabled == false) {
      gettingPerm++;

      if (gettingPerm > 1 || locationAllowed == false) {
        state = '3';
        locationAllowed = false;
      } else {
        state = '2';
      }
      _loading = false;
      setState(() {});
    } else if (permission == PermissionStatus.granted ||
        permission == PermissionStatus.grantedLimited) {
      var locs = await geolocs.Geolocator.getLastKnownPosition();
      if (locs != null) {
        setState(() {
          center = Point(
            latitude: double.parse(locs.latitude.toString()),
            longitude: double.parse(locs.longitude.toString()),
          );
          _centerLocation = Point(
            latitude: double.parse(locs.latitude.toString()),
            longitude: double.parse(locs.longitude.toString()),
          );
          currentLocation = Point(
            latitude: double.parse(locs.latitude.toString()),
            longitude: double.parse(locs.longitude.toString()),
          );
        });
      } else {
        var loc = await geolocs.Geolocator.getCurrentPosition(
            desiredAccuracy: geolocs.LocationAccuracy.low);
        setState(() {
          center = Point(
            latitude: double.parse(loc.latitude.toString()),
            longitude: double.parse(loc.longitude.toString()),
          );
          _centerLocation = Point(
            latitude: double.parse(loc.latitude.toString()),
            longitude: double.parse(loc.longitude.toString()),
          );
          currentLocation = Point(
            latitude: double.parse(loc.latitude.toString()),
            longitude: double.parse(loc.longitude.toString()),
          );
        });
      }
      _controller?.moveCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: center, zoom: 14.0),
        ),
      );
      setState(() {
        locationAllowed = true;
        state = '3';
        _loading = false;
      });
      if (timerLocation == null && locationAllowed == true) {
        getCurrentLocation();
      }
    }
  }

  getLocationPermission() async {
    if (serviceEnabled == false) {
      await location.requestService();
    }
    if (permission == geolocs.LocationPermission.denied ||
        permission == geolocs.LocationPermission.deniedForever) {
      if (permission != geolocs.LocationPermission.deniedForever) {
        await perm.Permission.location.request();
      }
    }
    setState(() {
      _loading = true;
    });
    getLocs();
  }

  int _bottom = 0;

  GeoHasher geo = GeoHasher();

  @override
  Widget build(BuildContext context) {
    double lat = 0.0144927536231884;
    double lon = 0.0181818181818182;
    double lowerLat = center.latitude - (lat * 1.24);
    double lowerLon = center.longitude - (lon * 1.24);
    double greaterLat = center.latitude + (lat * 1.24);
    double greaterLon = center.longitude + (lon * 1.24);
    var lower = geo.encode(lowerLon, lowerLat);
    var higher = geo.encode(greaterLon, greaterLat);

    var fdb = FirebaseDatabase.instance
        .ref('drivers')
        .orderByChild('g')
        .startAt(lower)
        .endAt(higher);

    var media = MediaQuery.of(context).size;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (s, a) async {
        if (_bottom == 1) {
          setState(() {
            _bottom = 0;
          });
        }
      },
      child: Material(
        child: ValueListenableBuilder(
          valueListenable: valueNotifierHome.value,
          builder: (context, value, child) {
            if (userRequestData.isNotEmpty &&
                userRequestData['is_later'] == 1 &&
                userRequestData['is_completed'] != 1 &&
                userRequestData['accepted_at'] != null) {
              Future.delayed(
                const Duration(seconds: 2),
                () {
                  if (userRequestData['is_rental'] == true) {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookingConfirmation(
                            type: 1,
                          ),
                        ),
                        (route) => false);
                  } else {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BookingConfirmation()),
                        (route) => false);
                  }
                },
              );
            }

            return Directionality(
              textDirection: (languageDirection == 'rtl')
                  ? TextDirection.rtl
                  : TextDirection.ltr,
              child: Scaffold(
                resizeToAvoidBottomInset: false,
                drawer: const NavDrawer(),
                body: Stack(
                  children: [
                    Container(
                      color: page,
                      height: media.height * 1,
                      width: media.width * 1,
                      child: Column(
                        mainAxisAlignment: (state == '1' || state == '2')
                            ? MainAxisAlignment.center
                            : MainAxisAlignment.start,
                        children: [
                          (state == '1')
                              ? StateOneWidget(onTap: () {
                                  setState(() {
                                    state = '';
                                  });
                                  getLocs();
                                })
                              : (state == '2')
                                  ? StateTwoWidget(onTap: () async {
                                      if (serviceEnabled == false) {
                                        await location.requestService();
                                      }
                                      if (await geolocs
                                          .GeolocatorPlatform.instance
                                          .isLocationServiceEnabled()) {
                                        if (permission ==
                                                PermissionStatus.denied ||
                                            permission ==
                                                PermissionStatus
                                                    .deniedForever) {
                                          await location.requestPermission();
                                        }
                                      }
                                      setState(() {
                                        _loading = true;
                                      });
                                      getLocs();
                                    })
                                  : (state == '3')
                                      ? StateThreeWidget(
                                          bottom: _bottom,
                                          fdb: fdb,
                                          center: center,
                                          dropLocationMap: _dropLocationMap,
                                          dropAddress: _dropaddress,
                                          pickaddress: _pickaddress,
                                          isMapMoving: _isMapMoving,
                                          onMapMove: _setMapMoving,
                                          onMapCreated: (d) {
                                            _onMapCreated(d);
                                          },
                                          onChange7: () async {
                                            setState(() {
                                              addAutoFill.clear();
                                              _bottom = 0;
                                            });
                                            if (_dropaddress == true &&
                                                addressList
                                                    .where((element) =>
                                                        element.id == 'pickup')
                                                    .isNotEmpty) {
                                              final bool? navigate =
                                                  await Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              const DropLocation()));
                                              if (navigate == true) {
                                                setState(() {
                                                  addressList.removeWhere(
                                                      (element) =>
                                                          element.id == 'drop');
                                                });
                                              }
                                            }
                                          },
                                          onChange6: (i) {
                                            if (_pickaddress == true) {
                                              setState(() {
                                                addAutoFill.clear();
                                                if (addressList
                                                    .where((element) =>
                                                        element.id == 'pickup')
                                                    .isEmpty) {
                                                  addressList.add(
                                                    AddressList(
                                                      id: 'pickup',
                                                      address: lastAddress[i]
                                                          .dropAddress,
                                                      latlng: Point(
                                                        latitude:
                                                            lastAddress[i]
                                                                .dropLat,
                                                        longitude:
                                                            lastAddress[i]
                                                                .dropLng,
                                                      ),
                                                    ),
                                                  );
                                                } else {
                                                  addressList
                                                          .firstWhere(
                                                              (element) =>
                                                                  element.id ==
                                                                  'pickup')
                                                          .address =
                                                      lastAddress[i]
                                                          .dropAddress;
                                                  addressList
                                                      .firstWhere((element) =>
                                                          element.id ==
                                                          'pickup')
                                                      .latlng = Point(
                                                    latitude:
                                                        lastAddress[i].dropLat,
                                                    longitude:
                                                        lastAddress[i].dropLng,
                                                  );
                                                }
                                                _controller?.moveCamera(
                                                  CameraUpdate
                                                      .newCameraPosition(
                                                    CameraPosition(
                                                      target: Point(
                                                        latitude: lastAddress[
                                                                i]
                                                            .dropLat,
                                                        longitude:
                                                            lastAddress[i]
                                                                .dropLng,
                                                      ),
                                                      zoom: 14.0,
                                                    ),
                                                  ),
                                                );

                                                _bottom = 0;
                                              });
                                            } else {
                                              setState(() {
                                                if (addressList
                                                    .where((element) =>
                                                        element.id == 'drop')
                                                    .isEmpty) {
                                                  addressList.add(
                                                    AddressList(
                                                      id: 'drop',
                                                      address: lastAddress[i]
                                                          .dropAddress,
                                                      latlng: Point(
                                                        latitude:
                                                            lastAddress[i]
                                                                .dropLat,
                                                        longitude:
                                                            lastAddress[i]
                                                                .dropLng,
                                                      ),
                                                    ),
                                                  );
                                                } else {
                                                  addressList
                                                      .firstWhere((element) =>
                                                          element.id == 'drop')
                                                      .address = lastAddress[
                                                          i]
                                                      .dropAddress;
                                                  addressList
                                                          .firstWhere(
                                                              (element) =>
                                                                  element.id ==
                                                                  'drop')
                                                          .latlng =
                                                      Point(
                                                    latitude:
                                                        lastAddress[i].dropLat,
                                                    longitude:
                                                        lastAddress[i].dropLng,
                                                  );
                                                }
                                                addAutoFill.clear();
                                                _bottom = 0;
                                              });
                                              if (addressList.length == 2) {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            BookingConfirmation()));
                                                dropAddress =
                                                    lastAddress[i].pickAddress;
                                              }
                                            }
                                          },
                                          onChange5: (i) async {
                                            if (favAddress
                                                .where((e) =>
                                                    e['pick_address'] ==
                                                    addAutoFill[i]
                                                        ['description'])
                                                .isEmpty) {
                                              var val =
                                                  await geoCodingForLatLng(
                                                      addAutoFill[i]
                                                          ['place_id']);
                                              setState(
                                                () {
                                                  favSelectedAddress =
                                                      addAutoFill[i]
                                                          ['description'];
                                                  favLat = val.latitude;
                                                  favLng = val.longitude;
                                                  favAddressAdd = true;
                                                },
                                              );
                                            }
                                          },
                                          onChange4: (i) async {
                                            var val = await geoCodingForLatLng(
                                                addAutoFill[i]['place_id']);
                                            if (_pickaddress == true) {
                                              setState(() {
                                                if (addressList
                                                    .where((element) =>
                                                        element.id == 'pickup')
                                                    .isEmpty) {
                                                  addressList.add(AddressList(
                                                      id: 'pickup',
                                                      address: addAutoFill[i]
                                                          ['description'],
                                                      latlng: val));
                                                } else {
                                                  addressList
                                                          .firstWhere(
                                                              (element) =>
                                                                  element.id ==
                                                                  'pickup')
                                                          .address =
                                                      addAutoFill[i]
                                                          ['description'];
                                                  addressList
                                                      .firstWhere((element) =>
                                                          element.id ==
                                                          'pickup')
                                                      .latlng = val;
                                                }
                                              });
                                            } else {
                                              setState(() {
                                                if (addressList
                                                    .where((element) =>
                                                        element.id == 'drop')
                                                    .isEmpty) {
                                                  addressList.add(AddressList(
                                                      id: 'drop',
                                                      address: addAutoFill[i]
                                                          ['description'],
                                                      latlng: val));
                                                } else {
                                                  addressList
                                                          .firstWhere(
                                                              (element) =>
                                                                  element.id ==
                                                                  'drop')
                                                          .address =
                                                      addAutoFill[i]
                                                          ['description'];
                                                  addressList
                                                      .firstWhere((element) =>
                                                          element.id == 'drop')
                                                      .latlng = val;
                                                }
                                              });
                                              if (addressList.length == 2) {
                                                navigate();
                                              }
                                            }
                                            addAutoFill.clear();
                                            _dropaddress = false;

                                            if (_pickaddress == true) {
                                              center = val;
                                              _controller?.moveCamera(
                                                CameraUpdate.newCameraPosition(
                                                  CameraPosition(
                                                    target: val,
                                                    zoom: 14.0,
                                                  ),
                                                ),
                                              );
                                            }
                                            _bottom = 0;
                                            setState(() {});
                                          },
                                          onChange3: (val) {
                                            if (val.length >= 4) {
                                              getAutoAddress(
                                                  val,
                                                  _sessionToken,
                                                  center.latitude,
                                                  center.longitude);
                                            } else {
                                              setState(() {
                                                addAutoFill.clear();
                                              });
                                            }
                                          },
                                          onChange2: () {
                                              if (addressList
                                                  .where((element) =>
                                                      element.id == 'pickup')
                                                  .isNotEmpty) {
                                              setState(() {
                                                _pickaddress = false;
                                                _dropaddress = true;
                                                addAutoFill.clear();
                                                _bottom = 1;
                                              });
                                            }
                                          },
                                          onChange1: (val) {
                                            if (val.delta.dy > 0) {
                                              setState(() {
                                                _bottom = 0;
                                                addAutoFill.clear();
                                                _pickaddress = false;
                                                _dropaddress = false;
                                              });
                                            }
                                            if (val.delta.dy < 0) {
                                              setState(() {
                                                _bottom = 1;
                                              });
                                            }
                                          },
                                          locationAllowed: () async {
                                            if (locationAllowed == true) {
                                              Point target = center;
                                              bool hasLocation = false;

                                              if (currentLocation != null) {
                                                target = currentLocation!;
                                                hasLocation = true;
                                              } else {
                                                geolocs.Position? loc;
                                                try {
                                                  loc = await geolocs
                                                      .Geolocator
                                                      .getLastKnownPosition();
                                                  loc ??= await geolocs
                                                      .Geolocator
                                                      .getCurrentPosition(
                                                          desiredAccuracy:
                                                              geolocs
                                                                  .LocationAccuracy
                                                                  .high);
                                                } catch (_) {}
                                                if (loc != null) {
                                                  target = Point(
                                                    latitude: loc.latitude,
                                                    longitude: loc.longitude,
                                                  );
                                                  hasLocation = true;
                                                }
                                              }

                                              if (!mounted) return;
                                              setState(() {
                                                center = target;
                                                _centerLocation = target;
                                                if (hasLocation) {
                                                  currentLocation = target;
                                                }
                                              });
                                              _controller?.moveCamera(
                                                CameraUpdate.newCameraPosition(
                                                  CameraPosition(
                                                    target: target,
                                                    zoom: 18.0,
                                                  ),
                                                ),
                                              );
                                            } else {
                                              if (serviceEnabled == true) {
                                                setState(() {
                                                  _locationDenied = true;
                                                });
                                              } else {
                                                await location.requestService();
                                                if (await geolocs
                                                    .GeolocatorPlatform.instance
                                                    .isLocationServiceEnabled()) {
                                                  setState(() {
                                                    _locationDenied = true;
                                                  });
                                                }
                                              }
                                            }
                                          },
                                          pickup: () {
                                            if (favAddress
                                                .where((element) =>
                                                    element['pick_address'] ==
                                                    addressList
                                                        .firstWhere((element) =>
                                                            element.id ==
                                                            'pickup')
                                                        .address)
                                                .isEmpty) {
                                              setState(() {
                                                favSelectedAddress = addressList
                                                    .firstWhere((element) =>
                                                        element.id == 'pickup')
                                                    .address;
                                                favLat = addressList
                                                    .firstWhere((element) =>
                                                        element.id == 'pickup')
                                                    .latlng
                                                    .latitude;
                                                favLng = addressList
                                                    .firstWhere((element) =>
                                                        element.id == 'pickup')
                                                    .latlng
                                                    .longitude;
                                                favAddressAdd = true;
                                              });
                                            }
                                          },
                                          centerLocation: (d) {
                                            setState(() {
                                              center = d.target;
                                              _centerLocation = d.target;
                                            });
                                          },
                                          addDirections: (val) {
                                            if (val.length >= 4) {
                                              getAutoAddress(
                                                  val,
                                                  _sessionToken,
                                                  center.latitude,
                                                  center.longitude);
                                            } else {
                                              setState(() {
                                                addAutoFill.clear();
                                              });
                                            }
                                          },
                                          changePosition: () {
                                            setState(() {
                                              _bottom = 1;
                                              _dropaddress = false;
                                              addAutoFill.clear();
                                              if (_pickaddress == false) {
                                                _dropLocationMap = false;
                                                _sessionToken =
                                                    const Uuid().v4();
                                                _pickaddress = true;
                                              }
                                            });
                                          },
                                          cameraIdle: () async {
                                            if (_bottom == 0 &&
                                                _pickaddress == false) {
                                              var val = await geoCoding(
                                                  _centerLocation.latitude,
                                                  _centerLocation.longitude);
                                              setState(() {
                                                if (addressList
                                                    .where((element) =>
                                                        element.id == 'pickup')
                                                    .isNotEmpty) {
                                                  var add = addressList
                                                      .firstWhere((element) =>
                                                          element.id ==
                                                          'pickup');
                                                  add.address = val;
                                                  add.latlng = Point(
                                                    latitude:
                                                        _centerLocation.latitude,
                                                    longitude:
                                                        _centerLocation.longitude,
                                                  );
                                                } else {
                                                  addressList.add(
                                                    AddressList(
                                                      id: 'pickup',
                                                      address: val,
                                                      latlng: Point(
                                                        latitude:
                                                            _centerLocation
                                                                .latitude,
                                                        longitude:
                                                            _centerLocation
                                                                .longitude,
                                                      ),
                                                    ),
                                                  );
                                                }
                                              });
                                            } else if (_pickaddress == true) {
                                              setState(() {
                                                _pickaddress = false;
                                              });
                                            }
                                          },
                                          carMarkerStream: carMarkerStream,
                                          myMarkers: myMarkers,
                                          eventData: (event) {
                                            List driverData = [];
                                            for (var element in event
                                                .data!.snapshot.children) {
                                              driverData.add(element.value);
                                            }
                                            for (var element in driverData) {
                                              if (element['is_active'] == 1 &&
                                                  element['is_available'] ==
                                                      true) {
                                                DateTime dt = DateTime
                                                    .fromMillisecondsSinceEpoch(
                                                        element['updated_at']);
                                                if (DateTime.now()
                                                        .difference(dt)
                                                        .inMinutes <=
                                                    2) {
                                                  final markerId =
                                                      'car${element['id']}';
                                                  final existingIndex =
                                                      myMarkers.indexWhere(
                                                          (e) =>
                                                              e.mapId.value ==
                                                              markerId);
                                                  final icon = (element[
                                                              'vehicle_type_icon'] ==
                                                          'taxi')
                                                      ? pinLocationIcon
                                                      : pinLocationIcon2;
                                                  final bearing = (myBearings[
                                                              element['id']
                                                                  .toString()] !=
                                                          null)
                                                      ? myBearings[
                                                          element['id']
                                                              .toString()]
                                                      : 0.0;
                                                  final nextPoint = Point(
                                                    latitude: element['l'][0],
                                                    longitude: element['l'][1],
                                                  );
                                                  if (existingIndex == -1) {
                                                    myMarkers.add(
                                                      _buildVehicleMarker(
                                                        markerId: markerId,
                                                        point: nextPoint,
                                                        icon: icon,
                                                        direction: bearing,
                                                      ),
                                                    );
                                                  } else if (_controller !=
                                                      null) {
                                                    final existing =
                                                        myMarkers[existingIndex];
                                                    if (existing
                                                                .point
                                                                .latitude !=
                                                            element['l'][0] ||
                                                        existing
                                                                .point
                                                                .longitude !=
                                                            element['l'][1]) {
                                                      final dist =
                                                          calculateDistance(
                                                        existing
                                                            .point.latitude,
                                                        existing
                                                            .point.longitude,
                                                        element['l'][0],
                                                        element['l'][1],
                                                      );
                                                      if (dist > 100) {
                                                        animationController =
                                                            AnimationController(
                                                          duration:
                                                              const Duration(
                                                                  milliseconds:
                                                                      1500),
                                                          //Animation duration of marker
                                                          vsync:
                                                              this, //From the widget
                                                        );
                                                        animateCar(
                                                            existing
                                                                .point
                                                                .latitude,
                                                            existing
                                                                .point
                                                                .longitude,
                                                            element['l'][0],
                                                            element['l'][1],
                                                            _mapMarkerSink,
                                                            this,
                                                            _controller,
                                                            markerId,
                                                            element['id'],
                                                            icon);
                                                      }
                                                    }
                                                  }
                                                }
                                              } else {
                                                if (myMarkers
                                                    .where((e) =>
                                                        e.mapId.value ==
                                                        'car${element['id']}')
                                                    .isNotEmpty) {
                                                  myMarkers.removeWhere((e) =>
                                                      e.mapId.value ==
                                                      'car${element['id']}');
                                                }
                                              }
                                            }
                                          },
                                        )
                                      : Container(),
                        ],
                      ),
                    ),

                    //add fav address
                    if (favAddressAdd == true)
                      AddFavAddressWidget(
                        onChangeFavName: (name) {
                          setState(() {
                            favName = name;
                          });
                        },
                        onChangeFavAddress: (change) {
                          setState(() {
                            favAddressAdd = false;
                          });
                        },
                        onChangeFavNameText: (String name) {
                          setState(() {
                            favNameText = name;
                          });
                        },
                        button: () async {
                          if (favName == 'Others' && favNameText != '') {
                            setState(() {
                              _loading = true;
                            });
                            var val = await addFavLocation(favLat, favLng,
                                favSelectedAddress, favNameText);
                            setState(() {
                              _loading = false;
                              if (val == true) {
                                favLat = '';
                                favLng = '';
                                favSelectedAddress = '';
                                favName = 'Home';
                                favNameText = '';
                                favAddressAdd = false;
                              }
                            });
                          } else if (favName == 'Home' || favName == 'Work') {
                            setState(() {
                              _loading = true;
                            });
                            var val = await addFavLocation(
                                favLat, favLng, favSelectedAddress, favName);
                            setState(() {
                              _loading = false;
                              if (val == true) {
                                favLat = '';
                                favLng = '';
                                favName = 'Home';
                                favSelectedAddress = '';
                                favNameText = '';
                                favAddressAdd = false;
                              }
                            });
                          }
                        },
                      ),

                    //driver cancelled request
                    if (requestCancelledByDriver == true)
                      DriverCancelRequestWidget(onTap: () {
                        setState(() {
                          requestCancelledByDriver = false;
                          userRequestData = {};
                        });
                      }),

                    //user cancelled request
                    if (cancelRequestByUser == true)
                      UserCancelRequestWidget(
                        onTap: () {
                          setState(() {
                            cancelRequestByUser = false;
                            userRequestData = {};
                          });
                        },
                      ),

                    //delete account
                    if (deleteAccount == true)
                      Positioned(
                        top: 0,
                        child: Container(
                          height: media.height * 1,
                          width: media.width * 1,
                          color: Colors.transparent.withValues(alpha: 0.6),
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
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: page),
                                        child: InkWell(
                                            onTap: () {
                                              setState(() {
                                                deleteAccount = false;
                                              });
                                            },
                                            child: const Icon(
                                                Icons.cancel_outlined))),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(media.width * 0.05),
                                width: media.width * 0.9,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: page),
                                child: Column(
                                  children: [
                                    Text(
                                      context.l10n.text_delete_confirm,
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.roboto(
                                        fontSize: media.width * sixteen,
                                        color: textColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(
                                      height: media.width * 0.05,
                                    ),
                                    Button(
                                      onTap: () async {
                                        setState(() {
                                          deleteAccount = false;
                                          _loading = true;
                                        });
                                        var result = await userDelete();
                                        if (result == 'success') {
                                          setState(() {
                                            Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const Login()),
                                                (route) => false);
                                            userDetails.clear();
                                          });
                                        } else {
                                          setState(() {
                                            _loading = false;
                                            deleteAccount = true;
                                          });
                                        }
                                        setState(() {
                                          _loading = false;
                                        });
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

                    //logout
                    if (logout == true)
                      Positioned(
                        top: 0,
                        child: Container(
                          height: media.height * 1,
                          width: media.width * 1,
                          color: Colors.transparent.withValues(alpha: 0.6),
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
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle, color: page),
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            logout = false;
                                          });
                                        },
                                        child: const Icon(
                                          Icons.cancel_outlined,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(media.width * 0.05),
                                width: media.width * 0.9,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: page),
                                child: Column(
                                  children: [
                                    Text(
                                      context.l10n.text_confirmlogout,
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.roboto(
                                        fontSize: media.width * sixteen,
                                        color: textColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(
                                      height: media.width * 0.05,
                                    ),
                                    Button(
                                      onTap: () async {
                                        setState(() {
                                          logout = false;
                                          _loading = true;
                                        });
                                        var result = await userLogout();
                                        if (result == 'success') {
                                          setState(() {
                                            Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const Login()),
                                                (route) => false);
                                            userDetails.clear();
                                          });
                                        } else {
                                          setState(() {
                                            _loading = false;
                                            logout = true;
                                          });
                                        }
                                        setState(() {
                                          _loading = false;
                                        });
                                      },
                                      text: context.l10n.text_confirm,
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    if (_locationDenied == true)
                      Positioned(
                        child: Container(
                          height: media.height * 1,
                          width: media.width * 1,
                          color: Colors.transparent.withValues(alpha: 0.6),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: media.width * 0.9,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          _locationDenied = false;
                                        });
                                      },
                                      child: Container(
                                        height: media.height * 0.05,
                                        width: media.height * 0.05,
                                        decoration: BoxDecoration(
                                          color: page,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Icons.cancel,
                                          color: buttonColor,
                                        ),
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
                                      color:
                                          Colors.black.withValues(alpha: 0.2),
                                    )
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        InkWell(
                                          onTap: () async {
                                            await perm.openAppSettings();
                                          },
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
                                            setState(() {
                                              _locationDenied = false;
                                              _loading = true;
                                            });

                                            getLocs();
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
                      ),

                    //loader
                    if (_loading == true || state == '')
                      const Positioned(
                        top: 0,
                        child: Loading(),
                      ),
                    if (internet == false)
                      Positioned(
                        top: 0,
                        child: NoInternet(
                          onTap: () {
                            setState(() {
                              internetTrue();
                              getUserDetails();
                            });
                          },
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

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

  PlacemarkMapObject _buildVehicleMarker({
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
    final double bearing =
        getBearing(Point(latitude: fromLat, longitude: fromLong),
            Point(latitude: toLat, longitude: toLong));

    myBearings[markerBearing.toString()] = bearing;

    var carMarker = _buildVehicleMarker(
      markerId: markerid,
      point: Point(latitude: fromLat, longitude: fromLong),
      icon: icon,
    );

    myMarkers.add(carMarker);

    mapMarkerSink.add(List<PlacemarkMapObject>.from(myMarkers));

    Tween<double> tween = Tween(begin: 0, end: 1);

    _animation = tween.animate(animationController)
      ..addListener(() async {
        myMarkers.removeWhere((element) =>
            element.mapId == MapObjectId(markerid.toString()));

        final v = _animation!.value;

        double lng = v * toLong + (1 - v) * fromLong;

        double lat = v * toLat + (1 - v) * fromLat;

        Point newPos = Point(latitude: lat, longitude: lng);

        //New marker location

        carMarker = _buildVehicleMarker(
          markerId: markerid,
          point: newPos,
          icon: icon,
          direction: bearing,
        );

        //Adding new marker to our list and updating the google map UI.

        myMarkers.add(carMarker);

        mapMarkerSink.add(List<PlacemarkMapObject>.from(myMarkers));
      });

    //Starting the animation

    animationController.forward();
  }
}
