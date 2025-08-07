import 'package:flutter/material.dart';
import 'package:quiz_app/pages/create_profile_page.dart';
import 'package:quiz_app/services/auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'home_page.dart'; // Placeholder

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});
  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _initializeAppAndSignIn();
  }

  Future<void> _initializeAppAndSignIn() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Supabase.initialize(
      url: 'SUA_URL',
      anonKey: 'SUA_CHAVE',
    );

    try {
      final playerId = await _authService.signIn();
      if (playerId == null) {
        throw Exception('Não foi possível obter o ID do jogador.');
      }

      final profile = await _authService.getProfile(playerId);

      if (mounted) {
        if (profile != null) {
          // Perfil existe, vai para a home
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
                builder: (context) => const HomePage()), // Placeholder
          );
        } else {
          // Perfil não existe, vai para a criação
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
                builder: (context) => CreateProfilePage(playerId: playerId)),
          );
        }
      }
    } catch (e) {
      // TODO: Mostrar um diálogo de erro com botão "Tentar novamente"
      print('Erro no fluxo de login: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
