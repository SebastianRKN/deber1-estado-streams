import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../estado/contador_cubit.dart';
import 'pantalla_control.dart';

class PantallaVisor extends StatelessWidget {
  const PantallaVisor({super.key});

  @override
  Widget build(BuildContext context) {
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
              BlocBuilder<ContadorCubit, int>(
                builder: (context, contador) => Text(
                  'Contador: $contador',
                  key: const Key('valor-contador'),
                  style: Theme.of(context).textTheme.displaySmall,
                ),
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
