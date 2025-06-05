class Code {
  final String codeInsee, codePostal, ville;

  Code.fromValues(this.codeInsee, this.codePostal, this.ville);

  Map<String, dynamic> toJson() =>
      {'codeInsee': codeInsee, 'codePostal': codePostal, 'ville': ville};
}
