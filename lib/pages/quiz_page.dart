import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:quiz_app/pages/resultado_page.dart';
import 'package:quiz_app/models/questao_model.dart'; // Vamos criar este modelo

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final _supabase = Supabase.instance.client;
  List<Questao> _questions = [];
  bool _isLoading = true;
  int _currentIndex = 0;
  int _score = 0;
  int? _selectedAlternativeId;
  bool _answerConfirmed = false;

  @override
  void initState() {
    super.initState();
    _fetchQuestions();
  }

  Future<void> _fetchQuestions() async {
    try {
      final response = await _supabase
          .rpc('get_random_questions', params: {'limit_count': 50});

      final List<Questao> loadedQuestions = (response as List)
          .map((item) => Questao.fromRpc(item['questao']))
          .toList();

      if (mounted) {
        setState(() {
          _questions = loadedQuestions;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        // TODO: Mostrar um erro mais amigável
        print("Erro ao buscar questões: $e");
        setState(() => _isLoading = false);
      }
    }
  }

  void _selectAlternative(int id) {
    if (_answerConfirmed) return;
    setState(() => _selectedAlternativeId = id);
  }

  void _confirmAnswer() {
    if (_selectedAlternativeId == null) return;

    final currentQuestion = _questions[_currentIndex];
    final correctAlternative =
        currentQuestion.alternativas.firstWhere((alt) => alt.correta);

    if (_selectedAlternativeId == correctAlternative.id) {
      setState(() => _score++);
    }
    setState(() => _answerConfirmed = true);
  }

  void _nextQuestion() {
    if (_currentIndex < _questions.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedAlternativeId = null;
        _answerConfirmed = false;
      });
    } else {
      // Fim do quiz
      // TODO: Salvar a pontuação no Supabase
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              ResultadoPage(score: _score, totalQuestions: _questions.length),
        ),
      );
    }
  }

  Color _getAlternativeColor(Alternativa alternative) {
    if (!_answerConfirmed) {
      return _selectedAlternativeId == alternative.id
          ? Colors.deepPurple.shade100
          : Colors.white;
    }
    if (alternative.correta) return Colors.green.shade200;
    if (_selectedAlternativeId == alternative.id) return Colors.red.shade200;
    return Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(body: const Center(child: CircularProgressIndicator()));
    }
    if (_questions.isEmpty) {
      return Scaffold(
          body: const Center(
              child: Text('Não foi possível carregar as questões.')));
    }

    final currentQuestion = _questions[_currentIndex];
    return Scaffold(
      appBar: AppBar(
        title: Text('Questão ${_currentIndex + 1} de ${_questions.length}'),
        automaticallyImplyLeading: false, // Remove o botão de voltar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(currentQuestion.enunciado,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                itemCount: currentQuestion.alternativas.length,
                itemBuilder: (context, index) {
                  final alternative = currentQuestion.alternativas[index];
                  return Card(
                    color: _getAlternativeColor(alternative),
                    child: ListTile(
                      title: Text(alternative.texto),
                      onTap: () => _selectAlternative(alternative.id),
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16)),
              onPressed: _selectedAlternativeId == null
                  ? null
                  : (_answerConfirmed ? _nextQuestion : _confirmAnswer),
              child: Text(_answerConfirmed ? 'Próxima Questão' : 'Confirmar'),
            ),
          ],
        ),
      ),
    );
  }
}
