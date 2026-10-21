import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:parte_b_conexion/domain/entities/estado_conexion.dart';
import 'package:parte_b_conexion/domain/repositories/conexion_repository.dart';
import 'package:parte_b_conexion/domain/usecases/consultar_conexion.dart';
import 'package:parte_b_conexion/domain/usecases/observar_conexion.dart';
import 'package:parte_b_conexion/presentation/estado/conexion_cubit.dart';

class _RepositorioFalso implements ConexionRepository {
  EstadoConexion actual = EstadoConexion.wifi;
  final controlador = StreamController<EstadoConexion>.broadcast();

  @override
  Future<EstadoConexion> consultarAhora() async => actual;

  @override
  Stream<EstadoConexion> observarCambios() => controlador.stream;
}

void main() {
  test('consulta, reacciona al stream y cancela la suscripcion', () async {
    final repository = _RepositorioFalso();
    final cubit = ConexionCubit(
      ConsultarConexion(repository),
      ObservarConexion(repository),
    );

    await cubit.iniciar();
    expect(cubit.state, EstadoConexion.wifi);
    expect(repository.controlador.hasListener, isTrue);

    repository.controlador.add(EstadoConexion.sinConexion);
    await Future<void>.delayed(Duration.zero);
    expect(cubit.state, EstadoConexion.sinConexion);
    expect(cubit.cambiosRecibidos, 1);

    await cubit.close();
    expect(repository.controlador.hasListener, isFalse);
    await repository.controlador.close();
  });
}
