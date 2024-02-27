import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import '../model/api_response.dart';
import 'package:http/http.dart' as http;
import '../services/api_service.dart';
import 'detail_meteo.dart';

class MeteoPage extends StatefulWidget {
  @override
  State<MeteoPage> createState() => _MeteoPageState();
}

class _MeteoPageState extends State<MeteoPage>
    // pour que le controller soit capable de fournir des ticks à l'animation
    with
        SingleTickerProviderStateMixin {
  late AnimationController
      controller; // Contrôleur d'animation pour la barre de progression
  List<APIResponse?>? apiResponse; // Liste des réponses API pour chaque ville

  int progressCounter =
      0; // Compteur de progression pour la barre de progression
  List<String> loadingMessages = [
    //une liste de messages de chargement qui seront affichés à tour de rôle pendant le chargement
    'Nous téléchargeons les données',
    'C\'est presque fini',
    'Plus que quelques secondes avant le résultat'
  ];
  int messageIndex = 0; // Index du message de chargement actuellement affiché

  bool _isRefreshing =
      false; // Indique si les données sont en cours de rafraîchissement cad si on est en train de télécharger les données

  //cette methode initState est appelée une seule fois lors de la création de l'objet
  @override
  void initState() {
    super.initState();

    // Initialisation du contrôleur d'animation pour la barre de progression
    controller = AnimationController(
      vsync: this,
      // `vsync` indique que le contrôleur d'animation doit recevoir des ticks (signaux de mise à jour) de cette instance de _MeteoPageState
      // Cela permet de synchroniser l'animation avec le taux de rafraîchissement de l'écran pour une mise à jour fluide de l'interface utilisateur
      // `this` fait référence à l'instance de _MeteoPageState qui est un objet de type SingleTickerProviderStateMixin
      duration: const Duration(
          seconds: 60), // durée de l'animation de la barre de progression
    )..addListener(() {
        // Ajout d'un listener pour mettre à jour le compteur de progression à chaque tick de l'animation
        setState(() {
          // Mise à jour de l'interface utilisateur lorsqu'un tick de l'animation se produit
          progressCounter = (controller.value * 100)
              .round(); // mise à jour du compteur de progression  * 100 pour avoir un pourcentage
        });
      });
    controller.repeat(
        reverse:
            true); // pour que l'animation de la barre de progression se répète en boucle

    // Mise en place de la récupération périodique des données météo
    Timer.periodic(Duration(seconds: 10), (Timer timer) async {
      // Utilisation de la classe Timer pour déclencher périodiquement une action
      // Dans ce cas, toutes les 10 secondes, on vérifie si la récupération de données est en cours
      if (!_isRefreshing) {
        // Si aucune récupération de données n'est actuellement en cours, on lance la récupération
        await _fetchWeatherForCities();
      }
    });

    // Mise en place de la rotation des messages de chargement
    Timer.periodic(Duration(seconds: 6), (Timer timer) {
      // Utilisation d'un autre Timer pour faire défiler périodiquement les messages de chargement
      // Toutes les 6 secondes, on met à jour l'index du message pour changer le message affiché
      setState(() {
        messageIndex = (messageIndex + 1) % loadingMessages.length;
        // L'opérateur % permet de revenir au début de la liste si on atteint la fin
      });
    });
  }

  @override
  void dispose() {
    // pour libérer les ressources utilisées par le contrôleur d'animation
    controller.dispose();
    super.dispose();
  }

  // Fonction pour récupérer les données météo pour les villes
  Future<void> _fetchWeatherForCities() async {
    setState(() {
      _isRefreshing =
          true; // on indique que les données sont en cours de rafraîchissement pour que l'interface utilisateur puisse afficher un indicateur de progression
      apiResponse =
          null; // on réinitialise la liste des réponses API car on va la remplir avec les nouvelles données
    });
    // Initialisation d'une liste de réponses API avec des valeurs nulles
    List<APIResponse?> responses =
        List.generate(ApiService.cities.length, (index) => null);

    // Simulation d'un appel API avec un délai
    await Future.delayed(Duration(seconds: 3));

    for (int i = 0; i < ApiService.cities.length; i++) {
      final String city = ApiService.cities[i];
      final response = await http.get(
        Uri.parse(
            '${ApiService.apiUrl}?q=$city&appid=${ApiService.apiKey}&units=metric'),
      );

      if (response.statusCode == 200) {
        // // Si la requête API réussit (statut 200), on traite la réponse

        final APIResponse apiResponse =
            APIResponse.fromJson(json.decode(response.body), city);
        responses[i] =
            apiResponse; // On remplit la liste des réponses avec les nouvelles données
      } else {
        print(
            'Échec de la récupération des données météo pour $city. Code de statut: ${response.statusCode}');
      }
    }

    setState(() {
      // Mise à jour de la liste des réponses avec les nouvelles données
      apiResponse = responses;
      _isRefreshing = false;
      // On indique que le rafraîchissement des données est terminé
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade900,
      appBar: AppBar(
        title: const Text('Meteo App'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _isRefreshing ? null : _fetchWeatherForCities,
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.blue.shade900,
                  Colors.blue.shade400,
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(
              top: 45,
              left: 20,
              right: 20,
            ),
            child: Column(
              children: [
                // Titre
                const Text(
                  'Météo actuelle dans vos villes sélectionnées',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                // Barre de progression
                Visibility(
                  visible: _isRefreshing,
                  child: LinearProgressIndicator(
                    minHeight: 20,
                    value: controller.value,
                    semanticsLabel: 'Indicateur de progression linéaire',
                  ),
                ),
                // Messages de chargement ou affichage des données
                _isRefreshing
                    ? Text(
                        loadingMessages[messageIndex],
                        style: const TextStyle(
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                        ),
                      )
                    : Expanded(
                        child: ListView.builder(
                          itemCount: ApiService.cities
                              .length, //on affiche les données pour chaque ville
                          itemBuilder: (context, index) {
                            APIResponse? cityResponse = apiResponse?[index];
                            if (cityResponse != null &&
                                cityResponse.list.isNotEmpty) {
                              Forecast firstForecast = cityResponse.list
                                  .first; // on récupère la première prévision de la liste
                              return ListTile(
                                onTap: () {
                                  // Lorsque l'utilisateur appuie sur une ville, on affiche les détails de la météo
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MeteoDetailsPage(
                                        forecast: firstForecast,
                                      ),
                                    ),
                                  );
                                },
                                title: Text(
                                    style: TextStyle(color: Colors.white),
                                    firstForecast.cityName ?? ''),
                                subtitle: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        style: TextStyle(color: Colors.white),
                                        'Température: ${firstForecast.main.temp}°C',
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        style: TextStyle(color: Colors.white),
                                        'Description: ${firstForecast.weather.first.description}',
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              return const ListTile(
                                title: Text(
                                  style: TextStyle(color: Colors.white),
                                  'Patience, nous récupérons les données...',
                                ),
                              );
                            }
                          },
                        ),
                      ),
                // Bouton de redémarrage après le chargement complet
                Visibility(
                  visible: !_isRefreshing && progressCounter == 100,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        progressCounter =
                            0; //on remet le compteur de progression à 0
                        controller.forward(
                            from:
                                0.0); //on relance l'animation de la barre de progression
                      });
                    },
                    child: Text('Recommencer'),
                  ),
                ),
                // Gestion des erreurs
                Visibility(
                  visible: _isRefreshing && progressCounter == 100,
                  child: const Text(
                    'Échec du chargement des données. Veuillez réessayer plus tard.',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
