import 'package:flutter/material.dart';
import 'package:projet_flutter/core/constants/colors_constantes.dart';
import 'package:projet_flutter/core/models/classe_model.dart';
import 'package:projet_flutter/core/services/classe_service.dart';
import 'package:projet_flutter/pages/seance/seance_admin_page.dart';

class ClasseListComponent extends StatefulWidget {
  const ClasseListComponent({super.key});

  @override
  State<ClasseListComponent> createState() => _ClasseListComponentState();
}

class _ClasseListComponentState extends State<ClasseListComponent> {
  Future<List<Classe>> futureCategories = ClasseService.getAll();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: FutureBuilder<List<Classe>>(
          future: futureCategories,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasData) {
              return SizedBox(
                height: 80,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return ClasseItem(classe: snapshot.data![index]);
                  },
                ),
              );
            } else {
              return const Center(
                child: Text("Pas Donnees"),
              );
            }
          },
        ));
  }
}

// ignore: must_be_immutable
class ClasseItem extends StatefulWidget {
  Classe classe;
  ClasseItem({super.key, required this.classe});

  @override
  State<ClasseItem> createState() => _ClasseItemState();
}

class _ClasseItemState extends State<ClasseItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          ClasseService.classeSelected = widget.classe.id;
        });
        Navigator.pop(context);
        Navigator.push(context,
          MaterialPageRoute(
              builder: (context) =>
                  const SeanceAdminPage()),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
        child: Column(
          children: [
            Container(
              height: 56,
              width: 56,
              decoration: BoxDecoration(
                color: (widget.classe.id==ClasseService.classeSelected) ? firstGradientColor : primaryColor,
                borderRadius: BorderRadius.circular(10)
              ),
              child: const Icon(
                Icons.meeting_room_outlined,
                color: whiteColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              widget.classe.libelle,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12),
            )
          ],
        ),
      ),
    );
  }
}
