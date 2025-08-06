import 'package:flutter/material.dart';
import 'package:games_services/games_services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Importações para as próximas páginas que vamos criar
// import 'home_page.dart';
// import 'create_profile_page.dart';

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
    // Garante que o Flutter está pronto
    WidgetsFlutterBinding.ensureInitialized();

    // Inicializa o Supabase (coloque suas chaves aqui)
    await Supabase.initialize(
      url: 'https://wbofvzuvirigmyjtvsuq.supabase.co',
      anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Indib2Z2enV2aXJpZ215anR2c3VxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTQ0MTgwODAsImV4cCI6MjA2OTk5NDA4MH0.w71LnzxjVpD0EaHMK4gMLAl_Sthc5Fn52D_U33X84aI',
    );

    // Tenta fazer o login com o Google Play Games
    try {
      await GamesServices.signIn();
      final String? playerId = await GamesServices.getPlayerID();

      if (playerId != null && mounted) {
        print('Login com Google Play bem-sucedido! Player ID: $playerId');
        // TODO: Verificar se o perfil existe no Supabase e navegar
        // Por enquanto, vamos para uma tela de sucesso temporária
        // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => HomePage()));
      } else {
        // Não conseguiu pegar o Player ID
        _showError('Não foi possível obter o ID do jogador.');
      }
    } catch (e) {
      // O usuário pode ter cancelado o login ou houve um erro
      print('Erro no login com Google Play: $e');
      _showError('Login com Google Play é necessário para jogar.');
    }
  }

  void _showError(String message) {
    // TODO: Mostrar um diálogo de erro mais amigável
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