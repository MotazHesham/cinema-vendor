import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';

import './bookings.dart';
import '../models/movie.dart';

class Movies with ChangeNotifier {
  List<Movie> _movies = [];

  List<Movie> get movies {
    return [..._movies];
  }

  Future<void> fetchMovies(int categoryId) async {
    final url =
        'https://e-commerce-94adb-default-rtdb.firebaseio.com/movies.json?orderBy="category"&equalTo=$categoryId';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;

      if (extractedData.isEmpty) {
        return;
      }
      final List<Movie> loadedMovies = [];
      extractedData.forEach((movieId, movieData) {
        loadedMovies.add(
          Movie(
            id: movieId,
            category: movieData['category'],
            cover: movieData['cover'],
            description: movieData['description'],
            isTicketAvailable: movieData['isTicketAvailable'],
            rateing: movieData['rateing'],
            thumbnail: movieData['thumbnail'],
            title: movieData['title'],
          ),
        );
      });
      _movies = loadedMovies;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addNewMovie({
    String txTitle,
    String txDescription,
    DateTime chosenDate,
    TimeOfDay chosenTime,
    int categoryId,
    File cover,
  }) async {
    final movieDate = DateFormat('dd/MM/yyyy').format(chosenDate);
    final movieTime = chosenTime.toString().substring(10).replaceAll(')', '');
    final response = await http.post(
      'https://e-commerce-94adb-default-rtdb.firebaseio.com/movies.json',
      body: json.encode({
        "category": categoryId,
        "cover": "url",
        "description": txDescription,
        "isTicketAvailable": true,
        "rateing": 4.9,
        "thumbnail": "url",
        "title": txTitle,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final movieId = json.decode(response.body)['name'];

      //store image in firebase storage and get url
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp();
      final ref = FirebaseStorage.instance
          .ref()
          .child('movies_images')
          .child(movieId + '.jpg');
      await ref.putFile(cover);
      final url = await ref.getDownloadURL();
      await http.patch(
        'https://e-commerce-94adb-default-rtdb.firebaseio.com/movies/$movieId.json',
        body: json.encode({
          "cover": url,
          "thumbnail": url,
        }),
      ); //update movie with image url

      final newMovie = Movie(
        id: movieId,
        category: categoryId,
        cover: url,
        thumbnail: url,
        description: txDescription,
        title: txTitle,
        isTicketAvailable: true,
        rateing: 4.9,
      );
      _movies.add(newMovie);
      notifyListeners();

      //add movie time and date
      await http.patch(
        'https://e-commerce-94adb-default-rtdb.firebaseio.com/movieSlots.json',
        body: json.encode({
          '$movieId': {
            '0': {
              'date': "$movieDate",
              'screen': {
                'bookedSeats': {
                  '0': 5,
                },
                'col': 10,
                'id': 'sc1',
                'row': 10,
                'screenLabel': "Screen 1"
              },
              'timings': "$movieTime",
            }
          },
        }),
      );

      Bookings().fetchBookings();
    }
  }

  Future<void> deleteProduct(String movieId) async {
    final url =
        'https://e-commerce-94adb-default-rtdb.firebaseio.com/movies/$movieId.json';
    final existingProductIndex = _movies.indexWhere((mov) => mov.id == movieId);
    var existingProduct = _movies[existingProductIndex];

    _movies.removeAt(existingProductIndex);
    notifyListeners();

    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      _movies.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product.');
    }

    existingProduct = null;
  }
}
