import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class StackOneWidget extends StatelessWidget {
  final Query fdb;
  final List<Marker> myMarkers;
  final Function(dynamic event) eventData;
  final Stream<List<Marker>>? carMarkerStream;
  final Function(GoogleMapController)? onMapCreated;
  final Function(CameraPosition) centerLocation;
  final Function() cameraIdle;
  final LatLng center;

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
          return StreamBuilder<List<Marker>>(
            stream: carMarkerStream,
            builder: (context, snapshot) {
              return GoogleMap(
                mapType: MapType.normal,
                onMapCreated: onMapCreated,
                compassEnabled: false,
                initialCameraPosition: CameraPosition(
                  target: center,
                  zoom: 14.0,
                ),
                onCameraMove: centerLocation,
                onCameraIdle: () => cameraIdle(),
                minMaxZoomPreference: const MinMaxZoomPreference(8.0, 20.0),
                myLocationButtonEnabled: false,
                markers: Set<Marker>.from(myMarkers),
                buildingsEnabled: false,
                zoomControlsEnabled: false,
                myLocationEnabled: true,
              );
            },
          );
        },
      ),
    );
  }
}
