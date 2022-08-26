import 'package:drag_and_drop/main.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart' show IterableExtension;

const calendarRows = [
  '8am',
  '9am',
  '10am',
  '11am',
  '12pm',
  '1pm',
  '2pm',
  '3pm',
  '4pm',
  '5pm',
];

const calendarStart = [
  ScheduleChip(
    id: '1',
    time: '8am',
    name: 'Bob',
    details: 'Plumber',
    color: Colors.redAccent,
  ),
  ScheduleChip(
    id: '2',
    time: '2pm',
    name: 'Allen',
    details: 'Technician',
    color: Colors.orangeAccent,
  ),
  ScheduleChip(
    id: '3',
    time: '5pm',
    name: 'James',
    details: 'Plumber',
    color: Colors.blueAccent,
  ),
];

class ScheduleChip {
  const ScheduleChip({
    required this.id,
    required this.time,
    required this.name,
    required this.details,
    required this.color,
  });

  final String id;
  final String time;
  final String name;
  final String details;
  final Color color;

  ScheduleChip.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        time = map['time'],
        name = map['name'],
        details = map['details'],
        color = map['color'];
}

class ScheduleRow {
  ScheduleRow({required this.time, required List<ScheduleChip> rows})
      : rows = ValueNotifier<List<ScheduleChipUI>>(
          [for (final row in rows) ScheduleChipUI(scheduleChip: row)],
        );

  final String time;
  final ValueNotifier<List<ScheduleChipUI>> rows;

  // void addRow(ScheduleChip scheduleChip) {
  //   rows.value.add(scheduleChip);
  // }

  // void removeRow(ScheduleChip scheduleChip) {
  //   rows.value.removeWhere((element) => element.id == scheduleChip.id);
  // }
}

class ScheduleProvider extends ChangeNotifier {
  final schedules = List<ScheduleRow>.generate(calendarRows.length, (index) {
    final time = calendarRows[index];

    final start = calendarStart.singleWhereOrNull(
      (element) => element.time == time,
    );

    return ScheduleRow(time: time, rows: start != null ? [start] : []);
  });

  // void updateSchedule(
  //     ScheduleChip oldScheduleChip, ScheduleChip newScheduleChip) {
  //   // Remove from old row
  //   final scheduleToRemoveFrom = schedules
  //       .singleWhere((schedule) => schedule.time == oldScheduleChip.time);
  //   scheduleToRemoveFrom.removeRow(oldScheduleChip);

  //   // Add to new ro
  //   final scheduleToUpdate = schedules
  //       .singleWhere((schedule) => schedule.time == newScheduleChip.time);
  //   scheduleToUpdate.addRow(newScheduleChip);

  //   // schedules.add(Schedu);
  //   notifyListeners();
  // }
}
