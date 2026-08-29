import 'dart:convert';

import 'dart:io';
import 'dart:math' as math;
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:tagyourtaxi_driver/src/core/services/api_provider.dart';
import 'package:tagyourtaxi_driver/src/core/services/app_state.dart';
import 'package:tagyourtaxi_driver/src/data/models/address_list.dart';
import 'package:tagyourtaxi_driver/src/data/models/http_result.dart';
import 'package:tagyourtaxi_driver/src/data/models/last_address_model.dart';

// import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:url_launcher/url_launcher.dart';

//languages code
dynamic phcode;
dynamic platform;
dynamic fcm;
dynamic pref;
String isActive = '';
double duration = 30.0;
var audio = 'audio/notification_sound.mp3';
bool internet = true;
List<AddressModel> lastAddress = [];

// Логирование только в debug-сборке. debugPrint в release не вырезается,
// а сюда уходят тела HTTP-ответов, в том числе с токенами.
void logDebug(Object? message) {
  if (kDebugMode) {
    debugPrint(message.toString());
  }
}

//base url
// Base API URL — must match the driver app, otherwise заявки уходят на другой бэкенд.
// Переопределяется без правки кода:
//   flutter build apk --dart-define=API_BASE_URL=https://...
String url = const String.fromEnvironment('API_BASE_URL',
    defaultValue: 'https://uzch.uz/'); //обязательно '/' в конце
// Ключи карт задаются нативно: Android — meta-data манифеста, iOS — Info.plist.

bool _hasConnection(dynamic result) {
  if (result is List<ConnectivityResult>) {
    return !result.contains(ConnectivityResult.none);
  }
  if (result is ConnectivityResult) {
    return result != ConnectivityResult.none;
  }
  return false;
}

//check internet connection

checkInternetConnection() {
  Connectivity().onConnectivityChanged.listen((connectionState) {
    internet = _hasConnection(connectionState);
    valueNotifierHome.incrementNotifier();
    valueNotifierBook.incrementNotifier();
  });
}

// void printWrapped(String text) {
//   final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
//   pattern.allMatches(text).forEach((match) => logDebug(match.group(0)));
// }

getDetailsOfDevice() async {
  var connectivityResult = await Connectivity().checkConnectivity();
  internet = _hasConnection(connectivityResult);
  try {
    mapStyle = '';
    var token = await FirebaseMessaging.instance.getToken();
    fcm = token;
    pref = await SharedPreferences.getInstance();
  } catch (e) {
    logDebug('FCM token unavailable: $e');
    if (e is SocketException) {
      internet = false;
    }
  }
  pref ??= await SharedPreferences.getInstance();

  // Бэкенд требует device_token обязательным полем при логине. Если FCM-токен
  // получить не удалось (симулятор без APNs, отказ от уведомлений, отсутствие
  // Play Services), запрос уходил с null и логин падал с 422 — пользователь
  // видел «неверный код», хотя код был верный.
  //
  // В debug подставляем стабильный локальный идентификатор, чтобы можно было
  // тестировать. В release этого не делаем: там нужно, чтобы бэкенд разрешил
  // device_token быть пустым, иначе часть пользователей не сможет войти вообще.
  if ((fcm == null || fcm.toString().isEmpty) && kDebugMode) {
    var stub = pref.getString('debug_device_token');
    if (stub == null || stub.toString().isEmpty) {
      stub = 'debug-no-fcm-${const Uuid().v4()}';
      await pref.setString('debug_device_token', stub);
    }
    fcm = stub;
    logDebug('device_token подставлен заглушкой для отладки: $stub');
  }
}

dynamic timerLocation;
dynamic locationAllowed;
//get current location
getCurrentLocation() {
  timerLocation = Timer.periodic(const Duration(seconds: 5), (timer) async {
    var serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (serviceEnabled == true && locationAllowed == true) {
      var loc = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.medium);

      currentLocation = Point(latitude: loc.latitude, longitude: loc.longitude);
    } else {
      timer.cancel();
      timerLocation = null;
    }
  });
}

//validate email already exist

validateEmail() async {
  dynamic result;
  try {
    var response = await http.post(
        Uri.parse('${url}api/v1/user/validate-mobile'),
        body: {'email': email});
    if (response.statusCode == 200) {
      if (jsonDecode(response.body)['success'] == true) {
        result = 'success';
      } else {
        logDebug(response.body);
        result = 'failed';
      }
    } else if (response.statusCode == 422) {
      logDebug(response.body);
      var error = jsonDecode(response.body)['errors'];
      result = error[error.keys.toList()[0]]
          .toString()
          .replaceAll('[', '')
          .replaceAll(']', '')
          .toString();
    } else {
      logDebug(response.body);
      result = jsonDecode(response.body)['message'];
    }
    return result;
  } catch (e) {
    if (e is SocketException) {
      internet = false;
    }
  }
}

getLastAddress() async {
  try {
    HttpResult response = await ApiProvider()
        .getRequest('${url}api/v1/user/latest-addresses?limit=10');
    if (response.isSuccess) {
      lastAddress = LastAddressModel.fromJson(response.result).data;
      valueNotifierHome.incrementNotifier();
    }
  } catch (e) {
    if (e is SocketException) {
      internet = false;
    }
  }
}

//language code
var choosenLanguage = '';
var languageDirection = '';
String phnumber = '';
// UUID returned by `send-otp`. Some backends require it when calling `verify-otp`.
String otpUuid = '';

List languagesCode = [
  {'name': 'English', 'code': 'en'},
  {'name': 'Russian', 'code': 'ru'},
  {'name': 'Uzbek', 'code': 'uz'},
];

ValueNotifier<Locale?> localeNotifier =
    ValueNotifier<Locale?>(const Locale('en'));

bool _isRtlLanguage(String code) =>
    code == 'ar' || code == 'ur' || code == 'iw';

void updateAppLanguage(String code) {
  choosenLanguage = code;
  languageDirection = _isRtlLanguage(code) ? 'rtl' : 'ltr';
  localeNotifier.value = Locale(code);
  pref?.setString('languageDirection', languageDirection);
  pref?.setString('choosenLanguage', choosenLanguage);
}

//getting country code

List countries = [];

getCountryCode() async {
  dynamic result;
  try {
    final response = await http.get(Uri.parse('${url}api/v1/countries'));

    if (response.statusCode == 200) {
      countries = jsonDecode(response.body)['data'];
      phcode = (countries
              .where((element) => element['dial_code'] == '+998')
              .isNotEmpty)
          ? countries.indexWhere((element) => element['dial_code'] == '+998')
          : 0;
      result = 'success';
    } else {
      logDebug(response.body);
      result = 'error';
    }
  } catch (e) {
    if (e is SocketException) {
      internet = false;
      result = 'no internet';
    }
  }
  return result;
}

//login firebase

String userUid = '';
var verId = '';
int? resendTokenId;
bool phoneAuthCheck = false;
dynamic credentials;

phoneAuth(String phone) async {
  try {
    credentials = null;
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: (PhoneAuthCredential credential) async {
        credentials = credential;
        valueNotifierHome.incrementNotifier();
      },
      forceResendingToken: resendTokenId,
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          logDebug('The provided phone number is not valid.');
        }
      },
      codeSent: (String verificationId, int? resendToken) async {
        verId = verificationId;
        resendTokenId = resendToken;
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  } catch (e) {
    if (e is SocketException) {
      internet = false;
    }
  }
}

//get local bearer token

getLocalData() async {
  dynamic result;
  bearerToken.clear();
  var connectivityResult = await Connectivity().checkConnectivity();
  internet = _hasConnection(connectivityResult);
  try {
    choosenLanguage = pref.getString('choosenLanguage') ?? '';
    languageDirection = pref.getString('languageDirection') ??
        (_isRtlLanguage(choosenLanguage) ? 'rtl' : 'ltr');
    localeNotifier.value =
        Locale(choosenLanguage.isNotEmpty ? choosenLanguage : 'en');

    if (choosenLanguage.isNotEmpty) {
      if (pref.containsKey('Bearer')) {
        var tokens = pref.getString('Bearer');
        if (tokens != null) {
          bearerToken.add(BearerClass(type: 'Bearer', token: tokens));

          var responce = await getUserDetails();
          if (responce == true) {
            result = '3';
          } else if (responce == false) {
            result = '2';
          }
        } else {
          result = '2';
        }
      } else {
        result = '2';
      }
    } else {
      result = '1';
    }
  } catch (e) {
    if (e is SocketException) {
      result = 'no internet';
      internet = false;
    }
  }
  return result;
}

//register user

List<BearerClass> bearerToken = <BearerClass>[];

registerUser() async {
  bearerToken.clear();
  dynamic result;
  try {
    final response =
        http.MultipartRequest('POST', Uri.parse('${url}api/v1/user/register'));
    response.headers.addAll({'Content-Type': 'application/json'});
    if (proImageFile1 != null) {
      response.files.add(
          await http.MultipartFile.fromPath('profile_picture', proImageFile1));
    }
    response.fields.addAll({
      "name": name,
      "mobile": phnumber,
      "email": email,
      "device_token": fcm,
      "country": countries[phcode]['code'],
      "login_by": (platform == TargetPlatform.android) ? 'android' : 'ios',
      'lang': choosenLanguage,
    });

    var request = await response.send();
    var respon = await http.Response.fromStream(request);

    if (respon.statusCode == 200) {
      var jsonVal = jsonDecode(respon.body);

      bearerToken.add(BearerClass(
          type: jsonVal['token_type'].toString(),
          token: jsonVal['access_token'].toString()));
      pref.setString('Bearer', authToken);
      await getUserDetails();
      result = 'true';
    } else if (respon.statusCode == 422) {
      logDebug(respon.body);
      var error = jsonDecode(respon.body)['errors'];
      result = error[error.keys.toList()[0]]
          .toString()
          .replaceAll('[', '')
          .replaceAll(']', '')
          .toString();
    } else {
      logDebug(respon.body);
      result = jsonDecode(respon.body)['message'];
    }
    return result;
  } catch (e) {
    if (e is SocketException) {
      internet = false;
    }
  }
}

//update referral code

updateReferral() async {
  dynamic result;
  try {
    var response =
        await http.post(Uri.parse('${url}api/v1/update/user/referral'),
            headers: {
              'Authorization': 'Bearer $authToken',
              'Content-Type': 'application/json'
            },
            body: jsonEncode({"refferal_code": referralCode}));
    if (response.statusCode == 200) {
      if (jsonDecode(response.body)['success'] == true) {
        result = 'true';
      } else {
        logDebug(response.body);
        result = 'false';
      }
    } else {
      logDebug(response.body);
      result = 'false';
    }
    return result;
  } catch (e) {
    if (e is SocketException) {
      internet = false;
    }
  }
}

//call firebase otp

Future<HttpResult> otpCall(String number) async {
  try {
    // Reset UUID on each new OTP request.
    otpUuid = '';
    var data = {'mobile': number, 'role': 'user'};
    HttpResult result = await ApiProvider()
        .postRequest('${url}api/v1/user/login/send-otp', data);

    // Persist uuid for the subsequent `verify-otp` call.
    try {
      final res = result.result;
      if (result.isSuccess && res is Map) {
        final data = res['data'];
        if (data is Map && data['uuid'] != null) {
          otpUuid = data['uuid'].toString();
        }
      }
    } catch (_) {
      // Ignore parsing issues; fallback to verifying without uuid.
    }

    return result;
  } catch (e) {
    if (e is SocketException) {
      internet = false;
      valueNotifierHome.incrementNotifier();
    }
  }
  return HttpResult(isSuccess: false, result: 1, status: 1);
}

//request notification
List notificationHistory = [];
Map<String, dynamic> notificationHistoryPage = {};

