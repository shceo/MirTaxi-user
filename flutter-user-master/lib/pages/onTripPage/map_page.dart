import 'dart:math';
import 'package:tagyourtaxi_driver/pages/onTripPage/booking_confirmation.dart';
import 'package:tagyourtaxi_driver/pages/onTripPage/drop_loc_select.dart';
import 'package:tagyourtaxi_driver/pages/login/login.dart';
import 'package:tagyourtaxi_driver/pages/noInternet/nointernet.dart';
import 'package:tagyourtaxi_driver/pages/onTripPage/screens/add_fav_address_widget.dart';
import 'package:tagyourtaxi_driver/pages/onTripPage/screens/driver_cancel_request_widget.dart';
import 'package:tagyourtaxi_driver/pages/onTripPage/screens/state_one_widget.dart';
import 'package:tagyourtaxi_driver/pages/onTripPage/screens/state_three_widget.dart';
import 'package:tagyourtaxi_driver/pages/onTripPage/screens/state_two_widget.dart';
import 'package:tagyourtaxi_driver/pages/onTripPage/screens/user_cancel_request_widget.dart';
import 'package:tagyourtaxi_driver/translations/translation.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tagyourtaxi_driver/functions/functions.dart';
import 'package:tagyourtaxi_driver/functions/geohash.dart';
import 'package:tagyourtaxi_driver/pages/loadingPage/loading.dart';
import 'package:tagyourtaxi_driver/styles/styles.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:location/location.dart';
import 'package:tagyourtaxi_driver/widgets/widgets.dart';
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
dynamic currentLocation;
LatLng center = const LatLng(41.4219057, -102.0840772);
String mapStyle = '';
List<Marker> myMarkers = [];
Set<Marker> markers = {};
String dropAddressConfirmation = '';
List<AddressList> addressList = <AddressList>[];
dynamic favLat;
dynamic favLng;
String favSelectedAddress = '';
String favName = 'Home';
String favNameText = '';
bool requestCancelledByDriver = false;
bool cancelRequestByUser = false;
bool logout = false;
bool deleteAccount = false;

class _MapsState extends State<Maps>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  LatLng _centerLocation = const LatLng(41.4219057, -102.0840772);

  dynamic animationController;
  dynamic _sessionToken;
  bool _loading = false;
  bool _pickaddress = false;
  bool _dropaddress = false;
  bool _dropLocationMap = false;
  bool _locationDenied = false;
  int gettingPerm = 0;
  Animation<double>? _animation;

  late PermissionStatus permission;
  Location location = Location();
  String state = '';
  dynamic _controller;
  Map myBearings = {};

  late BitmapDescriptor pinLocationIcon;
  dynamic pinLocationIcon2;
  dynamic userLocationIcon;
  bool favAddressAdd = false;
  bool _showToast = false;
  bool contactus = false;
  final _mapMarkerSC = StreamController<List<Marker>>();

  StreamSink<List<Marker>> get _mapMarkerSink => _mapMarkerSC.sink;

  Stream<List<Marker>> get carMarkerStream => _mapMarkerSC.stream;

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _controller = controller;
      _controller?.setMapStyle(mapStyle);
    });
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
      if (_controller != null) {
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

//show toast for demo
  addToast() {
    setState(() {
      _showToast = true;
    });
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _showToast = false;
      });
    });
  }

