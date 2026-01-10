import 'package:flutter/material.dart';

class StackTwoWidget extends StatelessWidget {
  final bool dropLocationMap;

  const StackTwoWidget({super.key, required this.dropLocationMap});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    final base = (w / 390).clamp(0.85, 1.05).toDouble();
  final scale = (base * 0.50).clamp(0.30, 0.50).toDouble();



    return Positioned.fill(
      child: IgnorePointer(
        child: Center(
          child: Transform.translate(
            offset: Offset(0, -10 * scale),
            child: dropLocationMap
                ? _DropPoint(scale: scale)
                : _PickupPoint(scale: scale),
          ),
        ),
      ),
    );
  }
}

class _PickupPoint extends StatelessWidget {
  const _PickupPoint({required this.scale});
  final double scale;

  @override
  Widget build(BuildContext context) {
    final s = scale;

    final pillRadius = 28 * s;
    final greenSize = 52 * s;

    final circleSize = 118 * s;
    final ringSize = 26 * s;
    final ringStroke = 6 * s;

    final lineW = 6 * s;
    final lineH = 48 * s;

    final arrowSize = 16 * s;
    final topGap = 10 * s;

    return SizedBox(
      width: 320 * s,
      height: (120 + lineH + (circleSize * 0.55)) * s,
      child: Stack(
        alignment: Alignment.topCenter,
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: (60 * s) + topGap + (lineH * 0.35),
            child: Container(
              width: circleSize,
              height: circleSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black.withOpacity(0.12),
              ),
            ),
          ),
          Positioned(
            top: (60 * s) + topGap,
            child: Container(
              width: lineW,
              height: lineH,
              decoration: BoxDecoration(
                color: const Color(0xFF0B0B0B),
                borderRadius: BorderRadius.circular(99),
              ),
            ),
          ),
          Positioned(
            top: (60 * s) + topGap + lineH - (ringSize / 2),
            child: SizedBox(
              width: ringSize + (arrowSize * 0.9),
              height: ringSize,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.centerLeft,
                children: [
                  Container(
                    width: ringSize,
                    height: ringSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(
                        color: const Color(0xFF0B0B0B),
                        width: ringStroke,
                      ),
                    ),
                  ),
                  Positioned(
                    left: ringSize - (arrowSize * 0.15),
                    child: Icon(
                      Icons.play_arrow_rounded,
                      size: arrowSize,
                      color: const Color(0xFF0B0B0B),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16 * s, vertical: 10 * s),
              decoration: BoxDecoration(
                color: const Color(0xFF0B0B0B),
             borderRadius: BorderRadius.circular(999),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 8 * s),
                    blurRadius: 18 * s,
                    color: Colors.black.withOpacity(0.35),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: greenSize,
                    height: greenSize,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF22C55E),
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.person,
                      size: 28 * s,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 14 * s),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Подача',
                        style: TextStyle(
                          fontSize: 26 * s,
                          fontWeight: FontWeight.w800,
                          height: 1.0,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 6 * s),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 34 * s,
                            height: 34 * s,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.access_time_rounded,
                              size: 20 * s,
                              color: const Color(0xFF0B0B0B),
                            ),
                          ),
                          SizedBox(width: 10 * s),
                          Text(
                            '5 мин',
                            style: TextStyle(
                              fontSize: 26 * s,
                              fontWeight: FontWeight.w800,
                              height: 1.0,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DropPoint extends StatelessWidget {
  final double scale;
  const _DropPoint({required this.scale});

  @override
  Widget build(BuildContext context) {
    final s = scale;
    return Container(
      width: 44 * s,
      height: 44 * s,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFF0B0B0B),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 10 * s),
            blurRadius: 18 * s,
            color: Colors.black.withOpacity(0.25),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Icon(
        Icons.location_on_rounded,
        size: 26 * s,
        color: const Color(0xFFF59E0B),
      ),
    );
  }
}
