import 'package:flutter/material.dart';
import 'package:three_tapp_app/view/common_view/map/current_user_view.dart';
import 'package:three_tapp_app/view/common_view/map/address_list.dart';
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
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (BuildContext context) {
                      return MapSearchPage();
                    }));
                  },
                  child: const Text("Map Search")),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (BuildContext context) {
                      return const CurrentLocationScreen();
                    }));
                  },
                  child: const Text("AutoFill")),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (BuildContext context) {
                      return AddressListScreen();
                    }));
                  },
                  child: const Text("Address List")),
            ],
          ),
        ));
  }
}
