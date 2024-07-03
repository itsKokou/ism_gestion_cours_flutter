import 'package:projet_flutter/core/models/classe_model.dart';
import 'package:projet_flutter/core/repositories/classe_repository.dart';

class ClasseService {
  static ClasseRepository classeRepository = ClasseRepository();
  static int classeSelected = 1;

  static Future<List<Classe>> getAll() async {
    List<Classe> classes = await classeRepository.findAll();
    return classes;
  }
}
