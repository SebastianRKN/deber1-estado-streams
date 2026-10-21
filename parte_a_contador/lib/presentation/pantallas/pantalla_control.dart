import 'package:flutter/material.dart';

import '../../domain/usecases/decrementar.dart';
import '../../domain/usecases/incrementar.dart';

class PantallaControl extends StatefulWidget {
  const PantallaControl({
    required this.valorInicial,
    required this.incrementar,
    required this.decrementar,
    super.key,
  });

  final int valorInicial;
  final Incrementar incrementar;
  final Decrementar decrementar;

  @override
  State<PantallaControl> createState() => _PantallaControlState();
}

class _PantallaControlState extends State<PantallaControl> {
  late int _contador;
  bool _procesando = false;

  @override
  void initState() {
    super.initState();
    _contador = widget.valorInicial;
  }

  Future<void> _cambiar(Future<int> Function() accion) async {
    if (_procesando) return;
    setState(() => _procesando = true);

    try {
      final nuevoValor = await accion();
      if (!mounted) return;
      setState(() => _contador = nuevoValor);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No se pudo guardar. Intenta otra vez.'),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _procesando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Control del contador')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Contador: $_contador',
                key: const Key('valor-control'),
                style: Theme.of(context).textTheme.displaySmall,
              ),
              const SizedBox(height: 32),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                alignment: WrapAlignment.center,
                children: [
                  FilledButton.icon(
                    key: const Key('incrementar'),
                    onPressed: _procesando
                        ? null
                        : () => _cambiar(widget.incrementar.call),
                    icon: const Icon(Icons.add),
                    label: const Text('+1'),
                  ),
                  FilledButton.tonalIcon(
                    key: const Key('decrementar'),
                    onPressed: _procesando
                        ? null
                        : () => _cambiar(widget.decrementar.call),
                    icon: const Icon(Icons.remove),
                    label: const Text('-1'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              OutlinedButton.icon(
                key: const Key('volver-con-valor'),
                onPressed: _procesando
                    ? null
                    : () => Navigator.pop(context, _contador),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Volver'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
