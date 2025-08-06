import 'package:games_services/games_services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final _supabase = Supabase.instance.client;

  // Tenta fazer o login e retorna o ID do jogador
  Future<String?> signIn() async {
    await GamesServices.signIn();
    return await GamesServices.getPlayerID();
  }

  // Verifica se um perfil já existe para um Player ID
  Future<Map<String, dynamic>?> getProfile(String playerId) async {
    try {
      final response = await _supabase
          .from('profiles')
          .select()
          .eq('player_id', playerId)
          .single();
      return response;
    } catch (e) {
      // Se o 'single()' falhar, significa que não encontrou o perfil
      return null;
    }
  }

  // Verifica se um nome de usuário já está em uso
  Future<bool> isUsernameTaken(String username) async {
    final response = await _supabase
        .from('profiles')
        .select('username')
        .eq('username', username)
        .limit(1);
    return response.isNotEmpty;
  }

  // Cria um novo perfil no banco de dados
  Future<void> createProfile(
      {required String playerId, required String username}) async {
    await _supabase.from('profiles').insert({
      'player_id': playerId,
      'username': username,
    });
  }
}
