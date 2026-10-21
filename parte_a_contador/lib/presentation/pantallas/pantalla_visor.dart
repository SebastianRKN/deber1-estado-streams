import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../estado/contador_provider.dart';
import 'pantalla_control.dart';

class PantallaVisor extends ConsumerStatefulWidget {
  const PantallaVisor({super.key});

  @override
  ConsumerState<PantallaVisor> createState() => _PantallaVisorState();
}

class _PantallaVisorState extends ConsumerState<PantallaVisor> {
  @override
  void initState() {
    super.initState();
    Future.microtask(ref.read(contadorProvider.notifier).cargar);
  }

  @override
  Widget build(BuildContext context) {
    final contador = ref.watch(contadorProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Visor del contador')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.visibility_outlined, size: 72),
              const SizedBox(height: 24),
              Text(
                'Contador: $contador',
                key: const Key('valor-contador'),
                style: Theme.of(context).textTheme.displaySmall,
              ),
              const SizedBox(height: 32),
              FilledButton.icon(
                onPressed: () => Navigator.of(context).push<void>(
                  MaterialPageRoute(builder: (_) => const PantallaControl()),
                ),
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
