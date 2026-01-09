import 'package:flutter/material.dart';
import 'package:tagyourtaxi_driver/src/presentation/styles/styles.dart';

class StackFiveWidget extends StatelessWidget {
  final Function() locationAllowed;

  const StackFiveWidget({super.key, required this.locationAllowed});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Positioned(
      bottom: 20 + media.width * 0.4,
      child: SizedBox(
        width: media.width * 0.9,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Spacer(),
            InkWell(
              onTap: () => locationAllowed(),
              child: Container(
                height: media.width * 0.1,
                width: media.width * 0.1,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 2,
                      color: Colors.black.withValues(alpha: 0.2),
                      spreadRadius: 2,
                    )
                  ],
                  color: page,
                  borderRadius: BorderRadius.circular(media.width * 0.02),
                ),
                child: const Icon(Icons.my_location_sharp),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
