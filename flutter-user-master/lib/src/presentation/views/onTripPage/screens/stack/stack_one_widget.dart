import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class StackOneWidget extends StatelessWidget {
  final Query fdb;
  final List<PlacemarkMapObject> myMarkers;
  final Function(dynamic event) eventData;
  final Stream<List<PlacemarkMapObject>>? carMarkerStream;
  final Function(YandexMapController)? onMapCreated;
  final Function(CameraPosition) centerLocation;
  final Function() cameraIdle;
  final ValueChanged<bool>? onMapMove;
  final Point center;

  const StackOneWidget({
    super.key,
    required this.fdb,
    required this.myMarkers,
    required this.eventData,
    this.carMarkerStream,
    required this.onMapCreated,
    required this.center,
    required this.centerLocation,
    required this.cameraIdle,
    this.onMapMove,
  });

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return SizedBox(
      height: media.height * 1,
      width: media.width * 1,
      child: StreamBuilder<DatabaseEvent>(
        stream: fdb.onValue,
        builder: (context, AsyncSnapshot<DatabaseEvent> event) {
          if (event.hasData) {
            eventData(event);
          }
          return StreamBuilder<List<PlacemarkMapObject>>(
            stream: carMarkerStream,
            builder: (context, snapshot) {
              return YandexMap(
                mapType: MapType.vector,
                onMapCreated: onMapCreated,
                cameraBounds: const CameraBounds(minZoom: 8.0, maxZoom: 20.0),
                onCameraPositionChanged:
                    (cameraPosition, reason, finished) {
                  centerLocation(cameraPosition);
                  if (onMapMove != null) {
                    if (reason == CameraUpdateReason.gestures) {
                      onMapMove!(!finished);
                    } else if (finished) {
                      onMapMove!(false);
                    }
                  }
                  if (finished) {
                    cameraIdle();
                  }
                },
                mapObjects: List<MapObject>.from(myMarkers),
              );
            },
          );
        },
      ),
    );
  }
}
