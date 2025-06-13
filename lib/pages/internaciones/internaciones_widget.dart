import 'package:h_c_web/pages/pacientes_internados/panel_camas_widget.dart';

import '/components/neo_widget.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:math';
import 'dart:ui';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../backend/api_requests/api_calls.dart';
import '/custom_code/actions/index.dart' as actions;
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'internaciones_model.dart';
export 'internaciones_model.dart';

// ======= PROVIDER para el Prestador (copiar esto arriba del widget) =======
class PrestadorProvider extends ChangeNotifier {
  int? idUsuario;
  int? idInstitucion;
  int? idPrestador;
  bool loading = false;

  PrestadorProvider(BuildContext context) {
    _init(context);
  }

  Future<void> _init(BuildContext context) async {
    print('[PrestadorProvider] Iniciando...');
    idUsuario = int.tryParse(FFAppState().userData?['idUsuario'].toString() ?? '0') ?? 0;
    idInstitucion = int.tryParse(FFAppState().idInstitucionSeleccionado.toString()) ?? 0;
    print('[PrestadorProvider] idUsuario: $idUsuario | idInstitucion: $idInstitucion');
    loading = true;
    notifyListeners();

    var respPrestador = await GetPrestadorPorUsuarioCall.call(
      idUsuario: idUsuario!,
      idInstitucion: idInstitucion!,
    );
    int? idPrestadorExtraido;
    try {
      final body = respPrestador.jsonBody;
      print('[PrestadorProvider] Respuesta GetPrestadorPorUsuario: $body');
      if (body['d'] != null) {
        var d = body['d'];
        if (d is Map && d['SuccessMessage'] != null && d['ContainsErrors'] == false) {
          idPrestadorExtraido = int.tryParse(d['SuccessMessage'].toString());
          print('[PrestadorProvider] idPrestadorExtraido: $idPrestadorExtraido');
        }
      }
    } catch (e) {
      print('[PrestadorProvider] Error extrayendo idPrestador: $e');
      idPrestadorExtraido = null;
    }
    idPrestador = idPrestadorExtraido ?? 0;
    print('[PrestadorProvider] idPrestador FINAL: $idPrestador');
    loading = false;
    notifyListeners();
  }
}
// ==========================================================================

class InternacionesWidget extends StatefulWidget {
  const InternacionesWidget({super.key});
  static String routeName = 'Internaciones';
  static String routePath = '/internaciones';

  @override
  State<InternacionesWidget> createState() => _InternacionesWidgetState();
}

