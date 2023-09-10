import 'package:el_easy_meal/model/ingredient.dart';

enum RecipeType {
  food,
  drink,
}

class Recipe {

  final int id;
  final String title;
  final String image;
  final int duration;
  final List<Ingredient> ingredients;
  final String instruction;

  Recipe({this.duration, this.id, this.image, this.title, this.ingredients, this.instruction});

  factory Recipe.fromMap(Map<String, dynamic> json) {

    var list = json['extendedIngredients'] as List;
    List<Ingredient> ingredientList = list.map((i) => Ingredient.fromMap(i)).toList();

    return Recipe(
        id: json["id"],
        title: json["title"],
        image: json["image"],
        duration: json["readyInMinutes"],
        ingredients: ingredientList,
        instruction: json["instructions"]

    );
  }
}