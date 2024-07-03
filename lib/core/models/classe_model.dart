import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Classe {
  int id;
  String libelle;

  Classe({
    required this.id,
    required this.libelle,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'libelle': libelle,
    };
  }

  factory Classe.fromMap(Map<String, dynamic> map) {
    return Classe(
      id: map['id'] as int,
      libelle: map['libelle'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Classe.fromJson(String source) => Classe.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Classe(id: $id, libelle: $libelle)';
}
