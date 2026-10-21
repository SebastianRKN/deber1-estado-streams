import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/decrementar.dart';
import '../../domain/usecases/incrementar.dart';
import '../../domain/usecases/obtener_contador.dart';

class ContadorCubit extends Cubit<int> {
  ContadorCubit(this._obtenerContador, this._incrementar, this._decrementar)
    : super(0);

  final ObtenerContador _obtenerContador;
  final Incrementar _incrementar;
  final Decrementar _decrementar;

  Future<void> _pendiente = Future<void>.value();
  Future<void> _encolar(Future<int> Function() accion) {
    final tarea = _pendiente.then((_) async {
      final valor = await accion();
      if (!isClosed) emit(valor);
    });
    // Una operación fallida no bloquea las siguientes.
    _pendiente = tarea.then<void>((_) {}, onError: (Object e, StackTrace s) {});
    return tarea;
  }

  Future<void> cargar() => _encolar(_obtenerContador.call);
  Future<void> incrementar() => _encolar(_incrementar.call);
  Future<void> decrementar() => _encolar(_decrementar.call);
}
