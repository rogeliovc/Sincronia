import 'package:flutter/material.dart';
import 'horario_page.dart';
import 'reproductor_page.dart';
import 'configuracion_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sincronía', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 4.0,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Colors.blueAccent),
              accountName: Text('Usuario', style: TextStyle(color: Colors.white)),
              accountEmail: Text('usuario@example.com', style: TextStyle(color: Colors.white)),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text('U', style: TextStyle(fontSize: 40.0)),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.schedule, color: Colors.blueAccent),
              title: const Text('Horario'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HorarioPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.music_note, color: Colors.blueAccent),
              title: const Text('Reproductor'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ReproductorPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings, color: Colors.blueAccent),
              title: const Text('Configuración'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ConfiguracionPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Bienvenido a Sincronía',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Próximos Eventos',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text('Evento 1: Detalles del evento'),
                    Text('Evento 2: Detalles del evento'),
                    // Agrega más eventos aquí
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Última Canción Escuchada',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const ListTile(
              leading: Icon(Icons.music_note, color: Colors.blueAccent),
              title: Text('Nombre de la Canción'),
              subtitle: Text('Artista - Álbum'),
            ),
          ],
        ),
      ),
    );
  }
}