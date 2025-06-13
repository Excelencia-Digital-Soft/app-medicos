// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:convert';
import 'package:xml/xml.dart' as xml;

Future<int> getTurnoCercano(String soapResponse) async {
  try {
    final document = xml.XmlDocument.parse(soapResponse);

    // Extraer el contenido de <SuccessMessage>
    final successMessageElement =
        document.findAllElements('SuccessMessage').first;
    final successMessageText = successMessageElement.text.trim();

    // Verificar si la lista está vacía
    if (successMessageText.isEmpty || successMessageText == '[]') {
      FFAppState().idTurnoCercano = -1;
      return -1;
    }

    // Convertir el JSON de SuccessMessage en una lista de turnos
    final List<dynamic> turnos = jsonDecode(successMessageText);

    // Obtener el primer IdTurno
    if (turnos.isNotEmpty) {
      int idTurnoCercano = turnos.first["IdTurno"];
      FFAppState().idTurnoCercano = idTurnoCercano;
      return idTurnoCercano;
    }

    // Si la lista está vacía por alguna razón, devolver -1
    FFAppState().idTurnoCercano = -1;
    return -1;
  } catch (e) {
    print("Error al procesar el XML: $e");
    FFAppState().idTurnoCercano = -1;
    return -1;
  }
}

// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
