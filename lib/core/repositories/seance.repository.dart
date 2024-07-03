import 'package:projet_flutter/core/constants/api.constante.dart';
import 'package:dio/dio.dart';
import 'package:projet_flutter/core/models/seance_model.dart';

class SeanceRepository {
  static var url = "$apiUrl/seances";
  static Dio dio = Dio();

  Future<List<Seance>> findAllByClasse({String id = "1"}) async {
    var path = "$url/classe/$id";
    final response = await dio.get(path);
    if (response.statusCode == 200) {
      List<dynamic> datas = response.data["results"];
      List<Seance> seances = [];
      for (var map in datas) {
        seances.add(Seance.fromMap(map));
      }
      return seances;
    } else {
      throw response;
    }
  }

  Future<List<Seance>> findAllByEtudiant({String id = "22"}) async {
    var path = "$url/etudiant/$id";
    final response = await dio.get(path);
    if (response.statusCode == 200) {
      List<dynamic> datas = response.data["results"];
      List<Seance> seances = [];
      for (var map in datas) {
        seances.add(Seance.fromMap(map));
      }
      return seances;
    } else {
      throw response;
    }
  }

  Future<dynamic> markPresence( {String idEtu = "22", String seanceId = "13"}) async {
    var path = "$url/$seanceId/presence/$idEtu";
    final response = await dio.get(path);
    if (response.statusCode == 200) {
      dynamic datas = response.data["results"];
      return datas;
    } else {
      throw response;
    }
  }

  Future<dynamic> isEtudiantPresence( {String idEtu = "22", String seanceId = "13"}) async {
    var path = "$url/$seanceId/presence/$idEtu/check";
    final response = await dio.get(path);
    if (response.statusCode == 200) {
      dynamic datas = response.data["results"];
      return datas;
    } else {
      throw response;
    }
  }
}
