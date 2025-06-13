import 'dart:convert';
import 'package:flutter/material.dart';
import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

// --- HELPER ---
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

class MisTurnosWidget extends StatefulWidget {
  const MisTurnosWidget({Key? key}) : super(key: key);

  static String routeName = 'MisTurnos';
  static String routePath = '/misTurnos';

  @override
  State<MisTurnosWidget> createState() => _MisTurnosWidgetState();
}

class _MisTurnosWidgetState extends State<MisTurnosWidget> {
  DateTime fechaSeleccionada = DateTime.now();
  bool cargando = false;
  List<dynamic> turnos = [];

  @override
  void initState() {
    super.initState();
    cargarTurnos();
  }

  Future<void> cargarTurnos() async {
    setState(() { cargando = true; });

    final idInstitucion = int.tryParse(FFAppState().idInstitucionSeleccionado.toString()) ?? 0;
    final idPrestador = await obtenerIdPrestadorActual();
    final fechaString = DateFormat('yyyy-MM-dd').format(fechaSeleccionada);

    final apiResult = await ListaPacientesLlamadosCall.call(
      idInstitucionWS: idInstitucion,
      idPrestadorWS: idPrestador,
      fecha: fechaString,
    );

    String? xml = apiResult.bodyText;
    final regex = RegExp(r'<SuccessMessage>(.*?)</SuccessMessage>', dotAll: true);
    final match = regex.firstMatch(xml ?? '');

    if (match != null) {
      final successMsg = match.group(1);
      try {
        final data = List<Map<String, dynamic>>.from(json.decode(successMsg!));
        setState(() { turnos = data; });
      } catch (e) {
        setState(() { turnos = []; });
      }
    } else {
      setState(() { turnos = []; });
    }
    setState(() { cargando = false; });
  }

  Future<void> _seleccionarFecha() async {
    final nuevaFecha = await showDatePicker(
      context: context,
      initialDate: fechaSeleccionada,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      locale: const Locale('es', ''),
      builder: (context, child) {
        // Personalizamos el modal del calendario
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: FlutterFlowTheme.of(context).primary, // header
              onPrimary: Colors.white, // texto de header
              surface: Colors.white,
              onSurface: FlutterFlowTheme.of(context).primary,
            ),
            dialogBackgroundColor: Colors.white,
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: FlutterFlowTheme.of(context).secondary,
              ),
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: child!,
          ),
        );
      },
    );
    if (nuevaFecha != null) {
      setState(() { fechaSeleccionada = nuevaFecha; });
      await cargarTurnos();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
   final fechaStr = DateFormat('EEEE dd \'de\' MMMM yyyy', 'es')
    .format(fechaSeleccionada);

// Capitaliza solo la primera letra, compatible con Flutter:
final fechaStrCapitalizada =
    fechaStr.isNotEmpty ? fechaStr[0].toUpperCase() + fechaStr.substring(1) : fechaStr;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).primary,
        elevation: 1.5,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 26),
          onPressed: () => Navigator.pop(context),
          tooltip: 'Volver',
        ),
        title: Text(
          "Mis Turnos",
          style: GoogleFonts.outfit(
            fontSize: 23,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 0.6,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_today_rounded, size: 25, color: Colors.white),
            tooltip: 'Cambiar Fecha',
            onPressed: _seleccionarFecha,
          )
        ],
      ),
      backgroundColor: isDark
          ? FlutterFlowTheme.of(context).secondaryBackground
          : const Color(0xFFF4F7FB),
      body: Column(
        children: [
          // --- CHIP FECHA ---
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 18, 14, 4),
            child: GestureDetector(
              onTap: _seleccionarFecha,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).primary,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: FlutterFlowTheme.of(context).primary.withOpacity(0.13),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                  border: Border.all(
                    color: FlutterFlowTheme.of(context).secondary,
                    width: 1.3,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.calendar_month_rounded, color: Colors.white, size: 27),
                    const SizedBox(width: 12),
                    Text(
                      fechaStrCapitalizada,
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // --- LISTADO DE TURNOS ---
          Expanded(
            child: cargando
                ? Center(child: CircularProgressIndicator())
                : turnos.isEmpty
                    ? Center(
                        child: Text(
                          'No hay turnos para la fecha seleccionada',
                          style: GoogleFonts.outfit(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[isDark ? 400 : 600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
                        itemCount: turnos.length,
                        itemBuilder: (context, index) {
                          final turno = turnos[index];
                          final hora = turno['Turno_Inicio']?.toString().substring(11, 16) ?? '--:--';
                          final llamado = turno['HoraLlamada'] ?? null;
                          return Card(
                            elevation: 4,
                            margin: const EdgeInsets.only(bottom: 18),
                            color: isDark
                                ? FlutterFlowTheme.of(context).primaryBackground
                                : Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 29,
                                    backgroundColor: FlutterFlowTheme.of(context).primary,
                                    child: Icon(
                                      Icons.person_rounded,
                                      color: Colors.white,
                                      size: 32,
                                    ),
                                  ),
                                  const SizedBox(width: 18),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${turno['Nombre']} ${turno['Apellido']}',
                                          style: GoogleFonts.outfit(
                                            fontSize: 19,
                                            fontWeight: FontWeight.bold,
                                            color: FlutterFlowTheme.of(context).primary,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          'Hora: $hora',
                                          style: GoogleFonts.outfit(
                                            fontSize: 15,
                                            color: Colors.blueGrey[isDark ? 200 : 600],
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          llamado != null && llamado.toString().isNotEmpty && llamado.toString() != 'null'
                                              ? 'Llamado: $llamado'
                                              : 'Llamado: Sin llamar',
                                          style: GoogleFonts.outfit(
                                            fontSize: 15,
                                            color: llamado != null && llamado.toString().isNotEmpty && llamado.toString() != 'null'
                                                ? Colors.green[700]
                                                : Colors.orange[800],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
