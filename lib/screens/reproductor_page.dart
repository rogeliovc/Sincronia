import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:file_picker/file_picker.dart';
import '../services/tidal_api_service.dart';

class ReproductorPage extends StatefulWidget {
  const ReproductorPage({super.key});

  @override
  _ReproductorPageState createState() => _ReproductorPageState();
}

class _ReproductorPageState extends State<ReproductorPage> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  List<String> _songPaths = [];
  int _currentSongIndex = 0;

  // TIDAL API
  final TidalApiService _tidalService = TidalApiService();
  Map<String, dynamic>? _trackInfo;
  String? _previewUrl;
  bool _loading = false;
  String? _error;
  String _searchQuery = '';
  List<Map<String, dynamic>> _searchResults = [];
  bool _searching = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer.playerStateStream.listen((state) {
      setState(() {
        _isPlaying = state.playing;
      });
    });
    //_loadTidalTrack(); // Ya no cargamos un track por defecto
  }

  Future<void> _loadTidalTrackFromResult(Map<String, dynamic> track) async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      _trackInfo = track;
      // Si la respuesta ya trae un campo previewUrl, úsalo, si no, pon null
      _previewUrl = track['previewUrl'] ?? null;
      _loading = false;
    } catch (e) {
      setState(() {
        _error = 'Error: $e';
        _loading = false;
      });
    }
  }

  Future<void> _searchTracks(String query) async {
    setState(() {
      _searching = true;
      _searchResults = [];
      _error = null;
    });
    try {
      final results = await _tidalService.searchTracks(query);
      setState(() {
        _searchResults = results;
        _searching = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Error de búsqueda: $e';
        _searching = false;
      });
    }
  }

  Future<void> _pickFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
      allowMultiple: true,
    );

    if (result != null) {
      setState(() {
        _songPaths = result.paths.whereType<String>().toList();
      });
    }
  }

  Future<void> _playPause() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      if (_songPaths.isNotEmpty) {
        await _audioPlayer.setFilePath(_songPaths[_currentSongIndex]);
        await _audioPlayer.play();
      }
    }
  }

  void _playSong(int index) {
    setState(() {
      _currentSongIndex = index;
    });
    _playPause();
  }

  void _showSongList() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListView.builder(
          itemCount: _songPaths.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(_songPaths[index].split('/').last),
              onTap: () {
                Navigator.pop(context);
                _playSong(index);
              },
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reproductor'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Buscador
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Buscar canción en TIDAL...',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      _searchQuery = value;
                    },
                    onSubmitted: (value) {
                      if (value.trim().isNotEmpty) {
                        _searchTracks(value.trim());
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    if (_searchQuery.trim().isNotEmpty) {
                      _searchTracks(_searchQuery.trim());
                    }
                  },
                  child: const Text('Buscar'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_searching)
              const CircularProgressIndicator(),
            if (_error != null)
              Text(_error!, style: const TextStyle(color: Colors.red)),
            if (!_searching && _searchResults.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    final track = _searchResults[index];
                    return ListTile(
                      title: Text(track['title'] ?? 'Sin título'),
                      subtitle: Text('ID: ${track['id']}'),
                      trailing: const Icon(Icons.play_arrow),
                      onTap: () async {
                        await _loadTidalTrackFromResult(track);
                      },
                    );
                  },
                ),
              ),
            if (_loading)
              const CircularProgressIndicator(),
            if (_trackInfo != null && !_loading)
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    (_trackInfo?['title'] ?? 'Sin título').toString(),
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text('Sin artista'),
                  const SizedBox(height: 10),
                  Text('Duración: ' + (_trackInfo?['duration'] ?? '-')),
                  const SizedBox(height: 20),
                  _previewUrl != null
                      ? IconButton(
                          iconSize: 64,
                          icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                          onPressed: () async {
                            if (_isPlaying) {
                              await _audioPlayer.pause();
                            } else {
                              await _audioPlayer.setUrl(_previewUrl!);
                              await _audioPlayer.play();
                            }
                          },
                        )
                      : const Text('No hay preview disponible'),
                ],
              ),
          ],
        ),
      ),
    );
  }
}