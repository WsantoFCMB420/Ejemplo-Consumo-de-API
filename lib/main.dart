import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Clima App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const ClimaScreen(),
    );
  }
}

class ClimaScreen extends StatefulWidget {
  const ClimaScreen({super.key});

  @override
  State<ClimaScreen> createState() => _ClimaScreenState();
}

class _ClimaScreenState extends State<ClimaScreen> {
  String ciudad = "Ubaté";
  String descripcion = "";
  double temperatura = 0;
  int humedad = 0;
  bool cargando = true;

  // 👇 Pega tu API KEY aquí
  final String apiKey = "38f9694b1fb4d9e4cd22d928bda34d69";

  @override
  void initState() {
    super.initState();
    obtenerClima();
  }

  Future<void> obtenerClima() async {
    final url = Uri.parse(
      "https://api.openweathermap.org/data/2.5/weather?q=$ciudad&appid=$apiKey&lang=es&units=metric",
    );

    try {
      final respuesta = await http.get(url);

      if (respuesta.statusCode == 200) {
        final datos = jsonDecode(respuesta.body);

        setState(() {
          descripcion = datos["weather"][0]["description"];
          temperatura = datos["main"]["temp"].toDouble();
          humedad = datos["main"]["humidity"].toInt();
          cargando = false;
        });
      } else {
        setState(() {
          descripcion = "Error al obtener el clima";
          cargando = false;
        });
      }
    } catch (e) {
      setState(() {
        descripcion = "Error de conexión";
        cargando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Clima en $ciudad"), centerTitle: true),
      body: Center(
        child: cargando
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Ciudad: $ciudad",
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Temperatura: $temperatura °C",
                    style: const TextStyle(fontSize: 20),
                  ),
                  Text(
                    "Humedad: $humedad%",
                    style: const TextStyle(fontSize: 20),
                  ),
                  Text(
                    "Descripción: $descripcion",
                    style: const TextStyle(
                      fontSize: 20,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: obtenerClima,
                    child: const Text("Actualizar"),
                  ),
                ],
              ),
      ),
    );
  }
}


// Ejemplo de respuesta JSON de la API de OpenWeatherMap

/**Respuesta JSON:{
  "lat": 5.30933,
  "lon": -73.81575,
  "timezone": "America/Ciudad_Ubate",
  "current": {
    "temp": 17.2,
    "humidity": 80,
    "weather": [
      { "description": "cielo parcialmente nublado" }
    ]
  }
}**/