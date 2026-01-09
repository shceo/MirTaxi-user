import 'package:flutter/material.dart';

class StackFourWidget extends StatelessWidget {
  const StackFourWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Positioned(
      top: MediaQuery.of(context).padding.top + 12.5,
      child: SizedBox(
        width: media.width * 0.9,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: media.width * 0.1,
              width: media.width * 0.1,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.fromRGBO(255, 255, 255, 1),
                    Color.fromRGBO(255, 255, 255, 0.2),
                  ],
                ),
              ),
              alignment: Alignment.center,
              child: StatefulBuilder(
                builder: (context, setState) {
                  return InkWell(
                    onTap: () {
                      Scaffold.of(context).openDrawer();
                    },
                    child: const Icon(Icons.menu),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
