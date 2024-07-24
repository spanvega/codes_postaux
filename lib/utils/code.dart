class Code {
  final String codePostal;
  final String codeCommune;
  final String nomCommune;
  final String libelleAcheminement;

  Code.fromJson(Map<dynamic, dynamic> item)
      : codePostal = item['codePostal'],
        codeCommune = item['codeCommune'],
        nomCommune = item['nomCommune'],
        libelleAcheminement = item['libelleAcheminement'];

  Map<String, dynamic> toJson() => {
        'codePostal': codePostal,
        'codeCommune': codeCommune,
        'nomCommune': nomCommune,
        'libelleAcheminement': libelleAcheminement
      };
}
