import 'package:flutter/material.dart';
import 'package:projet_flutter/core/constants/colors_constantes.dart';
import 'package:projet_flutter/pages/login/login.page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  static String routeName = "/home";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
          firstGradientColor,
          secondGradientColor,
        ])),
        child: Column(children: [
          const Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: Image(image: AssetImage('assets/godwin.png')),
          ),
          const SizedBox(
            height: 100,
          ),
          const Text(
            'Welcome Back',
            style: TextStyle(fontSize: 30, color: whiteColor),
          ),
          const SizedBox(
            height: 100,
          ),
          InkWell(
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, LoginPage.routeName);
            },
            child: Container(
              height: 53,
              width: 320,
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: whiteColor),
              ),
              child: const Center(
                child: Text(
                  'CONNEXION',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
            ),
          ),
          const Spacer(),
          const Text(
            'Nous joindre sur nos réseaux',
            style: TextStyle(fontSize: 17, color: whiteColor),
          ), //
          const SizedBox(
            height: 12,
          ),
          const Image(image: AssetImage('assets/social.png'))
          // Image.asset('assets/social.png',
          //                height: 400,
          //                width: 400,
          //                   ),
        ]),
      ),
    );
  }
}
