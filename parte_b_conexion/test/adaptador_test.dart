import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:parte_b_conexion/data/repositories/conexion_plus_repository.dart';
import 'package:parte_b_conexion/domain/entities/estado_conexion.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const channel = MethodChannel('dev.fluttercommunity.plus/connectivity');
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
  tearDown(() => messenger.setMockMethodCallHandler(channel, null));

  final casos = <String, (List<String>, EstadoConexion)>{
    'prioriza wifi sobre móvil': (['mobile', 'wifi'], EstadoConexion.wifi),
    'reconoce móvil': (['mobile'], EstadoConexion.datosMoviles),
    'reconoce sin conexión': (['none'], EstadoConexion.sinConexion),
    'tolera lista vacía': ([], EstadoConexion.sinConexion),
    'aplica política del deber a otras interfaces': (
      ['ethernet'],
      EstadoConexion.sinConexion,
    ),
  };
  for (final caso in casos.entries) {
    test(caso.key, () async {
      messenger.setMockMethodCallHandler(channel, (call) async {
        expect(call.method, 'check');
        return caso.value.$1;
      });
      expect(await ConexionPlusRepository().consultarAhora(), caso.value.$2);
    });
  }
}
