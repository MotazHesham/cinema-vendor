import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Booking {
  final String movieId;
  final seats;

  const Booking({
    @required this.movieId,
    @required this.seats,
  });
}

class Bookings with ChangeNotifier {
  List<Booking> _bookings = [];

  List<Booking> get bookings {
    return [..._bookings];
  }

  Booking findById(String movieId) {
    return _bookings.firstWhere((movie) => movie.movieId == movieId);
  }

  Future<void> fetchBookings() async {
    final url =
        'https://e-commerce-94adb-default-rtdb.firebaseio.com/movieSlots.json';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;

      if (extractedData.isEmpty) {
        return;
      }
      final List<Booking> loadedBookings = [];
      extractedData.forEach((movieId, movieData) {
        loadedBookings.add(
          Booking(
            movieId: movieId,
            seats: movieData[0]['screen']['bookedSeats'],
          ),
        );
      });
      _bookings = loadedBookings;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
