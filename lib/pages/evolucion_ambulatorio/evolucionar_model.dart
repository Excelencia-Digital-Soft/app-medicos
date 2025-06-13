  import '/backend/api_requests/api_calls.dart';
  import '/flutter_flow/flutter_flow_util.dart';
  import 'package:flutter/material.dart';
  import 'evolucionar_widget.dart';

  class EvolucionarModel extends FlutterFlowModel<EvolucionarWidget> {
    /// Controlador del texto de evolución
    TextEditingController? evolucionCtrl;

    /// Estado de carga
    bool cargando = false;

    /// Datos del paciente actual
    Map<String, dynamic>? datosPaciente;

    /// Lista de problemas/evoluciones actuales
    List<dynamic> problemasActuales = [];

    @override
    void initState(BuildContext context) {
      evolucionCtrl = TextEditingController();
      datosPaciente = FFAppState().ultimoTurnoLlamado;
    }

    @override
    void dispose() {
      evolucionCtrl?.dispose();
    }

    /// Método para limpiar datos (opcional)
    void limpiar() {
      evolucionCtrl?.clear();
      problemasActuales = [];
    }
  }
