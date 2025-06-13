import 'package:h_c_web/backend/api_requests/api_calls.dart';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'panel_camas_model.dart';
import '../paciente/paciente_widget.dart';

class PanelCamasWidget extends StatefulWidget {
  static String routeName = 'PanelCamas';
  static String routePath = '/panelCamas';

  const PanelCamasWidget({super.key});

  @override
  State<PanelCamasWidget> createState() => _PanelCamasWidgetState();
}

class _PanelCamasWidgetState extends State<PanelCamasWidget> {
  String searchCama = '';

  @override
  Widget build(BuildContext context) {
    debugPrint('[PanelCamasWidget] BUILD de widget');
    return ChangeNotifierProvider<PanelCamasModel>(
      create: (_) {
        debugPrint('[PanelCamasWidget] Creando provider PanelCamasModel...');
        return PanelCamasModel()..cargarCamas(context);
      },
      builder: (context, child) {
        final model = Provider.of<PanelCamasModel>(context);
        final isMobile = MediaQuery.of(context).size.width < 600;

        debugPrint('[PanelCamasWidget] build - isLoading=${model.isLoading}, errorMsg=${model.errorMsg}, camas=${model.camas.length}');

        // Filtros y estadísticas
        final camasFiltradas = model.camas.where((cama) {
          if (searchCama.trim().isEmpty) return true;
          return (cama['NombreCama'] ?? '')
              .toString()
              .toLowerCase()
              .contains(searchCama.trim().toLowerCase());
        }).toList();

        final ocupadas = model.camas.where((c) => (c['Paciente'] ?? '').toString().trim().isNotEmpty && (c['Paciente'] ?? '').toString().toLowerCase() != 'sin paciente').length;


        return Scaffold(
          appBar: AppBar(
            title: Text('Panel de Camas', style: TextStyle(fontWeight: FontWeight.w700)),
            backgroundColor: FlutterFlowTheme.of(context).primary,
            elevation: 2,
            leading: BackButton(color: Colors.white),
          ),
          backgroundColor: Color(0xFFF5F7FA),
          floatingActionButton: isMobile
              ? Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: FloatingActionButton.extended(
                    icon: Icon(Icons.refresh),
                    backgroundColor: Colors.blue[900],
                    label: Text('Actualizar', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                    onPressed: () {
                      debugPrint('[PanelCamasWidget] Tap en Actualizar');
                      model.cargarCamas(context);
                    },
                  ),
                )
              : null,
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          body: LayoutBuilder(
            builder: (context, constraints) {
              if (model.isLoading) {
                debugPrint('[PanelCamasWidget] isLoading=TRUE, mostrando loader');
                return Center(child: CircularProgressIndicator());
              }
              if (model.errorMsg != null) {
                debugPrint('[PanelCamasWidget] errorMsg detectado: ${model.errorMsg}');
                return Center(
                  child: Text(
                    model.errorMsg ?? 'Error',
                    style: TextStyle(fontSize: 18, color: Colors.red),
                  ),
                );
              }
              if (model.camas.isEmpty) {
                debugPrint('[PanelCamasWidget] No hay internados/camas, mostrando mensaje vacío');
                return Center(
                  child: Text(
                    'No hay internados actualmente.',
                    style: TextStyle(fontSize: 20, color: Colors.grey[500]),
                  ),
                );
              }

              debugPrint('[PanelCamasWidget] Pintando lista de camas (${model.camas.length})');
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20, left: 10, right: 10, top: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // -------- TARJETAS DE OCUPADAS ---------
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _StatusCard(
                            label: "Ocupadas",
                            count: ocupadas,
                            color: Colors.red[400]!,
                            icon: Icons.hotel,
                          ),
                        ],
                      ),
                      SizedBox(height: 18),
                      // -------- BUSCADOR ----------
                      TextField(
                        onChanged: (value) {
                          setState(() {
                            searchCama = value;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: "Buscar por número de cama",
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.blueGrey, width: 1.2),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        ),
                      ),
                      SizedBox(height: 10),
                      // --------- LISTADO DE CAMAS FILTRADAS ----------
                      if (camasFiltradas.isEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 30.0),
                          child: Center(
                            child: Text(
                              'No se encontraron camas con ese número.',
                              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                            ),
                          ),
                        ),
                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: camasFiltradas.length,
                        itemBuilder: (ctx, i) {
                          final cama = camasFiltradas[i];
                          debugPrint('[PanelCamasWidget] Pintando cama #$i: $cama');
                          return Card(
                            elevation: 3,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.local_hotel_rounded, color: Colors.blue[700], size: 26),
                                      SizedBox(width: 8),
                                      Text(
                                        cama['NombreCama'] ?? 'Cama',
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.blue[900]),
                                      ),
                                      Spacer(),
                                      Text(
                                        cama['Habitacion'] ?? '',
                                        style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Icon(Icons.person, color: Colors.green[700], size: 22),
                                      SizedBox(width: 7),
                                      Expanded(
                                        child: Text(
                                          cama['Paciente'] ?? 'Sin paciente',
                                          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 6),
                                  Row(
                                    children: [
                                      Icon(Icons.event, color: Colors.deepPurple, size: 20),
                                      SizedBox(width: 7),
                                      Text(
                                        'Ingreso: ${cama['FechaIngreso'] ?? ''}',
                                        style: TextStyle(fontSize: 15),
                                      ),
                                      Spacer(),
                                      Text(
                                        cama['Diagnostico'] != null ? 'Dx: ${cama['Diagnostico']}' : '',
                                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                                      ),
                                    ],
                                  ),
                                  // --- BOTÓN EVOLUCIONAR ---
                                  SizedBox(height: 14),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: FlutterFlowTheme.of(context).primary,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                        elevation: 2,
                                        padding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                                      ),
                                      icon: Icon(Icons.auto_graph, color: Colors.white),
                                      label: Text(
                                        'Evolucionar',
                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                                      ),
                                      onPressed: () async {
                                        debugPrint('[PanelCamasWidget] Tap Evolucionar: idCama=${cama['IdCama']} idInstitucion=${model.idInstitucion}');
                                        FFAppState().update(() {
                                          FFAppState().QRCamaINT = int.tryParse(cama['IdCama'].toString()) ?? 0;
                                          FFAppState().QRIdInstitucionINT = int.tryParse(model.idInstitucion.toString()) ?? 0;
                                        });
                                        debugPrint('[PanelCamasWidget] FFAppState seteado: QRCamaINT=${FFAppState().QRCamaINT}, QRIdInstitucionINT=${FFAppState().QRIdInstitucionINT}');
                                        final apiResult = await EvolucionesDiariasCall.call(
                                          idInstitucionM: FFAppState().QRIdInstitucionINT,
                                          idCamaM: FFAppState().QRCamaINT,
                                        );
                                        debugPrint('[PanelCamasWidget] EvolucionesDiariasCall status: ${apiResult?.statusCode}');
                                        debugPrint('[PanelCamasWidget] EvolucionesDiariasCall body: ${apiResult?.bodyText}');
                                        if ((apiResult?.succeeded ?? true)) {
                                          await actions.extractJsonFromString(apiResult?.bodyText ?? '');
                                          debugPrint('[PanelCamasWidget] Datos extraídos, navegando a PacienteWidget...');
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
                                          debugPrint('[PanelCamasWidget] API Call Failed: ${apiResult?.bodyText}');
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'No se pudo cargar la evolución del paciente',
                                                style: TextStyle(
                                                  color: FlutterFlowTheme.of(context).secondaryBackground,
                                                ),
                                              ),
                                              duration: Duration(milliseconds: 4000),
                                              backgroundColor: FlutterFlowTheme.of(context).error,
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

// Tarjeta de estado de camas
class _StatusCard extends StatelessWidget {
  final String label;
  final int count;
  final Color color;
  final IconData icon;
  const _StatusCard({
    required this.label,
    required this.count,
    required this.color,
    required this.icon,
  });
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      color: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Container(
        width: 145,
        padding: EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: 30),
            SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 2),
            Text(
              count.toString(),
              style: TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.w800, letterSpacing: 1.1),
            ),
          ],
        ),
      ),
    );
  }
}
