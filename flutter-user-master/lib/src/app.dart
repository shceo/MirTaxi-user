import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tagyourtaxi_driver/l10n/app_localizations.dart';

import 'core/services/functions.dart';
import 'presentation/design/app_theme.dart';
import 'presentation/views/loadingPage/loadingpage.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    platform = Theme.of(context).platform;
    return ValueListenableBuilder<Locale?>(
      valueListenable: localeNotifier,
      builder: (context, locale, _) {
        return GestureDetector(
          onTap: () {
            // Remove keyboard when tapping outside inputs.
            final currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
              FocusManager.instance.primaryFocus?.unfocus();
            }
          },
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Taxi user',
            theme: MtTheme.light(),
            darkTheme: MtTheme.dark(),
            // Тёмная тема готова, но пока принудительно светлая: остальные
            // экраны ещё используют старые захардкоженные цвета и в тёмной
            // читаться не будут. Переключим на ThemeMode.system, когда экраны
            // переедут на токены.
            themeMode: ThemeMode.light,
            locale: locale ?? const Locale('en'),
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: const LoadingPage(),
          ),
        );
      },
    );
  }
}