getnotificationHistory() async {
  dynamic result;

  try {
    var response = await http.get(
        Uri.parse('${url}api/v1/notifications/get-notification'),
        headers: {'Authorization': 'Bearer $authToken'});
    if (response.statusCode == 200) {
      notificationHistory = jsonDecode(response.body)['data'];
      notificationHistoryPage = jsonDecode(response.body)['meta'];
      result = 'success';
      valueNotifierHome.incrementNotifier();
    } else {
      logDebug(response.body);
      result = 'failure';
      valueNotifierHome.incrementNotifier();
    }
  } catch (e) {
    if (e is SocketException) {
      result = 'no internet';

      internet = false;
      valueNotifierHome.incrementNotifier();
    }
  }
  return result;
}

//delete notification
deleteNotification(id) async {
  dynamic result;

  try {
    var response = await http.get(
        Uri.parse('${url}api/v1/notifications/delete-notification/$id'),
        headers: {'Authorization': 'Bearer $authToken'});
    if (response.statusCode == 200) {
      // notificationHistory = jsonDecode(response.body)['data'];
      // notificationHistoryPage = jsonDecode(response.body)['meta'];
      result = 'success';
      valueNotifierHome.incrementNotifier();
    } else {
      logDebug(response.body);
      result = 'failure';
      valueNotifierHome.incrementNotifier();
    }
  } catch (e) {
    if (e is SocketException) {
      result = 'no internet';

      internet = false;
      valueNotifierHome.incrementNotifier();
    }
  }
  return result;
}

sharewalletfun({mobile, role, amount}) async {
  dynamic result;
  try {
    var response = await http.post(
        Uri.parse('${url}api/v1/payment/wallet/transfer-money-from-wallet'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: jsonEncode({'mobile': mobile, 'role': role, 'amount': amount}));
    if (response.statusCode == 200) {
      if (jsonDecode(response.body)['success'] == true) {
        result = 'success';
      } else {
        logDebug(response.body);
        result = 'failed';
      }
    } else {
      logDebug(response.body);
      result = jsonDecode(response.body)['message'];
    }
  } catch (e) {
    if (e is SocketException) {
      internet = false;
      result = 'no internet';
    }
  }
  return result;
}
// verify user already exist

Future<HttpResult> verifyNumber(String number, String code) async {
  try {
    final data = <String, dynamic>{
      'mobile': number,
      'code': code,
      'role': 'user',
      if (otpUuid.isNotEmpty) 'uuid': otpUuid,
    };
    HttpResult result = await ApiProvider()
        .postRequest('${url}api/v1/user/login/verify-otp', data);
    return result;
  } catch (e) {
    if (e is SocketException) {
      internet = false;
      valueNotifierHome.incrementNotifier();
    }
  }
  return HttpResult(isSuccess: false, result: 1, status: 1);
}

Future<bool?> validateMobileForLogin(String number) async {
  try {
    var response = await http.post(
      Uri.parse('${url}api/v1/user/validate-mobile-for-login'),
      body: {"mobile": number},
    );

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final success = decoded['success'];
      if (success is bool) {
        return success;
      }
      return success?.toString().toLowerCase() == 'true';
    }

    logDebug(response.body);
    return null;
  } catch (e) {
    if (e is SocketException) {
      internet = false;
    }
  }
  return null;
}

verifyUser(String number) async {
  dynamic val;
  try {
    val = await validateMobileForLogin(number);

    if (val == true) {
      var check = await userLogin();
      if (check == true) {
        var uCheck = await getUserDetails();
        val = uCheck;
      } else {
        val = check;
      }
    } else if (val == false) {
      val = false;
    } else {
      val = false;
    }
    return val;
  } catch (e) {
    if (e is SocketException) {
      internet = false;
    }
  }
}

sendTask(
    String name, String number, String photo, String desc, int type) async {
  var request = http.MultipartRequest(
      'POST', Uri.parse('${url}api/v1/request/applications'));

  request.files.add(await http.MultipartFile.fromPath("image", photo));
  request.fields.addAll({'name': name});
  request.fields.addAll({'mobile': number});
  request.fields.addAll({'type': type.toString()});
  request.fields.addAll({'description': desc});
  return await ApiProvider().postMultiRequest(request);
}

//user login
userLogin() async {
  bearerToken.clear();
  dynamic result;
  try {
    var response = await http.post(Uri.parse('${url}api/v1/user/login'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "mobile": phnumber,
          'device_token': fcm,
          "login_by": (platform == TargetPlatform.android) ? 'android' : 'ios',
        }));
    if (response.statusCode == 200) {
      var jsonVal = jsonDecode(response.body);
      bearerToken.add(BearerClass(
          type: jsonVal['token_type'].toString(),
          token: jsonVal['access_token'].toString()));
      result = true;
      pref.setString('Bearer', authToken);
    } else if (response.statusCode == 422) {
      logDebug(response.body);
      var error = jsonDecode(response.body)['errors'];
      result = error[error.keys.toList()[0]]
          .toString()
          .replaceAll('[', '')
          .replaceAll(']', '')
          .toString();
    } else {
      logDebug(response.body);
      result = false;
    }
    return result;
  } catch (e) {
    if (e is SocketException) {
      internet = false;
    }
  }
}

Map<String, dynamic> userDetails = {};
List favAddress = [];

//user current state
getUserDetails() async {
  dynamic result;
  try {
    var response = await http.get(
      Uri.parse('${url}api/v1/user'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken'
      },
    );
    if (response.statusCode == 200) {
      userDetails =
          Map<String, dynamic>.from(jsonDecode(response.body)['data']);
      if (userDetails['notifications_count'] != 0 &&
          userDetails['notifications_count'] != null) {
        valueNotifierNotification.incrementNotifier();
      }
      favAddress = userDetails['favouriteLocations']['data'];
      sosData = userDetails['sos']['data'];
      if (userDetails['onTripRequest'] != null) {
        if (userRequestData != userDetails['onTripRequest']['data']) {
          audioPlayers.play(AssetSource(audio));
        }
        userRequestData = userDetails['onTripRequest']['data'];
        if (userRequestData['accepted_at'] != null) {
          getCurrentMessages();
        }

        if (userRequestData['is_completed'] == 0) {
          if (rideStreamUpdate == null ||
              rideStreamUpdate?.isPaused == true ||
              rideStreamStart == null ||
              rideStreamStart?.isPaused == true) {
            streamRide();
          }
        } else {
          if (rideStreamUpdate != null ||
              rideStreamUpdate?.isPaused == false ||
              rideStreamStart != null ||
              rideStreamStart?.isPaused == false) {
            rideStreamUpdate?.cancel();
            rideStreamUpdate = null;
            rideStreamStart?.cancel();
            rideStreamStart = null;
          }
        }
        valueNotifierHome.incrementNotifier();
        valueNotifierBook.incrementNotifier();
      } else if (userDetails['metaRequest'] != null) {
        userRequestData = userDetails['metaRequest']['data'];
        addressList.add(
          AddressList(
              id: 'pickup',
              address: userRequestData['pick_address'],
              latlng: Point(
                  latitude: userRequestData['pick_lat'],
                  longitude: userRequestData['pick_lng'])),
        );
        if (userRequestData['drop_address'] != null) {
          addressList.add(
            AddressList(
                id: 'drop',
                address: userRequestData['drop_address'],
                latlng: Point(
                    latitude: userRequestData['drop_lat'],
                    longitude: userRequestData['drop_lng'])),
          );
        }

        if (requestStreamStart == null ||
            requestStreamStart?.isPaused == true ||
            requestStreamEnd == null ||
            requestStreamEnd?.isPaused == true) {
          streamRequest();
        }
        valueNotifierHome.incrementNotifier();
        valueNotifierBook.incrementNotifier();
      } else {
        if (userRequestData.isNotEmpty) {
          audioPlayers.play(AssetSource(audio));
        }
        chatList.clear();
        userRequestData = {};
        requestStreamStart?.cancel();
        requestStreamEnd?.cancel();
        rideStreamUpdate?.cancel();
        rideStreamStart?.cancel();
        requestStreamEnd = null;
        requestStreamStart = null;
        rideStreamUpdate = null;
        rideStreamStart = null;
        valueNotifierHome.incrementNotifier();
        valueNotifierBook.incrementNotifier();
      }
      if (userDetails['active'] == false) {
        isActive = 'false';
      } else {
        isActive = 'true';
      }
      result = true;
    } else {
      logDebug(response.body);
      result = false;
    }
  } catch (e) {
    if (e is SocketException) {
      internet = false;
    }
  }
  return result;
}

/// Безопасный доступ к токену. Обращение по индексу `bearerToken[0]` кидало
/// RangeError в каждом запросе, если список пуст (сессия сброшена, а экран
/// ещё жив и продолжает дергать API).
String get authToken => bearerToken.isNotEmpty ? bearerToken.first.token : '';

/// Взводится при 401 — UI по нему уводит пользователя на экран входа.
bool sessionExpired = false;

/// Локальный сброс сессии при 401. Дергать logout бессмысленно: токен уже
/// недействителен. Раньше 401 просто возвращался наверх, и пользователь
/// оставался в приложении с молча пустыми экранами.
void handleUnauthorized() {
  if (sessionExpired) return;
  sessionExpired = true;

  requestStreamStart?.cancel();
  requestStreamEnd?.cancel();
  rideStreamStart?.cancel();
  rideStreamUpdate?.cancel();
  requestStreamStart = null;
  requestStreamEnd = null;
  rideStreamStart = null;
  rideStreamUpdate = null;

  bearerToken.clear();
  userDetails.clear();
  userRequestData.clear();
  try {
    pref?.remove('Bearer');
  } catch (_) {
    // pref мог быть ещё не инициализирован — не критично.
  }
  valueNotifierHome.incrementNotifier();
}

class BearerClass {
  final String type;
  final String token;

  BearerClass({required this.type, required this.token});

  BearerClass.fromJson(Map<String, dynamic> json)
      : type = json['type'],
        token = json['token'];

  Map<String, dynamic> toJson() => {'type': type, 'token': token};
}

Map<String, dynamic> driverReq = {};

class ValueNotifying {
  ValueNotifier value = ValueNotifier(0);

  void incrementNotifier() {
    value.value++;
  }
}

ValueNotifying valueNotifier = ValueNotifying();

class ValueNotifyingHome {
  ValueNotifier value = ValueNotifier(0);

  void incrementNotifier() {
    value.value++;
  }
}

class ValueNotifyingNotification {
  ValueNotifier value = ValueNotifier(0);

  void incrementNotifier() {
    value.value++;
  }
}

ValueNotifyingHome valueNotifierHome = ValueNotifyingHome();
ValueNotifyingNotification valueNotifierNotification =
    ValueNotifyingNotification();

class ValueNotifyingBook {
  ValueNotifier value = ValueNotifier(0);

  void incrementNotifier() {
    value.value++;
  }
}

ValueNotifyingBook valueNotifierBook = ValueNotifyingBook();

//sound
AudioCache audioPlayer = AudioCache();
AudioPlayer audioPlayers = AudioPlayer();

//get reverse geo coding

var pickupAddress = '';
var dropAddress = '';

BoundingBox _suggestBoundingBox(Point centerPoint, {double delta = 0.2}) {
  return BoundingBox(
    southWest: Point(
      latitude: centerPoint.latitude - delta,
      longitude: centerPoint.longitude - delta,
    ),
    northEast: Point(
      latitude: centerPoint.latitude + delta,
      longitude: centerPoint.longitude + delta,
    ),
  );
}

Point? _firstPointFromGeometry(List<Geometry>? geometries) {
  if (geometries == null) {
    return null;
  }
  for (final geometry in geometries) {
    if (geometry.point != null) {
      return geometry.point;
    }
  }
  return null;
}

