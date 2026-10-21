import 'package:flutter/material.dart';

import 'data/repositories/contador_prefs_repository.dart';
import 'domain/usecases/decrementar.dart';
import 'domain/usecases/incrementar.dart';
import 'domain/usecases/obtener_contador.dart';
import 'presentation/pantallas/pantalla_visor.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final repository = ContadorPrefsRepository();

  runApp(
    ContadorApp(
      obtenerContador: ObtenerContador(repository),
      incrementar: Incrementar(repository),
      decrementar: Decrementar(repository),
    ),
  );
}

class ContadorApp extends StatelessWidget {
  const ContadorApp({
    required this.obtenerContador,
    required this.incrementar,
    required this.decrementar,
    super.key,
  });

  final ObtenerContador obtenerContador;
  final Incrementar incrementar;
  final Decrementar decrementar;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Contador - setState',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: PantallaVisor(
        obtenerContador: obtenerContador,
        incrementar: incrementar,
        decrementar: decrementar,
      ),
    );
  }
}
