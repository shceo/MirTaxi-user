import 'package:yandex_mapkit/yandex_mapkit.dart';

import '../../data/models/address_list.dart';

// Global shared state used across services and views.

// Auth/profile
String name = '';
String email = '';
dynamic proImageFile1;
dynamic referralCode;
dynamic imageFile;
double review = 0.0;
String feedback = '';
int complaintType = 0;
String complaintDesc = '';
dynamic selectedHistory;

// Map/location
Point center = const Point(latitude: 41.4219057, longitude: -102.0840772);
Point? currentLocation;
String mapStyle = '';
List<PlacemarkMapObject> myMarkers = [];
List<AddressList> addressList = <AddressList>[];
String dropAddressConfirmation = '';
String favSelectedAddress = '';
String favName = 'Home';
String favNameText = '';
bool requestCancelledByDriver = false;
bool cancelRequestByUser = false;
bool logout = false;
bool deleteAccount = false;

// Booking
bool serviceNotAvailable = false;
String promoCode = '';
dynamic promoStatus;
dynamic choosenVehicle;
int payingVia = 0;
dynamic choosenDateTime;
bool noDriverFound = false;
bool tripReqError = false;
List rentalOption = [];
int rentalChoosenOption = 0;
dynamic mapPadding = 0.0;
