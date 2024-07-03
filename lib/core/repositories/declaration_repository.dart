
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:projet_flutter/core/constants/api.constante.dart';
import 'package:projet_flutter/core/models/declaration_create_model.dart';

class DeclarationRepository {
  static var url = "$apiUrl/declarations";
  static Dio dio = Dio();

  Future<dynamic> isEtudiantDeclaration({String idEtu = "22", String seanceId = "13"}) async {
    var path = "$url/$seanceId/$idEtu/check";
    final response = await dio.get(path);
    if (response.statusCode == 200) {
      dynamic datas = response.data["results"];
      return datas;
    } else {
      throw response;
    }
  }

  Future<void> saveDeclaration(DeclarationCreateModel declaration) async{
    dio.post(
      url,
      data: declaration.toJson(),
      options: Options(
        followRedirects: false, 
        validateStatus: (status) {
          return status! < 500;
        },
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }
      ),
    );
  }
}