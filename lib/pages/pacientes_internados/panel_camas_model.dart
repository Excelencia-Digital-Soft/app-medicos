import 'dart:convert';
import 'package:flutter/material.dart';
import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';

class PanelCamasModel extends ChangeNotifier {
  int? idInstitucion;
  int? idUsuario;
  List<dynamic> camas = [];
  bool isLoading = false;
  String? errorMsg;

  PanelCamasModel() {
    try {
      idInstitucion = int.tryParse(FFAppState().idInstitucionSeleccionado.toString() ?? '') ?? 1;
      idUsuario = int.tryParse(FFAppState().userData?['idUsuario'].toString() ?? '') ?? 1;
      debugPrint('[PanelCamasModel] Instanciado. idInstitucion=$idInstitucion idUsuario=$idUsuario');
    } catch (e) {
      debugPrint('[PanelCamasModel] ERROR en constructor: $e');
    }
  }

  Future<void> cargarCamas(BuildContext context) async {
    debugPrint('[PanelCamasModel] === INICIANDO cargarCamas ===');
    isLoading = true;
    errorMsg = null;
    notifyListeners();

    try {
      idInstitucion = FFAppState().idInstitucionSeleccionado;
      idUsuario = FFAppState().userData?['idUsuario'] ?? 1;
      debugPrint('[PanelCamasModel] usando idInstitucion=$idInstitucion idUsuario=$idUsuario');

      final response = await GetPanelCamasAppCall.call(
        idInstitucion: idInstitucion ?? 1,
        idUsuario: idUsuario ?? 1,
      );

      debugPrint('[PanelCamasModel] respuesta cruda de la API: ${response.jsonBody}');

      final respJson = response.jsonBody;
      if (respJson == null) {
        debugPrint('[PanelCamasModel] Respuesta nula de la API');
        camas = [];
        errorMsg = "Respuesta vacía del servidor.";
        isLoading = false;
        notifyListeners();
        return;
      }

      final d = respJson['d'];
      final containsErrors = d != null && d['ContainsErrors'] == true;
      final msg = d?['SuccessMessage'] ?? d?['Message'] ?? null;
      debugPrint('[PanelCamasModel] containsErrors=$containsErrors, msg=${msg?.substring(0, (msg.length < 300) ? msg.length : 300)}');

      if (!containsErrors && msg != null) {
        try {
          final parsed = jsonDecode(msg);
          if (parsed is List) {
            camas = parsed;
            debugPrint('[PanelCamasModel] Camas parseadas OK. Total: ${camas.length}');
          } else {
            debugPrint('[PanelCamasModel] El JSON parseado NO es lista. $parsed');
            camas = [];
            errorMsg = "Respuesta inesperada: no es lista de camas.";
          }
        } catch (e) {
          debugPrint('[PanelCamasModel] ERROR al parsear JSON: $e');
          camas = [];
          errorMsg = "Error al parsear los datos de camas.";
        }
      } else {
        debugPrint('[PanelCamasModel] ERROR API: ${d?['ErrorMessage']}');
        camas = [];
        errorMsg = d?['ErrorMessage'] ?? "No se pudo traer los datos de camas.";
      }
    } catch (e) {
      debugPrint('[PanelCamasModel] CATCH ERROR: $e');
      camas = [];
      errorMsg = "Error de conexión: $e";
    }

    isLoading = false;
    debugPrint('[PanelCamasModel] === FIN cargarCamas (camas: ${camas.length}, errorMsg: $errorMsg) ===');
    notifyListeners();
  }
}
