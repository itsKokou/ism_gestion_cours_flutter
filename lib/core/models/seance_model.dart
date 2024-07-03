// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';
import 'dart:ui';

import 'package:syncfusion_flutter_calendar/calendar.dart';

class Seance {
  int id;
  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
  Seance({
    required this.id,
    required this.eventName,
    required this.from,
    required this.to,
    required this.background,
    required this.isAllDay,
  });


  Seance copyWith({
    int? id,
    String? eventName,
    DateTime? from,
    DateTime? to,
    Color? background,
    bool? isAllDay,
  }) {
    return Seance(
      id: id ?? this.id,
      eventName: eventName ?? this.eventName,
      from: from ?? this.from,
      to: to ?? this.to,
      background: background ?? this.background,
      isAllDay: isAllDay ?? this.isAllDay,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'eventName': eventName,
      'from': from.millisecondsSinceEpoch,
      'to': to.millisecondsSinceEpoch,
      'background': background.value,
      'isAllDay': isAllDay,
    };
  }

  factory Seance.fromMap(Map<String, dynamic> map) {
    return Seance(
      id: map['id'] as int,
      eventName: map['eventName'] as String,
      from: DateTime.parse(map['from']),
      to: DateTime.parse(map['to']),
      background: const Color(0xFFFF1074),
      isAllDay: map['isAllDay'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory Seance.fromJson(String source) => Seance.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Seance(id: $id, eventName: $eventName, from: $from, to: $to, background: $background, isAllDay: $isAllDay)';
  }

  @override
  bool operator ==(covariant Seance other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.eventName == eventName &&
      other.from == from &&
      other.to == to &&
      other.background == background &&
      other.isAllDay == isAllDay;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      eventName.hashCode ^
      from.hashCode ^
      to.hashCode ^
      background.hashCode ^
      isAllDay.hashCode;
  }
}

class SeanceDataSource extends CalendarDataSource {
  SeanceDataSource(List<Seance> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }

  @override
  String getSubject(int index) {
    return appointments![index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments![index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].isAllDay;
  }
}
