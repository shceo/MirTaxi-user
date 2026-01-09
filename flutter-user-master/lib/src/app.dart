import 'package:flutter/material.dart';

import 'core/services/functions.dart';
import 'presentation/views/loadingPage/loadingpage.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    platform = Theme.of(context).platform;
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
        theme: ThemeData(),
        home: const LoadingPage(),
      ),
    );
  }
}
