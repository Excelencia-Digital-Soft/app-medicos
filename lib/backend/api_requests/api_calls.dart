import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';

import '/flutter_flow/flutter_flow_util.dart';
import '_/api_manager.dart';

export '_/api_manager.dart' show ApiCallResponse;

const _kPrivateApiFunctionName = 'ffPrivateApiCall';

class LoginMobileCall {
  static Future<ApiCallResponse> call({
    String? user = '',
    String? password = '',
  }) async {
    final ffApiRequestBody = '''
    {
      "usuario": "$user",
      "password": "$password"
    }''';
    return ApiManager.instance.makeApiCall(
      callName: 'LoginMobile',
      apiUrl: 'https://excelenciadigital.online/hcweb/WsScript.asmx/LoginMobileApp',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json', // O 'text/xml' si el ASMX lo requiere.
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON, // O BodyType.TEXT si lo necesita.
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}


class EvolucionesDiariasCall {
  static Future<ApiCallResponse> call({
    int? idInstitucionM,
    int? idCamaM,
  }) async {
    final ffApiRequestBody = '''
<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <GetPacienteEvolucionMobile xmlns="http://tempuri.org/">
      <idInstitucion>${idInstitucionM}</idInstitucion> <!-- Reemplaza con el ID real de la institución -->
      <idCama>${idCamaM}</idCama> <!-- Reemplaza con el ID real de la cama -->
    </GetPacienteEvolucionMobile>
  </soap:Body>
</soap:Envelope>''';
    return ApiManager.instance.makeApiCall(
      callName: 'EvolucionesDiarias',
      apiUrl:
          'https://excelenciadigital.online/hcweb/WS.asmx?op=GetPacienteEvolucionMobile',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'text/xml; charset=utf-8',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.TEXT,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class InternadoGetValoresArquetipoCall {
  static Future<ApiCallResponse> call({
    required int idInternado,
    required int idMA,
  }) async {
    final ffApiRequestBody = '''
    {
      "idInternado": $idInternado,
      "IDMA": $idMA
    }
    ''';

    return ApiManager.instance.makeApiCall(
      callName: 'InternadoGetValoresArquetipo',
      apiUrl: 'https://excelenciadigital.online/hcweb/WebService.asmx/InternadoGetValoresArquetipo',
      callType: ApiCallType.POST,
      headers: {'Content-Type': 'application/json'},
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}


class GetValoresArquetipoCall {
  static Future<ApiCallResponse> call({
    required int idInternado,
    required int idma,
  }) async {
    final ffApiRequestBody = '''
<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <InternadoGetValoresArquetipo xmlns="http://tempuri.org/">
      <idInternado>${idInternado}</idInternado>
      <IDMA>${idma}</IDMA>
    </InternadoGetValoresArquetipo>
  </soap:Body>
</soap:Envelope>''';

    return ApiManager.instance.makeApiCall(
      callName: 'GetValoresArquetipo',
      apiUrl: 'https://excelenciadigital.online/hcweb/WebService.asmx?op=InternadoGetValoresArquetipo',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'text/xml; charset=utf-8',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.TEXT,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class AgregarEvolucionPanelCamasCall {
  static Future<ApiCallResponse> call({
    required int idInternadoPases,
    required int idPrestador,
    DateTime? fechaHora,
    required int iddat,   // IDDAT de Evolución Diaria, obtenido dinámicamente
    required String valor, // Texto de la evolución
    required int idma,    // IDMA de Evolución Diaria, obtenido dinámicamente
  }) async {
    final ffApiRequestBody = '''
{
  "idInternadoPases": $idInternadoPases,
  "idPrestador": $idPrestador,
  "fechaHora": "${fechaHora?.toIso8601String() ?? DateTime.now().toIso8601String()}",
  "datos": [
    {
      "IDDAT": $iddat,
      "Valor": "${valor.replaceAll('"', '\\"')}",
      "IDMA": $idma
    }
  ]
}
''';

    return ApiManager.instance.makeApiCall(
      callName: 'AgregarEvolucionPanelCamas',
      apiUrl: 'https://excelenciadigital.online/hcweb/PanelDeCamasPrestador.aspx/AgregarEvoluciones',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

 

class AgregarEvolucionCall {
  static Future<ApiCallResponse> call({
    String? evolucionM = '',
    int? idInternadoHCM,
    int? idInternadoM,
    int? idPrestadorM,
    int? idInternadoPaseM,
    int? idInstitucionM, // <-- NUEVO
  }) async {
    final ffApiRequestBody = '''
<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <InsertEvolucion xmlns="http://tempuri.org/">
      <evolucion>${evolucionM}</evolucion>
      <idInternadoHC>${idInternadoHCM}</idInternadoHC>
      <idInternado>${idInternadoM}</idInternado>
      <idPrestador>${idPrestadorM}</idPrestador>
      <idInternadoPase>${idInternadoPaseM}</idInternadoPase>
      <idInstitucion>${idInstitucionM}</idInstitucion> <!-- AGREGADO -->
    </InsertEvolucion>
  </soap:Body>
</soap:Envelope>''';
    return ApiManager.instance.makeApiCall(
      callName: 'AgregarEvolucion',
      apiUrl: 'https://excelenciadigital.online/hcweb/WS.asmx?op=InsertEvolucion',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'text/xml; charset=utf-8',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.TEXT,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class DetalleInstitucionesCall {
  static Future<ApiCallResponse> call({
    int? idInsti,
  }) async {
    final ffApiRequestBody = '''
<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <getDetalleInst xmlns="http://tempuri.org/">
      <idInstitucion>${idInsti}</idInstitucion>
    </getDetalleInst>
  </soap:Body>
</soap:Envelope>''';
    return ApiManager.instance.makeApiCall(
      callName: 'DetalleInstituciones',
      apiUrl:
          'https://excelenciadigital.online/hcweb/WS.asmx?op=getDetalleInst',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'text/xml; charset=utf-8',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.TEXT,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class ListaPacientesLlamadosCall {
  static Future<ApiCallResponse> call({
    int? idInstitucionWS,
    int? idPrestadorWS,
    String? fecha, // <-- Nuevo parámetro opcional
  }) async {
    // Si viene fecha, la enviás al endpoint; si no, mandás string vacío
    final String fechaSoap = (fecha != null && fecha.isNotEmpty)
        ? '<fecha>$fecha</fecha>'
        : '';

    final ffApiRequestBody = '''
<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <getTurnosApp xmlns="http://iosepscript.excelenciadigitial.net.ar/">
      <idInstitucion>${idInstitucionWS}</idInstitucion>
      <IdPrestador>${idPrestadorWS}</IdPrestador>
      $fechaSoap
    </getTurnosApp>
  </soap:Body>
</soap:Envelope>''';

    return ApiManager.instance.makeApiCall(
      callName: 'ListaPacientesLlamados',
      apiUrl: 'https://excelenciadigital.online/hcweb/WsScript.asmx?op=getTurnosApp',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'text/xml; charset=utf-8',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.TEXT,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class LlamarPacienteCall {
  static Future<ApiCallResponse> call({
    int? idTurnoWS,
  }) async {
    final ffApiRequestBody = '''
<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <LlamarPacienteApp xmlns="http://iosepscript.excelenciadigitial.net.ar/">
      <idTurno>${idTurnoWS}</idTurno>
    </LlamarPacienteApp>
  </soap:Body>
</soap:Envelope>''';
    return ApiManager.instance.makeApiCall(
      callName: 'LlamarPaciente',
      apiUrl:
          'https://excelenciadigital.online/hcweb/WsScript.asmx?op=LlamarPacienteApp',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'text/xml; charset=utf-8',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.TEXT,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class CajaPrestadorCall {
  static Future<ApiCallResponse> call({
    required int idPrestador,
    required int idInstitucion,
    required String fIni, // yyyy-MM-dd
    required String fFin,
    int idUsuario = 0,
  }) async {
    final ffApiRequestBody = '''
{
  "idPrestador": $idPrestador,
  "idInstitucion": $idInstitucion,
  "fIni": "$fIni",
  "fFin": "$fFin",
  "IdUsuario": $idUsuario
}
''';

    return ApiManager.instance.makeApiCall(
      callName: 'CajaPrestador',
      apiUrl: 'https://excelenciadigital.online/hcweb/WebService.asmx/GetCaja',
      callType: ApiCallType.POST,
      headers: {'Content-Type': 'application/json'},
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  // NO USAR EL getJsonField, solo dejá esto como está o eliminá esta función (ya no la usás)
  // static List? data(dynamic response) => getJsonField(response, r'''$.d''', true) as List?;
}

class CerrarCajaCall {
  static Future<ApiCallResponse> call({
    required int idUsuario,
    required List<int> idEstudioTurnos,
  }) async {
    final ffApiRequestBody = '''
{
  "IdUsuario": $idUsuario,
  "IdEstudioTurnos": ${idEstudioTurnos.toString()}
}
''';

    return ApiManager.instance.makeApiCall(
      callName: 'CerrarCaja',
      apiUrl: 'https://excelenciadigital.online/hcweb/WebService.asmx/CerrarCaja', // <-- Cambia por tu dominio real
      callType: ApiCallType.POST,
      headers: {'Content-Type': 'application/json'},
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  static dynamic message(dynamic response) => getJsonField(response, r'''$.d''');
}

class GetPrestadorPorUsuarioCall {
  static Future<ApiCallResponse> call({
    required int idUsuario,
    required int idInstitucion,
  }) async {
    final ffApiRequestBody = '''
    {
      "idUsuario": $idUsuario,
      "idInstitucion": $idInstitucion
    }
    ''';
    return ApiManager.instance.makeApiCall(
      callName: 'GetPrestadorPorUsuario',
      apiUrl: 'https://excelenciadigital.online/hcweb/WebService.asmx/GetPrestadorPorUsuario',
      callType: ApiCallType.POST,
      headers: {'Content-Type': 'application/json'},
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GuardarEvolucionAmbulatorioCall {
  static Future<ApiCallResponse> call({
    required int idInstitucion,
    required int idPrestador,
    required int idProblema,
    required String evolucion,
  }) async {
    final Map<String, dynamic> jsonBody = {
      "idInstitucion": idInstitucion,
      "idPrestador": idPrestador,
      "idProblema": idProblema,
      "evolucion": evolucion
    };

    return ApiManager.instance.makeApiCall(
      callName: 'GuardarEvolucionAmbulatorio',
      apiUrl: 'https://excelenciadigital.online/hcweb/WS.asmx/GuardarEvolucionAmbulatorio',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
      },
      params: {},
      body: json.encode(jsonBody),
      bodyType: BodyType.JSON,
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}


class GetProblemasMobileCall {
  static Future<ApiCallResponse> call({
    required int idPrestador,
    required int idPaciente,
  }) async {
    // Si tu endpoint es REST, sería algo como esto:
    // final url = 'http://localhost:54414/WS.asmx/GetProblemasMobile';
    // Si es SOAP, adaptamos el body.

    // Usamos JSON POST porque así lo declaraste arriba
    final ffApiRequestBody = '''
{
  "idPrestador": $idPrestador,
  "idPaciente": $idPaciente
}
''';

    return ApiManager.instance.makeApiCall(
      callName: 'GetProblemasMobile',
      apiUrl: 'https://excelenciadigital.online/hcweb/WS.asmx/GetProblemasMobile',
      callType: ApiCallType.POST,
      headers: {
        'Content-Type': 'application/json',
      },
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class GetPanelCamasAppCall {
  static Future<ApiCallResponse> call({
    required int idInstitucion,
    required int idUsuario,
  }) async {
    final ffApiRequestBody = '''
{
  "idInstitucion": $idInstitucion,
  "idUsuario": $idUsuario
}
''';

    return ApiManager.instance.makeApiCall(
      callName: 'GetPanelCamasApp',
      apiUrl: 'https://excelenciadigital.online/hcweb/WebService.asmx/GetPanelCamasApp',
      callType: ApiCallType.POST,
      headers: {'Content-Type': 'application/json'},
      params: {},
      body: ffApiRequestBody,
      bodyType: BodyType.JSON,
      returnBody: true,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}



class ApiPagingParams {
  int nextPageNumber = 0;
  int numItems = 0;
  dynamic lastResponse;

  ApiPagingParams({
    required this.nextPageNumber,
    required this.numItems,
    required this.lastResponse,
  });

  @override
  String toString() =>
      'PagingParams(nextPageNumber: $nextPageNumber, numItems: $numItems, lastResponse: $lastResponse,)';
}

String _toEncodable(dynamic item) {
  return item;
}

String _serializeList(List? list) {
  list ??= <String>[];
  try {
    return json.encode(list, toEncodable: _toEncodable);
  } catch (_) {
    if (kDebugMode) {
      print("List serialization failed. Returning empty list.");
    }
    return '[]';
  }
}

String _serializeJson(dynamic jsonVar, [bool isList = false]) {
  jsonVar ??= (isList ? [] : {});
  try {
    return json.encode(jsonVar, toEncodable: _toEncodable);
  } catch (_) {
    if (kDebugMode) {
      print("Json serialization failed. Returning empty json.");
    }
    return isList ? '[]' : '{}';
  }
}