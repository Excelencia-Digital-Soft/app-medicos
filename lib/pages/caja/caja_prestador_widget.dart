import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'caja_prestador_model.dart';

class CajaPrestadorWidget extends StatefulWidget {
  static String routeName = 'CajaPrestador';
  static String routePath = '/cajaPrestador';

  const CajaPrestadorWidget({super.key});
  @override
  State<CajaPrestadorWidget> createState() => _CajaPrestadorWidgetState();
}

class _CajaPrestadorWidgetState extends State<CajaPrestadorWidget> {
  final NumberFormat _formatter = NumberFormat("#,##0.00", "es_AR");

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CajaPrestadorModel>(
      create: (_) => CajaPrestadorModel(),
      builder: (context, child) {
        final model = Provider.of<CajaPrestadorModel>(context);

        final isMobile = MediaQuery.of(context).size.width < 600;
        return Scaffold(
          appBar: AppBar(
            title: Text('Caja Prestador', style: GoogleFonts.outfit(fontWeight: FontWeight.w700)),
            backgroundColor: FlutterFlowTheme.of(context).primary,
            elevation: 2,
            leading: BackButton(color: Colors.white),
          ),
          backgroundColor: Color(0xFFF5F7FA),
          floatingActionButton: isMobile
              ? Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: FloatingActionButton.extended(
                    icon: Icon(Icons.arrow_back),
                    backgroundColor: Colors.blue[900],
                    label: Text('Volver', style: GoogleFonts.outfit(fontSize: 17, fontWeight: FontWeight.bold)),
                    onPressed: () => Navigator.pop(context),
                  ),
                )
              : null,
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          body: LayoutBuilder(
            builder: (context, constraints) {
              // ==== FILTROS Y ACCIONES ARRIBA ====
              final filtroWidgets = isMobile
                  ? Row(
                      children: [
                        Expanded(
                          child: _FiltroFecha(
                            label: "Desde",
                            fecha: model.fechaDesde,
                            onTap: () async {
                              final picked = await _selectDate(context, true, model.fechaDesde);
                              if (picked != null) model.fechaDesde = picked;
                              model.notifyListeners();
                            },
                          ),
                        ),
                        SizedBox(width: 6),
                        Expanded(
                          child: _FiltroFecha(
                            label: "Hasta",
                            fecha: model.fechaHasta,
                            onTap: () async {
                              final picked = await _selectDate(context, false, model.fechaHasta);
                              if (picked != null) model.fechaHasta = picked;
                              model.notifyListeners();
                            },
                          ),
                        ),
                        SizedBox(width: 6),
                        Column(
                          children: [
                            Checkbox(
                              value: model.misAdmisiones,
                              onChanged: (v) {
                                model.misAdmisiones = v ?? false;
                                model.notifyListeners();
                              },
                              activeColor: Colors.blue[800],
                            ),
                            Text(
                              'Mis\nAdmis.',
                              style: GoogleFonts.outfit(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey[800]),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        SizedBox(width: 4),
                        IconButton(
                          icon: model.isLoading
                              ? SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.blue))
                              : Icon(Icons.table_view, color: Colors.blue[800], size: 28),
                          tooltip: 'Cargar Caja',
                          onPressed: model.isLoading
                              ? null
                              : () async {
                                  await model.cargarCaja(context);
                                },
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(
                          child: _FiltroFecha(
                            label: "Desde",
                            fecha: model.fechaDesde,
                            onTap: () async {
                              final picked = await _selectDate(context, true, model.fechaDesde);
                              if (picked != null) model.fechaDesde = picked;
                              model.notifyListeners();
                            },
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: _FiltroFecha(
                            label: "Hasta",
                            fecha: model.fechaHasta,
                            onTap: () async {
                              final picked = await _selectDate(context, false, model.fechaHasta);
                              if (picked != null) model.fechaHasta = picked;
                              model.notifyListeners();
                            },
                          ),
                        ),
                        SizedBox(width: 12),
                        Checkbox(
                          value: model.misAdmisiones,
                          onChanged: (v) {
                            model.misAdmisiones = v ?? false;
                            model.notifyListeners();
                          },
                          activeColor: Colors.blue[800],
                        ),
                        Text(
                          'Mis Admisiones',
                          style: GoogleFonts.outfit(fontSize: 15, color: Colors.grey[800], fontWeight: FontWeight.w600),
                        ),
                        SizedBox(width: 8),
                        ElevatedButton.icon(
                          icon: model.isLoading
                              ? SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                              : Icon(Icons.table_view, size: 20),
                          label: Padding(
                            padding: EdgeInsets.symmetric(vertical: 2),
                            child: Text('Cargar', style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w600)),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[800],
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            padding: EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                            elevation: 2,
                          ),
                          onPressed: model.isLoading
                              ? null
                              : () async {
                                  await model.cargarCaja(context);
                                },
                        ),
                      ],
                    );

              final totalPacientes = model.cajaList.fold<int>(
                  0,
                  (a, os) => a + ((os["Practicas"] as List?)?.length ?? 0)
              );

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        filtroWidgets,
                        SizedBox(height: 7),
                        Row(
                          children: [
                            _ChipPacientes(totalPacientes: totalPacientes),
                            Spacer(),
                          ],
                        ),
                        SizedBox(height: 6),
                        // Resumen Importes
                        isMobile
                          ? Container(
                              width: double.infinity,
                              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.99),
                              child: Wrap(
                                alignment: WrapAlignment.center,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                spacing: 7,
                                runSpacing: 0,
                                children: [
                                  _ImporteResumen(label: "Total", value: model.total, color: Colors.blue[900], size: 15),
                                  _ImporteResumen(label: "Rendido", value: model.totalCerrado, color: Colors.orange[700], size: 13),
                                  _ImporteResumen(label: "Efectivo", value: model.totalDiferencia, color: Colors.green[800], size: 13),
                                ],
                              ),
                            )
                          : Wrap(
                              alignment: WrapAlignment.center,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 24,
                              children: [
                                _ImporteResumen(label: "Total", value: model.total, color: Colors.blue[900], size: 22),
                                _ImporteResumen(label: "Rendido", value: model.totalCerrado, color: Colors.orange[700], size: 20),
                                _ImporteResumen(label: "Efectivo", value: model.totalDiferencia, color: Colors.green[800], size: 20),
                              ],
                            ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: model.isLoading
                        ? Center(child: CircularProgressIndicator())
                        : (model.cajaList.isEmpty
                            ? Center(
                                child: Text(
                                  'Sin datos',
                                  style: GoogleFonts.outfit(
                                    fontSize: 21,
                                    color: Colors.grey[350],
                                    fontWeight: FontWeight.w600,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              )
                            : ListView.builder(
                                padding: EdgeInsets.only(bottom: isMobile ? 75 : 20, left: 10, right: 10, top: 8),
                                itemCount: model.cajaList.length,
                                itemBuilder: (ctx, i) {
                                  final os = model.cajaList[i];
                                  final practicas = os['Practicas'] as List<dynamic>? ?? [];
                                  return Card(
                                    elevation: 3,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
                                    color: Colors.white,
                                    child: ExpansionTile(
                                      tilePadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                                      title: Text(
                                        os['Nombre'] ?? 'Obra Social',
                                        style: GoogleFonts.outfit(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 20,
                                          color: FlutterFlowTheme.of(context).primary,
                                        ),
                                      ),
                                      children: [
                                        ...practicas.map((p) => Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 18),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          'Paciente:',
                                                          style: GoogleFonts.outfit(fontSize: 13, color: Colors.grey[700]),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                          'Fecha/Hora:',
                                                          style: GoogleFonts.outfit(fontSize: 13, color: Colors.grey[700]),
                                                          textAlign: TextAlign.end,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          '${p['Documento']} - ${p['Paciente']}',
                                                          style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                          p['FechaHora'].toString(),
                                                          style: GoogleFonts.outfit(fontSize: 16),
                                                          textAlign: TextAlign.end,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 2),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        flex: 3,
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text('Práctica:', style: GoogleFonts.outfit(fontSize: 13, color: Colors.grey[700])),
                                                            Text(p['Practica'].toString(), style: GoogleFonts.outfit(fontSize: 16)),
                                                          ],
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 1,
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.end,
                                                          children: [
                                                            Text('Importe:', style: GoogleFonts.outfit(fontSize: 13, color: Colors.grey[700])),
                                                            Text(
                                                              '\$${_formatter.format(double.tryParse(p['Importe'].toString()) ?? 0.0)}',
                                                              style: GoogleFonts.outfit(fontSize: 18, color: Colors.green[800], fontWeight: FontWeight.bold),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 2),
                                                  Text('Usuario Cierra: ${p['Usuario'] ?? ''}', style: GoogleFonts.outfit(fontSize: 13, color: Colors.grey[800])),
                                                  Divider(thickness: 1, height: 18),
                                                ],
                                              ),
                                            )),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: Padding(
                                            padding: const EdgeInsets.only(right: 12, top: 3, bottom: 6),
                                            child: Text(
                                              'SubTotal: \$${_formatter.format(double.tryParse(os['SubTotal'].toString()) ?? 0.0)}',
                                              style: GoogleFonts.outfit(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.teal[700],
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              )),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  // CHIPS y RESUMENES
  Widget _ChipPacientes({required int totalPacientes}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue[100],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue[700]!, width: 1.3),
      ),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.people_alt_rounded, color: Colors.blue[900], size: 20),
          SizedBox(width: 5),
          Text('Atendidos: ', style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.blue[900])),
          Text('$totalPacientes', style: GoogleFonts.outfit(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.green[800])),
        ],
      ),
    );
  }

  Widget _ImporteResumen({required String label, required double value, required Color? color, required double size}) {
    final formatter = NumberFormat("#,##0.00", "es_AR");
    return Container(
      margin: EdgeInsets.symmetric(vertical: 2, horizontal: 2),
      constraints: BoxConstraints(maxWidth: 110), // Para evitar que se desborde en mobile
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: GoogleFonts.outfit(fontSize: size, fontWeight: FontWeight.w600, color: color)),
          FittedBox(
            child: Text(
              '\$${formatter.format(value)}',
              style: GoogleFonts.outfit(fontSize: size + 6, fontWeight: FontWeight.bold, color: color),
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }

  // FECHAS
  Widget _FiltroFecha({required String label, DateTime? fecha, required VoidCallback onTap}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.outfit(fontSize: 13, color: Colors.grey[700], fontWeight: FontWeight.w500)),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            margin: EdgeInsets.only(top: 3),
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
              color: Colors.grey[100],
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today, size: 18, color: Colors.blue[700]),
                SizedBox(width: 7),
                Text(
                  fecha != null
                      ? DateFormat('dd/MM/yyyy').format(fecha)
                      : '--/--/----',
                  style: GoogleFonts.outfit(fontSize: 14, color: Colors.black87),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<DateTime?> _selectDate(BuildContext context, bool isDesde, DateTime? initial) async {
    return await showDatePicker(
      context: context,
      initialDate: initial ?? DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime.now().add(Duration(days: 365)),
      builder: (context, child) => Theme(
        data: ThemeData.light().copyWith(
          primaryColor: Colors.blue[800],
          colorScheme: ColorScheme.light(primary: Colors.blue[800]!),
          buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
        ),
        child: child!,
      ),
    );
  }
}
