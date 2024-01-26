import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:three_tapp_app/model/product.dart';
import 'package:three_tapp_app/model/statistic.dart';
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
    // Thực hiện các tác vụ khởi tạo cần thiết ở đây (nếu có).
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thống kê người dùng'),
      ),
      body: _buildStatisticsList(),
    );
  }

  Widget _buildStatisticsList() {
    return FutureBuilder<Statistic>(
      future: StatisticViewModel().getStatisticOfCurrentUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // Show a loading indicator.
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData) {
          return const Text('No data available');
        } else {
          Statistic? statisticCurrentUser = snapshot.data;

          return ListView.builder(
            itemCount: 1,
            itemBuilder: (context, index) {
              return ListTile(
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Số bài đăng: ${statisticCurrentUser?.numberOfPosts}'),
                    Text(
                        'Số giao dịch thành công: ${statisticCurrentUser?.numberOfSuccessfulTrade}'),
                  ],
                ),
                // You can add more information or actions here.
              );
            },
          );
        }
      },
    );
  }
}
