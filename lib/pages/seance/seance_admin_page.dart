import 'package:flutter/material.dart';
import 'package:projet_flutter/core/constants/colors_constantes.dart';
import 'package:projet_flutter/core/models/classe_model.dart';
import 'package:projet_flutter/core/models/seance_model.dart';
import 'package:projet_flutter/core/services/classe_service.dart';
import 'package:projet_flutter/core/services/seance.service.dart';
import 'package:projet_flutter/core/services/security_service.dart';
import 'package:projet_flutter/pages/home/home.page.dart';
import 'package:projet_flutter/pages/qrcode/scanner.page.dart';
import 'package:projet_flutter/pages/seance/components/classe_list_component.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class SeanceAdminPage extends StatefulWidget {
  const SeanceAdminPage({super.key});
  static String routeName = "/admin/seance";

  @override
  State<SeanceAdminPage> createState() => _SeanceAdminPageState();
}

class _SeanceAdminPageState extends State<SeanceAdminPage> {
  final CalendarController _controller = CalendarController();
  Color? _viewHeaderColor;
  late Future<List<Seance>> meetings;
  late Future<List<Classe>> classes;
  List<Seance> seanceList = [];
  late Seance seanceSelected;
  bool showIcon = false;

  @override
  void initState() {
    super.initState();
    meetings = SeanceService.getAllByClasse(
        id: ClasseService.classeSelected.toString());
    classes = ClasseService.getAll();
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
            if (showIcon) // Conditionner l'affichage de l'icône
              IconButton(
                  icon: const Icon(
                    Icons.qr_code_scanner,
                    color: whiteColor,
                  ),
                  onPressed: () {
                    // Sacnner
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ScannerPage(seanceChosen: seanceSelected.id)),
                    );
                  }),

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
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const ClasseListComponent(),
              Expanded(
                child: FutureBuilder<List<Seance>>(
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
                            textStyle:
                                TextStyle(color: Colors.black, fontSize: 15),
                          ),
                          backgroundColor: whiteColor,
                          selectionDecoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border.all(color: Colors.blue, width: 2),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(4)),
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
                          viewHeaderStyle: ViewHeaderStyle(
                              backgroundColor: _viewHeaderColor),
                          controller: _controller,
                          initialDisplayDate: DateTime.now(),
                          onTap: calendarTapped,
                          monthViewSettings: const MonthViewSettings(
                              navigationDirection:
                                  MonthNavigationDirection.vertical),
                        );
                      }
                    }),
              ),
            ],
          ),
        ));
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
      //recuperer la seance en question.
      seanceSelected = calendarTapDetails.appointments!.first;
      DateTime start = seanceSelected.from;
      DateTime end = seanceSelected.to;
      DateTime emargement = start.add(const Duration(minutes: 30));
      DateTime emargementFin = end.subtract(const Duration(minutes: 10));
      DateTime now = DateTime.now();
      setState(() {
        if ((emargement.isBefore(now) || emargement.isAtSameMomentAs(now)) &&
            emargementFin.isAfter(now)) {
          //le laisser voir l'icone pour emarger
          showIcon = true;
        } else {
          showIcon = false;
        }
      });
    }
  }
}
