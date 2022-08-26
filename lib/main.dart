import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:drag_and_drop/providers/schedule.dart';

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
      home: ChangeNotifierProvider(
        create: (context) => ScheduleProvider(),
        child: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final schedules = context.watch<ScheduleProvider>().schedules;

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
                  itemCount: schedules.length,
                  itemBuilder: (context, index) {
                    final row = schedules[index];

                    return ScheduleRowUI(
                      index: index,
                      row: row,
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

class ScheduleRowUI extends StatefulWidget {
  const ScheduleRowUI({
    required this.index,
    required this.row,
    Key? key,
  }) : super(key: key);

  final int index;
  final ScheduleRow row;

  @override
  State<ScheduleRowUI> createState() => _ScheduleRowUIState();
}

class _ScheduleRowUIState extends State<ScheduleRowUI> {
  @override
  Widget build(BuildContext context) {
    return DragTarget<ScheduleChipUI>(
      onAccept: (ScheduleChipUI chipUI) {
        final oldScheduleChip = chipUI;

        final chip = ScheduleChip(
          id: chipUI.data.id,
          time: widget.row.time,
          name: chipUI.data.name,
          details: chipUI.data.details,
          color: chipUI.data.color,
        );

        final newScheduleChip = ScheduleChipUI(data: chip);

        context.read<ScheduleProvider>().updateSchedule(
              oldScheduleChip,
              newScheduleChip,
            );
      },
      onWillAccept: (data) {
        return data is ScheduleChipUI;
      },
      onAcceptWithDetails: (details) {
        print(details.offset);
      },
      builder: (context, candidateData, rejectedData) {
        return Container(
          height: 100,
          decoration: BoxDecoration(
            border: Border(
              top: widget.index == 0
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
            child: ValueListenableBuilder(
              valueListenable: widget.row.rows,
              builder: (context, List<ScheduleChipUI> list, child) {
                return Column(
                  children: [
                    Container(
                      height: 20,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        border: Border.all(
                          width: 1,
                          color: Colors.grey,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          widget.row.time.toString(),
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [...list],
                    )
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class ScheduleChipUI extends StatelessWidget {
  const ScheduleChipUI({
    required this.data,
    Key? key,
  }) : super(key: key);

  final ScheduleChip data;

  @override
  Widget build(BuildContext context) {
    // final renderBox = context.findRenderObject() as RenderBox;
    // final offset = renderBox.localToGlobal(Offset.zero);
    // print('OFFSET: $offset');

    return Draggable<ScheduleChipUI>(
      data: this,
      feedback: Material(
        child: Container(
          width: 100,
          height: 70,
          color: data.color.withOpacity(.5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                data.time.toString(),
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                ),
              ),
              Text(
                data.name.toString(),
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                ),
              ),
              Text(
                data.details.toString(),
                style: const TextStyle(
                  fontSize: 12,
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
        height: 70,
        color: data.color,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              data.time.toString(),
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              data.name.toString(),
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black,
              ),
            ),
            Text(
              data.details.toString(),
              style: const TextStyle(
                fontSize: 12,
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
