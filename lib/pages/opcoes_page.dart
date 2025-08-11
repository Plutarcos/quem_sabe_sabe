import 'package:flutter/material.dart';

class OpcoesPage extends StatefulWidget {
  const OpcoesPage({super.key});

  @override
  State<OpcoesPage> createState() => _OpcoesPageState();
}

class _OpcoesPageState extends State<OpcoesPage> {
  late bool _isMusicMuted;
  late bool _isSfxMuted;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() {
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
          appBar: AppBar(title: const Text('Opções')),
          body: const Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Opções')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Divider(height: 32),
          ListTile(
            leading: const Icon(Icons.ads_click),
            title: const Text('Remover Anúncios'),
            subtitle: const Text('Obtenha a versão Premium'),
            onTap: () {
              // TODO: Chamar o paywall do RevenueCat aqui
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Funcionalidade de compra em breve!')),
              );
            },
          ),
        ],
      ),
    );
  }
}
