import 'package:flutter/material.dart';
import 'package:tagyourtaxi_driver/src/presentation/views/login/create_task_screen.dart';
import 'package:tagyourtaxi_driver/src/presentation/views/onTripPage/map_page.dart';
import 'package:tagyourtaxi_driver/src/presentation/styles/styles.dart';

class SelectTaskScreen extends StatefulWidget {
  const SelectTaskScreen({super.key});

  @override
  State<SelectTaskScreen> createState() => _SelectTaskScreenState();
}

class _SelectTaskScreenState extends State<SelectTaskScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backColor,
      body: Column(
        children: [
          const SizedBox(height: 100, width: double.infinity),
          Image.asset(
            'assets/images/logo.png',
            height: 110,
            width: 224,
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateTaskScreen(id: 2)));
            },
            child: Image.asset(
              'assets/images/child.png',
              height: 128,
              width: 246,
            ),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateTaskScreen(id: 1)));
            },
            child: Image.asset(
              'assets/images/business.png',
              height: 128,
              width: 246,
            ),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () {
              Navigator.pushAndRemoveUntil(
                  context, MaterialPageRoute(builder: (context) => const Maps()), (route) => false);
            },
            child: Image.asset(
              'assets/images/taxi.png',
              height: 128,
              width: 246,
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