geoCoding(double lat, double lng) async {
  dynamic result;
  try {
    final (session, resultFuture) = await YandexSearch.searchByPoint(
      point: Point(latitude: lat, longitude: lng),
      searchOptions: const SearchOptions(
        searchType: SearchType.geo,
        resultPageSize: 1,
      ),
    );
    final response = await resultFuture;
    await session.close();
    if (response.items != null && response.items!.isNotEmpty) {
      final item = response.items!.first;
      result = item.toponymMetadata?.address.formattedAddress ?? item.name;
    } else {
      result = '';
    }
  } catch (e) {
    if (e is SocketException) {
      internet = false;
      result = 'no internet';
    }
  }
  return result;
}

//lang
getlangid() async {
  dynamic result;
  try {
    var response = await http
        .post(Uri.parse('${url}api/v1/user/update-my-lang'), headers: {
      'Authorization': 'Bearer $authToken',
    }, body: {
      'lang': choosenLanguage,
    });
    if (response.statusCode == 200) {
      if (jsonDecode(response.body)['success'] == true) {
        result = 'success';
      } else {
        logDebug(response.body);
        result = 'failed';
      }
    } else if (response.statusCode == 422) {
      logDebug(response.body);
      var error = jsonDecode(response.body)['errors'];
      result = error[error.keys.toList()[0]]
          .toString()
          .replaceAll('[', '')
          .replaceAll(']', '')
          .toString();
    } else {
      logDebug(response.body);
      result = jsonDecode(response.body)['message'];
    }
  } catch (e) {
    if (e is SocketException) {
      internet = false;
      result = 'no internet';
    }
  }
  return result;
}

//get address auto fill data

List addAutoFill = [];

int _autoAddressRequestId = 0;
String _autoAddressLastQuery = '';

getAutoAddress(input, sessionToken, lat, lng) async {
  final query = input?.toString().trim() ?? '';
  if (query.isEmpty) {
    addAutoFill.clear();
    valueNotifierHome.incrementNotifier();
    return;
  }
  _autoAddressLastQuery = query;
  final requestId = ++_autoAddressRequestId;
  try {
    final centerPoint = Point(latitude: lat, longitude: lng);
    final bounds = _suggestBoundingBox(centerPoint);
    final (session, resultFuture) = await YandexSuggest.getSuggestions(
      text: query,
      boundingBox: bounds,
      suggestOptions: SuggestOptions(
        // Let the backend decide the best suggestion types (geo/biz/transit).
        suggestType: SuggestType.unspecified,
        userPosition: centerPoint,
      ),
    );
    final response = await resultFuture;
    await session.close();
    if (requestId != _autoAddressRequestId || query != _autoAddressLastQuery) {
      // A newer request completed while this one was in flight.
      return;
    }
    final items = (response.items ?? [])
        // Transit suggestions are often noisy for taxi address picking.
        .where((item) => item.type != SuggestItemType.transit)
        .toList();

    final seen = <String>{};
    addAutoFill = items
        .map((item) {
          final title = item.title.trim();
          final subtitle = (item.subtitle ?? '').trim();
          final displayText = item.displayText.trim();
          final description = subtitle.isNotEmpty
              ? '$title, $subtitle'
              : (displayText.isNotEmpty ? displayText : title);
          final key = description.toLowerCase();
          if (seen.contains(key)) {
            return null;
          }
          seen.add(key);
          return {
            'title': title.isNotEmpty ? title : displayText,
            'subtitle': subtitle,
            'description': description,
            'place_id': item.center ?? item.searchText,
            'search_text': item.searchText,
            'type': item.type.index,
            'tags': item.tags,
          };
        })
        .whereType<Map>()
        .toList();
    valueNotifierHome.incrementNotifier();
  } catch (e) {
    if (e is SocketException) {
      internet = false;
    }
  }
}

//geocodeing location

geoCodingForLatLng(placeid) async {
  try {
    if (placeid is Point) {
      center = placeid;
      return center;
    }
    final query = placeid?.toString() ?? '';
    if (query.isEmpty) {
      return center;
    }
    final bounds = _suggestBoundingBox(center);
    final (session, resultFuture) = await YandexSearch.searchByText(
      searchText: query,
      geometry: Geometry.fromBoundingBox(bounds),
      searchOptions: const SearchOptions(
        searchType: SearchType.geo,
        geometry: true,
        resultPageSize: 1,
      ),
    );
    final response = await resultFuture;
    await session.close();
    if (response.items != null && response.items!.isNotEmpty) {
      final item = response.items!.first;
      final point = _firstPointFromGeometry(item.geometry) ??
          item.toponymMetadata?.balloonPoint;
      if (point != null) {
        center = point;
      }
    }
    return center;
  } catch (e) {
    if (e is SocketException) {
      internet = false;
    }
  }
}

//pickup drop address list

//get polylines

List<Point> polyList = [];
Polyline? polyline;
Color routeTrafficColor = const Color(0xff34C759);

class RouteSegment {
  const RouteSegment({
    required this.polyline,
    required this.color,
  });

  final Polyline polyline;
  final Color color;
}

List<RouteSegment> routeSegments = [];

int _routeSegmentsBuildToken = 0;

// Clears current route segments and invalidates any in-flight segment builds.
void clearRouteSegments() {
  _routeSegmentsBuildToken++;
  routeSegments.clear();
}

const Color _kRouteGreen = Color(0xff34C759);
const Color _kRouteYellow = Color(0xffFFCC00);
const Color _kRouteRed = Color(0xffFF3B30);

double _degToRad(double deg) => deg * (math.pi / 180.0);

double _bearingDegrees(Point a, Point b) {
  // Initial bearing (azimuth) from A to B in degrees [0..360).
  final lat1 = _degToRad(a.latitude);
  final lat2 = _degToRad(b.latitude);
  final dLon = _degToRad(b.longitude - a.longitude);

  final y = math.sin(dLon) * math.cos(lat2);
  final x = math.cos(lat1) * math.sin(lat2) -
      math.sin(lat1) * math.cos(lat2) * math.cos(dLon);
  final brng = math.atan2(y, x) * (180.0 / math.pi);
  return (brng + 360.0) % 360.0;
}

double _distanceMeters(Point a, Point b) {
  // Haversine formula (good enough for segmenting the route).
  const earthRadius = 6371000.0;
  final lat1 = _degToRad(a.latitude);
  final lat2 = _degToRad(b.latitude);
  final dLat = lat2 - lat1;
  final dLon = _degToRad(b.longitude - a.longitude);

  final sinDLat = math.sin(dLat / 2.0);
  final sinDLon = math.sin(dLon / 2.0);
  final h = sinDLat * sinDLat +
      math.cos(lat1) * math.cos(lat2) * sinDLon * sinDLon;

  return 2.0 * earthRadius * math.asin(math.min(1.0, math.sqrt(h)));
}

List<double> _buildCumulativeDistance(List<Point> points) {
  final cum = List<double>.filled(points.length, 0.0);
  for (var i = 1; i < points.length; i++) {
    cum[i] = cum[i - 1] + _distanceMeters(points[i - 1], points[i]);
  }
  return cum;
}

int _lowerBound(List<double> arr, double target) {
  var lo = 0;
  var hi = arr.length;
  while (lo < hi) {
    final mid = lo + ((hi - lo) >> 1);
    if (arr[mid] < target) {
      lo = mid + 1;
    } else {
      hi = mid;
    }
  }
  return lo;
}

int _segmentCountForDistance(double totalMeters) {
  if (totalMeters <= 0) return 0;
  // More segments = more точная раскраска, but also more routing requests.
  // Target: ~500m per segment; clamp to keep performance reasonable.
  final count = (totalMeters / 500.0).ceil();
  return count.clamp(8, 30);
}

Color _segmentTrafficColorFromWeight({
  required double? time,
  required double? timeWithTraffic,
  required double segmentMeters,
}) {
  // More sensitive than the whole-route thresholds: we want per-segment colors.
  // Note: slowdown ratio is noisy on very short segments, so we mainly use delay/km.
  if (time == null ||
      timeWithTraffic == null ||
      time <= 0 ||
      timeWithTraffic <= 0 ||
      segmentMeters <= 0) {
    return _kRouteGreen;
  }

  final delay = timeWithTraffic - time; // seconds (SI)
  if (delay <= 0) return _kRouteGreen;

  final km = segmentMeters / 1000.0;
  final delayPerKm = (km >= 0.2) ? (delay / km) : (delay / 0.2);
  final slowdown = timeWithTraffic / time; // >= 1.0 (can be noisy on small time)

  // Red: heavy traffic on this part of the route.
  if (delayPerKm >= 120 || delay >= 60 || (time >= 180 && slowdown >= 1.25)) {
    return _kRouteRed;
  }

  // Yellow: noticeable slowdown.
  if (delayPerKm >= 35 || delay >= 20 || (time >= 180 && slowdown >= 1.10)) {
    return _kRouteYellow;
  }

  return _kRouteGreen;
}

Future<(double? time, double? timeWithTraffic)> _requestSegmentTimes({
  required Point start,
  required Point end,
  List<Point> viaPoints = const [],
  double? initialAzimuth,
}) async {
  DrivingSession? session;
  try {
    final points = <RequestPoint>[
      RequestPoint(point: start, requestPointType: RequestPointType.wayPoint),
      ...viaPoints.map(
        (p) => RequestPoint(point: p, requestPointType: RequestPointType.viaPoint),
      ),
      RequestPoint(point: end, requestPointType: RequestPointType.wayPoint),
    ];

    final (createdSession, resultFuture) = await YandexDriving.requestRoutes(
      points: points,
      drivingOptions: DrivingOptions(routesCount: 1, initialAzimuth: initialAzimuth),
    );
    session = createdSession;
    final response = await resultFuture;

    final route = (response.routes != null && response.routes!.isNotEmpty)
        ? response.routes!.first
        : null;
    if (route == null) return (null, null);

    final weight = route.metadata.weight;
    return (weight.time.value, weight.timeWithTraffic.value);
  } catch (e) {
    if (e is SocketException) {
      internet = false;
    }
    return (null, null);
  } finally {
    try {
      await session?.close();
    } catch (_) {}
  }
}

Future<List<RouteSegment>> _buildTrafficSegmentsFromRoutePoints(List<Point> points) async {
  if (points.length < 2) return const [];

  final cum = _buildCumulativeDistance(points);
  final total = cum.last;
  final segmentCount = _segmentCountForDistance(total);
  if (segmentCount <= 0) return const [];

  // Choose split indices by distance so segments are roughly equal-length.
  final split = <int>[0];
  for (var s = 1; s < segmentCount; s++) {
    final target = total * (s / segmentCount);
    var idx = _lowerBound(cum, target);
    if (idx <= split.last) {
      idx = split.last + 1;
    }
    if (idx >= points.length - 1) {
      break;
    }
    split.add(idx);
  }
  if (split.last != points.length - 1) {
    split.add(points.length - 1);
  }

  // Build segment definitions first so we can fetch timings concurrently.
  final segmentPointsList = <List<Point>>[];
  final segmentMetersList = <double>[];
  for (var i = 0; i < split.length - 1; i++) {
    final startIdx = split[i];
    final endIdx = split[i + 1];
    if (endIdx - startIdx < 1) continue;

    segmentPointsList.add(points.sublist(startIdx, endIdx + 1));
    segmentMetersList.add(cum[endIdx] - cum[startIdx]);
  }
  if (segmentPointsList.isEmpty) return const [];

  List<Point> pickViaPoints(List<Point> segmentPoints) {
    if (segmentPoints.length < 3) return const [];
    if (segmentPoints.length < 7) {
      return <Point>[segmentPoints[segmentPoints.length ~/ 2]];
    }
    final idxs = <int>{
      segmentPoints.length ~/ 4,
      segmentPoints.length ~/ 2,
      (segmentPoints.length * 3) ~/ 4,
    };
    idxs.remove(0);
    idxs.remove(segmentPoints.length - 1);
    final sorted = idxs.toList()..sort();
    return <Point>[for (final idx in sorted) segmentPoints[idx]];
  }

  final results = List<RouteSegment?>.filled(segmentPointsList.length, null);
  var cursor = 0;
  const concurrency = 4;

  Future<void> worker() async {
    while (true) {
      final i = cursor++;
      if (i >= segmentPointsList.length) return;

      final segmentPoints = segmentPointsList[i];
      final start = segmentPoints.first;
      final end = segmentPoints.last;
      final initialAzimuth = segmentPoints.length >= 2
          ? _bearingDegrees(segmentPoints[0], segmentPoints[1])
          : null;

      final (time, timeWithTraffic) = await _requestSegmentTimes(
        start: start,
        end: end,
        viaPoints: pickViaPoints(segmentPoints),
        initialAzimuth: initialAzimuth,
      );

      results[i] = RouteSegment(
        polyline: Polyline(points: segmentPoints),
        color: _segmentTrafficColorFromWeight(
          time: time,
          timeWithTraffic: timeWithTraffic,
          segmentMeters: segmentMetersList[i],
        ),
      );
    }
  }

  await Future.wait(
    List.generate(
      math.min(concurrency, segmentPointsList.length),
      (_) => worker(),
    ),
  );

  return results.whereType<RouteSegment>().toList();
}

