import 'package:flutter/material.dart';
import 'package:tagyourtaxi_driver/src/presentation/styles/styles.dart';

class StackFiveWidget extends StatelessWidget {
  final int bottom;
  final VoidCallback locationAllowed;

  const StackFiveWidget({
    super.key,
    required this.bottom,
    required this.locationAllowed,
  });

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    if (bottom != 0) {
      return const SizedBox.shrink();
    }
    final bottomOffset = (media.width * 0.8) + (media.width * 0.03);
    final buttonSize = media.width * 0.11;
    return Positioned(
      right: media.width * 0.05,
      bottom: bottomOffset,
      child: InkWell(
        onTap: locationAllowed,
        child: Container(
          height: buttonSize,
          width: buttonSize,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                blurRadius: 4,
                color: Colors.black.withValues(alpha: 0.2),
                spreadRadius: 1,
              ),
            ],
            color: page,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.my_location,
            size: buttonSize * 0.55,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
