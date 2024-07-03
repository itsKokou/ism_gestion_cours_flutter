import 'package:projet_flutter/core/models/seance_model.dart';
import 'package:projet_flutter/core/repositories/seance.repository.dart';

class SeanceService {
  static SeanceRepository seanceRepository = SeanceRepository();
  static Seance? seance;

  static Future<List<Seance>> getAllByClasse({String id = "1"}) async {
    List<Seance> seances = await seanceRepository.findAllByClasse(id: id);
    return seances;
  }

  static Future<List<Seance>> getAllByEtudiant({String id = "22"}) async {
    List<Seance> seances = await seanceRepository.findAllByEtudiant(id: id);
    return seances;
  }

  static Future<dynamic> markPresence(
      {String etudiant = "22", String idSeance = "13"}) async {
    dynamic response = await seanceRepository.markPresence(
        idEtu: etudiant, seanceId: idSeance);
    return response;
  }

  static Future<dynamic> isEtudiantPresence(
      {String etudiant = "22", String idSeance = "13"}) async {
    dynamic response = await seanceRepository.isEtudiantPresence(
        idEtu: etudiant, seanceId: idSeance);
    return response;
  }
}