Color _routeTrafficColorFromWeight(double? time, double? timeWithTraffic) {
  // If we can't calculate traffic delay, keep route green.
  if (time == null || timeWithTraffic == null || time <= 0) {
    return _kRouteGreen;
  }

  final delay = timeWithTraffic - time;
  if (delay <= 0) {
    return _kRouteGreen;
  }

  // MapKit returns durations in SI units (seconds). We map traffic to a single
  // route color (green/yellow/red) since we don't have per-segment jam data.
  //
  // green: < 5 min delay
  // yellow: >= 5 min delay
  // red: > 10 min delay
  if (delay > 600) {
    return _kRouteRed;
  }
  if (delay >= 300) {
    return _kRouteYellow;
  }
  return _kRouteGreen;
}

Future<List<Point>> _buildRoutePoints(Point start, Point end) async {
  DrivingSession? session;
  try {
    final (createdSession, resultFuture) = await YandexDriving.requestRoutes(
      points: [
        RequestPoint(point: start, requestPointType: RequestPointType.wayPoint),
        RequestPoint(point: end, requestPointType: RequestPointType.wayPoint),
      ],
      drivingOptions: const DrivingOptions(routesCount: 1),
    );
    session = createdSession;
    final response = await resultFuture;
    if (response.routes != null && response.routes!.isNotEmpty) {
      final route = response.routes!.first;
      final weight = route.metadata.weight;
      routeTrafficColor = _routeTrafficColorFromWeight(
        weight.time.value,
        weight.timeWithTraffic.value,
      );
      return route.geometry.points;
    }
  } catch (e) {
    if (e is SocketException) {
      internet = false;
    }
  } finally {
    try {
      await session?.close();
    } catch (_) {}
  }
  return [];
}

getPolylines() async {
  polyList.clear();
  polyline = null;
  routeTrafficColor = _kRouteGreen;
  clearRouteSegments();
  final buildToken = _routeSegmentsBuildToken;
  Point? pickPoint;
  Point? dropPoint;
  if (userRequestData.isEmpty) {
    pickPoint =
        addressList.firstWhere((element) => element.id == 'pickup').latlng;
    dropPoint =
        addressList.firstWhere((element) => element.id == 'drop').latlng;
  } else {
    pickPoint = Point(
      latitude: double.parse(userRequestData['pick_lat'].toString()),
      longitude: double.parse(userRequestData['pick_lng'].toString()),
    );
    dropPoint = Point(
      latitude: double.parse(userRequestData['drop_lat'].toString()),
      longitude: double.parse(userRequestData['drop_lng'].toString()),
    );
  }

  final newPolyList = (pickPoint != null && dropPoint != null)
      ? await _buildRoutePoints(pickPoint, dropPoint)
      : <Point>[];

  if (buildToken != _routeSegmentsBuildToken) return newPolyList;

  polyList = newPolyList;
  polyline = polyList.isNotEmpty ? Polyline(points: polyList) : null;

  // Show the route immediately (green), then refine with per-segment traffic.
  if (polyline != null) {
    routeSegments = <RouteSegment>[
      RouteSegment(polyline: polyline!, color: _kRouteGreen),
    ];
  }
  valueNotifierBook.incrementNotifier();

  if (polyList.isEmpty) return polyList;

  final detailedSegments = await _buildTrafficSegmentsFromRoutePoints(polyList);
  if (buildToken != _routeSegmentsBuildToken) return polyList;

  if (detailedSegments.isNotEmpty) {
    routeSegments = detailedSegments;
  } else if (polyline != null) {
    // Fallback to whole-route traffic if we failed to split.
    routeSegments = <RouteSegment>[
      RouteSegment(polyline: polyline!, color: routeTrafficColor),
    ];
  }
  valueNotifierBook.incrementNotifier();
  return polyList;
}

getPolylineshistory({pickLat, pickLng, dropLat, dropLng}) async {
  polyList.clear();
  polyline = null;
  routeTrafficColor = _kRouteGreen;
  clearRouteSegments();
  final buildToken = _routeSegmentsBuildToken;
  final pickPoint = Point(
    latitude: double.parse(pickLat.toString()),
    longitude: double.parse(pickLng.toString()),
  );
  final dropPoint = Point(
    latitude: double.parse(dropLat.toString()),
    longitude: double.parse(dropLng.toString()),
  );
  final newPolyList = await _buildRoutePoints(pickPoint, dropPoint);

  if (buildToken != _routeSegmentsBuildToken) return newPolyList;

  polyList = newPolyList;
  polyline = polyList.isNotEmpty ? Polyline(points: polyList) : null;

  if (polyline != null) {
    routeSegments = <RouteSegment>[
      RouteSegment(polyline: polyline!, color: _kRouteGreen),
    ];
  }
  valueNotifierBook.incrementNotifier();

  if (polyList.isEmpty) return polyList;

  final detailedSegments = await _buildTrafficSegmentsFromRoutePoints(polyList);
  if (buildToken != _routeSegmentsBuildToken) return polyList;

  if (detailedSegments.isNotEmpty) {
    routeSegments = detailedSegments;
  } else if (polyline != null) {
    routeSegments = <RouteSegment>[
      RouteSegment(polyline: polyline!, color: routeTrafficColor),
    ];
  }
  valueNotifierBook.incrementNotifier();
  return polyList;
}

/*
// Google polyline helper (disabled; Yandex routing now in use)
class PointLatLng {
  /// Creates a geographical location specified in degrees [latitude] and
  /// [longitude].
  ///
  const PointLatLng(double latitude, double longitude)
      // ignore: unnecessary_null_comparison
      : assert(latitude != null),
        // ignore: unnecessary_null_comparison
        assert(longitude != null),
        // ignore: unnecessary_this, prefer_initializing_formals
        this.latitude = latitude,
        // ignore: unnecessary_this, prefer_initializing_formals
        this.longitude = longitude;

  /// The latitude in degrees.
  final double latitude;

  /// The longitude in degrees
  final double longitude;

  @override
  String toString() {
    return "lat: $latitude / longitude: $longitude";
  }
}
*/

List etaDetails = [];
var currencyFormat =
    NumberFormat.currency(locale: "en_US", symbol: "", decimalDigits: 0);

//eta request

etaRequest() async {
  dynamic result;
  try {
    var response = await http.post(Uri.parse('${url}api/v1/request/eta'),
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json',
        },
        body: (addressList.where((element) => element.id == 'drop').isNotEmpty)
            ? jsonEncode({
                'pick_lat': (userRequestData.isNotEmpty)
                    ? userRequestData['pick_lat']
                    : addressList
                        .firstWhere((e) => e.id == 'pickup')
                        .latlng
                        .latitude,
                'pick_lng': (userRequestData.isNotEmpty)
                    ? userRequestData['pick_lng']
                    : addressList
                        .firstWhere((e) => e.id == 'pickup')
                        .latlng
                        .longitude,
                'drop_lat': (userRequestData.isNotEmpty)
                    ? userRequestData['drop_lat']
                    : addressList
                        .firstWhere((e) => e.id == 'drop')
                        .latlng
                        .latitude,
                'drop_lng': (userRequestData.isNotEmpty)
                    ? userRequestData['drop_lng']
                    : addressList
                        .firstWhere((e) => e.id == 'drop')
                        .latlng
                        .longitude,
                'ride_type': 1
              })
            : jsonEncode({
                'pick_lat': (userRequestData.isNotEmpty)
                    ? userRequestData['pick_lat']
                    : addressList
                        .firstWhere((e) => e.id == 'pickup')
                        .latlng
                        .latitude,
                'pick_lng': (userRequestData.isNotEmpty)
                    ? userRequestData['pick_lng']
                    : addressList
                        .firstWhere((e) => e.id == 'pickup')
                        .latlng
                        .longitude,
                'ride_type': 1
              }));

    if (response.statusCode == 200) {
      etaDetails = jsonDecode(response.body)['data'];
      choosenVehicle =
          etaDetails.indexWhere((element) => element['is_default'] == true);
      result = true;
      valueNotifierBook.incrementNotifier();
    } else {
      logDebug(response.body);
      if (jsonDecode(response.body)['message'] ==
          "service not available with this location") {
        serviceNotAvailable = true;
      }
      result = false;
    }
    return result;
  } catch (e) {
    if (e is SocketException) {
      internet = false;
    }
  }
}

etaRequestWithPromo() async {
  dynamic result;
  // etaDetails.clear();
  try {
    var response = await http.post(Uri.parse('${url}api/v1/request/eta'),
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'pick_lat':
              addressList.firstWhere((e) => e.id == 'pickup').latlng.latitude,
          'pick_lng':
              addressList.firstWhere((e) => e.id == 'pickup').latlng.longitude,
          'drop_lat':
              addressList.firstWhere((e) => e.id == 'drop').latlng.latitude,
          'drop_lng':
              addressList.firstWhere((e) => e.id == 'drop').latlng.longitude,
          'ride_type': 1,
          'promo_code': promoCode
        }));

    if (response.statusCode == 200) {
      etaDetails = jsonDecode(response.body)['data'];
      promoCode = '';
      promoStatus = 1;
      valueNotifierBook.incrementNotifier();
    } else {
      logDebug(response.body);
      promoStatus = 2;
      promoCode = '';
      valueNotifierBook.incrementNotifier();

      result = false;
    }
    return result;
  } catch (e) {
    if (e is SocketException) {
      internet = false;
    }
  }
}

//rental eta request

rentalEta() async {
  dynamic result;
  try {
    var response = await http.post(
        Uri.parse('${url}api/v1/request/list-packages'),
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'pick_lat': (userRequestData.isNotEmpty)
              ? userRequestData['pick_lat']
              : addressList.firstWhere((e) => e.id == 'pickup').latlng.latitude,
          'pick_lng': (userRequestData.isNotEmpty)
              ? userRequestData['pick_lng']
              : addressList
                  .firstWhere((e) => e.id == 'pickup')
                  .latlng
                  .longitude,
        }));

    if (response.statusCode == 200) {
      etaDetails = jsonDecode(response.body)['data'];
      rentalOption = etaDetails[0]['typesWithPrice']['data'];
      rentalChoosenOption = 0;
      result = true;
      valueNotifierBook.incrementNotifier();
    } else {
      logDebug(response.body);
      result = false;
    }
    return result;
  } catch (e) {
    if (e is SocketException) {
      internet = false;
    }
  }
}

