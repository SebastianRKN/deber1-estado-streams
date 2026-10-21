import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/repositories/contador_repository.dart';
import '../../domain/usecases/decrementar.dart';
import '../../domain/usecases/incrementar.dart';
import '../../domain/usecases/obtener_contador.dart';

final contadorRepositoryProvider = Provider<ContadorRepository>((ref) {
  throw StateError(
    'contadorRepositoryProvider debe sobrescribirse en main.dart',
  );
});

final obtenerContadorProvider = Provider<ObtenerContador>(
  (ref) => ObtenerContador(ref.watch(contadorRepositoryProvider)),
);

final incrementarProvider = Provider<Incrementar>(
  (ref) => Incrementar(ref.watch(contadorRepositoryProvider)),
);

final decrementarProvider = Provider<Decrementar>(
  (ref) => Decrementar(ref.watch(contadorRepositoryProvider)),
);

final contadorProvider = NotifierProvider<ContadorNotifier, int>(
  ContadorNotifier.new,
);

class ContadorNotifier extends Notifier<int> {
  Future<void> _pendiente = Future<void>.value();
  Future<void> _encolar(Future<int> Function() accion) {
    final tarea = _pendiente.then((_) async {
      final valor = await accion();
      if (ref.mounted) state = valor;
    });
    // Una operación fallida no bloquea las siguientes.
    _pendiente = tarea.then<void>((_) {}, onError: (Object e, StackTrace s) {});
    return tarea;
  }

  @override
  int build() => 0;
  Future<void> cargar() => _encolar(() => ref.read(obtenerContadorProvider)());
  Future<void> incrementar() => _encolar(() => ref.read(incrementarProvider)());
  Future<void> decrementar() => _encolar(() => ref.read(decrementarProvider)());
}
