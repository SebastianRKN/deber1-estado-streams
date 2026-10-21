import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parte_b_conexion/domain/entities/estado_conexion.dart';
import 'package:parte_b_conexion/domain/repositories/conexion_repository.dart';
import 'package:parte_b_conexion/domain/usecases/consultar_conexion.dart';
import 'package:parte_b_conexion/domain/usecases/observar_conexion.dart';
import 'package:parte_b_conexion/main.dart';

class _RepositorioFalso implements ConexionRepository {
  EstadoConexion actual = EstadoConexion.wifi;
  final controlador = StreamController<EstadoConexion>.broadcast();

  @override
  Future<EstadoConexion> consultarAhora() async => actual;

  @override
  Stream<EstadoConexion> observarCambios() => controlador.stream;
}

void main() {
  testWidgets('Future conserva la foto hasta realizar otra consulta', (
    tester,
  ) async {
    final repository = _RepositorioFalso();
    await tester.pumpWidget(
      ConexionApp(
        consultarConexion: ConsultarConexion(repository),
        observarConexion: ObservarConexion(repository),
      ),
    );

    await tester.tap(find.byKey(const Key('consultar-ahora')));
    await tester.pumpAndSettle();
    expect(find.text('Wi-Fi'), findsOneWidget);

    repository.actual = EstadoConexion.sinConexion;
    await tester.pump();
    expect(find.text('Wi-Fi'), findsOneWidget);

    await tester.tap(find.byKey(const Key('consultar-ahora')));
    await tester.pumpAndSettle();
    expect(find.text('Sin conexión'), findsOneWidget);

    await repository.controlador.close();
  });

  testWidgets('Stream actualiza la pantalla sin pulsar un boton', (
    tester,
  ) async {
    final repository = _RepositorioFalso();
    await tester.pumpWidget(
      ConexionApp(
        consultarConexion: ConsultarConexion(repository),
        observarConexion: ObservarConexion(repository),
      ),
    );

    await tester.tap(find.text('Con Stream'));
    await tester.pumpAndSettle();
    expect(find.text('Wi-Fi'), findsOneWidget);

    repository.controlador.add(EstadoConexion.sinConexion);
    await tester.pumpAndSettle();
    expect(find.text('Sin conexión'), findsOneWidget);
    expect(
      find.textContaining('Cambios recibidos desde que se abrió: 1'),
      findsOneWidget,
    );

    await tester.tap(find.text('Con Future'));
    await tester.pumpAndSettle();
    await repository.controlador.close();
  });
}
