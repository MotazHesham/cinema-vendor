import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

enum MovieCategory {
  Action,
  Comedy,
  Thrilling,
}

class Category {
  final id;
  final String label;
  final MovieCategory value;
  final Color color;

  const Category({
    this.id,
    this.label,
    this.value,
    this.color,
  });
  static const List categoriesMap2 = [
    Category(
      id: 1,
      label: 'Action',
      value: MovieCategory.Action,
      color: Colors.deepPurple,
    ),
    Category(
      id: 2,
      label: 'Comedy',
      value: MovieCategory.Comedy,
      color: Colors.amber,
    ),
    Category(
      id: 3,
      label: 'Thrilling',
      value: MovieCategory.Thrilling,
      color: Colors.greenAccent,
    ),
  ];
}

final categoriesMap = [
  Category(
    id: 1,
    label: 'Action',
    value: MovieCategory.Action,
    color: HexColor("#3A5A81"),
  ),
  Category(
    id: 2,
    label: 'Comedy',
    value: MovieCategory.Comedy,
    color: HexColor("#D31336"),
  ),
  Category(
    id: 3,
    label: 'Thrilling',
    value: MovieCategory.Thrilling,
    color: HexColor("#252131"),
  ),
];
