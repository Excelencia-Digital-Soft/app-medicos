import '/backend/api_requests/api_calls.dart';
import '/components/empty_list_widget.dart';
import '/components/neo_widget.dart';
import '/flutter_flow/flutter_flow_choice_chips.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import 'paciente_widget.dart' show PacienteWidget;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:permission_handler/permission_handler.dart';

class PacienteModel extends FlutterFlowModel<PacienteWidget> {
  /// State fields for stateful widgets in this page.
  final formKey = GlobalKey<FormState>();

  int? idDatArquetipo;
  int? idMaArquetipo;

  // State field(s) for ChoiceChips widget.
  FormFieldController<List<String>>? choiceChipsValueController;
  String? get choiceChipsValue => choiceChipsValueController?.value?.firstOrNull;
  set choiceChipsValue(String? val) =>
      choiceChipsValueController?.value = val != null ? [val] : [];

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  String? _textControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Campo requerido';
    }
    if (val.length < 5) {
      return 'Requiere al menos 5 caracteres';
    }
    return null;
  }

  // Stores action output result for [Backend Call - API (AgregarEvolucion)] action in Button widget.
  ApiCallResponse? apiResultbbk;

  // Stores action output result for [Backend Call - API (EvolucionesDiarias)] action in Button widget.
  ApiCallResponse? apiResultppx2;

  // Speech to Text
  SpeechToText speechToText = SpeechToText();
  bool isSpeechEnabled = false;
  bool isListening = false;
  bool isProcessing = false;
  String recognizedText = '';
  int errorNoMatchCount = 0;
  String lastProcessedText = '';

  Future<bool> requestMicrophonePermission(BuildContext context) async {
    print('Solicitando permisos de micrófono');
    var status = await Permission.microphone.status;
    if (status.isDenied) {
      status = await Permission.microphone.request();
    }
    if (status.isPermanentlyDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Por favor, habilitá el permiso del micrófono en la configuración.'),
          action: SnackBarAction(
            label: 'Configuración',
            onPressed: () => openAppSettings(),
          ),
        ),
      );
      return false;
    } else if (!status.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Necesito el permiso del micrófono para continuar.')),
      );
      return false;
    }
    return true;
  }

  Future<String> getPreferredLocale() async {
    final locales = await speechToText.locales();
    final selectedLocaleObj = locales.firstWhere(
      (locale) => locale.localeId.contains('es_AR'),
      orElse: () => LocaleName('es_ES', 'Spanish (Spain)'),
    );
    final selectedLocale = selectedLocaleObj.localeId;
    print('Locale seleccionado: $selectedLocale');
    return selectedLocale;
  }

  @override
  void initState(BuildContext? context) {
    textControllerValidator = _textControllerValidator;
  }

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();
    speechToText.stop();
    speechToText.cancel();
  }
}
