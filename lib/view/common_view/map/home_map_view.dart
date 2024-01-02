import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:three_tapp_app/view/common_view/map/current_user_view.dart';
import 'package:three_tapp_app/view/common_view/map/search_places_view.dart';
import 'package:three_tapp_app/view/common_view/map/simple_map_screen.dart';

class MapSample extends StatefulWidget {
  const MapSample({super.key});

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Google Maps"),
        centerTitle: true,
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            ElevatedButton(onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                return const SimpleMapScreen();
              }));
            }, child: const Text("Simple Map")),
            ElevatedButton(onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                return const CurrentLocationScreen();
              }));
            }, child: const Text("User current location")),
                        ElevatedButton(onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                return const SearchPlaceView();
              }));
            }, child: const Text("Search Map")),
          ],
        ),
      )
    );
  }
}