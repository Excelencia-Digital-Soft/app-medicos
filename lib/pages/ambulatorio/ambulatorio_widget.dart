import '/backend/api_requests/api_calls.dart';
import '/components/neo_widget.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:math';
import 'dart:ui';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'ambulatorio_model.dart';
import '../turnos/mis_turnos_widget.dart'; // <-- Importá la vista de turnos
import '../evolucion_ambulatorio/evolucionar_widget.dart'; // <-- Importá la vista evolucionar
export 'ambulatorio_model.dart';

// Helper para obtener el idPrestador real
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

class AmbulatorioWidget extends StatefulWidget {
  const AmbulatorioWidget({super.key});

  static String routeName = 'Ambulatorio';
  static String routePath = '/ambulatorio';

  @override
  State<AmbulatorioWidget> createState() => _AmbulatorioWidgetState();
}

class _AmbulatorioWidgetState extends State<AmbulatorioWidget>
    with TickerProviderStateMixin {
  late AmbulatorioModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AmbulatorioModel());

    animationsMap.addAll({
      'containerOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          ScaleEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 200.0.ms,
            begin: Offset(0.7, 0.7),
            end: Offset(1.0, 1.0),
          ),
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 100.0.ms,
            duration: 100.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
        ],
      ),
    });
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<void> _llamarPaciente() async {
  print('🔵 [Ambulatorio] >>> INICIANDO LLAMAR PACIENTE (modo selección) <<<');
  final idUsuario = int.tryParse(getJsonField(FFAppState().userData, r'''$.idUsuario''').toString()) ?? 0;
  final idInstitucion = int.tryParse(FFAppState().idInstitucionSeleccionado.toString()) ?? 0;
  final idPrestador = await obtenerIdPrestadorActual();

  setState(() {
    FFAppState().llamandoPaciente = true;
  });

  // Trae los turnos del día
  final apiResult = await ListaPacientesLlamadosCall.call(
    idInstitucionWS: idInstitucion,
    idPrestadorWS: idPrestador,
  );
  print('📦 [Ambulatorio] XML recibido: ${apiResult.bodyText}');

  final xml = apiResult.bodyText;
  final regex = RegExp(r'<SuccessMessage>(.*?)</SuccessMessage>', dotAll: true);
  final match = regex.firstMatch(xml ?? '');

  String? successMsg;
  if (match != null) {
    successMsg = match.group(1);
    print('🟢 [Ambulatorio] SuccessMessage extraído: $successMsg');
  } else {
    print('🟡 [Ambulatorio] No se encontró SuccessMessage en el XML.');
  }

  List<Map<String, dynamic>> pendientes = [];
  if (successMsg != null && successMsg.isNotEmpty) {
    try {
      final turnos = List<Map<String, dynamic>>.from(json.decode(successMsg));
      pendientes = turnos.where((turno) {
        final horaLlamada = turno['HoraLlamada']?.toString();
        return (horaLlamada == '' || horaLlamada == 'null' || horaLlamada == null);
      }).toList();
      print('🟢 [Ambulatorio] Turnos pendientes: $pendientes');
    } catch (e) {
      print('❌ [Ambulatorio] Error decodificando turnos: $e');
    }
  }

  if (pendientes.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("No hay turnos pendientes para llamar.")),
    );
    FFAppState().ultimoTurnoLlamado = null;
    setState(() { FFAppState().llamandoPaciente = false; });
    return;
  }

  // --- MOSTRAR LA LISTA PARA ELEGIR PACIENTE ---
  final seleccionado = await showModalBottomSheet<Map<String, dynamic>>(
    context: context,
    isScrollControlled: true,
    builder: (context) => _buildListaPacientesModal(context, pendientes),
  );

  setState(() { FFAppState().llamandoPaciente = false; });

  if (seleccionado != null) {
    // Llamar paciente seleccionado
    final idTurnoLlamar = seleccionado['IdTurno'];
    final res = await LlamarPacienteCall.call(idTurnoWS: idTurnoLlamar);
    print('📦 [Ambulatorio] Respuesta LlamarPacienteCall: ${res.bodyText}');
    if (res.succeeded) {
      FFAppState().ultimoTurnoLlamado = seleccionado;
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Paciente llamado correctamente.")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error llamando al paciente.")),
      );
    }
  }
}


  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    // Habilita el botón si hay un paciente llamado pendiente de evolución
    final bool puedeEvolucionar = FFAppState().ultimoTurnoLlamado != null;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        body: SafeArea(
          top: true,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Header
              Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(18.0, 20.0, 18.0, 0.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 50.0,
                          height: 50.0,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: Image.asset(
                            'assets/images/logo_excelencia.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 5.0, 0.0),
                            child: Text(
                              getJsonField(FFAppState().userData, r'''$.nombre''').toString(),
                              textAlign: TextAlign.end,
                              style: FlutterFlowTheme.of(context)
                                  .headlineSmall
                                  .override(
                                    font: GoogleFonts.outfit(
                                      fontWeight: FontWeight.normal,
                                      fontStyle: FlutterFlowTheme.of(context).headlineSmall.fontStyle,
                                    ),
                                    color: FlutterFlowTheme.of(context).primary,
                                    fontSize: 18.0,
                                  ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            await showModalBottomSheet(
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              context: context,
                              builder: (context) {
                                return GestureDetector(
                                  onTap: () {
                                    FocusScope.of(context).unfocus();
                                  },
                                  child: Padding(
                                    padding: MediaQuery.viewInsetsOf(context),
                                    child: Container(
                                      height: MediaQuery.sizeOf(context).height * 0.5,
                                      child: NeoWidget(),
                                    ),
                                  ),
                                );
                              },
                            ).then((value) => setState(() {}));
                          },
                          child: Icon(
                            Icons.location_history,
                            color: FlutterFlowTheme.of(context).primary,
                            size: 44.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(18.0, 20.0, 18.0, 0.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () async {
                        context.safePop();
                      },
                      child: Icon(
                        Icons.arrow_back,
                        color: FlutterFlowTheme.of(context).primary,
                        size: 28.0,
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 5.0, 0.0),
                        child: GradientText(
                          'Ambulatorio',
                          textAlign: TextAlign.center,
                          style: FlutterFlowTheme.of(context)
                              .headlineSmall
                              .override(
                                font: GoogleFonts.outfit(
                                  fontWeight: FontWeight.normal,
                                  fontStyle: FlutterFlowTheme.of(context).headlineSmall.fontStyle,
                                ),
                                color: FlutterFlowTheme.of(context).primary,
                                fontSize: 22.0,
                              ),
                          colors: [
                            FlutterFlowTheme.of(context).primary,
                            FlutterFlowTheme.of(context).secondary
                          ],
                          gradientDirection: GradientDirection.rtl,
                          gradientType: GradientType.linear,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.arrow_back,
                      color: Colors.transparent,
                      size: 28.0,
                    ),
                  ],
                ),
              ),
              // BOTONES DEL AMBULATORIO
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 30.0, 0.0, 0.0),
                child: Column(
                  children: [
                    // Botón "Llamar Paciente"
                    InkWell(
                      onTap: FFAppState().llamandoPaciente
                          ? null
                          : () async {
                              await _llamarPaciente();
                            },
                      child: Container(
                        width: MediaQuery.sizeOf(context).width * 0.9,
                        height: 80.0,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              FlutterFlowTheme.of(context).primary,
                              FlutterFlowTheme.of(context).secondary
                            ],
                            stops: [0.0, 1.0],
                            begin: AlignmentDirectional(1.0, 0.0),
                            end: AlignmentDirectional(-1.0, 0),
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(20.0, 5.0, 20.0, 10.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Icon(
                                    Icons.person_add_alt_1,
                                    color: FlutterFlowTheme.of(context).alternate,
                                    size: 40.0,
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 0.0, 0.0),
                                      child: Text(
                                        'Llamar Paciente',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              font: GoogleFonts.readexPro(
                                                fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                              ),
                                              color: FlutterFlowTheme.of(context).alternate,
                                              fontSize: 20.0,
                                            ),
                                      ),
                                    ),
                                  ),
                                  if (!FFAppState().llamandoPaciente)
                                    Icon(
                                      Icons.arrow_circle_right,
                                      color: FlutterFlowTheme.of(context).alternate,
                                      size: 40.0,
                                    ),
                                  if (FFAppState().llamandoPaciente)
                                    Lottie.asset(
                                      'assets/jsons/lottiePacientes2.json',
                                      width: 100.0,
                                      height: 60.0,
                                      fit: BoxFit.fill,
                                      animate: true,
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ).animateOnPageLoad(
                        animationsMap['containerOnPageLoadAnimation']!),
                    const SizedBox(height: 24),
                    // Botón "Mis Turnos"
                     InkWell(
        borderRadius: BorderRadius.circular(18),
        splashColor: FlutterFlowTheme.of(context).primary.withOpacity(0.13),
        highlightColor: FlutterFlowTheme.of(context).secondary.withOpacity(0.09),
        onTap: () => context.push(MisTurnosWidget.routePath),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          width: MediaQuery.sizeOf(context).width * 0.9,
          height: 80,
          curve: Curves.easeIn,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                FlutterFlowTheme.of(context).primary,
                FlutterFlowTheme.of(context).secondary.withOpacity(0.88)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: FlutterFlowTheme.of(context).primary.withOpacity(0.10),
                blurRadius: 13,
                offset: const Offset(0, 5),
              ),
            ],
            border: Border.all(
              color: FlutterFlowTheme.of(context).secondary,
              width: 1.7,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 18),
              Icon(
                Icons.calendar_month_rounded,
                color: FlutterFlowTheme.of(context).alternate,
                size: 38,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Mis Turnos',
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.w700,
                    fontSize: 22,
                    color: FlutterFlowTheme.of(context).alternate,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_circle_right,
                color: FlutterFlowTheme.of(context).alternate,
                size: 36,
              ),
              const SizedBox(width: 18),
            ],
          ),
        ),
      ),

      const SizedBox(height: 26),

      // --- Botón "Evolucionar" ---
      InkWell(
        borderRadius: BorderRadius.circular(18),
        splashColor: puedeEvolucionar
            ? FlutterFlowTheme.of(context).secondary.withOpacity(0.14)
            : Colors.transparent,
        highlightColor: puedeEvolucionar
            ? FlutterFlowTheme.of(context).primary.withOpacity(0.10)
            : Colors.transparent,
        onTap: puedeEvolucionar
            ? () => context.push(EvolucionarWidget.routePath)
            : () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Debe llamar primero a un paciente para evolucionar.')),
              ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          width: MediaQuery.sizeOf(context).width * 0.9,
          height: 80,
          curve: Curves.easeIn,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: puedeEvolucionar
                  ? [
                      FlutterFlowTheme.of(context).secondary,
                      FlutterFlowTheme.of(context).primary,
                    ]
                  : [Colors.grey.shade300, Colors.grey.shade400],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              if (puedeEvolucionar)
                BoxShadow(
                  color: FlutterFlowTheme.of(context).secondary.withOpacity(0.13),
                  blurRadius: 13,
                  offset: const Offset(0, 4),
                ),
            ],
            border: Border.all(
              color: puedeEvolucionar
                  ? FlutterFlowTheme.of(context).primary
                  : Colors.grey.shade400,
              width: 1.7,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(width: 18),
              Icon(
                Icons.assignment_turned_in_rounded,
                color: puedeEvolucionar
                    ? FlutterFlowTheme.of(context).alternate
                    : Colors.grey.shade600,
                size: 36,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Evolucionar',
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.w700,
                    fontSize: 22,
                    color: puedeEvolucionar
                        ? FlutterFlowTheme.of(context).alternate
                        : Colors.grey.shade600,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_circle_right,
                color: puedeEvolucionar
                    ? FlutterFlowTheme.of(context).alternate
                    : Colors.grey.shade600,
                size: 34,
              ),
              const SizedBox(width: 18),
            ],
          ),
        ),
      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildListaPacientesModal(BuildContext context, List<Map<String, dynamic>> pendientes) {
  return SafeArea(
    child: Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: 20,
        left: 16,
        right: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Seleccionar paciente a llamar', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          ListView.separated(
            shrinkWrap: true,
            itemCount: pendientes.length,
            separatorBuilder: (_, __) => Divider(),
            itemBuilder: (context, index) {
              final t = pendientes[index];
              return ListTile(
                leading: Icon(Icons.person),
                title: Text('${t['Apellido'] ?? ''}, ${t['Nombre'] ?? ''}'),
                subtitle: Text('Turno: ${t['Turno_Inicio'] ?? ''}'),
                onTap: () => Navigator.of(context).pop(t),
              );
            },
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar'),
          )
        ],
      ),
    ),
  );
}

}
