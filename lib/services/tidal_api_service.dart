import 'dart:convert';
import 'package:http/http.dart' as http;

class TidalApiService {
  Future<List<Map<String, dynamic>>> searchTracks(String query, {int limit = 10}) async {
    // Cambia la URL por la API real de TIDAL o la que estés usando
    final response = await http.get(
      Uri.parse('https://api.example.com/tidal/search?q=$query&limit=$limit'),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // Ajusta según la estructura real de la respuesta de TIDAL
      return List<Map<String, dynamic>>.from(data['results']);
    } else {
      throw Exception('Error buscando tracks');
    }
  }
}
