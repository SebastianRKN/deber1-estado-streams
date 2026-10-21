import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:parte_b_conexion/domain/entities/estado_conexion.dart';
import 'package:parte_b_conexion/domain/repositories/conexion_repository.dart';
import 'package:parte_b_conexion/domain/usecases/consultar_conexion.dart';
import 'package:parte_b_conexion/domain/usecases/observar_conexion.dart';
import 'package:parte_b_conexion/presentation/estado/conexion_cubit.dart';

class Repo implements ConexionRepository {
  final eventos = StreamController<EstadoConexion>.broadcast();
  Future<EstadoConexion> Function() consulta = () async => EstadoConexion.wifi;
  @override
  Future<EstadoConexion> consultarAhora() => consulta();
  @override
  Stream<EstadoConexion> observarCambios() => eventos.stream;
  ConexionCubit cubit() => ConexionCubit(ConsultarConexion(this), ObservarConexion(this));
}

void main() {
  test('cerrar durante consulta inicial no deja suscripción', () async {
    final repo = Repo();
    final respuesta = Completer<EstadoConexion>();
    repo.consulta = () => respuesta.future;
    final cubit = repo.cubit();
    final inicio = cubit.iniciar();
    await cubit.close();
    respuesta.complete(EstadoConexion.wifi);
    await inicio;
    expect(repo.eventos.hasListener, false);
    await repo.eventos.close();
  });
  test('iniciar dos veces y avisos repetidos no duplican cambios', () async {
    final repo = Repo();
    final cubit = repo.cubit();
    await Future.wait([cubit.iniciar(), cubit.iniciar()]);
    for (final estado in [EstadoConexion.wifi, EstadoConexion.sinConexion,
      EstadoConexion.sinConexion, EstadoConexion.datosMoviles]) {
      repo.eventos.add(estado);
    }
    await Future<void>.delayed(Duration.zero);
    expect(cubit.cambiosRecibidos, 2);
    expect(cubit.state, EstadoConexion.datosMoviles);
    await cubit.close();
    await repo.eventos.close();
  });
  test('cincuenta aperturas y cierres liberan cada suscripción', () async {
    final repo = Repo();
    for (var i = 0; i < 50; i++) {
      final cubit = repo.cubit();
      await cubit.iniciar();
      expect(repo.eventos.hasListener, true);
      await cubit.close();
      expect(repo.eventos.hasListener, false);
    }
    await repo.eventos.close();
  });
  test('una consulta lenta no sobreescribe un aviso más reciente', () async {
    final repo = Repo();
    final cubit = repo.cubit();
    await cubit.iniciar();
    final respuesta = Completer<EstadoConexion>();
    repo.consulta = () => respuesta.future;
    final consulta = cubit.actualizar();
    repo.eventos.add(EstadoConexion.sinConexion);
    await Future<void>.delayed(Duration.zero);
    respuesta.complete(EstadoConexion.wifi);
    await consulta;
    expect(cubit.state, EstadoConexion.sinConexion);
    await cubit.close();
    await repo.eventos.close();
  });
  test('error de consulta se informa y el stream permite recuperarse', () async {
    final repo = Repo()..consulta = () async => throw StateError('prueba');
    final cubit = repo.cubit();
    await cubit.iniciar();
    expect(cubit.error, isNotNull);
    repo.eventos.add(EstadoConexion.wifi);
    await Future<void>.delayed(Duration.zero);
    expect(cubit.state, EstadoConexion.wifi);
    expect(cubit.error, isNull);
    await cubit.close();
    await repo.eventos.close();
  });
}
