import 'package:flutter/material.dart';
import 'package:games_services/games_services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Carrega as variáveis do .env
    await dotenv.load();

    // Inicializa o Supabase com as variáveis carregadas
    await Supabase.initialize(
      url: dotenv.env['SUPABASE_URL']!,
      anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
    );

    try {
      await GamesServices.signIn();
      final String? playerId = await GamesServices.getPlayerID();

      if (playerId != null && mounted) {
        print('Login com Google Play bem-sucedido! Player ID: $playerId');
        // TODO: Navegar para próxima tela
      } else {
        _showError('Não foi possível obter o ID do jogador.');
      }
    } catch (e) {
      _showError('Login com Google Play é necessário para jogar.');
    }
  }

  void _showError(String message) {
    print("ERRO: $message");
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text('Conectando...'),
          ],
        ),
      ),
    );
  }
}
