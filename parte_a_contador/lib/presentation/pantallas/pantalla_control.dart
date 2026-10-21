import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../estado/contador_cubit.dart';

class PantallaControl extends StatelessWidget {
  const PantallaControl({super.key});

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
              BlocBuilder<ContadorCubit, int>(
                builder: (context, contador) => Text(
                  'Contador: $contador',
                  key: const Key('valor-control'),
                  style: Theme.of(context).textTheme.displaySmall,
                ),
              ),
              const SizedBox(height: 32),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                alignment: WrapAlignment.center,
                children: [
                  FilledButton.icon(
                    key: const Key('incrementar'),
                    onPressed: context.read<ContadorCubit>().incrementar,
                    icon: const Icon(Icons.add),
                    label: const Text('+1'),
                  ),
                  FilledButton.tonalIcon(
                    key: const Key('decrementar'),
                    onPressed: context.read<ContadorCubit>().decrementar,
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
