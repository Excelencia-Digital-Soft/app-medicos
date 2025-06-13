import '/backend/api_requests/api_calls.dart';
import '/components/neo_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/index.dart';
import 'evolucion_scan_q_r_widget.dart' show EvolucionScanQRWidget;
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class EvolucionScanQRModel extends FlutterFlowModel<EvolucionScanQRWidget> {
  ///  State fields for stateful widgets in this page.

  var valorQR = '';
  // Stores action output result for [Custom Action - verifiedQRCode] action in Button widget.
  int? verifiedQR;
  // Stores action output result for [Backend Call - API (EvolucionesDiarias)] action in Button widget.
  ApiCallResponse? apiResultppx;
  // Stores action output result for [Backend Call - API (EvolucionesDiarias)] action in Button widget.
  ApiCallResponse? apiResultppxCopy;
  bool isLoading = false; // Añadir estado de carga

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}