rentalRequestWithPromo() async {
  dynamic result;
  try {
    var response = await http.post(
        Uri.parse('${url}api/v1/request/list-packages'),
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'pick_lat':
              addressList.firstWhere((e) => e.id == 'pickup').latlng.latitude,
          'pick_lng':
              addressList.firstWhere((e) => e.id == 'pickup').latlng.longitude,
          'ride_type': 1,
          'promo_code': promoCode
        }));

    if (response.statusCode == 200) {
      etaDetails = jsonDecode(response.body)['data'];
      rentalOption = etaDetails[0]['typesWithPrice']['data'];
      rentalChoosenOption = 0;
      promoCode = '';
      promoStatus = 1;
      valueNotifierBook.incrementNotifier();
    } else {
      logDebug(response.body);
      promoStatus = 2;
      promoCode = '';
      valueNotifierBook.incrementNotifier();

      result = false;
    }
    return result;
  } catch (e) {
    if (e is SocketException) {
      internet = false;
    }
  }
}

//calculate distance

calculateDistance(lat1, lon1, lat2, lon2) {
  var p = 0.017453292519943295;
  var a = 0.5 -
      math.cos((lat2 - lat1) * p) / 2 +
      math.cos(lat1 * p) *
          math.cos(lat2 * p) *
          (1 - math.cos((lon2 - lon1) * p)) /
          2;
  var val = (12742 * math.asin(math.sqrt(a))) * 1000;
  return val;
}

Map<String, dynamic> userRequestData = {};

//create request

createRequest() async {
  dynamic result;
  try {
    var response = await http.post(Uri.parse('${url}api/v1/request/create'),
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json',
        },
        body: (addressList.where((element) => element.id == 'drop').isNotEmpty)
            ? jsonEncode({
                'pick_lat': addressList
                    .firstWhere((e) => e.id == 'pickup')
                    .latlng
                    .latitude,
                'pick_lng': addressList
                    .firstWhere((e) => e.id == 'pickup')
                    .latlng
                    .longitude,
                'drop_lat': addressList
                    .firstWhere((e) => e.id == 'drop')
                    .latlng
                    .latitude,
                'drop_lng': addressList
                    .firstWhere((e) => e.id == 'drop')
                    .latlng
                    .longitude,
                'vehicle_type': etaDetails[choosenVehicle]['zone_type_id'],
                'ride_type': 1,
                'payment_opt': (etaDetails[choosenVehicle]['payment_type']
                            .toString()
                            .split(',')
                            .toList()[payingVia] ==
                        'card')
                    ? 0
                    : (etaDetails[choosenVehicle]['payment_type']
                                .toString()
                                .split(',')
                                .toList()[payingVia] ==
                            'cash')
                        ? 1
                        : 2,
                'pick_address':
                    addressList.firstWhere((e) => e.id == 'pickup').address,
                'drop_address':
                    addressList.firstWhere((e) => e.id == 'drop').address,
                'request_eta_amount': etaDetails[choosenVehicle]['total']
              })
            : jsonEncode({
                'pick_lat': addressList
                    .firstWhere((e) => e.id == 'pickup')
                    .latlng
                    .latitude,
                'pick_lng': addressList
                    .firstWhere((e) => e.id == 'pickup')
                    .latlng
                    .longitude,

                'vehicle_type': etaDetails[choosenVehicle]['zone_type_id'],
                'ride_type': 1,
                'payment_opt': (etaDetails[choosenVehicle]['payment_type']
                            .toString()
                            .split(',')
                            .toList()[payingVia] ==
                        'card')
                    ? 0
                    : (etaDetails[choosenVehicle]['payment_type']
                                .toString()
                                .split(',')
                                .toList()[payingVia] ==
                            'cash')
                        ? 1
                        : 2,
                'pick_address':
                    addressList.firstWhere((e) => e.id == 'pickup').address,
                // 'drop_address': addressList.firstWhere((e) => e.id == 'drop').address,
                'request_eta_amount': etaDetails[choosenVehicle]['total']
              }));
    if (response.statusCode == 200) {
      userRequestData = jsonDecode(response.body)['data'];
      streamRequest();
      result = 'success';

      valueNotifierBook.incrementNotifier();
    } else {
      logDebug(response.body);
      if (jsonDecode(response.body)['message'] == 'no drivers available') {
        noDriverFound = true;
      } else {
        tripReqError = true;
      }

      result = 'failure';
      valueNotifierBook.incrementNotifier();
    }
  } catch (e) {
    if (e is SocketException) {
      internet = false;
      result = 'no internet';
      valueNotifierBook.incrementNotifier();
    }
  }
  return result;
}

//create request with promo code

createRequestWithPromo() async {
  dynamic result;
  try {
    var response = await http.post(Uri.parse('${url}api/v1/request/create'),
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'pick_lat':
              addressList.firstWhere((e) => e.id == 'pickup').latlng.latitude,
          'pick_lng':
              addressList.firstWhere((e) => e.id == 'pickup').latlng.longitude,
          'drop_lat':
              addressList.firstWhere((e) => e.id == 'drop').latlng.latitude,
          'drop_lng':
              addressList.firstWhere((e) => e.id == 'drop').latlng.longitude,
          'vehicle_type': etaDetails[choosenVehicle]['zone_type_id'],
          'ride_type': 1,
          'payment_opt': (etaDetails[choosenVehicle]['payment_type']
                      .toString()
                      .split(',')
                      .toList()[payingVia] ==
                  'card')
              ? 0
              : (etaDetails[choosenVehicle]['payment_type']
                          .toString()
                          .split(',')
                          .toList()[payingVia] ==
                      'cash')
                  ? 1
                  : 2,
          'pick_address':
              addressList.firstWhere((e) => e.id == 'pickup').address,
          'drop_address': addressList.firstWhere((e) => e.id == 'drop').address,
          'promocode_id': etaDetails[choosenVehicle]['promocode_id'],
          'request_eta_amount': etaDetails[choosenVehicle]['total']
        }));
    if (response.statusCode == 200) {
      userRequestData = jsonDecode(response.body)['data'];
      result = 'success';
      streamRequest();
      valueNotifierBook.incrementNotifier();
    } else {
      logDebug(response.body);
      if (jsonDecode(response.body)['message'] == 'no drivers available') {
        noDriverFound = true;
      } else {
        tripReqError = true;
      }

      result = 'failure';
      valueNotifierBook.incrementNotifier();
    }
  } catch (e) {
    if (e is SocketException) {
      internet = false;
      result = 'no internet';
    }
  }
  return result;
}

//create request

createRequestLater() async {
  dynamic result;
  try {
    var response = await http.post(Uri.parse('${url}api/v1/request/create'),
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'pick_lat':
              addressList.firstWhere((e) => e.id == 'pickup').latlng.latitude,
          'pick_lng':
              addressList.firstWhere((e) => e.id == 'pickup').latlng.longitude,
          'drop_lat':
              addressList.firstWhere((e) => e.id == 'drop').latlng.latitude,
          'drop_lng':
              addressList.firstWhere((e) => e.id == 'drop').latlng.longitude,
          'vehicle_type': etaDetails[choosenVehicle]['zone_type_id'],
          'ride_type': 1,
          'payment_opt': (etaDetails[choosenVehicle]['payment_type']
                      .toString()
                      .split(',')
                      .toList()[payingVia] ==
                  'card')
              ? 0
              : (etaDetails[choosenVehicle]['payment_type']
                          .toString()
                          .split(',')
                          .toList()[payingVia] ==
                      'cash')
                  ? 1
                  : 2,
          'pick_address':
              addressList.firstWhere((e) => e.id == 'pickup').address,
          'drop_address': addressList.firstWhere((e) => e.id == 'drop').address,
          'trip_start_time': choosenDateTime.toString().substring(0, 19),
          'is_later': true,
          'request_eta_amount': etaDetails[choosenVehicle]['total']
        }));
    if (response.statusCode == 200) {
      result = 'success';
      streamRequest();
      valueNotifierBook.incrementNotifier();
    } else {
      logDebug(response.body);
      if (jsonDecode(response.body)['message'] == 'no drivers available') {
        noDriverFound = true;
      } else {
        tripReqError = true;
      }

      result = 'failure';
      valueNotifierBook.incrementNotifier();
    }
  } catch (e) {
    if (e is SocketException) {
      result = 'no internet';
      internet = false;
    }
  }
  return result;
}

//create request with promo code

createRequestLaterPromo() async {
  dynamic result;
  try {
    var response = await http.post(Uri.parse('${url}api/v1/request/create'),
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'pick_lat':
              addressList.firstWhere((e) => e.id == 'pickup').latlng.latitude,
          'pick_lng':
              addressList.firstWhere((e) => e.id == 'pickup').latlng.longitude,
          'drop_lat':
              addressList.firstWhere((e) => e.id == 'drop').latlng.latitude,
          'drop_lng':
              addressList.firstWhere((e) => e.id == 'drop').latlng.longitude,
          'vehicle_type': etaDetails[choosenVehicle]['zone_type_id'],
          'ride_type': 1,
          'payment_opt': (etaDetails[choosenVehicle]['payment_type']
                      .toString()
                      .split(',')
                      .toList()[payingVia] ==
                  'card')
              ? 0
              : (etaDetails[choosenVehicle]['payment_type']
                          .toString()
                          .split(',')
                          .toList()[payingVia] ==
                      'cash')
                  ? 1
                  : 2,
          'pick_address':
              addressList.firstWhere((e) => e.id == 'pickup').address,
          'drop_address': addressList.firstWhere((e) => e.id == 'drop').address,
          'promocode_id': etaDetails[choosenVehicle]['promocode_id'],
          'trip_start_time': choosenDateTime.toString().substring(0, 19),
          'is_later': true,
          'request_eta_amount': etaDetails[choosenVehicle]['total']
        }));
    if (response.statusCode == 200) {
      myMarkers.clear();
      streamRequest();
      valueNotifierBook.incrementNotifier();
      result = 'success';
    } else {
      logDebug(response.body);
      if (jsonDecode(response.body)['message'] == 'no drivers available') {
        noDriverFound = true;
      } else {
        tripReqError = true;
      }

      result = 'failure';
      valueNotifierBook.incrementNotifier();
    }
  } catch (e) {
    if (e is SocketException) {
      internet = false;
      result = 'no internet';
    }
  }

  return result;
}

//create rental request

createRentalRequest() async {
  dynamic result;
  try {
    var response = await http.post(Uri.parse('${url}api/v1/request/create'),
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'pick_lat':
              addressList.firstWhere((e) => e.id == 'pickup').latlng.latitude,
          'pick_lng':
              addressList.firstWhere((e) => e.id == 'pickup').latlng.longitude,
          'vehicle_type': rentalOption[choosenVehicle]['zone_type_id'],
          'ride_type': 1,
          'payment_opt': (rentalOption[choosenVehicle]['payment_type']
                      .toString()
                      .split(',')
                      .toList()[payingVia] ==
                  'card')
              ? 0
              : (rentalOption[choosenVehicle]['payment_type']
                          .toString()
                          .split(',')
                          .toList()[payingVia] ==
                      'cash')
                  ? 1
                  : 2,
          'pick_address':
              addressList.firstWhere((e) => e.id == 'pickup').address,
          'request_eta_amount': rentalOption[choosenVehicle]['fare_amount'],
          'rental_pack_id': etaDetails[rentalChoosenOption]['id']
        }));
    logDebug(jsonEncode({
      'pick_lat':
          addressList.firstWhere((e) => e.id == 'pickup').latlng.latitude,
      'pick_lng':
          addressList.firstWhere((e) => e.id == 'pickup').latlng.longitude,
      'vehicle_type': rentalOption[choosenVehicle]['zone_type_id'],
      'ride_type': 1,
      'payment_opt': (rentalOption[choosenVehicle]['payment_type']
                  .toString()
                  .split(',')
                  .toList()[payingVia] ==
              'card')
          ? 0
          : (rentalOption[choosenVehicle]['payment_type']
                      .toString()
                      .split(',')
                      .toList()[payingVia] ==
                  'cash')
              ? 1
              : 2,
      'pick_address': addressList.firstWhere((e) => e.id == 'pickup').address,
      'request_eta_amount': rentalOption[choosenVehicle]['fare_amount'],
      'rental_pack_id': etaDetails[rentalChoosenOption]['id']
    }));
    if (response.statusCode == 200) {
      userRequestData = jsonDecode(response.body)['data'];
      streamRequest();
      result = 'success';

      valueNotifierBook.incrementNotifier();
    } else {
      logDebug(response.body);
      if (jsonDecode(response.body)['message'] == 'no drivers available') {
        noDriverFound = true;
      } else {
        tripReqError = true;
      }

      result = 'failure';
      valueNotifierBook.incrementNotifier();
    }
  } catch (e) {
    if (e is SocketException) {
      internet = false;
      result = 'no internet';
      valueNotifierBook.incrementNotifier();
    }
  }
  return result;
}

