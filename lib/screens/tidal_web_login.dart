// Archivo eliminado: autenticación TIDAL Web Login ya no es necesaria.
import 'package:webview_flutter/webview_flutter.dart';

class TidalWebLogin extends StatefulWidget {
  final String authUrl;
  final String redirectUri;
  const TidalWebLogin({required this.authUrl, required this.redirectUri, super.key});

  @override
  State<TidalWebLogin> createState() => _TidalWebLoginState();
}

class _TidalWebLoginState extends State<TidalWebLogin> {
  late final WebViewController _controller;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (request) {
            if (request.url.startsWith(widget.redirectUri)) {
              final uri = Uri.parse(request.url);
              final code = uri.queryParameters['code'];
              if (code != null) {
                Navigator.of(context).pop(code);
              } else {
                setState(() {
                  _error = 'No se pudo obtener el código de autorización.';
                });
              }
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
          onPageStarted: (_) => setState(() => _loading = true),
          onPageFinished: (_) => setState(() => _loading = false),
          onWebResourceError: (error) => setState(() => _error = error.description),
        ),
      )
      ..loadRequest(Uri.parse(widget.authUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Iniciar sesión en TIDAL')),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_loading)
            const Center(child: CircularProgressIndicator()),
          if (_error != null)
            Center(
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(16),
                child: Text(_error!, style: const TextStyle(color: Colors.red)),
              ),
            ),
        ],
      ),
    );
  }
}
