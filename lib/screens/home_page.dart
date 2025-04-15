import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'horario_page.dart';
import 'reproductor_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Mock data para playlists
  final List<Map<String, String>> playlists = [
    {"name": "Alternativa", "img": "assets/playlist1.png"},
    {"name": "Pop - Rock", "img": "assets/playlist2.png"},
    {"name": "Folk", "img": "assets/playlist3.png"},
    {"name": "Balada", "img": "assets/playlist4.png"},
  ];
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  // Mock data: eventos/tareas por fecha
  final Map<DateTime, List<Map<String, String>>> eventosPorFecha = {
    DateTime(2025, 4, 14): [
      {"nombre": "Maquetado", "urgencia": "Urgente", "hora": "10:00"},
      {"nombre": "Diseño menú", "urgencia": "Urgente", "hora": "12:00"},
    ],
    DateTime(2025, 4, 15): [
      {"nombre": "Configurar notificaciones", "urgencia": "On Time", "hora": "09:00"},
    ],
    DateTime(2025, 4, 12): [
      {"nombre": "Reunión equipo", "urgencia": "On Time", "hora": "16:00"},
    ],
  };

  List<Map<String, String>> getEventosParaDia(DateTime day) {
    return eventosPorFecha.entries
        .where((entry) => isSameDay(entry.key, day))
        .expand((entry) => entry.value)
        .toList();
  }

  int _selectedIndex = 0;
  final List<String> _tabs = ["Horario", "Reproductor"];

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // Aquí puedes navegar o cambiar contenido según la pestaña
    });
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final selectedDay = _selectedDay ?? today;
    final eventos = getEventosParaDia(selectedDay);
    return Scaffold(
      backgroundColor: const Color(0xFF02395D),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Tab Inicio (casita)
            GestureDetector(
              onTap: () {
                setState(() {
                  _selectedIndex = 0;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                decoration: BoxDecoration(
                  color: _selectedIndex == 0 ? Colors.lightBlue[300] : Colors.transparent,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(
                  Icons.home,
                  color: Colors.white,
                  size: 26,
                ),
              ),
            ),
            // Tab Horario
            GestureDetector(
              onTap: () {
                setState(() {
                  _selectedIndex = 1;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                decoration: BoxDecoration(
                  color: _selectedIndex == 1 ? Colors.lightBlue[300] : Colors.transparent,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Text(
                  'Horario',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            // Tab Reproductor
            GestureDetector(
              onTap: () {
                setState(() {
                  _selectedIndex = 2;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                decoration: BoxDecoration(
                  color: _selectedIndex == 2 ? Colors.lightBlue[300] : Colors.transparent,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Text(
                  'Reproductor',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: _selectedIndex == 0
          ? SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Calendario
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.10),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: TableCalendar(
                          firstDay: DateTime.utc(2025, 4, 1),
                          lastDay: DateTime.utc(2025, 4, 30),
                          focusedDay: _focusedDay,
                          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                          locale: 'es_ES',
                          calendarFormat: CalendarFormat.week,
                          availableCalendarFormats: const {CalendarFormat.week: 'Semana', CalendarFormat.month: 'Mes'},
                          onDaySelected: (selected, focused) {
                            setState(() {
                              _selectedDay = selected;
                              _focusedDay = focused;
                            });
                          },
                          eventLoader: getEventosParaDia,
                          calendarStyle: CalendarStyle(
                            todayDecoration: BoxDecoration(
                              color: Colors.lightBlue[300],
                              shape: BoxShape.circle,
                            ),
                            selectedDecoration: BoxDecoration(
                              color: Colors.blueAccent,
                              shape: BoxShape.circle,
                            ),
                            markerDecoration: BoxDecoration(
                              color: Colors.redAccent,
                              shape: BoxShape.circle,
                            ),
                            outsideDaysVisible: false,
                            weekendTextStyle: const TextStyle(color: Colors.white70),
                            defaultTextStyle: const TextStyle(color: Colors.white),
                          ),
                          headerStyle: const HeaderStyle(
                            formatButtonVisible: false,
                            titleCentered: true,
                            titleTextStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                            leftChevronIcon: Icon(Icons.chevron_left, color: Colors.white),
                            rightChevronIcon: Icon(Icons.chevron_right, color: Colors.white),
                            decoration: BoxDecoration(color: Colors.transparent),
                          ),
                          daysOfWeekStyle: const DaysOfWeekStyle(
                            weekdayStyle: TextStyle(color: Colors.white70),
                            weekendStyle: TextStyle(color: Colors.white70),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Playlists
                      const Text("Playlists", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 90,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: playlists.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 18),
                          itemBuilder: (context, i) => Column(
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.white,
                                backgroundImage: AssetImage(playlists[i]["img"]!),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                playlists[i]["name"]!,
                                style: const TextStyle(color: Colors.white, fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Sección de tareas/eventos para el día seleccionado
                      const SizedBox(height: 14),
                      Text(
                        "Tareas/Eventos para el ${selectedDay.day}/${selectedDay.month}/${selectedDay.year}",
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      const SizedBox(height: 8),
                      eventos.isEmpty
                          ? const Text("No hay tareas/eventos para este día.", style: TextStyle(color: Colors.white70))
                          : Column(
                              children: eventos.map((evento) => Container(
                                margin: const EdgeInsets.symmetric(vertical: 6),
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(18),
                                  border: Border.all(color: evento["urgencia"] == "Urgente" ? Colors.redAccent : Colors.greenAccent, width: 2),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          evento["nombre"]!,
                                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          "Urgencia: ${evento["urgencia"]}",
                                          style: TextStyle(
                                            color: evento["urgencia"] == "Urgente" ? Colors.redAccent : Colors.greenAccent,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      evento["hora"]!,
                                      style: const TextStyle(color: Colors.white70, fontSize: 15),
                                    ),
                                  ],
                                ),
                              )).toList(),
                            ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            )
          : _selectedIndex == 1
          ? const HorarioPage()
          : const ReproductorPage(),
    );
  }
}