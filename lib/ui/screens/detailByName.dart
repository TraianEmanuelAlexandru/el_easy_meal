import 'package:el_easy_meal/services/favorites_api.dart';
import 'package:flutter/foundation.dart';
import 'package:el_easy_meal/model/ingredient.dart';
import 'package:el_easy_meal/model/recipe.dart';
import 'package:el_easy_meal/model/recipeByName.dart';
import 'package:el_easy_meal/ui/widgets/recipe_image.dart';
import 'package:el_easy_meal/ui/widgets/recipe_title.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class DetailScreenByName extends StatefulWidget {
  final RecipeByName recipeByName;
  final bool inFavorites;

  DetailScreenByName(this.recipeByName, this.inFavorites);

  @override
  _DetailScreenByNameState createState() => _DetailScreenByNameState();
}

class _DetailScreenByNameState extends State<DetailScreenByName>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  ScrollController _scrollController;
  bool _inFavorites;
  Recipe recipe;
  List<Recipe> favRecipes = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
    _scrollController = ScrollController();
    _inFavorites = widget.inFavorites;
    setList();

  }

  @override
  void dispose() {
    // "Unmount" the controllers:
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _toggleInFavorites() {
    setState(() {
      _inFavorites = !_inFavorites;
    });
  }

  @override
  Widget build(BuildContext context) {
    setRecipe(widget.recipeByName);
    return Scaffold(
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (BuildContext context, bool innerViewIsScrolled) {
          return <Widget>[
            SliverAppBar(
              backgroundColor: Colors.white,
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.pin,
                background: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    RecipeImage(recipe.image),
                    RecipeTitle(recipe, 20.0),
                  ],
                ),
              ),
              expandedHeight: 690.0,
              pinned: true,
              floating: true,
              elevation: 2.0,
              forceElevated: innerViewIsScrolled,
              bottom: TabBar(
                labelColor: Theme.of(context).indicatorColor,
                tabs: <Widget>[
                  Tab(text: "Home"),
                  Tab(text: "Preparation"),
                ],
                controller: _tabController,
              ),
            )
          ];
        },
        body: TabBarView(
          children: <Widget>[
            IngredientsView(recipe.ingredients),
            PreparationView(recipe.instruction),
          ],
          controller: _tabController,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _preferred(recipe.id.toString()),
        child: Icon(Icons.favorite),
        elevation: 2.0,
        focusColor: Theme.of(context).buttonColor,
        shape: CircleBorder(),
      ),
    );
  }

  Future<void> setRecipe(RecipeByName recipeByName) async {
    final a = recipeByName;
    final response = await getRecipe(a);
    setState(() {
      recipe = response;
    });
  }

  Future<Recipe> getRecipe(final RecipeByName recipeByName) async {
    final url = "https://api.spoonacular.com/recipes/${recipeByName.id}/information?apiKey=59528fa933464ad4a5eb212e6ea3973d";
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
    return recipe;
  }



  void _preferred(String id) async {
    final pref = await SharedPreferences.getInstance();
    if (!pref.containsKey(id)){
      await pref.setString(id, id);
      Fluttertoast.showToast(
          msg: "Aggiunto ai preferiti",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.blueAccent,
          textColor: Colors.white,
          fontSize: 16.0
      );
      setState(() {
        setList();
      });
    }
    else {
      await pref.remove(id);
      Fluttertoast.showToast(
          msg: "Rimosso dai preferiti",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.blueAccent,
          textColor: Colors.white,
          fontSize: 16.0
      );
      setState(() {
        setList();
      });
    }
  }

  Future<void> setList() async{
    final response2 = await FavoritesApi.setList();
    setState(() {
      favRecipes = response2;
    });
  }
}


class IngredientsView extends StatelessWidget {
  final List<Ingredient> ingredients;

  IngredientsView(this.ingredients);

  @override
  Widget build(BuildContext context) {
    List<Widget> children = new List<Widget>();
    ingredients.forEach((item) {
      children.add(
        new Row(
          children: <Widget>[
            new Icon(Icons.arrow_right),
            new SizedBox(width: 5.0),
            new Text(item.name),
          ],
        ),
      );
      // Add spacing between the lines:
      children.add(
        new SizedBox(
          height: 5.0,
        ),
      );
    });
    return ListView(
      padding: EdgeInsets.fromLTRB(25.0, 25.0, 25.0, 75.0),
      children: children,
    );
  }
}

class PreparationView extends StatelessWidget {

  final String preparationSteps;

  PreparationView(this.preparationSteps);

  @override
  Widget build(BuildContext context) {
    List<Widget> textElements = List<Widget>();

    textElements.add(
      Text(preparationSteps),
    );
    // Add spacing between the lines:
    textElements.add(
      SizedBox(
        height: 10.0,
      ),
    );

    return ListView(
      padding: EdgeInsets.fromLTRB(25.0, 25.0, 25.0, 75.0),
      children: textElements,
    );
  }

}

//c957b6816ba048139fbc25a67d2cff33           e113f9009c4b4752b855a0239efc1e35


