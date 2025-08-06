import 'package:flutter/material.dart';
import 'package:quiz_app/services/auth_service.dart';
import 'home_page.dart'; // A futura página principal

class CreateProfilePage extends StatefulWidget {
  final String playerId;
  const CreateProfilePage({super.key, required this.playerId});

  @override
  State<CreateProfilePage> createState() => _CreateProfilePageState();
}

class _CreateProfilePageState extends State<CreateProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _authService = AuthService();
  bool _isLoading = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // Cria o perfil no Supabase
      await _authService.createProfile(
        playerId: widget.playerId,
        username: _usernameController.text.trim(),
      );

      if (mounted) {
        // Navega para a tela principal
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (context) => const HomePage()), // Placeholder
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erro ao criar perfil: ${e.toString()}')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Bem-vindo!',
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                const Text('Escolha seu nome de usuário para o placar:'),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _usernameController,
                  decoration:
                      const InputDecoration(labelText: 'Nome de Usuário'),
                  validator: (value) {
                    if (value == null || value.length < 3) {
                      return 'O nome deve ter pelo menos 3 caracteres.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _submit,
                        child: const Text('Confirmar e Jogar'),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
