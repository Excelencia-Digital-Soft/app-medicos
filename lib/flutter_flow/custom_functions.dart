import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'lat_lng.dart';
import 'place.dart';
import 'uploaded_file.dart';

String formatDateString(String dateString) {
// Extrae los milisegundos desde el string con RegExp
  final milliseconds = int.parse(
    dateString.replaceAllMapped(
      RegExp(r'\/Date\((\d+)\)\/'),
      (match) => match.group(1) ?? '0',
    ),
  );

  // Convierte a DateTime
  final dateTime = DateTime.fromMillisecondsSinceEpoch(milliseconds);

  // Formatea la fecha
  final formattedDate = DateFormat('dd/MM/yyyy').format(dateTime);
  final formattedTime = DateFormat('HH:mm').format(dateTime);

  return '$formattedDate a las $formattedTime';
}

int obtenerElementoDelArray(
  List<int> idsInstituciones,
  int index,
) {
  if (idsInstituciones.isEmpty ||
      index < 0 ||
      index >= idsInstituciones.length) {
    return -1; // Valor de error si el índice es inválido
  }
  return idsInstituciones[index];
}
