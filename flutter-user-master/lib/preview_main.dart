// ВРЕМЕННАЯ точка входа только для просмотра экранов при редизайне.
// Запуск: flutter run -t lib/preview_main.dart
// В прод-сборку не попадает, main.dart не трогает. Удалить после редизайна.

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tagyourtaxi_driver/l10n/app_localizations.dart';

import 'src/core/services/cache_service.dart';
import 'src/core/services/functions.dart';
import 'src/presentation/design/app_theme.dart';
import 'src/presentation/design/tokens.dart';
import 'src/presentation/views/login/login.dart';
import 'src/presentation/views/login/otp_page.dart';
import 'src/presentation/views/login/create_task_screen.dart';
import 'src/presentation/views/login/select_task_screen.dart';
import 'src/presentation/views/login/send_success_screen.dart';
import 'src/presentation/views/onTripPage/map_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Карта читает водителей из Realtime Database, поэтому Firebase нужен и в
  // превью. Конфиг сейчас заглушка: машины не подгрузятся, но экран отрисуется.
  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint('Firebase в превью не поднялся: $e');
  }
  await CacheService.init();

  // Данные, которые в обычном потоке приезжают с предыдущих экранов.
  phnumber = '94 555 77 77';
  languageDirection = 'ltr';
  choosenLanguage = 'ru';
  countries = [
    {'dial_code': '+998', 'dial_max_length': 9, 'name': 'Uzbekistan'}
  ];
  phcode = 0;
  userDetails = {'name': 'Фаррух', 'mobile': '94 555 77 77'};

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
      home: const _PreviewIndex(),
    );
  }
}

/// Оглавление: экраны открываются поверх него, поэтому «назад» возвращает сюда,
/// а не в пустоту, как было бы, открывай мы экран сразу корневым.
class _PreviewIndex extends StatefulWidget {
  const _PreviewIndex();

  static final screens = <String, WidgetBuilder>{
    'Вход': (_) => const Login(),
    'Ввод кода из SMS': (_) => const Otp(),
    'Выбор услуги': (_) => const SelectTaskScreen(),
    'Форма заявки': (_) => const CreateTaskScreen(id: 2),
    'Заявка отправлена': (_) => const SendSuccessScreen(desc: ''),
    'Карта': (_) => const Maps(),
  };

  @override
  State<_PreviewIndex> createState() => _PreviewIndexState();
}

class _PreviewIndexState extends State<_PreviewIndex> {
  /// Автооткрытие экрана по номеру: --dart-define=SCREEN=2
  /// Экран открывается поверх списка, поэтому «назад» продолжает работать.
  static const int _autoOpen = int.fromEnvironment('SCREEN', defaultValue: -1);

  @override
  void initState() {
    super.initState();
    if (_autoOpen >= 0 && _autoOpen < _PreviewIndex.screens.length) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: _PreviewIndex.screens.values.elementAt(_autoOpen)),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Экраны — предпросмотр')),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: MtSpace.sm),
        itemCount: _PreviewIndex.screens.length,
        separatorBuilder: (_, __) => const Divider(indent: MtSpace.screenX),
        itemBuilder: (context, i) {
          final name = _PreviewIndex.screens.keys.elementAt(i);
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: MtSpace.screenX,
              vertical: MtSpace.xs,
            ),
            title: Text(name, style: theme.textTheme.bodyLarge),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: _PreviewIndex.screens[name]!),
            ),
          );
        },
      ),
    );
  }
}
