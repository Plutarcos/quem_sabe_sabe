class Alternativa {
  final int id;
  final String texto;
  final bool correta;

  Alternativa({required this.id, required this.texto, required this.correta});

  factory Alternativa.fromJson(Map<String, dynamic> json) {
    return Alternativa(
      id: json['id'],
      texto: json['texto'],
      correta: json['correta'] ?? false,
    );
  }
}

class Questao {
  final int id;
  final String enunciado;
  final List<Alternativa> alternativas;

  Questao(
      {required this.id, required this.enunciado, required this.alternativas});

  // Construtor especial para os dados que vêm da nossa função RPC
  factory Questao.fromRpc(Map<String, dynamic> json) {
    var alternativasData = json['alternativas'] as List? ?? [];
    List<Alternativa> alternativasList = alternativasData
        .map((altJson) => Alternativa.fromJson(altJson))
        .toList();

    return Questao(
      id: json['id'],
      enunciado: json['enunciado'],
      alternativas: alternativasList,
    );
  }
}
