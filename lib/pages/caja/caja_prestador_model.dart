import 'dart:convert';
import 'package:flutter/material.dart';
import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart'; // Para FFAppState

class CajaPrestadorModel extends ChangeNotifier {
  DateTime? fechaDesde;
  DateTime? fechaHasta;
  int? idPrestador;
  int? idInstitucion;
  int? idUsuario;
  bool misAdmisiones = false;

  List<dynamic> cajaList = [];
  double total = 0;
  double totalCerrado = 0;
  double totalDiferencia = 0;

  bool isLoading = false;

  CajaPrestadorModel() {
    final hoy = DateTime.now();
    fechaDesde = hoy;
    fechaHasta = hoy;

idPrestador = int.tryParse(FFAppState().userData?['idPrestador'].toString() ?? '') ?? 1;
idUsuario   = int.tryParse(FFAppState().userData?['idUsuario'].toString() ?? '') ?? 1;
idInstitucion = int.tryParse(FFAppState().idInstitucionSeleccionado.toString() ?? '') ?? 1;

  }

Future<void> cargarCaja(BuildContext context) async {
  isLoading = true;
  notifyListeners();

  // Trae los valores actuales de usuario e institución seleccionados
  idInstitucion = FFAppState().idInstitucionSeleccionado;
  idUsuario = FFAppState().userData?['idUsuario'] ?? 1;

  print('🟡 [cargarCaja] INICIO');
  print('🟡 [cargarCaja] Trae usuario $idUsuario, institucion $idInstitucion');
  print('🔍 Consultando idPrestador para usuario $idUsuario, institucion $idInstitucion...');

  // 1. Consultar el idPrestador correspondiente a este usuario e institución
  var respPrestador = await GetPrestadorPorUsuarioCall.call(
    idUsuario: idUsuario!,
    idInstitucion: idInstitucion!,
  );
  print("📦 Respuesta de GetPrestadorPorUsuario: ${respPrestador.jsonBody}");

  int? idPrestadorExtraido;
  try {
    final body = respPrestador.jsonBody;
    // Si la respuesta viene en body['d']['SuccessMessage']
    if (body['d'] != null) {
      var d = body['d'];
      if (d is Map && d['SuccessMessage'] != null && d['ContainsErrors'] == false) {
        idPrestadorExtraido = int.tryParse(d['SuccessMessage'].toString());
      }
    }
  } catch (_) {
    print("❌ No se pudo obtener idPrestador: $_");
    idPrestadorExtraido = null;
  }

  print('✅ idPrestador extraído: $idPrestadorExtraido');
  idPrestador = idPrestadorExtraido ?? 0;
  print('🟢 idPrestador usado: $idPrestador');

  final fIni = fechaDesde != null
      ? "${fechaDesde!.year}-${fechaDesde!.month.toString().padLeft(2, '0')}-${fechaDesde!.day.toString().padLeft(2, '0')}"
      : '';
  final fFin = fechaHasta != null
      ? "${fechaHasta!.year}-${fechaHasta!.month.toString().padLeft(2, '0')}-${fechaHasta!.day.toString().padLeft(2, '0')}"
      : '';
  final idUser = misAdmisiones ? (idUsuario ?? 0) : 0;

  print('🟣 [cargarCaja] Consultando caja con idPrestador: $idPrestador, idUsuario: $idUsuario, idInstitucion: $idInstitucion');

  final response = await CajaPrestadorCall.call(
    idPrestador: idPrestador ?? 0,
    idInstitucion: idInstitucion ?? 0,
    fIni: fIni,
    fFin: fFin,
    idUsuario: idUser,
  );

  print("📦 Respuesta de CajaPrestadorCall: ${response.jsonBody}");

  // Ajuste robusto: parsear SuccessMessage y devolver [] si hay cualquier problema
  final respJson = response.jsonBody;
  final ok = respJson['d'] != null &&
      respJson['d']['ContainsErrors'] == false;
  final msg = respJson['d']?['SuccessMessage'];

  cajaList = [];
  if (ok && msg != null) {
    try {
      final parsed = jsonDecode(msg);
      if (parsed is List) {
        print("✅ Caja parseada, ${parsed.length} registros.");
        cajaList = parsed;
        agruparPorObraSocial(); // <-- ACA agrupás la lista recibida
      }
    } catch (e) {
      print("❗ Error al parsear caja: $e");
      cajaList = [];
    }
  } else {
    print("❗ La llamada a CajaPrestadorCall retornó error: ${respJson['d']?['ErrorMessage']}");
  }
  calcularTotales();
  print('🟢 [cargarCaja] Totales recalculados. Caja tiene ${cajaList.length} elementos.');
  isLoading = false;
  notifyListeners();

  print('🟡 [cargarCaja] FIN - Datos traídos: ${cajaList.length} resultados');
}

void agruparPorObraSocial() {
  // Agrupa por 'ObraSocial'
  Map<String, List<dynamic>> agrupados = {};
  for (final item in cajaList) {
    final nombre = (item['ObraSocial'] ?? 'Obra Social').toString().trim();
    if (!agrupados.containsKey(nombre)) agrupados[nombre] = [];
    agrupados[nombre]!.add(item);
  }

  // Convierte el map en una lista del formato esperado por la vista
  List<Map<String, dynamic>> agrupadosList = [];
  agrupados.forEach((obra, practicas) {
    final subtotal = practicas.fold<double>(
      0,
      (a, b) => a + (double.tryParse(b['Importe'].toString()) ?? 0),
    );
    agrupadosList.add({
      'Nombre': obra,
      'Practicas': practicas,
      'SubTotal': subtotal,
    });
  });

  cajaList = agrupadosList;
}


void calcularTotales() {
  total = 0;
  totalCerrado = 0;
  totalDiferencia = 0;
  for (var os in cajaList) {
    final practicas = os['Practicas'] as List<dynamic>? ?? [];
    for (var p in practicas) {
      final importe = double.tryParse(p['Importe'].toString()) ?? 0;
      total += importe;
      if ((p['Usuario'] ?? '').toString().isNotEmpty) {
        totalCerrado += importe;
      }
    }
  }
  totalDiferencia = total - totalCerrado;
}


  Future<String> cerrarCaja(BuildContext context, List<int> idEstudioTurnos) async {
    idUsuario = FFAppState().userData?['idUsuario'] ?? 1;
    final response = await CerrarCajaCall.call(
      idUsuario: idUsuario ?? 0,
      idEstudioTurnos: idEstudioTurnos,
    );

    final respJson = response.jsonBody;
    final ok = respJson['ContainsErrors'] == false;
    final msg = respJson['SuccessMessage'];
    if (ok && msg != null) {
      try {
        final parsed = jsonDecode(msg);
        return parsed.toString();
      } catch (_) {
        return msg.toString();
      }
    } else {
      final err = respJson['ErrorMessage'];
      return err != null ? err.toString() : "Error desconocido";
    }
  }
}
