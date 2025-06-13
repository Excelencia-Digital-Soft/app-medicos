// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:convert';

import 'package:xml/xml.dart';

String extractJsonFromString(String input) {
  print('Raw API Response: $input');
  try {
    // Try parsing as SOAP response
    final document = XmlDocument.parse(input);
    final resultElements = document.findAllElements('GetPacienteEvolucionMobileResult');
    
    if (resultElements.isNotEmpty) {
      final jsonString = resultElements.first.text.trim();
      print('Extracted JSON from SOAP: $jsonString');
      
      if (jsonString.isNotEmpty) {
        // Validate and decode JSON
        final jsonData = json.decode(jsonString);
        FFAppState().update(() {
          FFAppState().Evolucionessss = jsonString;
          FFAppState().Evoluciones = jsonData;
        });
        return jsonString;
      } else {
        print('No JSON content found in GetPacienteEvolucionMobileResult');
        return "{}";
      }
    } else {
      print('No GetPacienteEvolucionMobileResult element found, attempting direct JSON extraction');
      // Fallback: Extract JSON directly from the response
      final RegExp jsonRegex = RegExp(r'\{.*?\}(?=\s*<\?xml|$)', multiLine: true);
      final match = jsonRegex.firstMatch(input);
      
      if (match != null) {
        final jsonString = match.group(0)!.trim();
        print('Extracted JSON directly: $jsonString');
        
        if (jsonString.isNotEmpty) {
          // Validate and decode JSON
          final jsonData = json.decode(jsonString);
          FFAppState().update(() {
            FFAppState().Evolucionessss = jsonString;
            FFAppState().Evoluciones = jsonData;
          });
          return jsonString;
        } else {
          print('Extracted JSON is empty');
          return "{}";
        }
      } else {
        print('No JSON found in response');
        return "{}";
      }
    }
  } catch (e) {
    print('Error extracting JSON: $e');
    // Fallback: Try direct JSON extraction on error
    try {
      final RegExp jsonRegex = RegExp(r'\{.*?\}(?=\s*<\?xml|$)', multiLine: true);
      final match = jsonRegex.firstMatch(input);
      
      if (match != null) {
        final jsonString = match.group(0)!.trim();
        print('Fallback JSON extraction: $jsonString');
        
        if (jsonString.isNotEmpty) {
          final jsonData = json.decode(jsonString);
          FFAppState().update(() {
            FFAppState().Evolucionessss = jsonString;
            FFAppState().Evoluciones = jsonData;
          });
          return jsonString;
        }
      }
      print('Fallback JSON extraction failed');
      return "{}";
    } catch (e) {
      print('Fallback extraction error: $e');
      return "{}";
    }
  }
}
// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
