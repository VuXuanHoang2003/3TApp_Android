import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:google_api_headers/google_api_headers.dart';

class SearchPlaceView extends StatefulWidget {
  const SearchPlaceView({super.key});

  @override
  State<SearchPlaceView> createState() => _SearchPlaceViewState();
}

const kGoogleApiKey = 'AIzaSyB80-J-FKtoXDTVuDJTKpXwizAcVub4OZY';
final GlobalKey<ScaffoldState> homeScaffoldKey = GlobalKey<ScaffoldState>();

class _SearchPlaceViewState extends State<SearchPlaceView> {
  static const CameraPosition initialCameraPosition = CameraPosition(target: LatLng(18.03, 108.05), zoom : 14.0);
  Set <Marker> markerList = {};
  late GoogleMapController googleMapController;
  final _mode = Mode.overlay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: homeScaffoldKey, 
      appBar: AppBar(
        title : const Text("Google Search Place"),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: initialCameraPosition, 
            markers: markerList, 
            mapType: MapType.normal, 
            onMapCreated: (GoogleMapController controller) {
              googleMapController = controller;
          }
          ),
          ElevatedButton(onPressed: _handlePressButton, child: const Text("Search Places"))
        ],
      ),
    );
  }

  Future<void> _handlePressButton() async {
    Prediction? p = await PlacesAutocomplete.show(
      context: context, 
      apiKey: kGoogleApiKey, 
      onError: onError, 
      mode: _mode, 
      language: 'en', 
      strictbounds: false, 
      types: [""], 
      decoration: InputDecoration(
        hintText: 'Search',
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Colors.white))),
      components: [Component(Component.country, "pk")]);

    displayPrediction(p!, homeScaffoldKey.currentState);
  }

void onError(PlacesAutocompleteResponse response) {
  if (response.errorMessage != null && homeScaffoldKey.currentState != null) {
    ScaffoldMessenger.of(homeScaffoldKey.currentContext!).showSnackBar(
      SnackBar(content: Text(response.errorMessage!)),
    );
  }
}

Future<void> displayPrediction(Prediction p, ScaffoldState? currentState) async {

  GoogleMapsPlaces places = GoogleMapsPlaces(
    apiKey: kGoogleApiKey,
    apiHeaders: await const GoogleApiHeaders().getHeaders()
  );

  PlacesDetailsResponse detail = await places.getDetailsByPlaceId(p.placeId!);

  final lat = detail.result.geometry!.location.lat;
  final lng = detail.result.geometry!.location.lng;

  markerList.clear();
  markerList.add(Marker(markerId: const MarkerId("0"), position: LatLng(lat,lng), infoWindow: InfoWindow(title: detail.result.name)));

  setState(() {});

  googleMapController.animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat, lng), 14.0));
  }
}