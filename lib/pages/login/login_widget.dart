import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:convert';
import 'package:xml/xml.dart' as xml;
import 'dart:ui';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'login_model.dart';
export 'login_model.dart';

class LoginWidget extends StatefulWidget {
  const LoginWidget({super.key});

  static String routeName = 'Login';
  static String routePath = '/login';

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  late LoginModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => LoginModel());

    _model.cuilTextController ??= TextEditingController();
    _model.cuilFocusNode ??= FocusNode();

    _model.contrasenaTextController ??= TextEditingController();
    _model.contrasenaFocusNode ??= FocusNode();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.asset(
                            'assets/images/logo_excelencia-removebg-preview.png',
                            width: 200.0,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Form(
                  key: _model.formKey,
                  autovalidateMode: AutovalidateMode.disabled,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(30.0, 0.0, 30.0, 0.0),
                                child: TextFormField(
                                  controller: _model.cuilTextController,
                                  focusNode: _model.cuilFocusNode,
                                  autofocus: false,
                                  obscureText: false,
                                  decoration: InputDecoration(
                                    labelText: 'Ingrese Email o Usuario',
                                    labelStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          font: GoogleFonts.outfit(
                                            fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                            fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                          ),
                                          color: FlutterFlowTheme.of(context).secondaryText,
                                          letterSpacing: 0.0,
                                        ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: FlutterFlowTheme.of(context).secondaryText,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(0.0),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: FlutterFlowTheme.of(context).primary,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(0.0),
                                    ),
                                    errorBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: FlutterFlowTheme.of(context).error,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(0.0),
                                    ),
                                    focusedErrorBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: FlutterFlowTheme.of(context).error,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(0.0),
                                    ),
                                  ),
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        font: GoogleFonts.outfit(
                                          fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                          fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                        ),
                                        fontSize: 16.0,
                                        letterSpacing: 0.0,
                                      ),
                                  validator: _model.cuilTextControllerValidator
                                      .asValidator(context),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(0.0, 15.0, 0.0, 0.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(30.0, 0.0, 30.0, 0.0),
                                child: TextFormField(
                                  controller: _model.contrasenaTextController,
                                  focusNode: _model.contrasenaFocusNode,
                                  autofocus: false,
                                  obscureText: !_model.contrasenaVisibility,
                                  decoration: InputDecoration(
                                    labelText: 'Contraseña',
                                    labelStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          font: GoogleFonts.outfit(
                                            fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                            fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                          ),
                                          color: FlutterFlowTheme.of(context).secondaryText,
                                          letterSpacing: 0.0,
                                        ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: FlutterFlowTheme.of(context).secondaryText,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(0.0),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: FlutterFlowTheme.of(context).primary,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(0.0),
                                    ),
                                    errorBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: FlutterFlowTheme.of(context).error,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(0.0),
                                    ),
                                    focusedErrorBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: FlutterFlowTheme.of(context).error,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(0.0),
                                    ),
                                    suffixIcon: InkWell(
                                      onTap: () => safeSetState(
                                        () => _model.contrasenaVisibility = !_model.contrasenaVisibility,
                                      ),
                                      focusNode: FocusNode(skipTraversal: true),
                                      child: Icon(
                                        _model.contrasenaVisibility
                                            ? Icons.visibility_outlined
                                            : Icons.visibility_off_outlined,
                                        color: FlutterFlowTheme.of(context).primary,
                                        size: 22.0,
                                      ),
                                    ),
                                  ),
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        font: GoogleFonts.outfit(
                                          fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                          fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                        ),
                                        fontSize: 16.0,
                                        letterSpacing: 0.0,
                                      ),
                                  validator: _model.contrasenaTextControllerValidator.asValidator(context),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(0.0, 45.0, 0.0, 0.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(40.0, 0.0, 40.0, 0.0),
                                child: FFButtonWidget(
                                  onPressed: () async {
                                    try {
                                      print('[LOGIN] --- INICIO ---');
                                      final user = _model.cuilTextController.text.trim();
                                      final pass = _model.contrasenaTextController.text;
                                      print('[LOGIN] --- Usuario: [$user] | Password: [$pass]');

                                      // (1) Log del body que se enviará
                                      final loginBody = {
                                        "usuario": user,
                                        "password": pass,
                                      };
                                      print('[LOGIN] --- Body JSON: ${jsonEncode(loginBody)}');

                                      // (2) Llamada al endpoint
                                      final loginResult = await LoginMobileCall.call(user: user, password: pass);
                                      print('[LOGIN] --- Resultado crudo de loginResult: ${loginResult.jsonBody}');

                                      // (3) Parseo de la respuesta
                                      dynamic loginJson;
                                      try {
                                        loginJson = loginResult.jsonBody is String
                                            ? jsonDecode(loginResult.jsonBody)
                                            : loginResult.jsonBody;
                                      } catch (e) {
                                        print('[LOGIN] --- ERROR al parsear JSON: $e');
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Error de formato en la respuesta del servidor')),
                                        );
                                        return;
                                      }
                                      print('[LOGIN] --- JSON Decodificado: $loginJson');

                                      // (4) Acceso al nodo principal ["d"]
                                      dynamic result;
                                      if (loginJson is Map && loginJson.containsKey('d')) {
                                        result = loginJson['d'];
                                        print('[LOGIN] --- Usando result = loginJson["d"]');
                                      } else {
                                        result = loginJson;
                                        print('[LOGIN] --- Usando result = loginJson');
                                      }
                                      print('[LOGIN] --- Result después de ["d"]: $result');

                                      // (5) Decodificar SuccessMessage si existe
                                      dynamic loginData;
                                      if (result is Map && result.containsKey('SuccessMessage')) {
                                        try {
                                          loginData = jsonDecode(result['SuccessMessage']);
                                          print('[LOGIN] --- loginData decodificado: $loginData');
                                        } catch (e) {
                                          print('[LOGIN] --- ERROR al decodificar SuccessMessage: $e');
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text('Error de formato interno de la respuesta')),
                                          );
                                          return;
                                        }
                                      } else {
                                        print('[LOGIN] --- ERROR: SuccessMessage no encontrado en result');
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Respuesta inesperada del servidor')),
                                        );
                                        return;
                                      }

                                      // (6) Validación de login usando loginData
                                      if (!(loginData['success'] == true || loginData['success'] == "true")) {
                                        print('[LOGIN] --- Login incorrecto: ${loginData['message']}');
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text(loginData['message'] ?? 'Login incorrecto')),
                                        );
                                        return;
                                      }
                                      print('[LOGIN] --- LOGIN EXITOSO');

                                      // (7) Guardar en FFAppState
                                      FFAppState().userData = loginData['usuario'];
                                      FFAppState().institucionesJSON = loginData['instituciones'];
                                      FFAppState().idInstitucionSeleccionado =
                                          (loginData['instituciones'] as List).isNotEmpty
                                              ? loginData['instituciones'][0]['idInstitucion']
                                              : 0;

                                      print('[LOGIN] --- FFAppState.userData: ${FFAppState().userData}');
                                      print('[LOGIN] --- FFAppState.institucionesJSON: ${FFAppState().institucionesJSON}');
                                      print('[LOGIN] --- FFAppState.idInstitucionSeleccionado: ${FFAppState().idInstitucionSeleccionado}');

                                      // (8) Limpiar inputs
                                      _model.cuilTextController?.clear();
                                      _model.contrasenaTextController?.clear();

                                      print('[LOGIN] --- Navegando al Home');
                                      // (9) Navegar al Home
                                      context.goNamed(
                                        HomeOficialWidget.routeName,
                                        extra: <String, dynamic>{
                                          kTransitionInfoKey: TransitionInfo(
                                            hasTransition: true,
                                            transitionType: PageTransitionType.leftToRight,
                                          ),
                                        },
                                      );
                                    } catch (e, st) {
                                      print('[LOGIN] --- ERROR GENERAL: $e');
                                      print('[LOGIN] --- STACKTRACE: $st');
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('No se pudo procesar la respuesta del servidor: $e')),
                                      );
                                    }
                                  },
                                  text: 'Iniciar sesión',
                                  options: FFButtonOptions(
                                    height: 40.0,
                                    padding: const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                                    iconPadding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                                    color: FlutterFlowTheme.of(context).secondaryBackground,
                                    textStyle: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .override(
                                          font: GoogleFonts.outfit(
                                            fontWeight: FlutterFlowTheme.of(context).titleSmall.fontWeight,
                                            fontStyle: FlutterFlowTheme.of(context).titleSmall.fontStyle,
                                          ),
                                          color: FlutterFlowTheme.of(context).primary,
                                          letterSpacing: 0.0,
                                        ),
                                    borderSide: BorderSide(
                                      color: FlutterFlowTheme.of(context).primary,
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(4.0),
                                    hoverColor: FlutterFlowTheme.of(context).primary,
                                    hoverBorderSide: BorderSide(
                                      color: FlutterFlowTheme.of(context).primary,
                                      width: 1.0,
                                    ),
                                    hoverTextColor: FlutterFlowTheme.of(context).primaryBackground,
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