class _InternacionesWidgetState extends State<InternacionesWidget>
    with TickerProviderStateMixin {
  late InternacionesModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final animationsMap = <String, AnimationInfo>{};

  // Para guardar resultados de la API "Lista de Pacientes"
  dynamic _apiResultListaPacientes;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => InternacionesModel());
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
    print('[Internaciones] initState');
  }

  @override
  void dispose() {
    _model.dispose();
    print('[Internaciones] dispose');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    // ENVOLVEMOS TODO en el Provider:
    return ChangeNotifierProvider(
      create: (_) => PrestadorProvider(context),
      builder: (context, child) {
        final prestadorProv = Provider.of<PrestadorProvider>(context);

        if (prestadorProv.loading) {
          print('[Internaciones] Esperando Provider...');
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final idUsuario = prestadorProv.idUsuario;
        final idInstitucion = prestadorProv.idInstitucion;
        final idPrestador = prestadorProv.idPrestador;

        print('[Internaciones] build con: idUsuario=$idUsuario, idInstitucion=$idInstitucion, idPrestador=$idPrestador');

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
                  // HEADER
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
                                  getJsonField(
                                    FFAppState().userData,
                                    r'''$.nombre''',
                                  ).toString(),
                                  textAlign: TextAlign.end,
                                  style: FlutterFlowTheme.of(context)
                                      .headlineSmall
                                      .override(
                                        font: GoogleFonts.outfit(
                                          fontWeight: FontWeight.normal,
                                          fontStyle: FlutterFlowTheme.of(context)
                                              .headlineSmall
                                              .fontStyle,
                                        ),
                                        color: FlutterFlowTheme.of(context).primary,
                                        fontSize: 18.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.normal,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .headlineSmall
                                            .fontStyle,
                                      ),
                                ),
                              ),
                            ),
                            InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                await showModalBottomSheet(
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  context: context,
                                  builder: (context) {
                                    return GestureDetector(
                                      onTap: () {
                                        FocusScope.of(context).unfocus();
                                        FocusManager.instance.primaryFocus?.unfocus();
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
                                ).then((value) => safeSetState(() {}));
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
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
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
                              'Internaciones',
                              textAlign: TextAlign.center,
                              style: FlutterFlowTheme.of(context)
                                  .headlineSmall
                                  .override(
                                    font: GoogleFonts.outfit(
                                      fontWeight: FontWeight.normal,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .headlineSmall
                                          .fontStyle,
                                    ),
                                    color: FlutterFlowTheme.of(context).primary,
                                    fontSize: 22.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.normal,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .headlineSmall
                                        .fontStyle,
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
                  // Botón de Evolución Diaria
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 0.0),
                    child: InkWell(
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () async {
                        print('[Internaciones] Tap Evolución Diaria');
                        print('  idUsuario: $idUsuario | idInstitucion: $idInstitucion | idPrestador: $idPrestador');
                        context.pushNamed(
                          EvolucionScanQRWidget.routeName,
                          extra: <String, dynamic>{
                            kTransitionInfoKey: TransitionInfo(
                              hasTransition: true,
                              transitionType: PageTransitionType.fade,
                              duration: Duration(milliseconds: 0),
                            ),
                          },
                        );
                      },
                      child: Container(
                        width: MediaQuery.sizeOf(context).width * 0.9,
                        height: 200.0,
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
                              padding: EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 0.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.asset(
                                  'assets/images/Background.png',
                                  height: 120.0,
                                  fit: BoxFit.fitWidth,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(20.0, 5.0, 20.0, 10.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Evolución\nDiaria',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          font: GoogleFonts.readexPro(
                                            fontWeight: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .fontWeight,
                                            fontStyle: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .fontStyle,
                                          ),
                                          color: FlutterFlowTheme.of(context)
                                              .alternate,
                                          fontSize: 20.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .fontWeight,
                                          fontStyle: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .fontStyle,
                                        ),
                                  ),
                                  Icon(
                                    Icons.arrow_circle_right,
                                    color: FlutterFlowTheme.of(context).alternate,
                                    size: 40.0,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ).animateOnPageLoad(animationsMap['containerOnPageLoadAnimation']!),
                  ),
                  // NUEVO Botón "Lista de Pacientes"
Padding(
  padding: EdgeInsetsDirectional.fromSTEB(0.0, 18.0, 0.0, 0.0),
  child: InkWell(
    splashColor: Colors.transparent,
    focusColor: Colors.transparent,
    hoverColor: Colors.transparent,
    highlightColor: Colors.transparent,
    onTap: () async {
      print('[Internaciones] Tap Lista de Pacientes');
      // Lógica: podés navegar a otra vista, abrir modal, o llamar la API que corresponda.
      context.pushNamed(
        PanelCamasWidget.routeName, // o el widget correcto si es otro
        extra: <String, dynamic>{
          kTransitionInfoKey: TransitionInfo(
            hasTransition: true,
            transitionType: PageTransitionType.fade,
            duration: Duration(milliseconds: 0),
          ),
        },
      );
    },
    child: Container(
      width: MediaQuery.sizeOf(context).width * 0.9,
      height: 200.0,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            FlutterFlowTheme.of(context).secondary, // Le doy vuelta el gradiente para diferenciarlo un poco
            FlutterFlowTheme.of(context).primary
          ],
          stops: [0.0, 1.0],
          begin: AlignmentDirectional(-1.0, 0.0),
          end: AlignmentDirectional(1.0, 0),
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 0.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.asset(
                'assets/images/Background.png', // Usá otra imagen si querés
                height: 120.0,
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(20.0, 5.0, 20.0, 10.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Lista de\nPacientes',
                  style: FlutterFlowTheme.of(context)
                      .bodyMedium
                      .override(
                        font: GoogleFonts.readexPro(
                          fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                          fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                        ),
                        color: FlutterFlowTheme.of(context).alternate,
                        fontSize: 20.0,
                        letterSpacing: 0.0,
                      ),
                ),
                Icon(
                  Icons.groups_2_rounded, // ícono de grupo/pacientes
                  color: FlutterFlowTheme.of(context).alternate,
                  size: 40.0,
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  ).animateOnPageLoad(animationsMap['containerOnPageLoadAnimation']!),
),
                  
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
