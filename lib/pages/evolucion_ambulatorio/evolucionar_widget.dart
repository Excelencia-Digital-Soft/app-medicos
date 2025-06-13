import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
// Reconocimiento de voz
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';

Future<int> obtenerIdPrestadorActual() async {
  final idUsuario = int.tryParse(FFAppState().userData?['idUsuario'].toString() ?? '0') ?? 0;
  final idInstitucion = int.tryParse(FFAppState().idInstitucionSeleccionado.toString()) ?? 0;
  var respPrestador = await GetPrestadorPorUsuarioCall.call(
    idUsuario: idUsuario,
    idInstitucion: idInstitucion,
  );
  int? idPrestadorExtraido;
  try {
    final body = respPrestador.jsonBody;
    if (body['d'] != null) {
      var d = body['d'];
      if (d is Map && d['SuccessMessage'] != null && d['ContainsErrors'] == false) {
        idPrestadorExtraido = int.tryParse(d['SuccessMessage'].toString());
      }
    }
  } catch (_) {
    idPrestadorExtraido = null;
  }
  return idPrestadorExtraido ?? 0;
}

class EvolucionarWidget extends StatefulWidget {
  const EvolucionarWidget({Key? key}) : super(key: key);

  static String routeName = 'Evolucionar';
  static String routePath = '/evolucionar';

  @override
  State<EvolucionarWidget> createState() => _EvolucionarWidgetState();
}

class _EvolucionarWidgetState extends State<EvolucionarWidget> {
  bool cargando = false;
  final TextEditingController evolucionCtrl = TextEditingController();
  Map<String, dynamic>? datosPaciente;
  int? idProblemaEncontrado;

  // Reconocimiento de voz
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _textoReconocido = '';
  double _confidence = 1.0;

  @override
  void initState() {
    super.initState();
    datosPaciente = FFAppState().ultimoTurnoLlamado;
    if (datosPaciente != null) {
      buscarIdProblema();
    }
    _speech = stt.SpeechToText();
  }

