import 'package:flutter/material.dart';

class ConfiguracionPage extends StatelessWidget {
  const ConfiguracionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración'),
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView(
        children: const [
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Perfil'),
            onTap: null, // Agrega la lógica para navegar a la página de perfil
          ),
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Notificaciones'),
            onTap: null, // Agrega la lógica para navegar a la configuración de notificaciones
          ),
          ListTile(
            leading: Icon(Icons.info, color: Colors.blueAccent),
            title: Text('Ayuda'),
            onTap: null, // Agrega la lógica para navegar a la página de ayuda
          ),
        ],
      ),
    );
  }
}