// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';


class DeclarationCreateModel {
  int userId;
  int seanceId;
  String motif;
  String description;
  
  DeclarationCreateModel({
    required this.userId,
    required this.seanceId,
    required this.motif,
    required this.description,
  });

  DeclarationCreateModel copyWith({
    int? userId,
    int? seanceId,
    String? motif,
    String? description,
  }) {
    return DeclarationCreateModel(
      userId: userId ?? this.userId,
      seanceId: seanceId ?? this.seanceId,
      motif: motif ?? this.motif,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'seanceId': seanceId,
      'motif': motif,
      'description': description,
    };
  }

  factory DeclarationCreateModel.fromMap(Map<String, dynamic> map) {
    return DeclarationCreateModel(
      userId: map['userId'] as int,
      seanceId: map['seanceId'] as int,
      motif: map['motif'] as String,
      description: map['description'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory DeclarationCreateModel.fromJson(String source) => DeclarationCreateModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'DeclarationCreateModel(userId: $userId, seanceId: $seanceId, motif: $motif, description: $description)';
  }

  @override
  bool operator ==(covariant DeclarationCreateModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.userId == userId &&
      other.seanceId == seanceId &&
      other.motif == motif &&
      other.description == description;
  }

  @override
  int get hashCode {
    return userId.hashCode ^
      seanceId.hashCode ^
      motif.hashCode ^
      description.hashCode;
  }
}
