class Arrondissement {
  final String codeInsee;
  final List<String> codePostal;

  Arrondissement(this.codeInsee, this.codePostal);
}

class Ville {
  final String nom;
  final String codeInsee;
  final List<Arrondissement> arrondissements;

  Ville(this.nom, this.codeInsee, this.arrondissements);
}

final List<Ville> villes = [
  Ville('Lyon', '69123', [
    Arrondissement('69381', ['69001']),
    Arrondissement('69382', ['69002']),
    Arrondissement('69383', ['69003']),
    Arrondissement('69384', ['69004']),
    Arrondissement('69385', ['69005']),
    Arrondissement('69386', ['69006']),
    Arrondissement('69387', ['69007']),
    Arrondissement('69388', ['69008']),
    Arrondissement('69389', ['69009'])
  ]),
  Ville('Marseille', '13055', [
    Arrondissement('13201', ['13001']),
    Arrondissement('13202', ['13002']),
    Arrondissement('13203', ['13003']),
    Arrondissement('13204', ['13004']),
    Arrondissement('13205', ['13005']),
    Arrondissement('13206', ['13006']),
    Arrondissement('13207', ['13007']),
    Arrondissement('13208', ['13008']),
    Arrondissement('13209', ['13009']),
    Arrondissement('13210', ['13010']),
    Arrondissement('13211', ['13011']),
    Arrondissement('13212', ['13012']),
    Arrondissement('13213', ['13013']),
    Arrondissement('13214', ['13014']),
    Arrondissement('13215', ['13015']),
    Arrondissement('13216', ['13016'])
  ]),
  Ville('Paris', '75056', [
    Arrondissement('75101', ['75001']),
    Arrondissement('75102', ['75002']),
    Arrondissement('75103', ['75003']),
    Arrondissement('75104', ['75004']),
    Arrondissement('75105', ['75005']),
    Arrondissement('75106', ['75006']),
    Arrondissement('75107', ['75007']),
    Arrondissement('75108', ['75008']),
    Arrondissement('75109', ['75009']),
    Arrondissement('75110', ['75010']),
    Arrondissement('75111', ['75011']),
    Arrondissement('75112', ['75012']),
    Arrondissement('75113', ['75013']),
    Arrondissement('75114', ['75014']),
    Arrondissement('75115', ['75015']),
    Arrondissement('75116', ['75016', '75116']),
    Arrondissement('75117', ['75017']),
    Arrondissement('75118', ['75018']),
    Arrondissement('75119', ['75019']),
    Arrondissement('75120', ['75020'])
  ])
];
