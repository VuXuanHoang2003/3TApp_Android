// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:three_tapp_app/model/statistic.dart';
// import 'package:three_tapp_app/utils/image_path.dart';
// import 'package:three_tapp_app/viewmodel/statistic_viewmodel.dart';

// class StatisticScreen extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() => _StatisticScreenState();
// }

// class _StatisticScreenState extends State<StatisticScreen> {
//   @override
//   void initState() {
//     super.initState();
//     // Perform any initializations here
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           Expanded(
//             child: _buildStatisticsList(),
//           ),
//           Expanded(
//             child: _buildTable(),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildStatisticsList() {
//     return FutureBuilder<Statistic>(
//       future: StatisticViewModel().getStatisticOfCurrentUser(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(
//             child: CircularProgressIndicator(),
//           ); // Centered loading indicator.
//         } else if (snapshot.hasError) {
//           return Center(
//             child: Text(
//               'Error: ${snapshot.error}',
//               style: TextStyle(color: Colors.red),
//             ),
//           ); // Centered error message with red color.
//         } else if (!snapshot.hasData) {
//           return Center(
//             child: Text(
//               'No data available',
//               style: TextStyle(color: Colors.grey),
//             ),
//           ); // Centered message for no data with grey color.
//         } else {
//           Statistic? statisticCurrentUser = snapshot.data;

//           return Padding(
//             padding: EdgeInsets.all(16.0),
//             child: ListView(
//               children: [
//                 _buildCard(
//                   title: 'Số lượng bài đăng trên hệ thống',
//                   value: '${statisticCurrentUser?.numberOfPosts}',
//                   color: Colors.green,
//                   imagePath: ImagePath.imgUploadedPost,
//                 ),
//                 _buildCard(
//                   title: 'Giao dịch thành công',
//                   value: '${statisticCurrentUser?.numberOfSuccessfulTrade}',
//                   color: Colors.green,
//                   imagePath: ImagePath.imgSuccessfulTransaction,
//                 ),
//               ],
//             ),
//           );
//         }
//       },
//     );
//   }

//   Widget _buildCard({
//     required String title,
//     required String value,
//     required Color color,
//     required String imagePath,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Row(
//         children: [
//           CircleAvatar(
//             radius: 30.0,
//             backgroundImage: AssetImage(imagePath),
//             backgroundColor: Colors.white,
//           ),
//           SizedBox(
//               width: 16.0), // Adjust the spacing between the image and the card
//           Expanded(
//             child: Card(
//               elevation: 8.0,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10.0),
//               ),
//               child: ListTile(
//                 title: Text(
//                   '$title: $value',
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 tileColor: color,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // Widget _buildTable() {
//   //   return Center(
//   //     child: SingleChildScrollView(
//   //       scrollDirection: Axis.horizontal,
//   //       child: DataTable(
//   //         border: TableBorder.all(),
//   //         columns: const [
//   //           DataColumn(label: Text('Loại sản phẩm')),
//   //           DataColumn(label: Text('Doanh thu (đơn vị: 1000 VNĐ)')),
//   //         ],
//   //         rows: const [
//   //           DataRow(cells: [
//   //             DataCell(Text('Kim loại')),
//   //             DataCell(Text('0')),
//   //           ]),
//   //           DataRow(cells: [
//   //             DataCell(Text('Giấy')),
//   //             DataCell(Text('0')),
//   //           ]),
//   //           DataRow(cells: [
//   //             DataCell(Text('Nhựa')),
//   //             DataCell(Text('0')),
//   //           ]),
//   //           DataRow(cells: [
//   //             DataCell(Text('Thuỷ tinh')),
//   //             DataCell(Text('0')),
//   //           ]),
//   //           DataRow(cells: [
//   //             DataCell(Text('Khác')),
//   //             DataCell(Text('0')),
//   //           ]),
//   //         ],
//   //       ),
//   //     ),
//   //   );
//   // }

//   Widget _buildTable() {
//     return FutureBuilder<Statistic>(
//       future: StatisticViewModel()
//           .getStatisticOfCurrentUser(), // Assuming email is already defined
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(
//             child:
//                 CircularProgressIndicator(), // Display a loading indicator while waiting for data
//           );
//         } else if (snapshot.hasError) {
//           return Center(
//             child: Text(
//                 'Error: ${snapshot.error}'), // Display an error message if there's an error
//           );
//         } else {
//           // Data has been successfully fetched, use it to populate the DataTable
//           final statistic = snapshot.data!;
//           return Center(
//             child: SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: DataTable(
//                 border: TableBorder.all(),
//                 columns: const [
//                   DataColumn(label: Text('Loại sản phẩm')),
//                   DataColumn(label: Text('Doanh thu (đơn vị: 1000 VNĐ)')),
//                 ],
//                 rows: [
//                   DataRow(cells: [
//                     DataCell(Text('Kim loại')),
//                     DataCell(Text('${statistic.doanh_thu_kim_loai}')),
//                   ]),
//                   DataRow(cells: [
//                     DataCell(Text('Giấy')),
//                     DataCell(Text('${statistic.doanh_thu_giay}')),
//                   ]),
//                   DataRow(cells: [
//                     DataCell(Text('Nhựa')),
//                     DataCell(Text('${statistic.doanh_thu_nhua}')),
//                   ]),
//                   DataRow(cells: [
//                     DataCell(Text('Thuỷ tinh')),
//                     DataCell(Text('${statistic.doanh_thu_thuy_tinh}')),
//                   ]),
//                   DataRow(cells: [
//                     DataCell(Text('Khác')),
//                     DataCell(Text('${statistic.doanh_thu_khac}')),
//                   ]),
//                 ],
//               ),
//             ),
//           );
//         }
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:three_tapp_app/model/statistic.dart';
import 'package:three_tapp_app/utils/image_path.dart';
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildStatisticsList(),
          Expanded(
            child: _buildTable(),
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsList() {
    return FutureBuilder<Statistic>(
      future: StatisticViewModel().getStatisticOfCurrentUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error: ${snapshot.error}',
              style: TextStyle(color: Colors.red),
            ),
          );
        } else if (!snapshot.hasData) {
          return Center(
            child: Text(
              'No data available',
              style: TextStyle(color: Colors.grey),
            ),
          );
        } else {
          Statistic? statisticCurrentUser = snapshot.data;

          return Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildCard(
                  title: 'Number of posts',
                  value: '${statisticCurrentUser?.numberOfPosts}',
                  color: Colors.green,
                  imagePath: ImagePath.imgUploadedPost,
                ),
                SizedBox(height: 16.0),
                _buildCard(
                  title: 'Successful transactions',
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
    return Card(
      elevation: 8.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30.0,
              backgroundImage: AssetImage(imagePath),
              backgroundColor: Colors.white,
            ),
            SizedBox(width: 16.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8.0),
                Text(
                  value,
                  style: TextStyle(color: color),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTable() {
    return FutureBuilder<Statistic>(
      future: StatisticViewModel().getStatisticOfCurrentUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error: ${snapshot.error}',
              style: TextStyle(color: Colors.red),
            ),
          );
        } else {
          final statistic = snapshot.data!;
          return Center(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(
                      color: Colors.black), // Set border color and width
                ),
                child: DataTable(
                  headingRowColor:
                      MaterialStateColor.resolveWith((states) => Colors.green),
                  dataRowColor:
                      MaterialStateColor.resolveWith((states) => Colors.cyan),
                  dividerThickness: 2.0,
                  columns: const [
                    DataColumn(
                      label: Center(
                        child: Text(
                          'Product Type',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Center(
                        child: Text(
                          'Revenue (1000 VND)',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                  rows: [
                    DataRow(
                      cells: [
                        DataCell(
                          Center(
                            child: Text(
                              'Kim loại',
                            ),
                          ),
                        ),
                        DataCell(
                          Center(
                            child: Text(
                              '${statistic.metalRevenue}',
                            ),
                          ),
                        ),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(
                          Center(
                            child: Text(
                              'Giấy',
                            ),
                          ),
                        ),
                        DataCell(
                          Center(
                            child: Text(
                              '${statistic.paperRevenue}',
                            ),
                          ),
                        ),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(
                          Center(
                            child: Text(
                              'Nhựa',
                            ),
                          ),
                        ),
                        DataCell(
                          Center(
                            child: Text(
                              '${statistic.plasticRevenue}',
                            ),
                          ),
                        ),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(
                          Center(
                            child: Text(
                              'Thuỷ tinh',
                            ),
                          ),
                        ),
                        DataCell(
                          Center(
                            child: Text(
                              '${statistic.glassRevenue}',
                            ),
                          ),
                        ),
                      ],
                    ),
                    DataRow(
                      cells: [
                        const DataCell(
                          Center(
                            child: Text(
                              'Khác',
                            ),
                          ),
                        ),
                        DataCell(
                          Center(
                            child: Text(
                              '${statistic.otherRevenue}',
                            ),
                          ),
                        ),
                      ],
                    ),
                    DataRow(
                      cells: [
                        const DataCell(
                          Center(
                            child: Text(
                              'Tổng tiền',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        DataCell(
                          Center(
                            child: Text(
                              '${statistic.sumOfRevenues}',
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }

  DataRow _buildDataRow(String type, String revenue) {
    return DataRow(cells: [
      DataCell(Text(type)),
      DataCell(Text(revenue)),
    ]);
  }
}
