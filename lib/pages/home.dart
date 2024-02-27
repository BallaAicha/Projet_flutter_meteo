import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade900,
      body: SafeArea(
        child: Stack(
          children: [
            // Dégradé de fond
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
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: const Text(
                      'Metéo App Mame Diarra',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  // Image du héros
                  SizedBox(
                    child: Image.asset(
                      'assets/meteoim.png',
                      width: 200,
                      height: 200,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Indicateur de localisation
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(size: 50, Icons.location_on),
                      Text(
                          style: TextStyle(fontSize: 30, color: Colors.white),
                          ' France'),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Message de bienvenue
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: const Text(
                      'Découvrez le temps qu\'il fait partout dans le monde !',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  // Panneau d'accès rapide
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 300, left: 15),
                        child: FloatingActionButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/meteo');
                          },
                          child: const Icon(size: 70, Icons.search),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
