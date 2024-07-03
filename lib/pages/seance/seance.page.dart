import 'package:flutter/material.dart';
import 'package:projet_flutter/core/constants/colors_constantes.dart';
import 'package:projet_flutter/core/models/seance_model.dart';
import 'package:projet_flutter/core/services/declaration_service.dart';
import 'package:projet_flutter/core/services/seance.service.dart';
import 'package:projet_flutter/core/services/security_service.dart';
import 'package:projet_flutter/pages/declaration/declaration_form_page.dart';
import 'package:projet_flutter/pages/home/home.page.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class SeancePage extends StatefulWidget {
  const SeancePage({super.key});
  static String routeName = "/seance";

  @override
  State<SeancePage> createState() => _SeancePageState();
}

class _SeancePageState extends State<SeancePage> {
  final CalendarController _controller = CalendarController();
  Color? _viewHeaderColor;
  late Future<List<Seance>> meetings;
  List<Seance> seanceList = [];
  late Seance seanceSelected;
  bool showPresenceIcon = false;
  bool showDeclarationIcon = false;

  @override
  void initState() {
    super.initState();
    meetings = SeanceService.getAllByEtudiant(
        id: SecurityService.connectedUser!.userId.toString());
    meetings.then((value) {
      seanceList = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 147, 142, 141),
        title: const Text("Planning ISM"),
        actions: [
          if (showPresenceIcon) // Conditionner l'affichage de l'icône
            IconButton(
              icon: const Icon(
                Icons.assignment_ind_rounded,
                color: whiteColor,
              ),
              onPressed: () {
                // Marquer présence et cacher icone
                SeanceService.markPresence(
                    etudiant: SecurityService.connectedUser!.userId.toString(),
                    idSeance: seanceSelected.id.toString());
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    icon: const Icon(Icons.person_pin_outlined),
                    iconColor: primaryColor,
                    title: const Text("Présence"),
                    content: const Text("Vous venez d'émarger !"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          setState(() {
                            showPresenceIcon =
                                false; // Cacher l'icône après un clic
                          });
                          Navigator.of(context).pop();
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
              },
            ),

          //Montrer icône de formulaire de déclaration
          if (showDeclarationIcon) // Conditionner l'affichage de l'icône
            IconButton(
              icon: const Icon(
                Icons.format_align_justify_rounded,
                color: whiteColor,
              ),
              onPressed: () {
                // Formulaire
                Navigator.pop(context);
                Navigator.pushNamed(context, DeclarationFormPage.routeName);
              },
            ),

          //Montrer déconnexion : ici il est déjà connecté
          IconButton(
            icon: const Icon(
              Icons.logout_rounded,
              color: whiteColor,
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Déconnexion"),
                  content: const Text("Vous allez être déconnecté(e) !"),
                  actions: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          //Decconexion
                          SecurityService.connectedUser = null;
                        });
                        Navigator.pop(context);
                        Navigator.pushNamed(context, HomePage.routeName);
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
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Seance>>(
          future: meetings,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('Pas de données'));
            } else {
              return SfCalendar(
                view: CalendarView.day,
                dataSource: SeanceDataSource(snapshot.data!),
                todayHighlightColor: Colors.blue,
                firstDayOfWeek: 1,
                showCurrentTimeIndicator: true,
                showTodayButton: true,
                showWeekNumber: true,
                weekNumberStyle: const WeekNumberStyle(
                  backgroundColor: primaryColor,
                  textStyle: TextStyle(color: Colors.black, fontSize: 15),
                ),
                backgroundColor: whiteColor,
                selectionDecoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(color: Colors.blue, width: 2),
                  borderRadius: const BorderRadius.all(Radius.circular(4)),
                  shape: BoxShape.rectangle,
                ),
                allowedViews: const [
                  CalendarView.day,
                  CalendarView.week,
                  CalendarView.workWeek,
                  CalendarView.month,
                  CalendarView.timelineDay,
                  CalendarView.timelineWeek,
                  CalendarView.timelineWorkWeek
                ],
                viewHeaderStyle:
                    ViewHeaderStyle(backgroundColor: _viewHeaderColor),
                controller: _controller,
                initialDisplayDate: DateTime.now(),
                onTap: calendarTapped,
                monthViewSettings: const MonthViewSettings(
                    navigationDirection: MonthNavigationDirection.vertical),
              );
            }
          }),
    );
  }

  void calendarTapped(CalendarTapDetails calendarTapDetails) {
    if (_controller.view == CalendarView.month &&
        calendarTapDetails.targetElement == CalendarElement.calendarCell) {
      _controller.view = CalendarView.day;
    } else if ((_controller.view == CalendarView.week ||
            _controller.view == CalendarView.workWeek) &&
        calendarTapDetails.targetElement == CalendarElement.viewHeader) {
      _controller.view = CalendarView.day;
    }
    if (calendarTapDetails.targetElement == CalendarElement.appointment) {
      //---------------------------- PRESENCE ------------------------------
      //recuperer la seance en question.
      seanceSelected = calendarTapDetails.appointments!.first;
      SeanceService.seance = seanceSelected;
      DateTime start = seanceSelected.from;
      DateTime end = seanceSelected.to;
      DateTime emargement = start.add(const Duration(minutes: 30));
      DateTime emargementFin = end.subtract(const Duration(minutes: 10));
      DateTime now = DateTime.now();
      if ((emargement.isBefore(now) || emargement.isAtSameMomentAs(now)) &&
          emargementFin.isAfter(now)) {
        //Tester s'il n'a pas déjà émargé
        var presenceFuture = SeanceService.isEtudiantPresence(
            etudiant: SecurityService.connectedUser!.userId.toString(),
            idSeance: seanceSelected.id.toString());
        presenceFuture.then(
          (value) {
            setState(() {
              if (value == false) {
                // Le laisser voir l'icone pour emarger
                showPresenceIcon = true;
              } else {
                showPresenceIcon = false;
              }
            });
          },
        );
      } else {
        setState(() {
          showPresenceIcon = false;
        });
      }

      //---------------------------- DECLARATION ------------------------------
      DateTime hier = start.subtract(const Duration(days: 1));

      if (now.isBefore(hier) || now.isAtSameMomentAs(hier)) {
        //Tester s'il n'a pas déjà fait de déclaration
        var declarationFuture = DeclarationService.isEtudiantDeclaration(
            etudiant: SecurityService.connectedUser!.userId.toString(),
            idSeance: seanceSelected.id.toString());
        declarationFuture.then(
          (value) {
            setState(() {
              if (value == false) {
                // Le laisser voir l'icone pour faire déclaration
                showDeclarationIcon = true;
              } else {
                showDeclarationIcon = false;
              }
            });
          },
        );
      } else {
        setState(() {
          showDeclarationIcon = false;
        });
      }
    }
  }
}
