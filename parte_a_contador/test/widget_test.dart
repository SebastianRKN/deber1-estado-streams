import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parte_a_contador/domain/repositories/contador_repository.dart';
import 'package:parte_a_contador/domain/usecases/decrementar.dart';
import 'package:parte_a_contador/domain/usecases/incrementar.dart';
import 'package:parte_a_contador/domain/usecases/obtener_contador.dart';
import 'package:parte_a_contador/main.dart';

class _RepositorioEnMemoria implements ContadorRepository {
  int valor = 0;

  @override
  Future<void> guardar(int valor) async => this.valor = valor;

  @override
  Future<int> leer() async => valor;
}

ContadorApp _crearApp(_RepositorioEnMemoria repository) => ContadorApp(
  obtenerContador: ObtenerContador(repository),
  incrementar: Incrementar(repository),
  decrementar: Decrementar(repository),
);

void main() {
  testWidgets('el boton Volver entrega el valor actualizado', (tester) async {
    final repository = _RepositorioEnMemoria();
    await tester.pumpWidget(_crearApp(repository));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Ir a Control'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('incrementar')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('volver-con-valor')));
    await tester.pumpAndSettle();

    expect(find.text('Contador: 1'), findsOneWidget);
  });

  testWidgets('el boton del sistema no actualiza el estado local del visor', (
    tester,
  ) async {
    final repository = _RepositorioEnMemoria();
    await tester.pumpWidget(_crearApp(repository));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Ir a Control'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('incrementar')));
    await tester.pumpAndSettle();
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    expect(find.text('Contador: 0'), findsOneWidget);
    expect(await repository.leer(), 1);
  });
}
