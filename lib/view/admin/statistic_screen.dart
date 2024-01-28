import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:three_tapp_app/model/product.dart';
import 'package:three_tapp_app/model/statistic.dart';
import 'package:three_tapp_app/utils/image_path.dart';
import 'package:three_tapp_app/viewmodel/product_viewmodel.dart';
import 'package:three_tapp_app/viewmodel/statistic_viewmodel.dart';

class StatisticScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _StatisticScreenState();
}

class _StatisticScreenState extends State<StatisticScreen> {
  @override
  void initState() {
    super.initState();
    // Perform any initializations here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildStatisticsList(),
    );
  }

  Widget _buildStatisticsList() {
    return FutureBuilder<Statistic>(
      future: StatisticViewModel().getStatisticOfCurrentUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          ); // Centered loading indicator.
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error: ${snapshot.error}',
              style: TextStyle(color: Colors.red),
            ),
          ); // Centered error message with red color.
        } else if (!snapshot.hasData) {
          return Center(
            child: Text(
              'No data available',
              style: TextStyle(color: Colors.grey),
            ),
          ); // Centered message for no data with grey color.
        } else {
          Statistic? statisticCurrentUser = snapshot.data;

          return Padding(
            padding: EdgeInsets.all(16.0),
            child: ListView(
              children: [
                _buildCard(
                  title: 'Số lượng bài đăng trên hệ thống',
                  value: '${statisticCurrentUser?.numberOfPosts}',
                  color: Colors.green,
                  imagePath: ImagePath.imgUploadedPost,
                ),
                _buildCard(
                  title: 'Giao dịch thành công: ',
                  value: '${statisticCurrentUser?.numberOfSuccessfulTrade}',
                  color: Colors.green,
                  imagePath: ImagePath.imgSuccessfulTransaction,
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Widget _buildCard({
    required String title,
    required String value,
    required Color color,
    required String imagePath,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30.0,
            backgroundImage: AssetImage(imagePath),
          ),
          SizedBox(
              width: 16.0), // Adjust the spacing between the image and the card
          Expanded(
            child: Card(
              elevation: 8.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: ListTile(
                title: Text(
                  '$title: $value',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                tileColor: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
