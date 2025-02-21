class Code {
  final String code;
  final String nom;

  Code.fromJson(Map<String, dynamic> item)
      : code = item['codeCommune'],
        nom = item['nomCommune'];

  Map<String, dynamic> toJson() => {
        'code': code,
        'nom': nom,
      };
}
