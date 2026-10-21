import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parte_a_contador/domain/repositories/contador_repository.dart';
import 'package:parte_a_contador/main.dart';
import 'package:parte_a_contador/presentation/estado/contador_provider.dart';

class _RepositorioEnMemoria implements ContadorRepository {
  int valor = 0;

  @override
  Future<void> guardar(int valor) async => this.valor = valor;

  @override
  Future<int> leer() async => valor;
}

void main() {
  test('pulsaciones concurrentes no pierden incrementos', () async {
    final repository = _RepositorioEnMemoria();
    final container = ProviderContainer(
      overrides: [contadorRepositoryProvider.overrideWithValue(repository)],
    );
    final estado = container.read(contadorProvider.notifier);
    addTearDown(container.dispose);
    await Future.wait([
      estado.cargar(),
      ...List.generate(20, (_) => estado.incrementar()),
    ]);
    expect(await repository.leer(), 20);
    await estado.decrementar();
    expect(await repository.leer(), 19);
  });

  testWidgets('el boton del sistema conserva el estado compartido', (
    tester,
  ) async {
    final repository = _RepositorioEnMemoria();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [contadorRepositoryProvider.overrideWithValue(repository)],
        child: const ContadorApp(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Ir a Control'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('incrementar')));
    await tester.pumpAndSettle();
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    expect(find.text('Contador: 1'), findsOneWidget);
    expect(await repository.leer(), 1);
  });
}
