import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parte_a_contador/domain/repositories/contador_repository.dart';
import 'package:parte_a_contador/domain/usecases/decrementar.dart';
import 'package:parte_a_contador/domain/usecases/incrementar.dart';
import 'package:parte_a_contador/domain/usecases/obtener_contador.dart';
import 'package:parte_a_contador/main.dart';
import 'package:parte_a_contador/presentation/estado/contador_cubit.dart';

class _RepositorioEnMemoria implements ContadorRepository {
  int valor = 0;

  @override
  Future<void> guardar(int valor) async => this.valor = valor;

  @override
  Future<int> leer() async => valor;
}

void main() {
  test('BlocObserver registra valor anterior y siguiente', () async {
    final mensajes = <String>[];
    final imprimirAnterior = debugPrint;
    final observadorAnterior = Bloc.observer;
    debugPrint = (String? mensaje, {int? wrapWidth}) {
      if (mensaje != null) mensajes.add(mensaje);
    };
    Bloc.observer = ContadorBlocObserver();
    addTearDown(() {
      debugPrint = imprimirAnterior;
      Bloc.observer = observadorAnterior;
    });
    final repo = _RepositorioEnMemoria();
    final cubit = ContadorCubit(
      ObtenerContador(repo),
      Incrementar(repo),
      Decrementar(repo),
    );
    await cubit.incrementar();
    expect(mensajes, contains('ContadorCubit: 0 -> 1'));
    await cubit.close();
  });

  test('pulsaciones concurrentes no pierden incrementos', () async {
    final repository = _RepositorioEnMemoria();
    final estado = ContadorCubit(
      ObtenerContador(repository),
      Incrementar(repository),
      Decrementar(repository),
    );
    addTearDown(estado.close);
    await Future.wait([
      estado.cargar(),
      ...List.generate(20, (_) => estado.incrementar()),
    ]);
    expect(await repository.leer(), 20);
    await estado.decrementar();
    expect(await repository.leer(), 19);
  });

  testWidgets('Cubit conserva el valor al volver con el boton del sistema', (
    tester,
  ) async {
    final repository = _RepositorioEnMemoria();
    await tester.pumpWidget(
      BlocProvider(
        create: (_) => ContadorCubit(
          ObtenerContador(repository),
          Incrementar(repository),
          Decrementar(repository),
        )..cargar(),
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
