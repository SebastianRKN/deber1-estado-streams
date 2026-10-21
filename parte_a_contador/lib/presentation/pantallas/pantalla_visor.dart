import 'package:flutter/material.dart';

import '../../domain/usecases/decrementar.dart';
import '../../domain/usecases/incrementar.dart';
import '../../domain/usecases/obtener_contador.dart';
import 'pantalla_control.dart';

class PantallaVisor extends StatefulWidget {
  const PantallaVisor({
    required this.obtenerContador,
    required this.incrementar,
    required this.decrementar,
    super.key,
  });

  final ObtenerContador obtenerContador;
  final Incrementar incrementar;
  final Decrementar decrementar;

  @override
  State<PantallaVisor> createState() => _PantallaVisorState();
}

class _PantallaVisorState extends State<PantallaVisor> {
  int _contador = 0;
  bool _cargando = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _cargarContador();
  }

  Future<void> _cargarContador() async {
    try {
      final valor = await widget.obtenerContador();
      if (!mounted) return;
      setState(() {
        _contador = valor;
        _cargando = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _error = 'No se pudo cargar el contador: $error';
        _cargando = false;
      });
    }
  }

  Future<void> _abrirControl() async {
    final resultado = await Navigator.of(context).push<int>(
      MaterialPageRoute(
        builder: (_) => PantallaControl(
          valorInicial: _contador,
          incrementar: widget.incrementar,
          decrementar: widget.decrementar,
        ),
      ),
    );

    if (resultado != null && mounted) {
      setState(() => _contador = resultado);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Visor del contador')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: _cargando
              ? const CircularProgressIndicator()
              : _error != null
              ? Text(_error!, textAlign: TextAlign.center)
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.visibility_outlined, size: 72),
                    const SizedBox(height: 24),
                    Text(
                      'Contador: $_contador',
                      key: const Key('valor-contador'),
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                    const SizedBox(height: 32),
                    FilledButton.icon(
                      onPressed: _abrirControl,
                      icon: const Icon(Icons.tune),
                      label: const Text('Ir a Control'),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