createRentalRequestWithPromo() async {
  dynamic result;
  try {
    var response = await http.post(Uri.parse('${url}api/v1/request/create'),
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'pick_lat':
              addressList.firstWhere((e) => e.id == 'pickup').latlng.latitude,
          'pick_lng':
              addressList.firstWhere((e) => e.id == 'pickup').latlng.longitude,
          'vehicle_type': rentalOption[choosenVehicle]['zone_type_id'],
          'ride_type': 1,
          'payment_opt': (rentalOption[choosenVehicle]['payment_type']
                      .toString()
                      .split(',')
                      .toList()[payingVia] ==
                  'card')
              ? 0
              : (rentalOption[choosenVehicle]['payment_type']
                          .toString()
                          .split(',')
                          .toList()[payingVia] ==
                      'cash')
                  ? 1
                  : 2,
          'pick_address':
              addressList.firstWhere((e) => e.id == 'pickup').address,
          'promocode_id': rentalOption[choosenVehicle]['promocode_id'],
          'request_eta_amount': rentalOption[choosenVehicle]['fare_amount'],
          'rental_pack_id': etaDetails[rentalChoosenOption]['id']
        }));
    if (response.statusCode == 200) {
      userRequestData = jsonDecode(response.body)['data'];
      streamRequest();
      result = 'success';
      valueNotifierBook.incrementNotifier();
    } else {
      logDebug(response.body);
      if (jsonDecode(response.body)['message'] == 'no drivers available') {
        noDriverFound = true;
      } else {
        logDebug(response.body);
        tripReqError = true;
      }

      result = 'failure';
      valueNotifierBook.incrementNotifier();
    }
  } catch (e) {
    if (e is SocketException) {
      internet = false;
      result = 'no internet';
    }
  }
  return result;
}

createRentalRequestLater() async {
  dynamic result;
  try {
    var response = await http.post(Uri.parse('${url}api/v1/request/create'),
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'pick_lat':
              addressList.firstWhere((e) => e.id == 'pickup').latlng.latitude,
          'pick_lng':
              addressList.firstWhere((e) => e.id == 'pickup').latlng.longitude,
          'vehicle_type': rentalOption[choosenVehicle]['zone_type_id'],
          'ride_type': 1,
          'payment_opt': (rentalOption[choosenVehicle]['payment_type']
                      .toString()
                      .split(',')
                      .toList()[payingVia] ==
                  'card')
              ? 0
              : (rentalOption[choosenVehicle]['payment_type']
                          .toString()
                          .split(',')
                          .toList()[payingVia] ==
                      'cash')
                  ? 1
                  : 2,
          'pick_address':
              addressList.firstWhere((e) => e.id == 'pickup').address,
          'trip_start_time': choosenDateTime.toString().substring(0, 19),
          'is_later': true,
          'request_eta_amount': rentalOption[choosenVehicle]['fare_amount'],
          'rental_pack_id': etaDetails[rentalChoosenOption]['id']
        }));
    if (response.statusCode == 200) {
      result = 'success';
      streamRequest();
      valueNotifierBook.incrementNotifier();
    } else {
      logDebug(response.body);
      if (jsonDecode(response.body)['message'] == 'no drivers available') {
        noDriverFound = true;
      } else {
        tripReqError = true;
      }

      result = 'failure';
      valueNotifierBook.incrementNotifier();
    }
  } catch (e) {
    if (e is SocketException) {
      result = 'no internet';
      internet = false;
    }
  }
  return result;
}

createRentalRequestLaterPromo() async {
  dynamic result;
  try {
    var response = await http.post(Uri.parse('${url}api/v1/request/create'),
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'pick_lat':
              addressList.firstWhere((e) => e.id == 'pickup').latlng.latitude,
          'pick_lng':
              addressList.firstWhere((e) => e.id == 'pickup').latlng.longitude,
          'vehicle_type': rentalOption[choosenVehicle]['zone_type_id'],
          'ride_type': 1,
          'payment_opt': (rentalOption[choosenVehicle]['payment_type']
                      .toString()
                      .split(',')
                      .toList()[payingVia] ==
                  'card')
              ? 0
              : (rentalOption[choosenVehicle]['payment_type']
                          .toString()
                          .split(',')
                          .toList()[payingVia] ==
                      'cash')
                  ? 1
                  : 2,
          'pick_address':
              addressList.firstWhere((e) => e.id == 'pickup').address,
          'promocode_id': rentalOption[choosenVehicle]['promocode_id'],
          'trip_start_time': choosenDateTime.toString().substring(0, 19),
          'is_later': true,
          'request_eta_amount': rentalOption[choosenVehicle]['fare_amount'],
          'rental_pack_id': etaDetails[rentalChoosenOption]['id'],
        }));
    if (response.statusCode == 200) {
      myMarkers.clear();
      streamRequest();
      valueNotifierBook.incrementNotifier();
      result = 'success';
    } else {
      logDebug(response.body);
      if (jsonDecode(response.body)['message'] == 'no drivers available') {
        noDriverFound = true;
      } else {
        logDebug(response.body);
        tripReqError = true;
      }

      result = 'failure';
      valueNotifierBook.incrementNotifier();
    }
  } catch (e) {
    if (e is SocketException) {
      internet = false;
      result = 'no internet';
    }
  }

  return result;
}

List<RequestCreate> createRequestList = <RequestCreate>[];

class RequestCreate {
  dynamic pickLat;
  dynamic pickLng;
  dynamic dropLat;
  dynamic dropLng;
  dynamic vehicleType;
  dynamic rideType;
  dynamic paymentOpt;
  dynamic pickAddress;
  dynamic dropAddress;
  dynamic promoCodeId;

  RequestCreate(
      {this.pickLat,
      this.pickLng,
      this.dropLat,
      this.dropLng,
      this.vehicleType,
      this.rideType,
      this.paymentOpt,
      this.pickAddress,
      this.dropAddress,
      this.promoCodeId});

  Map<String, dynamic> toJson() => {
        'pick_lat': pickLat,
        'pick_lng': pickLng,
        'drop_lat': dropLat,
        'drop_lng': dropLng,
        'vehicle_type': vehicleType,
        'ride_type': rideType,
        'payment_opt': paymentOpt,
        'pick_address': pickAddress,
        'drop_address': dropAddress,
        'promocode_id': promoCodeId
      };
}

//user cancel request

cancelRequest() async {
  dynamic result;
  try {
    var response = await http.post(Uri.parse('${url}api/v1/request/cancel'),
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'request_id': userRequestData['id']}));
    if (response.statusCode == 200) {
      userCancelled = true;
      FirebaseDatabase.instance
          .ref('requests')
          .child(userRequestData['id'])
          .update({'cancelled_by_user': true});
      userRequestData = {};
      if (requestStreamStart?.isPaused == false ||
          requestStreamEnd?.isPaused == false) {
        requestStreamStart?.cancel();
        requestStreamEnd?.cancel();
        requestStreamStart = null;
        requestStreamEnd = null;
      }
      result = 'success';
      valueNotifierBook.incrementNotifier();
    } else {
      logDebug(response.body);
      result = 'failed';
    }
  } catch (e) {
    if (e is SocketException) {
      internet = false;
    }
  }
  return result;
}

cancelLaterRequest(val) async {
  try {
    var response = await http.post(Uri.parse('${url}api/v1/request/cancel'),
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'request_id': val}));
    if (response.statusCode == 200) {
      userRequestData = {};
      if (requestStreamStart?.isPaused == false ||
          requestStreamEnd?.isPaused == false) {
        requestStreamStart?.cancel();
        requestStreamEnd?.cancel();
        requestStreamStart = null;
        requestStreamEnd = null;
      }
      valueNotifierBook.incrementNotifier();
    } else {
      logDebug(response.body);
    }
  } catch (e) {
    if (e is SocketException) {
      internet = false;
    }
  }
}

//user cancel request with reason

cancelRequestWithReason(reason) async {
  try {
    var response = await http.post(Uri.parse('${url}api/v1/request/cancel'),
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(
            {'request_id': userRequestData['id'], 'reason': reason}));
    if (response.statusCode == 200) {
      cancelRequestByUser = true;
      FirebaseDatabase.instance
          .ref('requests/${userRequestData['id']}')
          .update({'cancelled_by_user': true});
      userRequestData = {};
      if (rideStreamUpdate?.isPaused == false ||
          rideStreamStart?.isPaused == false) {
        rideStreamUpdate?.cancel();
        rideStreamUpdate = null;
        rideStreamStart?.cancel();
        rideStreamStart = null;
      }
      valueNotifierBook.incrementNotifier();
    } else {
      logDebug(response.body);
    }
  } catch (e) {
    if (e is SocketException) {
      internet = false;
    }
  }
}

//making call to user

makingPhoneCall(phnumber) async {
  var mobileCall = 'tel:$phnumber';
  if (await canLaunch(mobileCall)) {
    await launch(mobileCall);
  } else {
    throw 'Could not launch $mobileCall';
  }
}

//cancellation reason
List cancelReasonsList = [];

cancelReason(reason) async {
  dynamic result;
  try {
    var response = await http.get(
      Uri.parse('${url}api/v1/common/cancallation/reasons?arrived=$reason'),
      headers: {
        'Authorization': 'Bearer $authToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      cancelReasonsList = jsonDecode(response.body)['data'];
      result = true;
    } else {
      logDebug(response.body);
      result = false;
    }
  } catch (e) {
    if (e is SocketException) {
      internet = false;
      result = 'no internet';
    }
  }
  return result;
}

List<CancelReasonJson> cancelJson = <CancelReasonJson>[];

class CancelReasonJson {
  dynamic requestId;
  dynamic reason;

  CancelReasonJson({this.requestId, this.reason});

  Map<String, dynamic> toJson() {
    return {'request_id': requestId, 'reason': reason};
  }
}

//add user rating

userRating() async {
  dynamic result;
  try {
    var response = await http.post(Uri.parse('${url}api/v1/request/rating'),
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json'
        },
        body: jsonEncode({
          'request_id': userRequestData['id'],
          'rating': review,
          'comment': feedback
        }));
    if (response.statusCode == 200) {
      await getUserDetails();
      result = true;
    } else {
      logDebug(response.body);
      result = false;
    }
  } catch (e) {
    if (e is SocketException) {
      internet = false;
      result = 'no internet';
    }
  }
  return result;
}

//class for realtime database driver data

class NearByDriver {
  double bearing;
  String g;
  String id;
  List l;
  String updatedAt;

  NearByDriver(
      {required this.bearing,
      required this.g,
      required this.id,
      required this.l,
      required this.updatedAt});

  factory NearByDriver.fromJson(Map<String, dynamic> json) {
    return NearByDriver(
        id: json['id'],
        bearing: json['bearing'],
        g: json['g'],
        l: json['l'],
        updatedAt: json['updated_at']);
  }
}

//add favourites location

