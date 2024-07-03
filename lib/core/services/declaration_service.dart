import 'package:projet_flutter/core/models/declaration_create_model.dart';
import 'package:projet_flutter/core/repositories/declaration_repository.dart';

class DeclarationService {
  static DeclarationRepository declarationRepository = DeclarationRepository();

  static Future<void> saveDeclaration(DeclarationCreateModel declaration) async {
    await declarationRepository.saveDeclaration(declaration);
  }

  static Future<dynamic> isEtudiantDeclaration({String etudiant = "22", String idSeance = "13"}) async {
    dynamic response = await declarationRepository.isEtudiantDeclaration(idEtu: etudiant, seanceId: idSeance);
    return response;
  }
}
