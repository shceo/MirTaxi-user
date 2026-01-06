import 'package:flutter/material.dart';

class StackTwoWidget extends StatelessWidget {
  final bool dropLocationMap;

  const StackTwoWidget({super.key, required this.dropLocationMap});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Positioned(
      top: 0,
      child: Container(
        height: media.height * 1,
        width: media.width * 1,
        alignment: Alignment.center,
        child: (dropLocationMap == false)
            ? Column(
                children: [
                  SizedBox(
                    height: (media.height / 2) - media.width * 0.08,
                  ),
                  Image.asset(
                    'assets/images/pickupmarker.png',
                    width: media.width * 0.07,
                    height: media.width * 0.08,
                  ),
                ],
              )
            : Image.asset('assets/images/dropmarker.png'),
      ),
    );
  }
}
