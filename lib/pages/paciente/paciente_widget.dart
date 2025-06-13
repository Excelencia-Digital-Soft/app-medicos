import '/backend/api_requests/api_calls.dart';
import '/components/empty_list_widget.dart';
import '/components/neo_widget.dart';
import '/flutter_flow/flutter_flow_choice_chips.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'dart:convert';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'paciente_model.dart';
export 'paciente_model.dart';

class PacienteWidget extends StatefulWidget {
  const PacienteWidget({super.key});

  static String routeName = 'Paciente';
  static String routePath = '/paciente';

  @override
  State<PacienteWidget> createState() => _PacienteWidgetState();
}

class _PacienteWidgetState extends State<PacienteWidget> {
  late PacienteModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isSpeechInitialized = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PacienteModel());
    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();
    _initializeSpeech();
  }

  Future<void> _initializeSpeech() async {
    await _model.speechToText.stop();
    await _model.speechToText.cancel();
    _isSpeechInitialized = false;

    if (!await _model.requestMicrophonePermission(context)) {
      setState(() {
        _model.isSpeechEnabled = false;
        _model.isListening = false;
        _model.isProcessing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Necesito el permiso del micrófono para continuar.')),
      );
      return;
    }

    bool available = await _model.speechToText.initialize(
      onStatus: (status) {
        setState(() {
          _model.isListening = status == 'listening';
          if ((status == 'done' || status == 'notListening') &&
              _model.recognizedText.isNotEmpty &&
              !_model.isProcessing) {
            if (_model.recognizedText != _model.lastProcessedText) {
              _processInput();
            }
          }
        });
      },
      onError: (error) {
        setState(() {
          _model.isListening = false;
          _model.isProcessing = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No te entendí. Probá de nuevo.')),
        );
      },
    );

    if (available) {
      _isSpeechInitialized = true;
      setState(() {
        _model.isSpeechEnabled = true;
        _model.isListening = false;
        _model.isProcessing = false;
      });
    } else {
      _isSpeechInitialized = false;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo iniciar el reconocimiento de voz.')),
      );
      Future.delayed(Duration(seconds: 2), () {
        if (mounted) _initializeSpeech();
      });
    }
  }

  Future<void> _startListening() async {
    if (!_model.isListening && !_model.isProcessing && _isSpeechInitialized) {
      if (!await _model.requestMicrophonePermission(context)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Necesito el permiso del micrófono para continuar.')),
        );
        return;
      }

      setState(() {
        _model.isListening = true;
        _model.recognizedText = '';
      });

      try {
        String selectedLocale = await _model.getPreferredLocale();
        await _model.speechToText.listen(
          localeId: selectedLocale,
          partialResults: false,
          listenFor: Duration(seconds: 30),
          pauseFor: Duration(seconds: 5),
          onResult: (result) {
            String processedText = result.recognizedWords.trim();
            setState(() {
              _model.recognizedText = processedText;
            });
            if (processedText.length >= 5) {
              _model.speechToText.stop();
              _processInput();
            }
          },
        );
      } catch (e) {
        setState(() {
          _model.isListening = false;
          _model.isProcessing = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al iniciar el reconocimiento de voz.')),
        );
      }
    }
  }

  Future<void> _stopListening() async {
    if (_model.isListening) {
      await _model.speechToText.stop();
      setState(() {
        _model.isListening = false;
        _model.isProcessing = false;
      });
      if (_model.recognizedText.isNotEmpty && _model.recognizedText != _model.lastProcessedText) {
        _processInput();
      }
    }
  }

  Future<void> _processInput() async {
    if (_model.isProcessing || _model.recognizedText == _model.lastProcessedText) {
      return;
    }
    setState(() {
      _model.isProcessing = true;
      _model.lastProcessedText = _model.recognizedText;
    });

    if (_model.recognizedText.trim().length >= 5) {
      setState(() {
        _model.textController?.text = (_model.textController?.text ?? '') +
            (_model.textController!.text.isNotEmpty ? ' ' : '') +
            _model.recognizedText.trim();
        _model.recognizedText = '';
        _model.isProcessing = false;
        _model.errorNoMatchCount = 0;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Texto registrado correctamente.')),
      );
    } else {
      String errorMessage = _model.recognizedText.trim().isEmpty
          ? 'No escuché nada. Hablá de nuevo.'
          : 'Texto demasiado corto. Hablá un poco más.';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
      setState(() {
        _model.recognizedText = '';
        _model.isProcessing = false;
      });
    }
  }

  String? _validateTextField(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Campo requerido';
    }
    if (val.length < 5) {
      return 'Requiere al menos 5 caracteres';
    }
    return null;
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

@override
Widget build(BuildContext context) {
  context.watch<FFAppState>();

  final nombreCompleto =
      '${getJsonField(FFAppState().Evoluciones, r'''$.InternadoData[0].Nombre''').toString()} ${getJsonField(FFAppState().Evoluciones, r'''$.InternadoData[0].Apellido''').toString()}';
  final dni = getJsonField(
    FFAppState().Evoluciones,
    r'''$.InternadoData[0].Documento''',
  ).toString();

  return GestureDetector(
    onTap: () {
      FocusScope.of(context).unfocus();
      FocusManager.instance.primaryFocus?.unfocus();
    },
    child: Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Fondo gradiente arriba
          Container(
            height: MediaQuery.of(context).size.height * 0.35,
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
                // Botón VOLVER
      Padding(
        padding: const EdgeInsets.only(left: 8, top: 8),
        child: Align(
          alignment: Alignment.centerLeft,
          child: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white, size: 36),
            onPressed: () {
              context.safePop(); // igual que tu código original
            },
          ),
        ),
      ),
                // Header: Nombre y DNI centrado
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
                      Text(
                        "DNI • $dni",
                        style: FlutterFlowTheme.of(context).labelLarge.override(
                              fontFamily: 'Outfit',
                              color: Colors.white.withOpacity(0.93),
                              fontSize: 20,
                            ),
                      ),
                    ],
                  ),
                ),
                // Card principal
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF7F8FC),
                      borderRadius: BorderRadius.vertical(top: Radius.circular(34.0)),
                    ),
                    child: SingleChildScrollView(
                      padding: EdgeInsets.only(bottom: 150),
                      child: Column(
                        children: [
                          // Chips
                          Padding(
                            padding: const EdgeInsets.only(top: 24, bottom: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                FlutterFlowChoiceChips(
                                  options: [
                                    ChipData('Evolución', Icons.auto_graph),
                                    ChipData('Historial', Icons.view_list)
                                  ],
                                  onChanged: (val) {
                                    setState(() => _model.choiceChipsValue = val?.firstOrNull);
                                  },
                                  selectedChipStyle: ChipStyle(
                                    backgroundColor: Color(0xFF337CEB),
                                    textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                                          fontFamily: 'Outfit',
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                    iconColor: Colors.white,
                                    iconSize: 22.0,
                                    labelPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                    elevation: 2.0,
                                    borderRadius: BorderRadius.circular(22.0),
                                  ),
                                  unselectedChipStyle: ChipStyle(
                                    backgroundColor: Color(0xFFF1F4F8),
                                    textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                                          fontFamily: 'Outfit',
                                          color: Color(0xFF7A869A),
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                        ),
                                    iconColor: Color(0xFF7A869A),
                                    iconSize: 22.0,
                                    labelPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                    elevation: 0.0,
                                    borderRadius: BorderRadius.circular(22.0),
                                  ),
                                  chipSpacing: 20.0,
                                  rowSpacing: 5.0,
                                  multiselect: false,
                                  initialized: _model.choiceChipsValue != null,
                                  alignment: WrapAlignment.center,
                                  controller: _model.choiceChipsValueController ??=
                                      FormFieldController<List<String>>(['Evolución']),
                                  wrapped: false,
                                ),
                              ],
                            ),
                          ),
                          // === EVOLUCIÓN ===
                          if ((_model.choiceChipsValue ?? 'Evolución') == 'Evolución') ...[
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
                                child: Form(
                                  key: _model.formKey,
                                  autovalidateMode: AutovalidateMode.disabled,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                                    child: TextFormField(
                                      controller: _model.textController,
                                      focusNode: _model.textFieldFocusNode,
                                      onChanged: (_) {
                                        EasyDebounce.debounce(
                                          '_model.textController',
                                          Duration(milliseconds: 2000),
                                          () => setState(() {}),
                                        );
                                      },
                                      autofocus: false,
                                      maxLines: 12,
                                      decoration: InputDecoration(
                                        hintText: 'Escriba o dicte la evolución...',
                                        hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
                                              fontFamily: 'Outfit',
                                              color: Color(0xFF5D6A85),
                                              fontSize: 20,
                                              letterSpacing: 0.0,
                                            ),
                                        border: InputBorder.none,
                                        contentPadding: const EdgeInsets.all(18.0),
                                      ),
                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                            fontFamily: 'Outfit',
                                            color: Color(0xFF394867),
                                            fontSize: 20,
                                            letterSpacing: 0.0,
                                          ),
                                      cursorColor: Color(0xFF337CEB),
                                      validator: _model.textControllerValidator.asValidator(context),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 38, vertical: 22),
                              child: SizedBox(
                                width: double.infinity,
                                height: 82,
                                child: FFButtonWidget(
                                  text: 'Guardar',
                                  icon: Icon(Icons.save_alt, size: 30, color: Colors.white),
                                  onPressed: _model.isListening
                                      ? null
                                      : () async {
                                          if (_model.formKey.currentState == null ||
                                              !_model.formKey.currentState!.validate()) {
                                            return;
                                          }
                                          // ... TU LÓGICA DE GUARDADO, NO TOCADA ...
                                          final evolucion = _model.textController?.text ?? '';
                                          final idInternadoHC = 0;
                                          final idInternado = getJsonField(
                                            FFAppState().Evoluciones,
                                            r'''$.InternadoData[0].IdInternado''',
                                          );
                                          final idPrestador = getJsonField(
                                            FFAppState().Evoluciones,
                                            r'''$.InternadoData[0].IdPrestador''',
                                          );
                                          final idInternadoPase = getJsonField(
                                            FFAppState().Evoluciones,
                                            r'''$.InternadoData[0].IdInternadoPases''',
                                          );
                                          final idInstitucion = FFAppState().idInstitucionSeleccionado;

                                          _model.apiResultbbk = await AgregarEvolucionCall.call(
                                            evolucionM: evolucion,
                                            idInternadoHCM: idInternadoHC,
                                            idInternadoM: idInternado,
                                            idPrestadorM: idPrestador,
                                            idInternadoPaseM: idInternadoPase,
                                            idInstitucionM: idInstitucion,
                                          );

                                          if ((_model.apiResultbbk?.succeeded ?? false)) {
                                            _model.textController?.clear();
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text('Evolución añadida con éxito!',
                                                    style: TextStyle(color: Colors.white)),
                                                duration: Duration(milliseconds: 2000),
                                                backgroundColor: Color(0xFF337CEB),
                                              ),
                                            );
                                          } else {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                    'Hubo un error al agregar la evolución. Inténtelo de nuevo más tarde',
                                                    style: TextStyle(color: Colors.white)),
                                                duration: Duration(milliseconds: 3000),
                                                backgroundColor: Color(0xFFB4232C),
                                              ),
                                            );
                                          }
                                          safeSetState(() {});
                                        },
                                  options: FFButtonOptions(
                                    height: 62.0,
                                    color: Color(0xFF337CEB),
                                    textStyle: FlutterFlowTheme.of(context).titleLarge.override(
                                          fontFamily: 'Outfit',
                                          color: Colors.white,
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                    iconSize: 28,
                                    borderSide: BorderSide(
                                      color: Colors.transparent,
                                      width: 0.0,
                                    ),
                                    borderRadius: BorderRadius.circular(16.0),
                                  ),
                                ),
                              ),
                            ),
                            // MICRÓFONO: Centrado en el espacio en blanco
                            SizedBox(height: 30),
                            Center(
                              child: GestureDetector(
                                onTap: _model.isListening ? _stopListening : _startListening,
                                child: AnimatedContainer(
                                  duration: Duration(milliseconds: 350),
                                  width: 130,
                                  height: 130,
                                  decoration: BoxDecoration(
                                    color: _model.isListening ? Colors.redAccent : Color(0xFF337CEB),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: (_model.isListening ? Colors.redAccent : Color(0xFF337CEB)).withOpacity(0.5),
                                        blurRadius: _model.isListening ? 32 : 18,
                                        spreadRadius: _model.isListening ? 8 : 3,
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    _model.isListening ? Icons.mic : Icons.mic_none,
                                    color: Colors.white,
                                    size: 72,
                                  ),
                                ),
                              ),
                            ),
                          ],
                          // === HISTORIAL ===
                          if ((_model.choiceChipsValue ?? 'Evolución') == 'Historial')
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                              child: Builder(
                                builder: (context) {
                                  final evoluciones = getJsonField(
                                    FFAppState().Evoluciones,
                                    r'''$.Evoluciones''',
                                  ).toList();
                                  if (evoluciones.isEmpty) {
                                    return EmptyListWidget();
                                  }
                                  return ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: evoluciones.length,
                                    itemBuilder: (context, index) {
                                      final evolucionesItem = evoluciones[index];
                                      return Container(
                                        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                                        padding: EdgeInsets.all(18),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(20),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black12,
                                              blurRadius: 8,
                                            )
                                          ],
                                        ),
                                        child: ListTile(
                                          leading: Icon(
                                            Icons.control_point_rounded,
                                            color: Color(0xFF337CEB),
                                            size: 32,
                                          ),
                                          title: Text(
                                            getJsonField(
                                              evolucionesItem,
                                              r'''$..Valor''',
                                            ).toString(),
                                            style: FlutterFlowTheme.of(context)
                                                .titleLarge
                                                .override(
                                                  fontFamily: 'Outfit',
                                                  fontSize: 18.0,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                          subtitle: Text(
                                            functions.formatDateString(getJsonField(
                                              evolucionesItem,
                                              r'''$..FechaHora''',
                                            ).toString()),
                                            style: FlutterFlowTheme.of(context)
                                                .labelMedium
                                                .override(
                                                  fontFamily: 'Outfit',
                                                  fontSize: 14.0,
                                                  color: Color(0xFF7A869A),
                                                  fontWeight: FontWeight.w500,
                                                ),
                                          ),
                                          tileColor: Colors.transparent,
                                          dense: false,
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

}