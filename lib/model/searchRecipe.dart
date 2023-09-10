import 'package:el_easy_meal/model/ingredient.dart';
import 'package:el_easy_meal/model/missedingredient.dart';

enum RecipeType {
  food,
  drink,
}

class SearchRecipe {

  final int id;
  final String title;
  final String image;
  final List<MissedIngredient> missedIngredients;

  SearchRecipe({this.id, this.image, this.title, this.missedIngredients});

  factory SearchRecipe.fromMap(Map<String, dynamic> json) {
    var list = json['missedIngredients'] as List;
    List<MissedIngredient> missedIngredientsList = list.map((i) => MissedIngredient.fromMap(i)).toList();

    return SearchRecipe(
        id: json["id"],
        title: json["title"],
        image: json["image"],
        missedIngredients: missedIngredientsList,
    );
  }
}