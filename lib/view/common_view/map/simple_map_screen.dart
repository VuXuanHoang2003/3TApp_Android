import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
class SimpleMapScreen extends StatefulWidget {
  const SimpleMapScreen({super.key});

  @override
  State<SimpleMapScreen> createState() => _SimpleMapScreenState();
}

class _SimpleMapScreenState extends State<SimpleMapScreen> {

  final Completer<GoogleMapController> _controller = Completer();

  static const CameraPosition initialPosition = CameraPosition(
    target: LatLng(16.05437, 108.24061),
    zoom: 14.5
    );

  static const CameraPosition targetPosition = CameraPosition(
    target: LatLng(16.07392, 108.14993),
    zoom: 14.0, 
    bearing: 192.0,
    tilt: 60  
    );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Simple Google Map"),
        centerTitle: true,
      ),
      body: GoogleMap(
        initialCameraPosition: initialPosition,
        mapType: MapType.normal,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          goToKinhTe();
        }, 
        label: const Text("Di den Bach Khoa"),
        icon : const Icon(Icons.directions_bike),
      )
    );
  }

  Future<void> goToKinhTe() async {
    final GoogleMapController controller =await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(targetPosition));
  }

}