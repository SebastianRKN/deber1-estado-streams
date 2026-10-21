import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../estado/contador_provider.dart';

class PantallaControl extends ConsumerWidget {
  const PantallaControl({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contador = ref.watch(contadorProvider);
    final notifier = ref.read(contadorProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Control del contador')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Contador: $contador',
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
                    onPressed: notifier.incrementar,
                    icon: const Icon(Icons.add),
                    label: const Text('+1'),
                  ),
                  FilledButton.tonalIcon(
                    key: const Key('decrementar'),
                    onPressed: notifier.decrementar,
                    icon: const Icon(Icons.remove),
                    label: const Text('-1'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              OutlinedButton.icon(
                onPressed: () => Navigator.pop(context),
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
