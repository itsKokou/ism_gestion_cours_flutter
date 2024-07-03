import 'dart:io';

import 'package:flutter/material.dart';
import 'package:projet_flutter/core/constants/colors_constantes.dart';
import 'package:projet_flutter/core/services/seance.service.dart';
import 'package:projet_flutter/pages/seance/seance_admin_page.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

// ignore: must_be_immutable
class ScannerPage extends StatefulWidget {
  int seanceChosen;
  ScannerPage({super.key, required this.seanceChosen});
  static String routeName = "/scanner";

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  @override
  void initState() {
    super.initState();
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    }
    controller?.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scanner'),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
            Navigator.pushNamed(context, SeanceAdminPage.routeName);
          },
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape(
                borderColor: dangerColor,
                borderRadius: 10,
                borderLength: 30,
                borderWidth: 10,
                cutOutSize: 300,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: (result != null)
                  ? Text('Etudiant : ${result!.code!.split('=').last}')
                  : const Text('Scanner un code'),
            ),
          )
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) async {
      setState(() {
        result = scanData;
      });
      if (result != null) {
        controller.pauseCamera(); // Pause camera while processing result
        String idEtu = result!.code!.split('=').first;
        String nomEtu = result!.code!.split('=').last;

        var presenceFuture = await SeanceService.isEtudiantPresence(
            idSeance: widget.seanceChosen.toString(), etudiant: idEtu);
        if (presenceFuture == true) {
          // Il a déjà émargé
          await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              icon: const Icon(
                Icons.warning_amber_rounded
              ),
              iconColor: primaryColor,
              title: const Text("Emargement !"),
              content: Text("$nomEtu a déjà emargé"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'OK',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          );
        } else {
          bool confirmation = await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                icon: const Icon(Icons.info_outline),
                iconColor: primaryColor,
                title: const Text('Confirmation'),
                content: Text("Confirmez-vous la présence de $nomEtu ?"),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(false); // Annuler
                    },
                    child: Container(
                      height: 30,
                      width: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: dangerColor,
                          borderRadius: BorderRadius.circular(4)),
                      child: const Text(
                        'Non',
                        style: TextStyle(
                            color: whiteColor, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(true); // Confirmer
                    },
                    child: Container(
                      height: 30,
                      width: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: confirmColor,
                          borderRadius: BorderRadius.circular(4)),
                      child: const Text(
                        'Oui',
                        style: TextStyle(
                            color: whiteColor, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              );
            },
          );

          // Si la confirmation est donnée, marquer la présence
          if (confirmation == true) {
            await SeanceService.markPresence(
                idSeance: widget.seanceChosen.toString(), etudiant: idEtu);
          }
        }
        controller.resumeCamera(); // Resume camera after processing result
      }
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