//get location permission and location details
  getLocs() async {
    myBearings.clear;
    addressList.clear();
    serviceEnabled = await location.serviceEnabled();
    polyline.clear();
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
          center = LatLng(double.parse(locs.latitude.toString()),
              double.parse(locs.longitude.toString()));
          _centerLocation = LatLng(double.parse(locs.latitude.toString()),
              double.parse(locs.longitude.toString()));
          currentLocation = LatLng(double.parse(locs.latitude.toString()),
              double.parse(locs.longitude.toString()));
        });
      } else {
        var loc = await geolocs.Geolocator.getCurrentPosition(
            desiredAccuracy: geolocs.LocationAccuracy.low);
        setState(() {
          center = LatLng(double.parse(loc.latitude.toString()),
              double.parse(loc.longitude.toString()));
          _centerLocation = LatLng(double.parse(loc.latitude.toString()),
              double.parse(loc.longitude.toString()));
          currentLocation = LatLng(double.parse(loc.latitude.toString()),
              double.parse(loc.longitude.toString()));
        });
      }
      _controller?.animateCamera(CameraUpdate.newLatLngZoom(center, 14.0));
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
                                              var navigate = await Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const DropLocation()));
                                              if (navigate) {
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
                                                      latlng: LatLng(
                                                        lastAddress[i].dropLat,
                                                        lastAddress[i].dropLng,
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
                                                      .latlng = LatLng(
                                                    lastAddress[i].dropLat,
                                                    lastAddress[i].dropLng,
                                                  );
                                                }
                                                _controller?.moveCamera(
                                                  CameraUpdate.newLatLngZoom(
                                                      LatLng(
                                                          lastAddress[i]
                                                              .dropLat,
                                                          lastAddress[i]
                                                              .dropLng),
                                                      14.0),
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
                                                      latlng: LatLng(
                                                        lastAddress[i].dropLat,
                                                        lastAddress[i].dropLng,
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
                                                      LatLng(
                                                          lastAddress[i]
                                                              .dropLat,
                                                          lastAddress[i]
                                                              .dropLng);
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
                                                  CameraUpdate.newLatLngZoom(
                                                      val, 14.0));
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
                                              _controller?.animateCamera(
                                                  CameraUpdate.newLatLngZoom(
                                                      center, 18.0));
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
                                              _centerLocation = center;
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
                                                  add.latlng = LatLng(
                                                      _centerLocation.latitude,
                                                      _centerLocation
                                                          .longitude);
                                                } else {
                                                  addressList.add(
                                                    AddressList(
                                                      id: 'pickup',
                                                      address: val,
                                                      latlng: LatLng(
                                                          _centerLocation
                                                              .latitude,
                                                          _centerLocation
                                                              .longitude),
                                                    ),
                                                  );
                                                }
                                              });
                                              addToast();
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
                                                  if (myMarkers
                                                      .where((e) => e.markerId
                                                          .toString()
                                                          .contains(
                                                              'car${element['id']}'))
                                                      .isEmpty) {
                                                    myMarkers.add(
                                                      Marker(
                                                        markerId: MarkerId(
                                                            'car${element['id']}'),
                                                        rotation: (myBearings[
                                                                    element['id']
                                                                        .toString()] !=
                                                                null)
                                                            ? myBearings[
                                                                element['id']
                                                                    .toString()]
                                                            : 0.0,
                                                        position: LatLng(
                                                            element['l'][0],
                                                            element['l'][1]),
                                                        icon: (element[
                                                                    'vehicle_type_icon'] ==
                                                                'taxi')
                                                            ? pinLocationIcon
                                                            : pinLocationIcon2,
                                                      ),
                                                    );
                                                  } else if (_controller !=
                                                      null) {
                                                    if (myMarkers
                                                                .lastWhere((e) => e
                                                                    .markerId
                                                                    .toString()
                                                                    .contains(
                                                                        'car${element['id']}'))
                                                                .position
                                                                .latitude !=
                                                            element['l'][0] ||
                                                        myMarkers
                                                                .lastWhere((e) => e
                                                                    .markerId
                                                                    .toString()
                                                                    .contains(
                                                                        'car${element['id']}'))
                                                                .position
                                                                .longitude !=
                                                            element['l'][1]) {
                                                      var dist = calculateDistance(
                                                          myMarkers
                                                              .lastWhere((e) => e
                                                                  .markerId
                                                                  .toString()
                                                                  .contains(
                                                                      'car${element['id']}'))
                                                              .position
                                                              .latitude,
                                                          myMarkers
                                                              .lastWhere((e) => e
                                                                  .markerId
                                                                  .toString()
                                                                  .contains(
                                                                      'car${element['id']}'))
                                                              .position
                                                              .longitude,
                                                          element['l'][0],
                                                          element['l'][1]);
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
                                                            myMarkers
                                                                .lastWhere((e) => e
                                                                    .markerId
                                                                    .toString()
                                                                    .contains(
                                                                        'car${element['id']}'))
                                                                .position
                                                                .latitude,
                                                            myMarkers
                                                                .lastWhere((e) => e
                                                                    .markerId
                                                                    .toString()
                                                                    .contains(
                                                                        'car${element['id']}'))
                                                                .position
                                                                .longitude,
                                                            element['l'][0],
                                                            element['l'][1],
                                                            _mapMarkerSink,
                                                            this,
                                                            _controller,
                                                            'car${element['id']}',
                                                            element['id'],
                                                            (element['vehicle_type_icon'] ==
                                                                    'taxi')
                                                                ? pinLocationIcon
                                                                : pinLocationIcon2);
                                                      }
                                                    }
                                                  }
                                                }
                                              } else {
                                                if (myMarkers
                                                    .where((e) => e.markerId
                                                        .toString()
                                                        .contains(
                                                            'car${element['id']}'))
                                                    .isNotEmpty) {
                                                  myMarkers.removeWhere((e) => e
                                                      .markerId
                                                      .toString()
                                                      .contains(
                                                          'car${element['id']}'));
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
                                      languages[choosenLanguage]
                                          ['text_delete_confirm'],
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
                                      text: languages[choosenLanguage]
                                          ['text_confirm'],
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
                                      languages[choosenLanguage]
                                          ['text_confirmlogout'],
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
                                      text: languages[choosenLanguage]
                                          ['text_confirm'],
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
                                        languages[choosenLanguage]
                                            ['text_open_loc_settings'],
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
                                            languages[choosenLanguage]
                                                ['text_open_settings'],
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
                                            languages[choosenLanguage]
                                                ['text_done'],
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

                    //display toast
                    if (_showToast == true)
                      Positioned(
                        top: media.height * 0.5,
                        child: Container(
                          width: media.width * 0.9,
                          margin: EdgeInsets.all(media.width * 0.05),
                          padding: EdgeInsets.all(media.width * 0.025),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: page),
                          child: Text(
                            'Auto address by scrolling map feature is not available in demo',
                            style: GoogleFonts.roboto(
                              fontSize: media.width * twelve,
                              color: textColor,
                            ),
                            textAlign: TextAlign.center,
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

  double getBearing(LatLng begin, LatLng end) {
    double lat = (begin.latitude - end.latitude).abs();

    double lng = (begin.longitude - end.longitude).abs();

    if (begin.latitude < end.latitude && begin.longitude < end.longitude) {
      return vector.degrees(atan(lng / lat));
    } else if (begin.latitude >= end.latitude &&
        begin.longitude < end.longitude) {
      return (90 - vector.degrees(atan(lng / lat))) + 90;
    } else if (begin.latitude >= end.latitude &&
        begin.longitude >= end.longitude) {
      return vector.degrees(atan(lng / lat)) + 180;
    } else if (begin.latitude < end.latitude &&
        begin.longitude >= end.longitude) {
      return (90 - vector.degrees(atan(lng / lat))) + 270;
    }

    return -1;
  }

  animateCar(
      double fromLat, //Starting latitude

      double fromLong, //Starting longitude

      double toLat, //Ending latitude

      double toLong, //Ending longitude

      StreamSink<List<Marker>> mapMarkerSink,
      //Stream build of map to update the UI

      TickerProvider provider,
      //Ticker provider of the widget. This is used for animation

      GoogleMapController controller, //Google map controller of our widget

      markerid,
      markerBearing,
      icon) async {
    final double bearing =
        getBearing(LatLng(fromLat, fromLong), LatLng(toLat, toLong));

    myBearings[markerBearing.toString()] = bearing;

    var carMarker = Marker(
        markerId: MarkerId(markerid),
        position: LatLng(fromLat, fromLong),
        icon: icon,
        anchor: const Offset(0.5, 0.5),
        flat: true,
        draggable: false);

    myMarkers.add(carMarker);

    mapMarkerSink.add(Set<Marker>.from(myMarkers).toList());

    Tween<double> tween = Tween(begin: 0, end: 1);

    _animation = tween.animate(animationController)
      ..addListener(() async {
        myMarkers
            .removeWhere((element) => element.markerId == MarkerId(markerid));

        final v = _animation!.value;

        double lng = v * toLong + (1 - v) * fromLong;

        double lat = v * toLat + (1 - v) * fromLat;

        LatLng newPos = LatLng(lat, lng);

        //New marker location

        carMarker = Marker(
            markerId: MarkerId(markerid),
            position: newPos,
            icon: icon,
            anchor: const Offset(0.5, 0.5),
            flat: true,
            rotation: bearing,
            draggable: false);

        //Adding new marker to our list and updating the google map UI.

        myMarkers.add(carMarker);

        mapMarkerSink.add(Set<Marker>.from(myMarkers).toList());
      });

    //Starting the animation

    animationController.forward();
  }
}
