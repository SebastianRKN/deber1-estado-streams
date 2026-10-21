import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:parte_a_contador/data/repositories/contador_prefs_repository.dart';
import 'package:parte_a_contador/domain/usecases/obtener_contador.dart';
import 'package:parte_a_contador/domain/usecases/incrementar.dart';
import 'package:parte_a_contador/domain/usecases/decrementar.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() => SharedPreferences.setMockInitialValues({}));
  test('empieza en cero cuando no hay valor persistido', () async {
    expect(await ObtenerContador(ContadorPrefsRepository())(), 0);
  });
  test('incrementa, decrementa y otra instancia recupera el valor', () async {
    final repo = ContadorPrefsRepository();
    expect(await Incrementar(repo)(), 1);
    expect(await Incrementar(repo)(), 2);
    expect(await Decrementar(repo)(), 1);
    expect(await ObtenerContador(ContadorPrefsRepository())(), 1);
    expect((await SharedPreferences.getInstance()).getInt('contador'), 1);
  });
  test('lee un valor anterior y permite números negativos', () async {
    SharedPreferences.setMockInitialValues({'contador': -2});
    expect(await Decrementar(ContadorPrefsRepository())(), -3);
  });
}
