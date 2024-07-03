import 'package:dio/dio.dart';
import 'package:projet_flutter/core/constants/api.constante.dart';
import 'package:projet_flutter/core/models/login_model.dart';
import 'package:projet_flutter/core/models/login_response_model.dart';

class SecurityRepository {
  static var url = "$apiUrl/login";
  static Dio dio = Dio();

  Future<LoginResponseModel?> findUserByLoginAndPassword(LoginModel loginModel) async {
    final response = await dio.post(url,
        data: loginModel.toJson(),
        options: Options(
            followRedirects: false,
            validateStatus: (status) {
              return status! < 500;
            },
            headers: {Headers.contentTypeHeader: "application/json"}));

    if (response.statusCode == 200) {
      dynamic datas = response.data["results"];
      return LoginResponseModel.fromMap(datas);
    } else {
      return null;
    }
  }
}
