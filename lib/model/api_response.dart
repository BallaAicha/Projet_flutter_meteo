import '../services/data_convert.dart';

// Ce fichier contient plusieurs classes responsables de la représentation des données provenant de l'API météo.

// La classe APIResponse représente la réponse complète de l'API météo.
// Elle contient des informations telles que le code de statut, le message, le nombre de prévisions (cnt), et une liste de prévisions (list).
// Elle a des méthodes pour créer une instance à partir d'un objet JSON et pour fusionner plusieurs réponses en une seule.
class APIResponse {
  String cod; // Code de statut de la réponse
  double message; // Message associé à la réponse
  int cnt; // Nombre total de prévisions
  List<Forecast> list; // Liste des prévisions météo
  // Constructeur de la classe
  APIResponse(this.cod, this.message, this.list, this.cnt);
  // Fabrique pour créer une instance à partir d'un objet JSON et du nom de la ville
  //la pertinence de ce factory est de pouvoir créer une instance de la classe APIResponse à partir d'un objet JSON
  factory APIResponse.fromJson(Map<String, dynamic> map, String cityName) {
    return APIResponse(
      map["cod"],
      (map["message"] ?? 0.0).toDouble(),
      DataConverter()
          .listMappable(map["list"])
          .map((e) => Forecast.fromJson(e, cityName))
          .toList(),
      map["cnt"],
    );
  }
}

// La classe Forecast représente une prévision météo pour une période spécifique.
// Elle contient des informations telles que la date et l'heure (dt), les données principales (main),
// les conditions météo (weather), le vent (wind), les nuages (clouds), la visibilité, la date en texte (dt_txt),
// et le nom de la ville associée à la prévision.
class Forecast {
  int dt; // Date et heure de la prévision
  Main main; // Données principales de la prévision
  List<Weather> weather; // Conditions météo de la prévision
  Wind wind; // Vent de la prévision
  Clouds clouds; // Nuages de la prévision
  int visibility; // Visibilité de la prévision
  String dt_txt; // Date et heure en texte de la prévision
  String cityName; // Nom de la ville associée à la prévision
  // Constructeur de la classe Forecast
  Forecast(this.dt, this.main, this.weather, this.wind, this.clouds,
      this.visibility, this.dt_txt, this.cityName);
  // Fabrique pour créer une instance à partir d'un objet JSON
  factory Forecast.fromJson(Map<String, dynamic> map, String cityName) {
    return Forecast(
      map["dt"] ?? 0,
      Main.fromJson(map["main"] ?? {}),
      (map["weather"] as List<dynamic>?)
              ?.map((e) => Weather.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      Wind.fromJson(map["wind"] ?? {}),
      Clouds.fromJson(map["clouds"] ?? {}),
      map["visibility"] ?? 0,
      map["dt_txt"] ?? "",
      cityName,
    );
  }
}

class Main {
  double temp;
  double feels_like;
  double temp_min;
  double temp_max;
  double pressure;
  double sea_level;
  double grnd_level;
  double humidity;
  double temp_kf;

  Main(this.temp, this.temp_max, this.temp_min, this.temp_kf, this.humidity,
      this.grnd_level, this.sea_level, this.pressure, this.feels_like);

  factory Main.fromJson(Map<String, dynamic> map) {
    return Main(
      (map["temp"] ?? 0).toDouble(),
      (map["temp_max"] ?? 0).toDouble(),
      (map["temp_min"] ?? 0).toDouble(),
      (map["temp_kf"] ?? 0).toDouble(),
      (map["humidity"] ?? 0).toDouble(),
      (map["grnd_level"] ?? 0).toDouble(),
      (map["sea_level"] ?? 0).toDouble(),
      (map["pressure"] ?? 0).toDouble(),
      (map["feels_like"] ?? 0).toDouble(),
    );
  }
}

class Weather {
  int id;
  String main;
  String description;
  String icon;

  Weather(this.id, this.main, this.description, this.icon);

  factory Weather.fromJson(Map<String, dynamic> map) {
    return Weather(
      map["id"] ?? 0,
      map["main"] ?? "",
      map["description"] ?? "",
      map["icon"] ?? "",
    );
  }
}

class Clouds {
  int all;

  Clouds(this.all);

  Clouds.fromJson(Map<String, dynamic> map) : all = map["all"] ?? 0;
}

class Wind {
  double speed;
  double deg;

  Wind(this.speed, this.deg);

  Wind.fromJson(Map<String, dynamic> map)
      : speed = (map["speed"] ?? 0).toDouble(),
        deg = (map["deg"] ?? 0).toDouble();
}
