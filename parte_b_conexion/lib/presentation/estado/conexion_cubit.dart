import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/estado_conexion.dart';
import '../../domain/usecases/consultar_conexion.dart';
import '../../domain/usecases/observar_conexion.dart';

class ConexionCubit extends Cubit<EstadoConexion> {
  ConexionCubit(this._consultarConexion, this._observarConexion)
    : super(EstadoConexion.otro);
  final ConsultarConexion _consultarConexion;
  final ObservarConexion _observarConexion;
  StreamSubscription<EstadoConexion>? _suscripcion;
  bool _iniciado = false;
  bool _cerrando = false;
  int _revision = 0;
  int cambiosRecibidos = 0;
  String? error;
  bool get _activo => !_cerrando && !isClosed;

  Future<void> iniciar() async {
    if (_iniciado || !_activo) return;
    _iniciado = true;
    await actualizar();
    if (!_activo) return;
    _suscripcion = _observarConexion().listen(
      (estado) {
        if (!_activo) return;
        _revision++;
        error = null;
        // Contamos transiciones, no notificaciones duplicadas del sistema.
        if (estado != state) {
          cambiosRecibidos++;
          emit(estado);
        }
      },
      onError: (Object exception, StackTrace trace) {
        if (!_activo) return;
        _revision++;
        error = 'No se pudo observar la conexión. Vuelve a abrir esta pestaña.';
        emit(EstadoConexion.otro);
      },
    );
  }

  // Android puede no notificar cambios mientras la app está en segundo plano.
  Future<void> actualizar() async {
    final revision = ++_revision;
    try {
      final actual = await _consultarConexion();
      if (!_activo || revision != _revision) return;
      error = null;
      emit(actual);
    } catch (_) {
      if (!_activo || revision != _revision) return;
      error = 'No se pudo consultar la conexión. Vuelve a abrir esta pestaña.';
      emit(EstadoConexion.otro);
    }
  }

  @override
  Future<void> close() async {
    _cerrando = true;
    await _suscripcion?.cancel();
    await super.close();
  }
}
