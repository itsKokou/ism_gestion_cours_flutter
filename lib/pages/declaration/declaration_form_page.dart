import 'package:flutter/material.dart';
import 'package:projet_flutter/core/constants/colors_constantes.dart';
import 'package:projet_flutter/core/models/declaration_create_model.dart';
import 'package:projet_flutter/core/services/declaration_service.dart';
import 'package:projet_flutter/core/services/seance.service.dart';
import 'package:projet_flutter/core/services/security_service.dart';
import 'package:projet_flutter/pages/seance/seance.page.dart';

class DeclarationFormPage extends StatefulWidget {
  const DeclarationFormPage({super.key});
  static String routeName = "/declaration/form";

  @override
  State<DeclarationFormPage> createState() => _DeclarationFormPageState();
}

class _DeclarationFormPageState extends State<DeclarationFormPage> {
  // Key qui gère le formulaire: si valide ou invalide
  final _formKey = GlobalKey<FormState>();
  // Controller pour récupérer les valeurs
  final TextEditingController _motifController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  // Validator
  late final String? Function(String?)? validator;
  // Cas où connexion ne passe pas
  String errorMessage = "";

  @override
  void dispose() {
    _motifController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 232, 231, 227),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, SeancePage.routeName);
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            color: const Color.fromARGB(255, 232, 231, 227),
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 30, left: 10, right: 10, bottom: 200),
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        const Text(
                          "Formulaire de déclaration",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 30),
                        TextFormField(
                          controller: _motifController,
                          decoration: InputDecoration(
                            labelText: 'Motif',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.blue),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez entrer un motif';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20.0),
                        TextFormField(
                          controller: _descriptionController,
                          decoration: InputDecoration(
                            labelText: 'Description',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.blue),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          maxLines: 5,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez entrer une description';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 50),
                        Center(
                          child: ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                // Formulaire valide
                                _formKey.currentState!.save();
                                DeclarationCreateModel declarationModel =
                                    DeclarationCreateModel(
                                        userId: SecurityService
                                            .connectedUser!.userId,
                                        seanceId: SeanceService.seance!.id,
                                        motif: _motifController.text,
                                        description:
                                            _descriptionController.text);

                                // Faites quelque chose avec ces valeurs
                                await DeclarationService.saveDeclaration(
                                    declarationModel);

                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    icon: const Icon(Icons.info_outline),
                                    iconColor: primaryColor,
                                    title: const Text("Déclaration"),
                                    content: const Text(
                                        "Votre déclaration a été enregistrée et est en attente de traitement."),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          Navigator.pushNamed(
                                              context, SeancePage.routeName);
                                        },
                                        child: const Text(
                                          'OK',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            },
                            style: ButtonStyle(
                              backgroundColor:
                                  WidgetStateProperty.all(Colors.blue),
                              shadowColor: WidgetStateProperty.all(Colors.grey),
                              shape: WidgetStateProperty.all(RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),),
                              ),
                            ),
                            child: const Text(
                              'Soumettre',
                              style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
