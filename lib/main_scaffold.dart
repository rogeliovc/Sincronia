import 'package:flutter/material.dart';
import 'screens/home_page.dart';
import 'screens/reproductor_page.dart';
import 'screens/horario_page.dart';
import 'screens/configuracion_page.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({Key? key}) : super(key: key);

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _selectedIndex = 1;

  final List<Widget> _pages = const [
    ReproductorPage(), // Música
    HomePage(),        // Inicio
    HorarioPage(),     // Tareas
    ConfiguracionPage(), // Configuración
  ];

  final List<IconData> _icons = [
    Icons.music_note,
    Icons.home,
    Icons.calendar_today,
    Icons.settings,
  ];

  final List<String> _titles = [
    'Música',
    'Sincronía',
    'Tareas',
    'Ajustes',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF02395D),
      appBar: AppBar(
        title: Text(_titles[_selectedIndex], style: const TextStyle(fontFamily: 'Lora', fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () {
            setState(() {
              _selectedIndex = 3;
            });
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 18,
              child: Icon(Icons.person, color: Colors.blueAccent),
            ),
          ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: _pages[_selectedIndex],
      // Barra de navegación inferior eliminada
    );
  }
}
