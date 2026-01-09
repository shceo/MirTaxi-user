import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppSvgAsset extends StatelessWidget {
  final String icon;
  final Color? color;
  final double? width;
  final double? height;
  final BoxFit? fit;

  const AppSvgAsset(
    this.icon, {
    super.key,
    this.color,
    this.width,
    this.height,
    this.fit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: SvgPicture.asset(
        icon,
        width: width,
        height: height,
        fit: fit ?? BoxFit.contain,
        colorFilter: color == null
            ? null
            : ColorFilter.mode(
                color!,
                BlendMode.srcIn,
              ),
      ),
    );
  }
}
