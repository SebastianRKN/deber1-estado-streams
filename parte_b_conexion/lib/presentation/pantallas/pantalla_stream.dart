import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/estado_conexion.dart';
import '../../domain/usecases/consultar_conexion.dart';
import '../../domain/usecases/observar_conexion.dart';
import '../estado/conexion_cubit.dart';
import '../widgets/tarjeta_conexion.dart';

class PantallaStream extends StatelessWidget {
  const PantallaStream({
    required this.consultarConexion,
    required this.observarConexion,
    super.key,
  });

  final ConsultarConexion consultarConexion;
  final ObservarConexion observarConexion;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          ConexionCubit(consultarConexion, observarConexion)..iniciar(),
      child: const _ContenidoStream(),
    );
  }
}

class _ContenidoStream extends StatefulWidget {
  const _ContenidoStream();
  @override
  State<_ContenidoStream> createState() => _ContenidoStreamState();
}

class _ContenidoStreamState extends State<_ContenidoStream>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      context.read<ConexionCubit>().actualizar();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: BlocBuilder<ConexionCubit, EstadoConexion>(
          builder: (context, estado) {
            final cambios = context.read<ConexionCubit>().cambiosRecibidos;
            return TarjetaConexion(
              estado: estado,
              subtitulo:
                  context.read<ConexionCubit>().error ??
                  'Cambios recibidos desde que se abrió: $cambios',
            );
          },
        ),
      ),
    );
  }
}
