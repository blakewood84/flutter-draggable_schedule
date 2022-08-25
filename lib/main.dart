import 'package:flutter/material.dart';

const rows = [
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

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final schedules = <Map<String, dynamic>>[
    {
      'time': '8am',
      'tech': 'Bob',
      'details': 'Bob is cool',
      'color': Colors.redAccent
    },
    {
      'time': '2pm',
      'tech': 'Allen',
      'details': 'Allen is cool',
      'color': Colors.blueAccent
    },
    {
      'time': '5pm',
      'tech': 'James',
      'details': 'James is cool',
      'color': Colors.orangeAccent
    },
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: size.width,
          height: size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Calendar',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: rows.length,
                  itemBuilder: (context, index) {
                    final row = rows[index];
                    final schedule = schedules.firstWhere(
                        (e) => e['time'] == row,
                        orElse: () => <String, dynamic>{});

                    final widget = schedule.isNotEmpty
                        ? ScheduleColumn(
                            color: schedule['color'] as Color?,
                            name: schedule['tech'] as String?,
                            description: schedule['details'] as String?,
                            time: row,
                          )
                        : null;

                    return DragTarget(
                      onAccept: (Map<String, dynamic> data) {
                        final oldTime = data['time'];

                        final newData = {
                          ...data,
                          'time': row,
                        };

                        final index =
                            schedules.indexWhere((e) => e['time'] == oldTime);

                        setState(() {
                          schedules.removeWhere((e) => e['time'] == oldTime);

                          schedules.insert(index, newData);
                        });
                      },
                      onWillAccept: (data) {
                        return true;
                      },
                      builder: (context, candidateData, rejectedData) {
                        return Container(
                          height: 100,
                          decoration: BoxDecoration(
                            border: Border(
                              top: index == 0
                                  ? const BorderSide(
                                      width: 1,
                                      color: Colors.black,
                                    )
                                  : BorderSide.none,
                              bottom: const BorderSide(
                                width: 1,
                                color: Colors.black,
                              ),
                              left: const BorderSide(
                                width: 1,
                                color: Colors.black,
                              ),
                              right: const BorderSide(
                                width: 1,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          child: Center(
                            child: Row(
                              children: [
                                // TODO: Allow for a Row of Widgets here
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ScheduleColumn extends StatelessWidget {
  const ScheduleColumn({
    required this.time,
    required this.color,
    required this.name,
    required this.description,
    Key? key,
  }) : super(key: key);

  final String? name;
  final String? description;
  final Color? color;
  final String? time;

  @override
  Widget build(BuildContext context) {
    return Draggable(
      data: {
        'color': color,
        'tech': name,
        'details': description,
        'time': time,
      },
      feedback: Material(
        child: Container(
          width: 100,
          height: 50,
          color: color?.withOpacity(.5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(name.toString()),
              Text(
                description.toString(),
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  overflow: TextOverflow.ellipsis,
                ),
              )
            ],
          ),
        ),
      ),
      child: Container(
        width: 100,
        height: 50,
        color: color,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(name.toString()),
            Text(
              description.toString(),
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black,
                overflow: TextOverflow.ellipsis,
              ),
            )
          ],
        ),
      ),
    );
  }
}
