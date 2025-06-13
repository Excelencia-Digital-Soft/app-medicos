// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

Future<int> verifiedQRCode(String? entrada) async {
  print('Scanned QR Code: $entrada');
  if (entrada == null || entrada.isEmpty || entrada.length < 4) {
    print('QR Code Error: Invalid or empty input');
    return 1; // Error: Entrada inválida
  } else {
    // Updated regex to match idcama:<number>-IdInstitucion:<number>
    final RegExp regex = RegExp(r'idcama:(\d+)-IdInstitucion:(\d+)');
    final match = regex.firstMatch(entrada);

    if (match == null) {
      print('QR Code Error: Invalid format, does not match regex');
      return 2; // Error: Formato inválido
    } else {
      final camaStr = match.group(1); // Extrae el idcama como cadena
      final institucionStr = match.group(2); // Extrae el IdInstitucion como cadena

      if (camaStr != null && institucionStr != null) {
        final int? cama = int.tryParse(camaStr);
        final int? institucion = int.tryParse(institucionStr);

        if (cama != null && institucion != null) {
          print('Parsed Values: idCama=$cama, idInstitucion=$institucion');
          FFAppState().update(() {
            FFAppState().QRCamaINT = cama;
            FFAppState().QRIdInstitucionINT = institucion;
          });
          return 3; // Éxito
        } else {
          print('QR Code Error: Failed to parse integers');
          return 2; // Error: Conversión a entero fallida
        }
      } else {
        print('QR Code Error: Extracted values are null');
        return 2; // Error: Datos no válidos
      }
    }
  }
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
