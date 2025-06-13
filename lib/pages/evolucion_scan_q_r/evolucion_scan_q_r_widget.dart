import '/backend/api_requests/api_calls.dart';
import '/components/neo_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'evolucion_scan_q_r_model.dart';
export 'evolucion_scan_q_r_model.dart';

// =============== PROVIDER Prestador ===============
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
// =================================================

class EvolucionScanQRWidget extends StatefulWidget {
  const EvolucionScanQRWidget({super.key});

  static String routeName = 'EvolucionScanQR';
  static String routePath = '/evolucionScanQR';

  @override
  State<EvolucionScanQRWidget> createState() => _EvolucionScanQRWidgetState();
}

class _EvolucionScanQRWidgetState extends State<EvolucionScanQRWidget> {
  late EvolucionScanQRModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => EvolucionScanQRModel());
    print('[EvolucionScanQR] initState');
  }

  @override
  void dispose() {
    _model.dispose();
    print('[EvolucionScanQR] dispose');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return ChangeNotifierProvider(
      create: (_) => PrestadorProvider(context),
      builder: (context, child) {
        final prestadorProv = Provider.of<PrestadorProvider>(context);

        if (prestadorProv.loading) {
          print('[EvolucionScanQR] Esperando Provider...');
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final idUsuario = prestadorProv.idUsuario;
        final idInstitucion = prestadorProv.idInstitucion;
        final idPrestador = prestadorProv.idPrestador;

        print('[EvolucionScanQR] build con: idUsuario=$idUsuario, idInstitucion=$idInstitucion, idPrestador=$idPrestador');

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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ---- Header con logs ----
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
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0.0, 11.0, 0.0, 0.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 0.0, 0.0),
                              child: InkWell(
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
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // ---- Main body ----
                  Expanded(
                    flex: 4,
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 0.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            flex: 3,
                            child: Align(
                              alignment: AlignmentDirectional(0.0, -0.5),
                              child: Lottie.asset(
                                'assets/jsons/BtuKi5Yh80.json',
                                width: MediaQuery.sizeOf(context).width * 1.0,
                                height: 300.0,
                                fit: BoxFit.cover,
                                animate: true,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 0.0),
                                  child: FFButtonWidget(
                                    onPressed: () async {
                                      print('[EvolucionScanQR] Presionó Escanear QR');
                                      print('  idUsuario: $idUsuario | idInstitucion: $idInstitucion | idPrestador: $idPrestador');

                                      _model.valorQR = await FlutterBarcodeScanner.scanBarcode(
                                        '#C62828', // scanning line color
                                        'Cancelar', // cancel button text
                                        true, // show flash icon
                                        ScanMode.QR,
                                      );
                                      print('[EvolucionScanQR] valorQR: ${_model.valorQR}');

                                      if (_model.valorQR != null && _model.valorQR != '') {
                                        _model.verifiedQR = await actions.verifiedQRCode(_model.valorQR);
                                        print('[EvolucionScanQR] verifiedQR: ${_model.verifiedQR}');

                                        if (_model.verifiedQR == 3) {
                                          FFAppState().Evoluciones = null;
                                          FFAppState().Evolucionessss = '';
                                          safeSetState(() {});

                                          _model.apiResultppx = await EvolucionesDiariasCall.call(
                                            idInstitucionM: FFAppState().QRIdInstitucionINT,
                                            idCamaM: FFAppState().QRCamaINT,
                                          );
                                          print('[EvolucionScanQR] API EvolucionesDiarias status: ${_model.apiResultppx?.statusCode}');
                                          final responseBody = _model.apiResultppx?.bodyText ?? '';
                                          print('[EvolucionScanQR] API EvolucionesDiarias body: $responseBody');

                                          if ((_model.apiResultppx?.succeeded ?? true)) {
                                            await actions.extractJsonFromString(responseBody);
                                            print('[EvolucionScanQR] Datos extraídos, navegando a PacienteWidget...');
                                            context.pushNamed(
                                              PacienteWidget.routeName,
                                              extra: <String, dynamic>{
                                                kTransitionInfoKey: TransitionInfo(
                                                  hasTransition: true,
                                                  transitionType: PageTransitionType.fade,
                                                ),
                                              },
                                            );
                                          } else {
                                            print('[EvolucionScanQR] API Call Failed: ${_model.apiResultppx?.bodyText}');
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  'La internacion no existe: ${_model.apiResultppx?.bodyText ?? "Unknown error"}',
                                                  style: TextStyle(
                                                    color: FlutterFlowTheme.of(context).secondaryBackground,
                                                  ),
                                                ),
                                                duration: Duration(milliseconds: 4000),
                                                backgroundColor: FlutterFlowTheme.of(context).error,
                                              ),
                                            );
                                          }
                                        } else {
                                          print('[EvolucionScanQR] QR INVÁLIDO/VACÍO');
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'QR INVÁLIDO/VACÍO',
                                                style: TextStyle(
                                                  color: FlutterFlowTheme.of(context).secondaryBackground,
                                                ),
                                              ),
                                              duration: Duration(milliseconds: 4000),
                                              backgroundColor: Color(0xFFA0272E),
                                            ),
                                          );
                                        }
                                      } else {
                                        print('[EvolucionScanQR] No se leyó ningún QR');
                                      }
                                      safeSetState(() {});
                                    },
                                    text: 'Escanear QR',
                                    icon: Icon(
                                      Icons.qr_code_scanner_outlined,
                                      color: FlutterFlowTheme.of(context).primaryBackground,
                                      size: 20.0,
                                    ),
                                    options: FFButtonOptions(
                                      height: 50.0,
                                      padding: EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 0.0),
                                      iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                      color: FlutterFlowTheme.of(context).primary,
                                      textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                            font: GoogleFonts.readexPro(
                                              fontWeight: FlutterFlowTheme.of(context).titleSmall.fontWeight,
                                              fontStyle: FlutterFlowTheme.of(context).titleSmall.fontStyle,
                                            ),
                                            color: Colors.white,
                                            fontSize: 16.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FlutterFlowTheme.of(context).titleSmall.fontWeight,
                                            fontStyle: FlutterFlowTheme.of(context).titleSmall.fontStyle,
                                          ),
                                      elevation: 3.0,
                                      borderSide: BorderSide(
                                        color: Colors.transparent,
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(24.0),
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
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
