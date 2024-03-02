import '../../view/flutter_flow/flutter_flow_theme.dart';
import '../../view/flutter_flow/flutter_flow_util.dart';
import '../../view/flutter_flow/flutter_flow_widgets.dart';
import '../admin/statistic_screen.dart' show StatisticScreen;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StatisticScreenModel extends FlutterFlowModel<StatisticScreen> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // State field(s) for PaginatedDataTable widget.

  /// Initialization and disposal methods.

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }

  /// Action blocks are added here.

  /// Additional helper methods are added here.
}
