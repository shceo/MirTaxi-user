import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tagyourtaxi_driver/src/core/services/app_state.dart';
import 'package:tagyourtaxi_driver/src/core/services/functions.dart';
import 'package:tagyourtaxi_driver/src/core/utils/geohash.dart';
import 'package:tagyourtaxi_driver/src/presentation/views/onTripPage/invoice.dart';
import 'package:tagyourtaxi_driver/src/presentation/views/loadingPage/loading.dart';
import 'package:tagyourtaxi_driver/src/presentation/views/onTripPage/map_page.dart';
import 'package:tagyourtaxi_driver/src/presentation/views/noInternet/nointernet.dart';
import 'package:tagyourtaxi_driver/src/presentation/views/onTripPage/screens/booking/address_widget.dart';
import 'package:tagyourtaxi_driver/src/presentation/views/onTripPage/screens/booking/select_taxi_widget.dart';
import 'package:tagyourtaxi_driver/src/presentation/styles/styles.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import 'package:location/location.dart';
import 'package:tagyourtaxi_driver/src/l10n/l10n.dart';
import 'package:tagyourtaxi_driver/src/presentation/widgets/booking/address_view_widget.dart';
import 'package:tagyourtaxi_driver/src/presentation/widgets/widgets.dart';
import 'package:vector_math/vector_math.dart' as vector;
import 'dart:ui' as ui;
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart' as perm;
import 'package:geolocator/geolocator.dart' as geolocs;

part 'booking_confirmation_logic.dart';
part 'booking_confirmation_panels.dart';
part 'booking_confirmation_modals.dart';
part 'booking_confirmation_ui.dart';

// ignore: must_be_immutable
class BookingConfirmation extends StatefulWidget {
  // const BookingConfirmation({Key? key}) : super(key: key);
  dynamic type;

  //type = 1 is rental ride and type = null is regular ride
  BookingConfirmation({Key? key, this.type}) : super(key: key);

  @override
  State<BookingConfirmation> createState() => _BookingConfirmationState();
}

dynamic timing;
var driverData = {};
var driversData = [];
bool lowWalletBalance = false;
Animation<double>? _animation;

class _BookingConfirmationState extends State<BookingConfirmation>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  TextEditingController promoKey = TextEditingController();
  final Map minutes = {};
  List<PlacemarkMapObject> myMarker = [];
  Map myBearings = {};
  String _cancelReason = '';
  YandexMapController? _controller;
  late PermissionStatus permission;
  Location location = Location();
  bool _locationDenied = false;
  bool _isLoading = false;
  Point _center = const Point(latitude: 41.2995, longitude: 69.2401);
  dynamic pinLocationIcon;
  dynamic pinLocationIcon2;
  dynamic animationController;
  bool _ontripBottom = false;
  bool _cancelling = false;
  bool _choosePayment = false;
  String _cancelCustomReason = '';
  dynamic timers;
  bool _bottomChooseMethod = false;
  bool _dateTimePicker = false;
  bool _rideLaterSuccess = false;
  bool _confirmRideLater = false;
  bool showSos = false;
  bool notifyCompleted = false;
  bool _showInfo = false;
  dynamic _showInfoInt;
  dynamic _dist;
  String _cancellingError = '';
  GlobalKey iconKey = GlobalKey();
  GlobalKey iconDropKey = GlobalKey();

  final _mapMarkerSC = StreamController<List<PlacemarkMapObject>>();

  StreamSink<List<PlacemarkMapObject>> get _mapMarkerSink =>
      _mapMarkerSC.sink;

  Stream<List<PlacemarkMapObject>> get mapMarkerStream =>
      _mapMarkerSC.stream;

  // final _distSC = StreamController();
  // // StreamSink get _distSCSink => _distSC.sink;
  // Stream get distSinc => _distSC.stream;

  @override
  void initState() {
    initBookingConfirmationState();
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    onBookingConfirmationLifecycle(state);
  }

  @override
  void dispose() {
    disposeBookingConfirmationState();
    super.dispose();
  }

  void _updateState(VoidCallback fn) {
    setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return buildBookingConfirmationView(context);
  }

}
