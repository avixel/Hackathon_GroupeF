class Event {
  final String titre;
  final String description;
  final String image;
  final String identifiant;
  final String typeDAnimation;
  final String horaireDetaile;
  final String horaire;
  final String nomDuLieu;
  final String ville;
  final String descriptionLongue;
  final String nombreEvenements;
  final List<String> lienDInscription;

  final List geolocalisation;

  Map<String, dynamic> customToJson() => {
        'titre': titre,
        'description': description,
        'image': image,
        "identifiant": identifiant,
        'typeDAnimation': typeDAnimation,
        'horaireDetaile': horaireDetaile,
        'horaire': horaire,
        'nomDuLieu': nomDuLieu,
        'ville': ville,
        'descriptionLongue': descriptionLongue,
        'nombreEvenements': nombreEvenements,
        'lienDInscription': lienDInscription,
        'geolocalisation': geolocalisation,
      };

  Event({
    this.titre,
    this.description,
    this.image,
    this.identifiant,
    this.typeDAnimation,
    this.horaireDetaile,
    this.nomDuLieu,
    this.ville,
    this.descriptionLongue,
    this.horaire,
    this.nombreEvenements,
    this.geolocalisation,
    this.lienDInscription,
  });

  factory Event.customFromJson(Map<String, dynamic> json) {
    return new Event(
      titre: json['titre'].toString(),
      description: json['description'].toString(),
      image: json['image'].toString(),
      identifiant: json['identifiant'].toString(),
      typeDAnimation: json['typeDAnimation'].toString(),
      horaireDetaile: json['horaireDetaile'].toString(),
      horaire: json['horaire'].toString(),
      nomDuLieu: json['nomDuLieu'].toString(),
      ville: json['ville'].toString(),
      descriptionLongue: json['descriptionLongue'].toString(),
      nombreEvenements: json['nombreEvenements'].toString(),
      geolocalisation: json['geolocalisation'],
      lienDInscription: json['lienDInscription'].toString().split(','),
    );
  }

  factory Event.fromJson(Map<String, dynamic> json) {
    return new Event(
      titre: json['fields']['titre_fr'].toString(),
      description: json['fields']['description_fr'].toString(),
      image: json['fields']['image'].toString(),
      identifiant: json['fields']['identifiant'].toString(),
      typeDAnimation: json['fields']['type_d_animation'].toString(),
      horaireDetaile: json['fields']['horaires_detailles_fr'].toString(),
      horaire: json['fields']['resume_horaires_fr'].toString(),
      nomDuLieu: json['fields']['nom_du_lieu'].toString(),
      ville: json['fields']['ville'].toString(),
      descriptionLongue: json['fields']['description_longue_fr'].toString(),
      nombreEvenements: json['fields']['nb_evenements'].toString(),
      geolocalisation: json['fields']['geolocalisation'],
      lienDInscription:
          json['fields']['lien_d_inscription'].toString().split(','),
    );
  }
}
