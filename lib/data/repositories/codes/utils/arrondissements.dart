class Arrondissement {
  final int codeInsee;
  final List<int> codePostal;

  Arrondissement(this.codeInsee, this.codePostal);
}

class Ville {
  final List<Arrondissement> arrondissements;
  final int codeInsee;
  final String nom;

  Ville(this.nom, this.codeInsee, this.arrondissements);
}

final List<Ville> villes = [
  .new('Lyon', 69123, [
    .new(69381, [69001]),
    .new(69382, [69002]),
    .new(69383, [69003]),
    .new(69384, [69004]),
    .new(69385, [69005]),
    .new(69386, [69006]),
    .new(69387, [69007]),
    .new(69388, [69008]),
    .new(69389, [69009]),
  ]),
  .new('Marseille', 13055, [
    .new(13201, [13001]),
    .new(13202, [13002]),
    .new(13203, [13003]),
    .new(13204, [13004]),
    .new(13205, [13005]),
    .new(13206, [13006]),
    .new(13207, [13007]),
    .new(13208, [13008]),
    .new(13209, [13009]),
    .new(13210, [13010]),
    .new(13211, [13011]),
    .new(13212, [13012]),
    .new(13213, [13013]),
    .new(13214, [13014]),
    .new(13215, [13015]),
    .new(13216, [13016]),
  ]),
  .new('Paris', 75056, [
    .new(75101, [75001]),
    .new(75102, [75002]),
    .new(75103, [75003]),
    .new(75104, [75004]),
    .new(75105, [75005]),
    .new(75106, [75006]),
    .new(75107, [75007]),
    .new(75108, [75008]),
    .new(75109, [75009]),
    .new(75110, [75010]),
    .new(75111, [75011]),
    .new(75112, [75012]),
    .new(75113, [75013]),
    .new(75114, [75014]),
    .new(75115, [75015]),
    .new(75116, [75016, 75116]),
    .new(75117, [75017]),
    .new(75118, [75018]),
    .new(75119, [75019]),
    .new(75120, [75020]),
  ]),
];
