import 'package:flutter/material.dart';

import '../../domain/entities/estado_conexion.dart';

class TarjetaConexion extends StatelessWidget {
  const TarjetaConexion({
    required this.estado,
    required this.subtitulo,
    this.pendiente = false,
    super.key,
  });

  final EstadoConexion estado;
  final String subtitulo;
  final bool pendiente;

  @override
  Widget build(BuildContext context) {
    final conectado = estado != EstadoConexion.sinConexion;
    final color = pendiente || estado == EstadoConexion.otro
        ? Colors.blueGrey
        : conectado
        ? Colors.green.shade700
        : Colors.red.shade700;

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(_icono, size: 84, color: color),
            const SizedBox(height: 20),
            Text(
              pendiente ? 'Sin consultar' : _etiqueta,
              key: const Key('estado-conexion'),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium
                  ?.copyWith(color: color),
            ),
            const SizedBox(height: 12),
            Text(subtitulo, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  String get _etiqueta => switch (estado) {
    EstadoConexion.wifi => 'Wi-Fi',
    EstadoConexion.datosMoviles => 'Datos móviles',
    EstadoConexion.otro => 'Estado no disponible',
    EstadoConexion.sinConexion => 'Sin conexión',
  };

  IconData get _icono => switch (estado) {
    EstadoConexion.wifi => Icons.wifi,
    EstadoConexion.datosMoviles => Icons.signal_cellular_alt,
    EstadoConexion.otro => Icons.device_hub,
    EstadoConexion.sinConexion => Icons.signal_wifi_off,
  };
}
