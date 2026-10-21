import '../repositories/contador_repository.dart';

class ObtenerContador {
  const ObtenerContador(this._repository);

  final ContadorRepository _repository;

  Future<int> call() => _repository.leer();
}
