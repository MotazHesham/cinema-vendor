import 'package:flutter/material.dart';

class Movie {
  final String id;
  final category;
  final String cover;
  final String thumbnail;
  final String title;
  final String description;
  final bool isTicketAvailable;
  final double rateing;

  const Movie({
    @required this.id,
    @required this.category,
    @required this.cover,
    @required this.thumbnail,
    @required this.title,
    @required this.description,
    @required this.isTicketAvailable,
    @required this.rateing,
  });
}
