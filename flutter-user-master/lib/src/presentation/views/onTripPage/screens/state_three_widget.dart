import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import 'package:tagyourtaxi_driver/src/core/services/functions.dart';
import 'package:tagyourtaxi_driver/src/presentation/views/onTripPage/screens/stack/stack_five_widget.dart';
import 'package:tagyourtaxi_driver/src/presentation/views/onTripPage/screens/stack/stack_four_widget.dart';
import 'package:tagyourtaxi_driver/src/presentation/views/onTripPage/screens/stack/stack_one_widget.dart';
import 'package:tagyourtaxi_driver/src/presentation/views/onTripPage/screens/stack/stack_six_widget.dart';
import 'package:tagyourtaxi_driver/src/presentation/views/onTripPage/screens/stack/stack_three_widget.dart';
import 'package:tagyourtaxi_driver/src/presentation/views/onTripPage/screens/stack/stack_two_widget.dart';

class StateThreeWidget extends StatelessWidget {
  final Query fdb;
  final List<PlacemarkMapObject> myMarkers;
  final Function(dynamic event) eventData;
  final Stream<List<PlacemarkMapObject>>? carMarkerStream;
  final Function(YandexMapController) onMapCreated;
  final Function(CameraPosition) centerLocation;
  final Function() changePosition;
  final Function(String) addDirections;
  final Function() pickup;
  final Function() cameraIdle;
  final Function() locationAllowed;
  final Function(DragUpdateDetails) onChange1;
  final Function() onChange2;
  final Function(String) onChange3;
  final Function(int i) onChange4;
  final Function(int i) onChange5;
  final Function(int i) onChange6;
  final Function() onChange7;
  final Point center;
  final int bottom;
  final bool dropLocationMap;
  final bool pickaddress;
  final bool dropAddress;

  const StateThreeWidget({
    super.key,
    required this.bottom,
    required this.fdb,
    required this.myMarkers,
    required this.eventData,
    this.carMarkerStream,
    required this.cameraIdle,
    required this.onMapCreated,
    required this.centerLocation,
    required this.center,
    required this.dropLocationMap,
    required this.pickaddress,
    required this.changePosition,
    required this.addDirections,
    required this.pickup,
    required this.locationAllowed,
    required this.dropAddress,
    required this.onChange1,
    required this.onChange2,
    required this.onChange3,
    required this.onChange4,
    required this.onChange5,
    required this.onChange6,
    required this.onChange7,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        StackOneWidget(
          fdb: fdb,
          myMarkers: myMarkers,
          cameraIdle: cameraIdle,
          carMarkerStream: carMarkerStream,
          eventData: eventData,
          onMapCreated: onMapCreated,
          center: center,
          centerLocation: centerLocation,
        ),
        StackTwoWidget(dropLocationMap: dropLocationMap),
        StackThreeWidget(
          bottom: bottom,
          pickaddress: pickaddress,
          changePosition: changePosition,
          addDirections: addDirections,
          pickup: pickup,
        ),
        if (bottom == 0) const StackFourWidget(),
        StackSixWidget(
          bottom: bottom,
          dropaddress: dropAddress,
          pickaddress: pickaddress,
          onChange1: onChange1,
          onChange2: () => onChange2(),
          onChange3: (String a) => onChange3(a),
          onChange4: onChange4,
          onChange5: onChange5,
          onChange6: onChange6,
          onChange7: onChange7,
        ),
        StackFiveWidget(
          bottom: bottom,
          locationAllowed: () => locationAllowed(),
        ),
      ],
    );
  }
}