addFavLocation(lat, lng, add, name) async {
  dynamic result;
  try {
    var response = await http.post(
        Uri.parse('${url}api/v1/user/add-favourite-location'),
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json'
        },
        body: jsonEncode({
          'pick_lat': lat,
          'pick_lng': lng,
          'pick_address': add,
          'address_name': name
        }));
    if (response.statusCode == 200) {
      result = true;
      await getUserDetails();
      valueNotifierHome.incrementNotifier();
    } else {
      logDebug(response.body);
      result = false;
    }
    return result;
  } catch (e) {
    if (e is SocketException) {
      internet = false;
    }
  }
}

//sos data
List sosData = [];

getSosData(lat, lng) async {
  dynamic result;
  try {
    var response = await http.get(
      Uri.parse('${url}api/v1/common/sos/list/$lat/$lng'),
      headers: {
        'Authorization': 'Bearer $authToken',
        'Content-Type': 'application/json'
      },
    );

    if (response.statusCode == 200) {
      sosData = jsonDecode(response.body)['data'];
      result = 'success';
      valueNotifierBook.incrementNotifier();
    } else {
      logDebug(response.body);
      result = 'failure';
    }
  } catch (e) {
    if (e is SocketException) {
      internet = false;
      result = 'no internet';
    }
  }
  return result;
}

//sos admin notification

notifyAdmin() async {
  var db = FirebaseDatabase.instance.ref();
  // var result;

  try {
    await db.child('SOS/${userRequestData['id']}').update({
      "is_driver": "0",
      "is_user": "1",
      "req_id": userRequestData['id'],
      "serv_loc_id": userRequestData['service_location_id'],
      "updated_at": ServerValue.timestamp
    });
  } catch (e) {
    if (e is SocketException) {
      internet = false;
    }
  }
  return true;
}

//get current ride messages

List chatList = [];

getCurrentMessages() async {
  try {
    var response = await http.get(
      Uri.parse('${url}api/v1/request/chat-history/${userRequestData['id']}'),
      headers: {
        'Authorization': 'Bearer $authToken',
        'Content-Type': 'application/json'
      },
    );
    if (response.statusCode == 200) {
      if (jsonDecode(response.body)['success'] == true) {
        if (chatList.where((element) => element['from_type'] == 2).length !=
            jsonDecode(response.body)['data']
                .where((element) => element['from_type'] == 2)
                .length) {
          audioPlayers.play(AssetSource(audio));
        }
        chatList = jsonDecode(response.body)['data'];
        valueNotifierBook.incrementNotifier();
      }
    } else {
      logDebug(response.body);
    }
  } catch (e) {
    if (e is SocketException) {
      internet = false;
    }
  }
}

//send chat

sendMessage(chat) async {
  try {
    var response = await http.post(Uri.parse('${url}api/v1/request/send'),
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json'
        },
        body:
            jsonEncode({'request_id': userRequestData['id'], 'message': chat}));
    if (response.statusCode == 200) {
      await getCurrentMessages();
      FirebaseDatabase.instance
          .ref('requests/${userRequestData['id']}')
          .update({'message_by_user': chatList.length});
    } else {
      logDebug(response.body);
    }
  } catch (e) {
    if (e is SocketException) {
      internet = false;
    }
  }
}

//message seen

messageSeen() async {
  var response = await http.post(Uri.parse('${url}api/v1/request/seen'),
      headers: {
        'Authorization': 'Bearer $authToken',
        'Content-Type': 'application/json'
      },
      body: jsonEncode({'request_id': userRequestData['id']}));
  if (response.statusCode == 200) {
    getCurrentMessages();
  } else {
    logDebug(response.body);
  }
}

//add sos

addSos(name, number) async {
  dynamic result;
  try {
    var response = await http.post(Uri.parse('${url}api/v1/common/sos/store'),
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json'
        },
        body: jsonEncode({'name': name, 'number': number}));

    if (response.statusCode == 200) {
      await getUserDetails();
      result = 'success';
    } else {
      logDebug(response.body);
      result = 'failure';
    }
  } catch (e) {
    if (e is SocketException) {
      internet = false;
      result = 'no internet';
    }
  }
  return result;
}

//remove sos

deleteSos(id) async {
  dynamic result;
  try {
    var response = await http
        .post(Uri.parse('${url}api/v1/common/sos/delete/$id'), headers: {
      'Authorization': 'Bearer $authToken',
      'Content-Type': 'application/json'
    });
    if (response.statusCode == 200) {
      await getUserDetails();
      result = 'success';
    } else {
      logDebug(response.body);
      result = 'failure';
    }
  } catch (e) {
    if (e is SocketException) {
      internet = false;
      result = 'no internet';
    }
  }
  return result;
}

//open url in browser

openBrowser(browseUrl) async {
  if (await canLaunch(browseUrl)) {
    await launch(browseUrl);
  } else {
    throw 'Could not launch $browseUrl';
  }
}

//get faq
List faqData = [];

getFaqData(lat, lng) async {
  dynamic result;
  try {
    var response = await http
        .get(Uri.parse('${url}api/v1/common/faq/list/$lat/$lng'), headers: {
      'Authorization': 'Bearer $authToken',
      'Content-Type': 'application/json'
    });
    if (response.statusCode == 200) {
      faqData = jsonDecode(response.body)['data'];
      valueNotifierBook.incrementNotifier();
      result = 'success';
    } else {
      logDebug(response.body);
      result = 'failure';
    }
  } catch (e) {
    if (e is SocketException) {
      result = 'no internet';
      internet = false;
    }
    return result;
  }
}

//remove fav address

removeFavAddress(id) async {
  dynamic result;
  try {
    var response = await http.get(
        Uri.parse('${url}api/v1/user/delete-favourite-location/$id'),
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json'
        });
    if (response.statusCode == 200) {
      await getUserDetails();
      result = 'success';
    } else {
      logDebug(response.body);
      result = 'failure';
    }
  } catch (e) {
    if (e is SocketException) {
      result = 'no internet';
      internet = false;
    }
  }
  return result;
}

//get user referral

Map<String, dynamic> myReferralCode = {};

getReferral() async {
  dynamic result;
  try {
    var response =
        await http.get(Uri.parse('${url}api/v1/get/referral'), headers: {
      'Authorization': 'Bearer $authToken',
      'Content-Type': 'application/json'
    });
    if (response.statusCode == 200) {
      result = 'success';
      myReferralCode = jsonDecode(response.body)['data'];
      valueNotifierBook.incrementNotifier();
    } else {
      logDebug(response.body);
      result = 'failure';
    }
  } catch (e) {
    if (e is SocketException) {
      result = 'no internet';
      internet = false;
    }
  }
  return result;
}

//user logout

userLogout() async {
  dynamic result;
  try {
    var response = await http.post(Uri.parse('${url}api/v1/logout'), headers: {
      'Authorization': 'Bearer $authToken',
      'Content-Type': 'application/json'
    });
    if (response.statusCode == 200) {
      pref.remove('Bearer');

      result = 'success';
    } else {
      logDebug(response.body);
      result = 'failure';
    }
  } catch (e) {
    if (e is SocketException) {
      result = 'no internet';
      internet = false;
    }
  }
  return result;
}

//request history
List myHistory = [];
Map<String, dynamic> myHistoryPage = {};

getHistory(id) async {
  dynamic result;

  try {
    var response = await http.get(Uri.parse('${url}api/v1/request/history?$id'),
        headers: {'Authorization': 'Bearer $authToken'});
    if (response.statusCode == 200) {
      myHistory = jsonDecode(response.body)['data'];
      myHistoryPage = jsonDecode(response.body)['meta'];
      result = 'success';
      valueNotifierBook.incrementNotifier();
    } else {
      logDebug(response.body);
      result = 'failure';
      valueNotifierBook.incrementNotifier();
    }
  } catch (e) {
    if (e is SocketException) {
      result = 'no internet';

      internet = false;
      valueNotifierBook.incrementNotifier();
    }
  }
  return result;
}

getHistoryPages(id) async {
  dynamic result;

  try {
    var response = await http.get(Uri.parse('${url}api/v1/request/history?$id'),
        headers: {'Authorization': 'Bearer $authToken'});
    if (response.statusCode == 200) {
      List list = jsonDecode(response.body)['data'];
      // ignore: avoid_function_literals_in_foreach_calls
      list.forEach((element) {
        myHistory.add(element);
      });
      myHistoryPage = jsonDecode(response.body)['meta'];
      result = 'success';
      valueNotifierBook.incrementNotifier();
    } else {
      logDebug(response.body);
      result = 'failure';
      valueNotifierBook.incrementNotifier();
    }
  } catch (e) {
    if (e is SocketException) {
      result = 'no internet';

      internet = false;
      valueNotifierBook.incrementNotifier();
    }
  }
  return result;
}

//get wallet history

Map<String, dynamic> walletBalance = {};
List walletHistory = [];
Map<String, dynamic> walletPages = {};

getWalletHistory() async {
  dynamic result;
  try {
    var response = await http.get(
        Uri.parse('${url}api/v1/payment/wallet/history'),
        headers: {'Authorization': 'Bearer $authToken'});
    if (response.statusCode == 200) {
      walletBalance = jsonDecode(response.body);
      walletHistory = walletBalance['wallet_history']['data'];
      walletPages = walletBalance['wallet_history']['meta']['pagination'];
      result = 'success';
      valueNotifierBook.incrementNotifier();
    } else {
      logDebug(response.body);
      result = 'failure';
      valueNotifierBook.incrementNotifier();
    }
  } catch (e) {
    if (e is SocketException) {
      internet = false;
      result = 'no internet';
      valueNotifierBook.incrementNotifier();
    }
  }
  return result;
}

getWalletHistoryPage(page) async {
  dynamic result;
  try {
    var response = await http.get(
        Uri.parse('${url}api/v1/payment/wallet/history?page=$page'),
        headers: {'Authorization': 'Bearer $authToken'});
    if (response.statusCode == 200) {
      walletBalance = jsonDecode(response.body);
      List list = walletBalance['wallet_history']['data'];
      // ignore: avoid_function_literals_in_foreach_calls
      list.forEach((element) {
        walletHistory.add(element);
      });
      walletPages = walletBalance['wallet_history']['meta']['pagination'];
      result = 'success';
      valueNotifierBook.incrementNotifier();
    } else {
      logDebug(response.body);
      result = 'failure';
      valueNotifierBook.incrementNotifier();
    }
  } catch (e) {
    if (e is SocketException) {
      internet = false;
      result = 'no internet';
      valueNotifierBook.incrementNotifier();
    }
  }
  return result;
}

//get client token for braintree

getClientToken() async {
  dynamic result;
  try {
    var response = await http.get(
        Uri.parse('${url}api/v1/payment/client/token'),
        headers: {'Authorization': 'Bearer $authToken'});
    if (response.statusCode == 200) {
      result = 'success';
    } else {
      logDebug(response.body);
      result = 'failure';
    }
  } catch (e) {
    if (e is SocketException) {
      internet = false;
      result = 'no internet';
    }
  }
  return result;
}

//stripe payment

Map<String, dynamic> stripeToken = {};

getStripePayment(money) async {
  dynamic results;
  try {
    var response =
        await http.post(Uri.parse('${url}api/v1/payment/stripe/intent'),
            headers: {
              'Authorization': 'Bearer $authToken',
              'Content-Type': 'application/json'
            },
            body: jsonEncode({'amount': money}));
    if (response.statusCode == 200) {
      results = 'success';
      stripeToken = jsonDecode(response.body)['data'];
    } else {
      logDebug(response.body);
      results = 'failure';
    }
  } catch (e) {
    if (e is SocketException) {
      results = 'no internet';
      internet = false;
    }
  }
  return results;
}

//stripe add money

