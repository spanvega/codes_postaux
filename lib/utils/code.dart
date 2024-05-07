class Code {
  final int codePostal;
  final int codeCommune;
  final String nomCommune;
  final String libelleAcheminement;

  Code.fromJson(Map<dynamic, dynamic> item)
      : codePostal = int.parse(item['codePostal']),
        codeCommune = int.parse(item['codeCommune']),
        nomCommune = item['nomCommune'] as String,
        libelleAcheminement = item['libelleAcheminement'] as String;

  Map<String, dynamic> toJson() => {
        'codePostal': codePostal,
        'codeCommune': codeCommune,
        'nomCommune': nomCommune,
        'libelleAcheminement': libelleAcheminement
      };
}
