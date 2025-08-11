import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:quiz_app/pages/opcoes_page.dart';
import 'package:quiz_app/pages/placar_page.dart';
import 'package:quiz_app/pages/quiz_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:games_services/games_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
    _loadBannerAd();
  }

  // A função de áudio agora é muito mais simples

  Map<String, dynamic>? _profile;
  BannerAd? _bannerAd;
  final bool _isPremium = false; // Futuramente, virá do RevenueCat

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    try {
      final playerId = await GamesServices.getPlayerID();
      if (playerId == null) throw Exception("Player ID não encontrado");

      final data = await _supabase
          .from('profiles') // A nova tabela agora se chama 'profiles'
          .select()
          .eq('player_id', playerId)
          .single();

      if (mounted) setState(() => _profile = data);
    } catch (e) {
      print("Erro ao carregar perfil: $e");
      // TODO: Lidar com erro (ex: mostrar diálogo e fechar o app)
    }
  }

  void _loadBannerAd() {
    // TODO: Substituir por seu ID de anúncio real
    const adUnitId = "ca-app-pub-3940256099942544/6300978111"; // ID de teste

    _bannerAd = BannerAd(
      adUnitId: adUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (_) => setState(() {}), // Apenas reconstrói a tela
        onAdFailedToLoad: (ad, err) {
          print('BannerAd failed to load: $err');
          ad.dispose();
        },
      ),
    )..load();
  }

  @override
  Widget build(BuildContext context) {
    final username = _profile?['username'] ?? 'Carregando...';

    return Scaffold(
      appBar: AppBar(
        title: Text('Olá, $username'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.play_arrow),
                label: const Text('INICIAR QUIZ'),
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16)),
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const QuizPage())),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.leaderboard),
                label: const Text('PLACAR SEMANAL'),
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16)),
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const PlacarPage())),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.settings),
                label: const Text('OPÇÕES'),
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16)),
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const OpcoesPage())),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _bannerAd != null && !_isPremium
          ? SizedBox(
              width: _bannerAd!.size.width.toDouble(),
              height: _bannerAd!.size.height.toDouble(),
              child: AdWidget(ad: _bannerAd!),
            )
          : const SizedBox.shrink(),
    );
  }
}
