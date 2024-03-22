import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';
import '../../customer/order/order_per_person_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Trang chính hiển thị danh sách địa chỉ
class AddressListScreen extends StatefulWidget {
  @override
  _AddressListScreenState createState() => _AddressListScreenState();
}

class _AddressListScreenState extends State<AddressListScreen> {
  late Future<QuerySnapshot<Map<String, dynamic>>> _usersCollection;
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _usersCollection = FirebaseFirestore.instance.collection('USERS').get();
    _getCurrentLocation();
  }

  void _getCurrentLocation() async {
    try {
      Position position = await _determinePosition();
      setState(() {
        _currentPosition = position;
      });
    } catch (e) {
      print("Error getting current location: $e");
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error("Location services are not enabled");
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        return Future.error("Location permission denied");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error("Location permission are pernmanently denied");
    }

    Position position = await Geolocator.getCurrentPosition();
    return position;
  }

  void _onAddressTapped(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty && _currentPosition != null) {
        Location destinationLocation = locations.first;
        double distanceInMeters = await Geolocator.distanceBetween(
          _currentPosition!.latitude,
          _currentPosition!.longitude,
          destinationLocation.latitude,
          destinationLocation.longitude,
        );
        double distanceInKm = distanceInMeters / 1000;
        Fluttertoast.showToast(
          msg:
              '${AppLocalizations.of(context)?.distanceMsg} $address: ${distanceInKm.toStringAsFixed(2)} km',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        double latitude = destinationLocation.latitude;
        double longitude = destinationLocation.longitude;
        _openGoogleMaps(latitude, longitude);
      } else {
        Fluttertoast.showToast(
          msg: '${AppLocalizations.of(context)?.addressMsg}',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } catch (e) {
      print("Error processing address tap: $e");
    }
  }

  void _openGoogleMaps(double latitude, double longitude) async {
    String googleMapsUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(googleMapsUrl)) {
      await launch(googleMapsUrl);
    } else {
      Fluttertoast.showToast(
        msg: '${AppLocalizations.of(context)?.googleMapMsg}',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh sách người dùng theo địa chỉ'),
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
            List<String> addresses = snapshot.data!.docs
                .map((document) => document.data()['address'] as String)
                .toList();
            return _buildAddressList(addresses);
          }
        },
      ),
    );
  }

  Widget _buildAddressList(List<String> addresses) {
    return FutureBuilder<List<String>>(
      future: _sortAddressesByProximity(addresses),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          List<String> sortedAddresses = snapshot.data ?? [];
          return ListView.builder(
            itemCount: sortedAddresses.length,
            itemBuilder: (context, index) {
              return _buildListTile(sortedAddresses, index);
            },
          );
        }
      },
    );
  }

  Widget _buildListTile(List<String> sortedAddresses, int index) {
    return FutureBuilder<Location>(
      future: _currentPosition != null
          ? locationFromAddress(sortedAddresses[index])
              .then((locations) => locations.first)
          : null,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return ListTile(title: Text('Loading...'));
        } else if (snapshot.hasError) {
          return ListTile(title: Text('Error loading location'));
        } else if (snapshot.hasData) {
          Location destinationLocation = snapshot.data!;
          double distanceInMeters = Geolocator.distanceBetween(
            _currentPosition!.latitude,
            _currentPosition!.longitude,
            destinationLocation.latitude,
            destinationLocation.longitude,
          );
          double distanceInKm = distanceInMeters / 1000;
          return Card(
            child: ListTile(
              title: Text(sortedAddresses[index]),
              subtitle: Text(
                  '${AppLocalizations.of(context)?.distance}: ${distanceInKm.toStringAsFixed(2)} km'),
              leading: Icon(Icons.location_on),
              trailing: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          OrderPerPersonScreen(address: sortedAddresses[index]),
                    ),
                  );
                },
                child: Text('${AppLocalizations.of(context)?.viewOrder}'),
              ),
              onTap: () {
                _onAddressTapped(sortedAddresses[index]);
              },
            ),
          );
        } else {
          return ListTile(
              title: Text('${AppLocalizations.of(context)?.loading}'));
        }
      },
    );
  }

  Future<List<String>> _sortAddressesByProximity(List<String> addresses) async {
    try {
      if (_currentPosition != null) {
        List<Map<String, dynamic>> addressDetails = [];
        for (String address in addresses) {
          List<Location> locations = await locationFromAddress(address);
          if (locations.isNotEmpty) {
            Location location = locations.first;
            double distanceInMeters = Geolocator.distanceBetween(
                _currentPosition!.latitude,
                _currentPosition!.longitude,
                location.latitude,
                location.longitude);
            double distanceInKm = distanceInMeters / 1000;
            addressDetails.add({
              'address': address,
              'distanceInKm': distanceInKm,
            });
          }
        }
        addressDetails.sort((a, b) => (a['distanceInKm'] as double)
            .compareTo(b['distanceInKm'] as double));
        return addressDetails
            .map((details) => details['address'] as String)
            .toList();
      } else {
        return addresses;
      }
    } catch (e) {
      print("Error sorting addresses by proximity: $e");
      return addresses;
    }
  }
}

void main() {
  runApp(MaterialApp(
    home: AddressListScreen(),
  ));
}
