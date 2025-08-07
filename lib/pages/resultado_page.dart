import 'package:flutter/material.dart';

class ResultadoPage extends StatelessWidget {
  final int score;
  final int totalQuestions;

  const ResultadoPage(
      {super.key, required this.score, required this.totalQuestions});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Resultado do Quiz')),
      body: Center(
        // O Center garante que a Column fique no meio da tela
        child: Column(
          // A Column organiza os itens verticalmente
          mainAxisAlignment:
              MainAxisAlignment.center, // A Column USA o mainAxisAlignment
          children: [
            Text(
              'Você acertou',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text(
              '$score de $totalQuestions',
              style: Theme.of(context)
                  .textTheme
                  .displayLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Jogar Novamente'),
            ),
          ],
        ),
      ),
    );
  }
}
