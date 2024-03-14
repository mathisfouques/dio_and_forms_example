import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class DioPage extends StatelessWidget {
  const DioPage({super.key});

  Dio get dio {
    final dio = Dio();

    // Ajout d'un Interceptor
    dio.interceptors.add(InterceptorsWrapper(
      // Intercepte les requêtes
      onRequest: (options, handler) {
        // Ajout d'un token d'authentification à l'en-tête
        options.headers["Authorization"] =
            "Bearer votre_token_d'authentification";
        print('Envoi de la requête : ${options.path}');

        return handler.next(options); // Continue la requête
      },
      // Intercepte les réponses
      onResponse: (response, handler) {
        // Vous pouvez modifier la réponse ici
        print('Réponse reçue : ${response.statusCode}');
        return handler.next(response); // Continue la réponse
      },
      // Intercepte les erreurs
      onError: (DioError e, handler) async {
        // Gestion des erreurs
        print('Erreur : ${e.message}');

        return handler.next(e); // Continue l'erreur
      },
    ));

    return dio;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dio Page'),
      ),
      body: Center(
        child: TextButton(
          onPressed: () async {
            try {
              final response =
                  await dio.get('https://jsonplaceholder.typicode.com/posts/1');
              print('Données de la réponse : ${response.data}');
            } on DioError catch (e) {
              print('DioError capturé : ${e.message}');
              if (e.response != null) {
                print("Données d'erreur : ${e.response!.data}");
                print("Code d'erreur HTTP : ${e.response!.statusCode}");
              } else {
                print('Erreur lors de l\'envoi de la requête');
              }
            }
          },
          child: const Text("Envoi requête test"),
        ),
      ),
    );
  }
}
