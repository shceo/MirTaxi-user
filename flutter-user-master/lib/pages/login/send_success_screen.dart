import 'package:flutter/material.dart';
import 'package:tagyourtaxi_driver/styles/styles.dart';
import 'package:tagyourtaxi_driver/widgets/widgets.dart';

class SendSuccessScreen extends StatefulWidget {
  final String desc;

  const SendSuccessScreen({super.key, required this.desc});

  @override
  State<SendSuccessScreen> createState() => _SendSuccessScreenState();
}

class _SendSuccessScreenState extends State<SendSuccessScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: double.infinity),
          Image.asset(
            'assets/images/logo.png',
            height: 110,
            width: 224,
          ),
          SizedBox(height: 32),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, 1),
                  blurRadius: 4,
                  color: Color.fromRGBO(0, 0, 0, 0.25),
                ),
              ],
            ),
            child: Center(
              child: Text(
                widget.desc,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            child: Button(
              onTap: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              text: 'Закрыть',
            ),
          ),
        ],
      ),
    );
  }
}
