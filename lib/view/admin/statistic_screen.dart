import 'package:flutter/material.dart';
import 'package:three_tapp_app/model/statistic.dart';
import 'package:three_tapp_app/utils/image_path.dart';
import 'package:three_tapp_app/viewmodel/statistic_viewmodel.dart';
import '../../view/flutter_flow/flutter_flow.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/statistic_screen_model.dart';

class StatisticScreen extends StatefulWidget {
  const StatisticScreen({super.key});
  @override
  State<StatefulWidget> createState() => _StatisticScreenState();
}

class _StatisticScreenState extends State<StatisticScreen> {
  Future<Statistic> statisticUser =
      StatisticViewModel().getStatisticOfCurrentUser();
  late StatisticScreenModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => StatisticScreenModel());
    statisticUser = StatisticViewModel().getStatisticOfCurrentUser();
  }

  Widget build(BuildContext context) {
    return FutureBuilder<Statistic>(
      future: statisticUser,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error: ${snapshot.error}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        } else if (!snapshot.hasData) {
          return const Center(
            child: Text(
              'No data available',
              style: TextStyle(color: Colors.grey),
            ),
          );
        } else {
          Statistic? statisticCurrentUser = snapshot.data;

          return Padding(
              padding: const EdgeInsets.all(16.0),
              child: GestureDetector(
                onTap: () => _model.unfocusNode.canRequestFocus
                    ? FocusScope.of(context).requestFocus(_model.unfocusNode)
                    : FocusScope.of(context).unfocus(),
                child: Scaffold(
                  key: scaffoldKey,
                  body: SafeArea(
                    top: true,
                    child: Stack(
                      children: [
                        Align(
                          alignment: const AlignmentDirectional(0.03, -0.86),
                          child: Container(
                            width: 376,
                            height: 145,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .secondaryBackground,
                            ),
                            child: Container(
                              height: 101,
                              child: Stack(
                                children: [
                                  Align(
                                    alignment:
                                        const AlignmentDirectional(-0.86, -0.45),
                                    child: Text(
                                      'Số giao dịch thành công:',
                                      textAlign: TextAlign.start,
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium,
                                    ),
                                  ),
                                  Align(
                                    alignment:
                                        const AlignmentDirectional(0.54, -0.89),
                                    child: Text(
                                      statisticCurrentUser!.numberOfPosts
                                          .toString(),
                                      textAlign: TextAlign.center,
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium,
                                    ),
                                  ),
                                  Align(
                                    alignment:
                                        const AlignmentDirectional(-0.87, -0.9),
                                    child: Text(
                                      'Số sản phẩm đã đăng: ',
                                      textAlign: TextAlign.start,
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium,
                                    ),
                                  ),
                                  Align(
                                    alignment:
                                        const AlignmentDirectional(0.54, -0.43),
                                    child: Text(
                                      statisticCurrentUser!
                                          .numberOfSuccessfulTrade
                                          .toString(),
                                      textAlign: TextAlign.center,
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: const AlignmentDirectional(-0.02, -0.97),
                          child: Text(
                            'Dashboard',
                            style: FlutterFlowTheme.of(context).bodyMedium,
                          ),
                        ),
                        Align(
                          alignment: const AlignmentDirectional(0.01, -0.34),
                          child: Text(
                            'Doanh thu',
                            style: FlutterFlowTheme.of(context).bodyMedium,
                          ),
                        ),
                        Align(
                          alignment: const AlignmentDirectional(0, 1),
                          child: Container(
                              width: 397,
                              height: 448,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                              ),
                              child: // Generated code for this Column Widget...
                                  Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Stack(
                                    children: [
                                      Align(
                                        alignment:
                                            const AlignmentDirectional(-0.61, 0),
                                        child: Text(
                                          'Loại sản phẩm',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: 'Readex Pro',
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                      ),
                                      Align(
                                        alignment:
                                            const AlignmentDirectional(0.52, 0),
                                        child: Text(
                                          'Doanh thu',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: 'Readex Pro',
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Stack(
                                      children: [
                                        Align(
                                          alignment:
                                              const AlignmentDirectional(-0.63, 0),
                                          child: Text(
                                            'Giấy',
                                            textAlign: TextAlign.start,
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium,
                                          ),
                                        ),
                                        Align(
                                          alignment:
                                              const AlignmentDirectional(0.49, 0),
                                          child: Text(
                                            statisticCurrentUser.paperRevenue
                                                .toString(),
                                            textAlign: TextAlign.end,
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Stack(
                                      children: [
                                        Align(
                                          alignment:
                                              const AlignmentDirectional(-0.63, 0),
                                          child: Text(
                                            'Nhựa',
                                            textAlign: TextAlign.start,
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium,
                                          ),
                                        ),
                                        Align(
                                          alignment:
                                              const AlignmentDirectional(0.49, 0),
                                          child: Text(
                                            statisticCurrentUser.plasticRevenue
                                                .toString(),
                                            textAlign: TextAlign.end,
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Stack(
                                      children: [
                                        Align(
                                          alignment:
                                              const AlignmentDirectional(-0.63, 0),
                                          child: Text(
                                            'Kim loại',
                                            textAlign: TextAlign.start,
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium,
                                          ),
                                        ),
                                        Align(
                                          alignment:
                                              const AlignmentDirectional(0.49, 0),
                                          child: Text(
                                            statisticCurrentUser.metalRevenue
                                                .toString(),
                                            textAlign: TextAlign.end,
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Stack(
                                      children: [
                                        Align(
                                          alignment:
                                              const AlignmentDirectional(-0.63, 0),
                                          child: Text(
                                            'Thuỷ tinh',
                                            textAlign: TextAlign.start,
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium,
                                          ),
                                        ),
                                        Align(
                                          alignment:
                                              const AlignmentDirectional(0.49, 0),
                                          child: Text(
                                            statisticCurrentUser.glassRevenue
                                                .toString(),
                                            textAlign: TextAlign.end,
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Stack(
                                      children: [
                                        Align(
                                          alignment:
                                              const AlignmentDirectional(-0.63, 0),
                                          child: Text(
                                            'Khác',
                                            textAlign: TextAlign.start,
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium,
                                          ),
                                        ),
                                        Align(
                                          alignment:
                                              const AlignmentDirectional(0.49, 0),
                                          child: Text(
                                            statisticCurrentUser.otherRevenue
                                                .toString(),
                                            textAlign: TextAlign.end,
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Stack(
                                      children: [
                                        Align(
                                          alignment:
                                              const AlignmentDirectional(-0.63, 0),
                                          child: Text(
                                            'Tổng tiền',
                                            textAlign: TextAlign.start,
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily: 'Readex Pro',
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                        ),
                                        Align(
                                          alignment:
                                              const AlignmentDirectional(0.49, 0),
                                          child: Text(
                                            statisticCurrentUser.sumOfRevenues
                                                .toString(),
                                            textAlign: TextAlign.end,
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily: 'Readex Pro',
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
              ));
        }
      },
    );
  }
}
