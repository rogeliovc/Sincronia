import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class HorarioPage extends StatefulWidget {
  const HorarioPage({super.key});

  @override
  _HorarioPageState createState() => _HorarioPageState();
}

class _HorarioPageState extends State<HorarioPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDay = DateTime.now();
  final Map<DateTime, List<String>> _events = {};
  final TextEditingController _eventController = TextEditingController();

  @override
  void dispose() {
    _eventController.dispose();
    super.dispose();
  }

  void _addEvent() {
    setState(() {
      _events[_selectedDay] = _events[_selectedDay] ?? [];
      _events[_selectedDay]!.add(_eventController.text);
      _eventController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Horario Inteligente'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2023, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _selectedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
              });
            },
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _eventController,
                  decoration: const InputDecoration(labelText: 'Añadir Clase o Evento'),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _addEvent,
                  child: const Text('Agregar'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: _events[_selectedDay]?.map((event) => ListTile(title: Text(event))).toList() ?? [],
            ),
          ),
        ],
      ),
    );
  }
}