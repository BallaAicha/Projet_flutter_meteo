import 'package:flutter/material.dart';
import 'package:projet_mame_diarra_flutter/pages/home.dart';
import 'package:projet_mame_diarra_flutter/pages/meteo.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/home': (context) => HomePage(),
        '/meteo': (context) => MeteoPage(),
      },
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        backgroundColor: Colors.blue.shade900,
      ),
      initialRoute: '/home',
      // home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
