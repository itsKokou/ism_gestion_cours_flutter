import 'package:flutter/material.dart';
import 'package:projet_flutter/core/constants/colors_constantes.dart';
import 'package:projet_flutter/core/models/login_model.dart';
import 'package:projet_flutter/core/services/security_service.dart';
import 'package:projet_flutter/pages/seance/seance.page.dart';
import 'package:projet_flutter/pages/seance/seance_admin_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  static String routeName = "/login";

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //Key qui gère le formulaire: si valide ou invalide
  final _formKey = GlobalKey<FormState>();
  //Controller pour recuperer les valeur
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  //validator
  late final String? Function(String?)? validator;
  //Cas où connexion ne passe pas
  String errorMessage = "";

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
                firstGradientColor,
                secondGradientColor,
              ]),
            ),
            child: const Padding(
              padding: EdgeInsets.only(top: 60.0, left: 22),
              child: Text(
                'Bonjour,\nConnectez-vous !',
                style: TextStyle(
                    fontSize: 30,
                    color: whiteColor,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 200.0),
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40)),
                color: whiteColor,
              ),
              height: double.infinity,
              width: double.infinity,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(left: 18.0, right: 18),
                  child: Form(
                      key: _formKey,
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            child: Text(
                              errorMessage,
                              style: const TextStyle(
                                  color: dangerColor,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "L'email est obligatoire";
                              }
                              // Regex for email validation
                              String pattern =
                                  r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                              RegExp regex = RegExp(pattern);
                              if (!regex.hasMatch(value)) {
                                return 'Adresse email invalide ';
                              }
                              return null;
                            },
                            controller: _emailController,
                            decoration: const InputDecoration(
                                suffixIcon: Icon(
                                  Icons.email_outlined,
                                  color: greyColor,
                                ),
                                label: Text(
                                  'Email',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xffB81736),
                                  ),
                                )),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Le mot de passe est obligatoire";
                              }
                              return null;
                            },
                            controller: _passwordController,
                            obscureText: true,
                            // obscuringCharacter: '*',
                            decoration: const InputDecoration(
                                suffixIcon: Icon(
                                  Icons.visibility_off_outlined,
                                  color: greyColor,
                                ),
                                label: Text(
                                  'Password',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xffB81736),
                                  ),
                                )),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              'Mot de passe oublié ?',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                                color: Color(0xFF352BC0),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 100,
                          ),
                          Container(
                            height: 55,
                            width: 300,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              gradient: const LinearGradient(colors: [
                                firstGradientColor,
                                secondGradientColor,
                              ]),
                            ),
                            child: InkWell(
                              onTap: () async {
                                if (_formKey.currentState!.validate()) {
                                  //Formualaire valide
                                  //Prendre les valeurs et les mettre dans les controllers
                                  _formKey.currentState!.save();
                                  LoginModel loginModel = LoginModel(
                                      username: _emailController.text,
                                      password: _passwordController.text);
                                  //Se connecter
                                  await SecurityService.getConnectedUser(
                                      loginModel);
                                  if (SecurityService.connectedUser != null) {
                                    //Connexion réussi
                                    if (!SecurityService.connectedUser!.roles
                                        .contains("ROLE_PROFESSEUR")) {
                                      if (SecurityService.connectedUser!.roles
                                          .contains("ROLE_ETUDIANT")) {
                                        //Si role Etudiant
                                        Navigator.pop(context);
                                        Navigator.pushNamed(
                                            context, SeancePage.routeName);
                                      } else {
                                        //Si AC ou RP ou Admin
                                        Navigator.pop(context);
                                        Navigator.pushNamed(
                                            context, SeanceAdminPage.routeName);
                                      }
                                    } else {
                                      //Prof pas autorisé
                                      setState(() {
                                        errorMessage = "Accès refusé !!!";
                                        SecurityService.connectedUser = null;
                                      });
                                    }
                                  } else {
                                    //echec connexion
                                    setState(() {
                                      //Pour lui dire qu'il y a un changement
                                      errorMessage =
                                          "Login ou mot de passe incorrect";
                                    });
                                  }
                                }
                              },
                              child: const Center(
                                child: Text(
                                  'Log in',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: whiteColor),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 200),
                          const Align(
                            alignment: Alignment.bottomRight,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "Mon agenda du jour",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: greyColor),
                                ),
                                Text(
                                  "~Kokou~",
                                  style: TextStyle(

                                      ///done login page
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: greyColor),
                                ),
                              ],
                            ),
                          )
                        ],
                      )),
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
