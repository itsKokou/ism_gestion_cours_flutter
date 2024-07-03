import 'package:dio/dio.dart';
import 'package:projet_flutter/core/constants/api.constante.dart';
import 'package:projet_flutter/core/models/classe_model.dart';

class ClasseRepository {
  static var url = "$apiUrl/classes";
  static Dio dio = Dio();

  Future<List<Classe>> findAll() async {
    var path = "$url/all";
    final response = await dio.get(path);
    if (response.statusCode == 200) {
      List<dynamic> datas = response.data["results"];
      List<Classe> classes = [];
      for (var map in datas) {
        classes.add(Classe.fromMap(map));
      }
      return classes;
    } else {
      throw response;
    }
  }
  
}