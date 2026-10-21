import 'package:flutter/material.dart';

import '../../domain/entities/estado_conexion.dart';
import '../../domain/usecases/consultar_conexion.dart';
import '../widgets/tarjeta_conexion.dart';

class PantallaFoto extends StatefulWidget {
  const PantallaFoto({required this.consultarConexion, super.key});

  final ConsultarConexion consultarConexion;

  @override
  State<PantallaFoto> createState() => _PantallaFotoState();
}

class _PantallaFotoState extends State<PantallaFoto> {
  EstadoConexion _estado = EstadoConexion.otro;
  DateTime? _ultimaConsulta;
  bool _consultando = false;
  String? _error;

  Future<void> _consultar() async {
    setState(() => _consultando = true);
    try {
      final estado = await widget.consultarConexion();
      if (!mounted) return;
      setState(() {
        _estado = estado;
        _ultimaConsulta = DateTime.now();
        _error = null;
      });
    } catch (_) {
      if (mounted) {
        setState(() => _error = 'No se pudo consultar. Intenta otra vez.');
      }
    } finally {
      if (mounted) setState(() => _consultando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final subtitulo = _ultimaConsulta == null
        ? 'Todavía no se ha realizado una consulta.'
        : 'Consultado a las ${_formatearHora(_ultimaConsulta!)}';

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TarjetaConexion(
              estado: _estado,
              subtitulo: _error ?? subtitulo,
              pendiente: _ultimaConsulta == null,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              key: const Key('consultar-ahora'),
              onPressed: _consultando ? null : _consultar,
              icon: _consultando
                  ? const SizedBox.square(
                      dimension: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.refresh),
              label: const Text('Consultar ahora'),
            ),
          ],
        ),
      ),
    );
  }

  String _formatearHora(DateTime fecha) {
    String dosDigitos(int valor) => valor.toString().padLeft(2, '0');
    return '${dosDigitos(fecha.hour)}:'
        '${dosDigitos(fecha.minute)}:'
        '${dosDigitos(fecha.second)}';
  }
}
