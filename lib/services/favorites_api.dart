import 'package:el_easy_meal/model/ingredient.dart';
import 'package:el_easy_meal/model/recipe.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class FavoritesApi {

 static Future<List<Recipe>> setList() async {
    List<Recipe> listRecipe = [];
    final pref = await SharedPreferences.getInstance();
    final keys = pref.getKeys();
    if (keys.isNotEmpty) {
      for (String key in keys) {
        final url = "https://api.spoonacular.com/recipes/$key/information?apiKey=e113f9009c4b4752b855a0239efc1e35";
        final uri = Uri.parse(url);
        final response = await http.get(uri);
        final body = response.body;
        final json = jsonDecode(body);
        var list = json['extendedIngredients'] as List;
        List<Ingredient> ingredientList = list.map((i) => Ingredient.fromMap(i)).toList();
        final Recipe recipe = new Recipe(
            id: json["id"],
            title: json["title"],
            image: json["image"],
            duration: json["readyInMinutes"],
            ingredients: ingredientList,
            instruction: json["instructions"]
        );
        print(recipe.title);
        listRecipe.add(recipe);
      }
      return listRecipe;
    }
    else {
      //setTitleFail();
      return listRecipe;
    }
  }
}