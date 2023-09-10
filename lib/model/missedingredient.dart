import 'package:flutter/services.dart';

class MissedIngredient {

  final int id;
  final double amount;
  final String name;
  final String unit;
  final String aisle;

  MissedIngredient({this.name, this.unit, this.amount, this.aisle, this.id});

  factory MissedIngredient.fromMap(Map<String, dynamic> json){
    return MissedIngredient(
        id: json["id"],
        amount: json["amount"],
        name: json["name"],
        aisle: json["aisle"],
        unit: json["unit"]
    );
  }
}

