import 'package:projet_flutter/core/models/login_model.dart';
import 'package:projet_flutter/core/models/login_response_model.dart';
import 'package:projet_flutter/core/repositories/security_repository.dart';

class SecurityService {
  static LoginResponseModel? connectedUser;
  static SecurityRepository securityRepository = SecurityRepository();

  static Future<void> getConnectedUser(LoginModel loginModel) async {
    connectedUser = await securityRepository.findUserByLoginAndPassword(loginModel);
  }
}
