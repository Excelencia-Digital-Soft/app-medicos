import 'package:flutter/material.dart';
import '/backend/api_requests/_/api_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'flutter_flow/flutter_flow_util.dart';
import 'dart:convert';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {
    prefs = await SharedPreferences.getInstance();
    _safeInit(() {
      if (prefs.containsKey('ff_userData')) {
        try {
          _userData = jsonDecode(prefs.getString('ff_userData') ?? '');
        } catch (e) {
          print("Can't decode persisted json. Error: $e.");
        }
      }
    });
    _safeInit(() {
      if (prefs.containsKey('ff_Evoluciones')) {
        try {
          _Evoluciones = jsonDecode(prefs.getString('ff_Evoluciones') ?? '');
        } catch (e) {
          print("Can't decode persisted json. Error: $e.");
        }
      }
    });
    _safeInit(() {
      _ocultarRecetas = prefs.getBool('ff_ocultarRecetas') ?? _ocultarRecetas;
    });
    _safeInit(() {
      if (prefs.containsKey('ff_errores')) {
        try {
          _errores = jsonDecode(prefs.getString('ff_errores') ?? '');
        } catch (e) {
          print("Can't decode persisted json. Error: $e.");
        }
      }
    });
    _safeInit(() {
      if (prefs.containsKey('ff_institucionesJSON')) {
        try {
          _institucionesJSON =
              jsonDecode(prefs.getString('ff_institucionesJSON') ?? '');
        } catch (e) {
          print("Can't decode persisted json. Error: $e.");
        }
      }
    });
  }

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  late SharedPreferences prefs;

  dynamic _userData;
  dynamic get userData => _userData;
  set userData(dynamic value) {
    _userData = value;
    prefs.setString('ff_userData', jsonEncode(value));
  }

  dynamic _Evoluciones;
  dynamic get Evoluciones => _Evoluciones;
  set Evoluciones(dynamic value) {
    _Evoluciones = value;
    prefs.setString('ff_Evoluciones', jsonEncode(value));
  }

  String _Evolucionessss = '';
  String get Evolucionessss => _Evolucionessss;
  set Evolucionessss(String value) {
    _Evolucionessss = value;
  }

  int _QRCamaINT = 0;
  int get QRCamaINT => _QRCamaINT;
  set QRCamaINT(int value) {
    _QRCamaINT = value;
  }

  int _QRIdInstitucionINT = 0;
  int get QRIdInstitucionINT => _QRIdInstitucionINT;
  set QRIdInstitucionINT(int value) {
    _QRIdInstitucionINT = value;
  }

  bool _ocultarRecetas = true;
  bool get ocultarRecetas => _ocultarRecetas;
  set ocultarRecetas(bool value) {
    _ocultarRecetas = value;
    prefs.setBool('ff_ocultarRecetas', value);
  }

  dynamic _errores = jsonDecode('{\"null\":null}');
  dynamic get errores => _errores;
  set errores(dynamic value) {
    _errores = value;
    prefs.setString('ff_errores', jsonEncode(value));
  }

  List<int> _IdInstituciones = [];
  List<int> get IdInstituciones => _IdInstituciones;
  set IdInstituciones(List<int> value) {
    _IdInstituciones = value;
  }

  void addToIdInstituciones(int value) {
    IdInstituciones.add(value);
  }

  void removeFromIdInstituciones(int value) {
    IdInstituciones.remove(value);
  }

  void removeAtIndexFromIdInstituciones(int index) {
    IdInstituciones.removeAt(index);
  }

  void updateIdInstitucionesAtIndex(
    int index,
    int Function(int) updateFn,
  ) {
    IdInstituciones[index] = updateFn(_IdInstituciones[index]);
  }

  void insertAtIndexInIdInstituciones(int index, int value) {
    IdInstituciones.insert(index, value);
  }

  int _indexInstituciones = 0;
  int get indexInstituciones => _indexInstituciones;
  set indexInstituciones(int value) {
    _indexInstituciones = value;
  }

  String _nombreInsti = '';
  String get nombreInsti => _nombreInsti;
  set nombreInsti(String value) {
    _nombreInsti = value;
  }

  int _idInstitucionSeleccionado = 0;
  int get idInstitucionSeleccionado => _idInstitucionSeleccionado;
  set idInstitucionSeleccionado(int value) {
    _idInstitucionSeleccionado = value;
  }

Map<String, dynamic>? ultimoTurnoLlamado;

  dynamic _institucionesJSON;
  dynamic get institucionesJSON => _institucionesJSON;
  set institucionesJSON(dynamic value) {
    _institucionesJSON = value;
    prefs.setString('ff_institucionesJSON', jsonEncode(value));
  }

  int _idTurnoCercano = 0;
  int get idTurnoCercano => _idTurnoCercano;
  set idTurnoCercano(int value) {
    _idTurnoCercano = value;
  }

  bool _llamandoPaciente = false;
  bool get llamandoPaciente => _llamandoPaciente;
  set llamandoPaciente(bool value) {
    _llamandoPaciente = value;
  }
}

void _safeInit(Function() initializeField) {
  try {
    initializeField();
  } catch (_) {}
}

Future _safeInitAsync(Function() initializeField) async {
  try {
    await initializeField();
  } catch (_) {}
}
