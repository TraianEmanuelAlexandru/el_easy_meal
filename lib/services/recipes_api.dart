import 'package:el_easy_meal/model/recipe.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class RecipesApi {

  static Future<List<Recipe>> fetchRecipes() async {
    const url = "https://api.spoonacular.com/recipes/random?number=9&instructionsRequired=true&apiKey=e113f9009c4b4752b855a0239efc1e35";
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final body = response.body;
    final json = jsonDecode(body);
    final results = json["recipes"] as List<dynamic>;
    final recipes = results.map((e) {
      return Recipe.fromMap(e);
    }).toList();
    return recipes;
  }

}