  Future<void> buscarIdProblema() async {
    setState(() { cargando = true; });

    final idPrestador = await obtenerIdPrestadorActual();
    final idPaciente = datosPaciente?['IdPacientes_Instituciones'] ?? datosPaciente?['IdPaciente'];

    if (idPrestador == 0 || idPaciente == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("No se pudo obtener el IdProblema.")),
      );
      setState(() { cargando = false; });
      return;
    }

    final res = await GetProblemasMobileCall.call(
      idPrestador: idPrestador,
      idPaciente: int.tryParse(idPaciente.toString()) ?? 0,
    );
    if (res.succeeded && res.bodyText != null) {
      try {
        final jsonMap = json.decode(res.bodyText!);
        final lista = json.decode(jsonMap['d'] ?? '[]');
        if (lista is List && lista.isNotEmpty) {
          lista.sort((a, b) {
            final fechaA = DateTime.tryParse(a['FechaProblema'] ?? '') ?? DateTime(1900);
            final fechaB = DateTime.tryParse(b['FechaProblema'] ?? '') ?? DateTime(1900);
            return fechaB.compareTo(fechaA);
          });
          idProblemaEncontrado = lista.first['IdProblema'];
        } else {
          idProblemaEncontrado = null;
        }
      } catch (e) {
        idProblemaEncontrado = null;
      }
    } else {
      idProblemaEncontrado = null;
    }
    setState(() { cargando = false; });
  }

  Future<void> guardarEvolucion() async {
    setState(() { cargando = true; });

    final idInstitucion = int.tryParse(FFAppState().idInstitucionSeleccionado.toString()) ?? 0;
    final idPrestador = await obtenerIdPrestadorActual();
    final evolucion = evolucionCtrl.text.trim();

    if (idInstitucion == 0 || idPrestador == 0 || idProblemaEncontrado == null || evolucion.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Faltan datos para guardar la evolución.")),
      );
      setState(() => cargando = false);
      return;
    }

    final res = await GuardarEvolucionAmbulatorioCall.call(
      idInstitucion: idInstitucion,
      idProblema: idProblemaEncontrado!,
      idPrestador: idPrestador,
      evolucion: evolucion,
    );

    bool ok = false;
    String mensaje = '';

    if (res.bodyText != null) {
      try {
        final jsonResult = json.decode(res.bodyText!);
        final resultObj = jsonResult['d'];
        if (resultObj != null && resultObj is Map && resultObj['ContainsErrors'] == false) {
          ok = true;
          mensaje = "Evolución cargada correctamente.";
        } else {
          mensaje = "Error al guardar la evolución: ${resultObj?['ErrorMessage'] ?? 'desconocido'}";
        }
      } catch (e) {
        mensaje = "Error inesperado al parsear respuesta: $e";
      }
    } else {
      mensaje = "Error inesperado: bodyText es null";
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje)),
    );

    if (ok) {
      FFAppState().ultimoTurnoLlamado = null;
      Navigator.pop(context);
    }

    setState(() {
      cargando = false;
    });
  }

  Future<void> _toggleListening() async {
  if (!_isListening) {
    var status = await Permission.microphone.request();
    if (!status.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Permiso de micrófono denegado')),
      );
      return;
    }
    bool available = await _speech.initialize(
      onStatus: (status) {
        if (status == 'done' || status == 'notListening') {
          setState(() => _isListening = false);
        }
      },
      onError: (error) {
        setState(() => _isListening = false);
      },
    );
    if (available) {
      setState(() => _isListening = true);
      _speech.listen(
        localeId: 'es_AR',
        onResult: (val) {
          setState(() {
            _textoReconocido = val.recognizedWords;
            evolucionCtrl.text = val.recognizedWords;
            evolucionCtrl.selection = TextSelection.fromPosition(
              TextPosition(offset: evolucionCtrl.text.length),
            );
            if (val.hasConfidenceRating && val.confidence > 0) {
              _confidence = val.confidence;
            }
          });
        },
        pauseFor: Duration(seconds: 5),
        partialResults: false,
      );
    } else {
      setState(() => _isListening = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo inicializar el micrófono')),
      );
    }
  } else {
    _speech.stop();
    setState(() => _isListening = false);
  }
}


  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (datosPaciente == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            "Evolucionar",
            style: GoogleFonts.outfit(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 22,
            ),
          ),
          backgroundColor: FlutterFlowTheme.of(context).primary,
        ),
        body: Center(
          child: Text(
            'No hay paciente para evolucionar',
            style: GoogleFonts.outfit(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[isDark ? 300 : 600],
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    final nombreCompleto = '${datosPaciente?['Nombre'] ?? ''} ${datosPaciente?['Apellido'] ?? ''}';

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // FONDO GRADIENTE AZUL
          Container(
            height: MediaQuery.of(context).size.height * 0.36,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF337CEB), Color(0xFF5BA8F5)],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                // BOTÓN VOLVER
                Padding(
                  padding: const EdgeInsets.only(left: 8, top: 8),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white, size: 36),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
                // HEADER: Nombre
                Padding(
                  padding: const EdgeInsets.only(top: 36.0, bottom: 8.0),
                  child: Column(
                    children: [
                      Text(
                        nombreCompleto,
                        textAlign: TextAlign.center,
                        style: FlutterFlowTheme.of(context).headlineLarge.override(
                              fontFamily: 'Outfit',
                              fontSize: 34,
                              color: Colors.white,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      SizedBox(height: 6),
                    ],
                  ),
                ),
                // CARD PRINCIPAL
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF7F8FC),
                      borderRadius: BorderRadius.vertical(top: Radius.circular(34.0)),
                    ),
                    child: Center(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.only(bottom: 110),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 4),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(22),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 10,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Título
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 10),
                                        child: Row(
                                          children: [
                                            Icon(Icons.assignment_rounded,
                                                size: 34, color: FlutterFlowTheme.of(context).primary),
                                            const SizedBox(width: 10),
                                            Flexible(
                                              child: Text(
                                                'Evolución de Paciente',
                                                style: GoogleFonts.outfit(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 22,
                                                  color: FlutterFlowTheme.of(context).primary,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      // INPUT DE EVOLUCIÓN
                                      Text(
                                        "Ingrese evolución",
                                        style: GoogleFonts.outfit(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                          color: FlutterFlowTheme.of(context).primary,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      TextField(
                                        controller: evolucionCtrl,
                                        maxLines: 9,
                                        minLines: 6,
                                        style: GoogleFonts.outfit(fontSize: 18),
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Color(0xFFF1F4F8),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(16),
                                            borderSide: BorderSide.none,
                                          ),
                                          hintText: 'Describa la evolución clínica...',
                                          hintStyle: GoogleFonts.outfit(
                                            fontSize: 18,
                                            color: Color(0xFF5D6A85),
                                          ),
                                          contentPadding: EdgeInsets.symmetric(horizontal: 18, vertical: 18),
                                        ),
                                      ),
                                      if (_isListening)
                                        Padding(
                                          padding: const EdgeInsets.only(top: 8.0),
                                          child: Text(
                                            'Escuchando... Dicta tu evolución.',
                                            style: TextStyle(
                                              color: Colors.red,
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                        ),
                                      // GUARDAR
                                      Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10),
                                        child: SizedBox(
                                          width: double.infinity,
                                          height: 62,
                                          child: ElevatedButton.icon(
                                            icon: Icon(Icons.save_alt_rounded, size: 26),
                                            label: Text(
                                              'Guardar Evolución',
                                              style: GoogleFonts.outfit(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 20,
                                              ),
                                            ),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Color(0xFF337CEB),
                                              foregroundColor: Colors.white,
                                              elevation: 2,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(16),
                                              ),
                                            ),
                                            onPressed: cargando ? null : guardarEvolucion,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            // MICRÓFONO GRANDE CENTRADO ABAJO (como en la vista 1)
                            SizedBox(height: 28),
                            Center(
                              child: GestureDetector(
                                onTap: cargando ? null : _toggleListening,
                                child: AnimatedContainer(
                                  duration: Duration(milliseconds: 350),
                                  width: 120,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    color: _isListening ? Colors.redAccent : Color(0xFF337CEB),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: (_isListening ? Colors.redAccent : Color(0xFF337CEB)).withOpacity(0.5),
                                        blurRadius: _isListening ? 30 : 18,
                                        spreadRadius: _isListening ? 7 : 3,
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    _isListening ? Icons.mic : Icons.mic_none,
                                    color: Colors.white,
                                    size: 60,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (cargando)
            Container(
              color: Colors.black.withOpacity(0.1),
              child: Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}
