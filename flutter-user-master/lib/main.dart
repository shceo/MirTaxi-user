import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'src/app.dart';
import 'src/core/services/cache_service.dart';
import 'src/core/services/functions.dart';
import 'src/core/services/notifications.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await Firebase.initializeApp();
  await CacheService.init();
  checkInternetConnection();

  initMessaging();
  runApp(const MyApp());
}
