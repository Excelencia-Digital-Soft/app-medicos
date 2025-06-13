import '/backend/api_requests/api_calls.dart';
import '/components/neo_widget.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:math';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import 'ambulatorio_widget.dart' show AmbulatorioWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class AmbulatorioModel extends FlutterFlowModel<AmbulatorioWidget> {
  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - API (ListaPacientesLlamados)] action in Container widget.
  ApiCallResponse? apiResultmnz;
  // Stores action output result for [Custom Action - getTurnoCercano] action in Container widget.
  int? idTurnoAction;
  // Stores action output result for [Backend Call - API (LlamarPaciente)] action in Container widget.
  ApiCallResponse? apiResultrsu;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
