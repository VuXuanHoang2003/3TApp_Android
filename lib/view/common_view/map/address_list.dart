import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:location/location.dart'; // Import location package
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

class AddressListScreen extends StatefulWidget {
  @override
  _AddressListScreenState createState() => _AddressListScreenState();
}

class _AddressListScreenState extends State<AddressListScreen> {
  late Future<QuerySnapshot<Map<String, dynamic>>> _usersCollection;
  late Position _currentPosition;

  @override
  void initState() {
    super.initState();
    _usersCollection = FirebaseFirestore.instance.collection('USERS').get();
    _getCurrentLocation();
  }

  void _onAddressTapped(String address) async {
    try {
      Location location = Location();
      Map<String, double> coordinates = await location.locationFromAddress(address);
      double latitude = coordinates['latitude']!;
      double longitude = coordinates['longitude']!;
      double distance = _calculateDistance(latitude, longitude);

      Fluttertoast.showToast(
        msg: 'Address: $address\nDistance: ${distance.toStringAsFixed(2)} km from your location',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.blue,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } catch (e) {
      print(e);
      Fluttertoast.showToast(
        msg: 'Error finding location for the address',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  void _openGoogleMaps(double latitude, double longitude) async {
    String googleMapsUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(googleMapsUrl)) {
      await launch(googleMapsUrl);
    } else {
      Fluttertoast.showToast(
        msg: 'Could not open Google Maps',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  void _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentPosition = position;
      });
    } catch (e) {
      print(e);
    }
  }

  double _calculateDistance(double latitude, double longitude) {
    if (_currentPosition.latitude == null ||
        _currentPosition.longitude == null) {
      return 0.0;
    }

    double distanceInMeters = Geolocator.distanceBetween(
      _currentPosition.latitude!,
      _currentPosition.longitude!,
      latitude,
      longitude,
    );

    return distanceInMeters / 1000.0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Addresses'),
      ),
      body: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
        future: _usersCollection,
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<String> addresses = [];
            snapshot.data!.docs.forEach(
                (DocumentSnapshot<Map<String, dynamic>> document) {
              final address = document.data()!['address'] as String;
              addresses.add(address);
            });
            return ListView.builder(
              itemCount: addresses.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(addresses[index]),
                  onTap: () {
                    _onAddressTapped(addresses[index]);
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: AddressListScreen(),
  ));
}
