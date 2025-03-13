import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:file_picker/file_picker.dart';

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

  @override
  void initState() {
    super.initState();
    _audioPlayer.playerStateStream.listen((state) {
      setState(() {
        _isPlaying = state.playing;
      });
    });
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
        actions: [
          IconButton(
            icon: const Icon(Icons.folder_open),
            onPressed: _pickFiles,
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Column(
              children: [
                IconButton(
                  iconSize: 64,
                  icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                  onPressed: _playPause,
                ),
                const SizedBox(height: 20),
                if (_songPaths.isNotEmpty)
                  Text('Reproduciendo: ${_songPaths[_currentSongIndex].split('/').last}'),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _showSongList,
            child: const Text('Mostrar Lista de Canciones'),
          ),
        ],
      ),
    );
  }
}