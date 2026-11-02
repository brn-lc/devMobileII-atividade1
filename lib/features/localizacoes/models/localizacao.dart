class Localizacao {
  final int? id;
  final double latitude;
  final double longitude;
  final double precisao;
  final DateTime instante;

  Localizacao({
    this.id,
    required this.latitude,
    required this.longitude,
    required this.precisao,
    required this.instante,
  });

  // Converte Objeto -> Map (para salvar no SQLite em UTC ISO 8601)
  Map<String, dynamic> toMap() => {
        'id': id,
        'latitude': latitude,
        'longitude': longitude,
        'precisao': precisao,
        'instante': instante.toUtc().toIso8601String(),
      };

  // Converte Map do SQLite -> Objeto (convertendo para horário local)
  factory Localizacao.fromMap(Map<String, dynamic> map) => Localizacao(
        id: map['id'] as int?,
        latitude: map['latitude'] as double,
        longitude: map['longitude'] as double,
        precisao: map['precisao'] as double,
        instante: DateTime.parse(map['instante'] as String).toLocal(),
      );
}