addMoneyStripe(amount, nonce) async {
  dynamic result;
  try {
    var response = await http.post(
        Uri.parse('${url}api/v1/payment/stripe/add/money'),
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json'
        },
        body: jsonEncode(
            {'amount': amount, 'payment_nonce': nonce, 'payment_id': nonce}));
    if (response.statusCode == 200) {
      await getWalletHistory();
      await getUserDetails();
      result = 'success';
    } else {
      logDebug(response.body);
      result = 'failure';
    }
  } catch (e) {
    if (e is SocketException) {
      internet = false;
      result = 'no internet';
    }
  }
  return result;
}

//paystack payment
Map<String, dynamic> paystackCode = {};

getPaystackPayment(money) async {
  dynamic results;
  paystackCode.clear();
  try {
    var response =
        await http.post(Uri.parse('${url}api/v1/payment/paystack/initialize'),
            headers: {
              'Authorization': 'Bearer $authToken',
              'Content-Type': 'application/json'
            },
            body: jsonEncode({'amount': money}));
    if (response.statusCode == 200) {
      if (jsonDecode(response.body)['status'] == false) {
        results = jsonDecode(response.body)['message'];
      } else {
        results = 'success';
        paystackCode = jsonDecode(response.body)['data'];
      }
    } else {
      logDebug(response.body);
      results = jsonDecode(response.body)['message'];
    }
  } catch (e) {
    if (e is SocketException) {
      results = 'no internet';
      internet = false;
    }
  }
  return results;
}

addMoneyPaystack(amount, nonce) async {
  dynamic result;
  try {
    var response = await http.post(
        Uri.parse('${url}api/v1/payment/paystack/add-money'),
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json'
        },
        body: jsonEncode(
            {'amount': amount, 'payment_nonce': nonce, 'payment_id': nonce}));
    if (response.statusCode == 200) {
      await getWalletHistory();
      await getUserDetails();
      paystackCode.clear();
      result = 'success';
    } else {
      logDebug(response.body);
      result = 'failure';
    }
  } catch (e) {
    if (e is SocketException) {
      internet = false;
      result = 'no internet';
    }
  }
  return result;
}

//flutterwave

addMoneyFlutterwave(amount, nonce) async {
  dynamic result;
  try {
    var response = await http.post(
        Uri.parse('${url}api/v1/payment/flutter-wave/add-money'),
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json'
        },
        body: jsonEncode(
            {'amount': amount, 'payment_nonce': nonce, 'payment_id': nonce}));
    if (response.statusCode == 200) {
      await getWalletHistory();
      await getUserDetails();
      result = 'success';
    } else {
      logDebug(response.body);
      result = 'failure';
    }
  } catch (e) {
    if (e is SocketException) {
      internet = false;
      result = 'no internet';
    }
  }
  return result;
}

//razorpay

addMoneyRazorpay(amount, nonce) async {
  dynamic result;
  try {
    var response = await http.post(
        Uri.parse('${url}api/v1/payment/razerpay/add-money'),
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json'
        },
        body: jsonEncode(
            {'amount': amount, 'payment_nonce': nonce, 'payment_id': nonce}));
    if (response.statusCode == 200) {
      await getWalletHistory();
      await getUserDetails();
      result = 'success';
    } else {
      logDebug(response.body);
      result = 'failure';
    }
  } catch (e) {
    if (e is SocketException) {
      internet = false;
      result = 'no internet';
    }
  }
  return result;
}

//cashfree

Map<String, dynamic> cftToken = {};

getCfToken(money, currency) async {
  cftToken.clear();
  cfSuccessList.clear();
  dynamic result;
  try {
    var response = await http.post(
        Uri.parse('${url}api/v1/payment/cashfree/generate-cftoken'),
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json'
        },
        body: jsonEncode({'order_amount': money, 'order_currency': currency}));
    if (response.statusCode == 200) {
      if (jsonDecode(response.body)['status'] == 'OK') {
        cftToken = jsonDecode(response.body);
        result = 'success';
      } else {
        logDebug(response.body);
        result = 'failure';
      }
    } else {
      logDebug(response.body);
      result = 'failure';
    }
  } catch (e) {
    if (e is SocketException) {
      internet = false;
      result = 'no internet';
    }
  }
  return result;
}

Map<String, dynamic> cfSuccessList = {};

cashFreePaymentSuccess() async {
  dynamic result;
  try {
    var response = await http.post(
        Uri.parse('${url}api/v1/payment/cashfree/add-money-to-wallet-webhooks'),
        headers: {
          'Authorization': 'Bearer $authToken',
          'Content-Type': 'application/json'
        },
        body: jsonEncode({
          'orderId': cfSuccessList['orderId'],
          'orderAmount': cfSuccessList['orderAmount'],
          'referenceId': cfSuccessList['referenceId'],
          'txStatus': cfSuccessList['txStatus'],
          'paymentMode': cfSuccessList['paymentMode'],
          'txMsg': cfSuccessList['txMsg'],
          'txTime': cfSuccessList['txTime'],
          'signature': cfSuccessList['signature']
        }));
    if (response.statusCode == 200) {
      if (jsonDecode(response.body)['success'] == true) {
        result = 'success';
        await getWalletHistory();
        await getUserDetails();
      } else {
        logDebug(response.body);
        result = 'failure';
      }
    } else {
      logDebug(response.body);
      result = 'failure';
    }
  } catch (e) {
    if (e is SocketException) {
      internet = false;
      result = 'no internet';
    }
  }
  return result;
}

//edit user profile

updateProfile(name, email) async {
  dynamic result;
  try {
    var response = http.MultipartRequest(
      'POST',
      Uri.parse('${url}api/v1/user/profile'),
    );
    response.headers
        .addAll({'Authorization': 'Bearer $authToken'});
    response.files
        .add(await http.MultipartFile.fromPath('profile_picture', imageFile));
    response.fields['email'] = email;
    response.fields['name'] = name;
    var request = await response.send();
    var respon = await http.Response.fromStream(request);
    final val = jsonDecode(respon.body);
    if (request.statusCode == 200) {
      result = 'success';
      if (val['success'] == true) {
        await getUserDetails();
      }
    } else {
      logDebug(val);
      result = 'failure';
    }
  } catch (e) {
    if (e is SocketException) {
      result = 'no internet';
    }
  }
  return result;
}

updateProfileWithoutImage(name, email) async {
  dynamic result;
  try {
    var response = http.MultipartRequest(
      'POST',
      Uri.parse('${url}api/v1/user/profile'),
    );
    response.headers
        .addAll({'Authorization': 'Bearer $authToken'});
    response.fields['email'] = email;
    response.fields['name'] = name;
    var request = await response.send();
    var respon = await http.Response.fromStream(request);
    final val = jsonDecode(respon.body);
    if (request.statusCode == 200) {
      result = 'success';
      if (val['success'] == true) {
        await getUserDetails();
      }
    } else {
      logDebug(val);
      result = 'failure';
    }
  } catch (e) {
    if (e is SocketException) {
      result = 'no internet';
    }
  }
  return result;
}

//internet true
internetTrue() {
  internet = true;
  valueNotifierHome.incrementNotifier();
}

//make complaint

List generalComplaintList = [];

getGeneralComplaint(type) async {
  dynamic result;
  try {
    var response = await http.get(
      Uri.parse('${url}api/v1/common/complaint-titles?complaint_type=$type'),
      headers: {'Authorization': 'Bearer $authToken'},
    );
    if (response.statusCode == 200) {
      generalComplaintList = jsonDecode(response.body)['data'];
      result = 'success';
    } else {
      logDebug(response.body);
      result = 'failed';
    }
  } catch (e) {
    if (e is SocketException) {
      internet = false;
      result = 'no internet';
    }
  }
  return result;
}

makeGeneralComplaint() async {
  dynamic result;
  try {
    var response =
        await http.post(Uri.parse('${url}api/v1/common/make-complaint'),
            headers: {
              'Authorization': 'Bearer $authToken',
              'Content-Type': 'application/json'
            },
            body: jsonEncode({
              'complaint_title_id': generalComplaintList[complaintType]['id'],
              'description': complaintDesc,
            }));
    if (response.statusCode == 200) {
      result = 'success';
    } else {
      logDebug(response.body);
      result = 'failed';
    }
  } catch (e) {
    if (e is SocketException) {
      internet = false;
      result = 'no internet';
    }
  }
  return result;
}

makeRequestComplaint() async {
  dynamic result;
  try {
    var response =
        await http.post(Uri.parse('${url}api/v1/common/make-complaint'),
            headers: {
              'Authorization': 'Bearer $authToken',
              'Content-Type': 'application/json'
            },
            body: jsonEncode({
              'complaint_title_id': generalComplaintList[complaintType]['id'],
              'description': complaintDesc,
              'request_id': myHistory[selectedHistory]['id']
            }));
    if (response.statusCode == 200) {
      result = 'success';
    } else {
      logDebug(response.body);
      result = 'failed';
    }
  } catch (e) {
    if (e is SocketException) {
      internet = false;
      result = 'no internet';
    }
  }
  return result;
}

//requestStream
StreamSubscription<DatabaseEvent>? requestStreamStart;
StreamSubscription<DatabaseEvent>? requestStreamEnd;
bool userCancelled = false;

streamRequest() {
  requestStreamEnd?.cancel();
  requestStreamStart?.cancel();
  rideStreamUpdate?.cancel();
  rideStreamStart?.cancel();
  requestStreamStart = null;
  requestStreamEnd = null;
  rideStreamUpdate = null;
  rideStreamStart = null;
  requestStreamStart = FirebaseDatabase.instance
      .ref('request-meta')
      .child(userRequestData['id'])
      .onChildRemoved
      .handleError((onError) {
    requestStreamStart?.cancel();
  }).listen((event) async {
    getUserDetails();
    requestStreamEnd?.cancel();
    requestStreamStart?.cancel();
  });
}

StreamSubscription<DatabaseEvent>? rideStreamStart;
StreamSubscription<DatabaseEvent>? rideStreamUpdate;

streamRide() {
  requestStreamEnd?.cancel();
  requestStreamStart?.cancel();
  rideStreamUpdate?.cancel();
  rideStreamStart?.cancel();
  requestStreamStart = null;
  requestStreamEnd = null;
  rideStreamUpdate = null;
  rideStreamStart = null;
  rideStreamUpdate = FirebaseDatabase.instance
      .ref('requests/${userRequestData['id']}')
      .onChildChanged
      .handleError((onError) {
    rideStreamUpdate?.cancel();
  }).listen((DatabaseEvent event) async {
    if (event.snapshot.key.toString() == 'trip_start' ||
        event.snapshot.key.toString() == 'trip_arrived' ||
        event.snapshot.key.toString() == 'is_completed') {
      getUserDetails();
    } else if (event.snapshot.key.toString() == 'message_by_driver') {
      getCurrentMessages();
    } else if (event.snapshot.key.toString() == 'cancelled_by_driver') {
      requestCancelledByDriver = true;
      getUserDetails();
    }
  });

  rideStreamStart = FirebaseDatabase.instance
      .ref('requests/${userRequestData['id']}')
      .onChildAdded
      .handleError((onError) {
    rideStreamStart?.cancel();
  }).listen((DatabaseEvent event) async {
    if (event.snapshot.key.toString() == 'message_by_driver') {
      getCurrentMessages();
    } else if (event.snapshot.key.toString() == 'cancelled_by_driver') {
      requestCancelledByDriver = true;
      getUserDetails();
    }
  });
}

userDelete() async {
  dynamic result;
  try {
    var response = await http
        .post(Uri.parse('${url}api/v1/user/delete-user-account'), headers: {
      'Authorization': 'Bearer $authToken',
      'Content-Type': 'application/json'
    });
    if (response.statusCode == 200) {
      pref.remove('Bearer');

      result = 'success';
    } else {
      logDebug(response.body);
      result = 'failure';
    }
  } catch (e) {
    if (e is SocketException) {
      result = 'no internet';
      internet = false;
    }
  }
  return result;
}
