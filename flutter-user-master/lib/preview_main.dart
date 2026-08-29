// ВРЕМЕННАЯ точка входа только для просмотра отдельных экранов при редизайне.
// Запуск: flutter run -t lib/preview_main.dart
// В сборку не попадает, main.dart не трогает. Удалить после редизайна.

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tagyourtaxi_driver/l10n/app_localizations.dart';

import 'src/core/services/cache_service.dart';
import 'src/core/services/functions.dart';
import 'src/presentation/design/app_theme.dart';
import 'src/presentation/views/login/otp_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheService.init();

  // Подставляем данные, которые обычно приходят с экрана входа.
  phnumber = '94 555 77 77';
  languageDirection = 'ltr';
  choosenLanguage = 'ru';
  countries = [
    {'dial_code': '+998', 'dial_max_length': 9, 'name': 'Uzbekistan'}
  ];
  phcode = 0;

  runApp(const _PreviewApp());
}

class _PreviewApp extends StatelessWidget {
  const _PreviewApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: MtTheme.light(),
      darkTheme: MtTheme.dark(),
      themeMode: ThemeMode.light,
      locale: const Locale('ru'),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const Otp(),
    );
  }
}
