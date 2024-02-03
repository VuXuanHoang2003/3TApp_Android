import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

class MapSearchPage extends StatefulWidget {
  @override
  _MapSearchPageState createState() => _MapSearchPageState();
}

class _MapSearchPageState extends State<MapSearchPage> {
  TextEditingController searchController = TextEditingController();

void searchAndNavigate(BuildContext context) async {
  String searchText = searchController.text;
  if (searchText.isEmpty) {
    return;
  }
  try {
    List<Location> locations = await locationFromAddress(searchText);
    if (locations.isNotEmpty) {
      double latitude = locations.first.latitude;
      double longitude = locations.first.longitude;
      String mapUrl = "https://www.google.com/maps/search/?api=1&query=$latitude,$longitude";
      // Convert the URL string to a Uri object
      Uri uri = Uri.parse(mapUrl);
      // Check if the Google Maps app is installed
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        Fluttertoast.showToast(msg: "Ứng dụng Google Maps không được cài đặt");
      }
    } else {
      Fluttertoast.showToast(msg: "Không tìm thấy địa chỉ");
    }
  } catch (error) {
    Fluttertoast.showToast(msg: "Không tìm thấy địa chỉ");
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Google SearchMap')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Nhập địa chỉ cần tìm',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () => searchAndNavigate(context),
                ),
              ),
              onSubmitted: (value) => searchAndNavigate(context),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => searchAndNavigate(context),
              child: Text('Tìm kiếm'),
            ),
          ],
        ),
      ),
    );
  }
}
