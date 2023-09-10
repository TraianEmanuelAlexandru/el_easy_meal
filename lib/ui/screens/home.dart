import 'dart:convert';
import 'dart:io';
import 'dart:core';
import 'package:el_easy_meal/model/recipeByName.dart';
import 'package:el_easy_meal/model/searchRecipe.dart';
import 'package:el_easy_meal/services/favorites_api.dart';
import 'package:el_easy_meal/ui/widgets/search_recipe_card.dart';
import 'package:el_easy_meal/ui/widgets/recipe_by_name_card.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'package:el_easy_meal/services/recipes_api.dart';
import 'package:el_easy_meal/ui/widgets/recipe_card.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:el_easy_meal/model/recipe.dart';
import 'package:el_easy_meal/utils/store.dart';
import 'package:shared_preferences/shared_preferences.dart';


class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new HomeScreenState();
}


class HomeScreenState extends State<HomeScreen> {

  List<Recipe> favRecipes = [];
  List<Recipe> recipes = [];
  List<RecipeByName> recipesByName = [];
  TextEditingController textEditingController = new TextEditingController();
  TextEditingController textEditingController2 = new TextEditingController();
  List<SearchRecipe> searchRecipes = [];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    fetchRecipes();//---------------------------Da scommentare
    setList();
  }




  List<String> userFavorites = getFavoritesIDs(); //---------------- Da scommentare

 /* void _handleFavoritesListChanged(String recipeID) { ---------------------- Da scommentare
    // Set new state and refresh the widget:
    setState(() {
      if (userFavorites.contains(recipeID)) {
        userFavorites.remove(recipeID);
      } else {
        userFavorites.add(recipeID.toString());
      }
    });
  }*/


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
      print(favRecipes);
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
      print(favRecipes);
    }
 }



  @override
  Widget build(BuildContext context) {
    Column _buildRecipes(List<Recipe> recipesList,
        List<RecipeByName> recipeListByName) {
      return Column(
        children: <Widget>[
          SizedBox(height: 40.0),
          SizedBox(height: 40.0),
          Text(
            "What will you cook today?",
            style: TextStyle(
                fontSize: 20,
                color: Theme
                    .of(context)
                    .indicatorColor,
                fontWeight: FontWeight.w400,
                fontFamily: 'Overpass'),
          ),
          Text(
            "Just enter the recipe name you are searching for",
            style: TextStyle(
                fontSize: 15,
                color: Theme
                    .of(context)
                    .indicatorColor,
                fontWeight: FontWeight.w300,
                fontFamily: 'OverpassRegular'),
          ),
          SizedBox(height: 40.0),
          Container(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: textEditingController2,
                    onChanged: (text) {recipesByName.clear();},
                    style: TextStyle(
                        fontSize: 16,
                        color: Theme
                            .of(context)
                            .indicatorColor,
                        fontFamily: 'Overpass'),
                    decoration: InputDecoration(
                      hintText: "Enter Ingridients",
                      hintStyle: TextStyle(
                          fontSize: 16,
                          color: Theme
                              .of(context)
                              .indicatorColor
                              .withOpacity(0.5),
                          fontFamily: 'Merriweather'),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 16,
                ),
                InkWell(
                    onTap: () async {
                      if (textEditingController2.text.isNotEmpty) {
                        setState(() {
                          _loading = true;
                        });
                        String url =
                            "https://api.spoonacular.com/recipes/search?query=${textEditingController2
                            .text}&number=2&instructionsRequired=true&apiKey=e113f9009c4b4752b855a0239efc1e35";
                        var response = await http.get(Uri.parse(url));
                        final body = response.body;
                        final json = jsonDecode(body);
                        final results = json["results"] as List<dynamic>;

                        results.forEach((element) {
                          print(element.toString());
                          RecipeByName recipeModel = new RecipeByName();
                          recipeModel =
                              RecipeByName.fromMap(element);
                          recipesByName.add(recipeModel);
                        });
                        setState(() {
                          _loading = false;
                          recipesList.clear();
                        });
                        print("doing it");
                      } else {
                        setState(() {
                          recipesByName.clear();
                          fetchRecipes();
                        });
                        print("not doing it");
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          gradient: LinearGradient(
                              colors: [
                                const Color(0xffA2834D),
                                const Color(0xffBC9A5F)
                              ],
                              begin: FractionalOffset.topRight,
                              end: FractionalOffset.bottomLeft)),
                      padding: EdgeInsets.all(20),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(
                              Icons.search,
                              size: 18,
                              color: Colors.white
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          ),
          SizedBox(height: 30),
          if (recipesByName.isNotEmpty) Expanded(
            child: ListView.builder(
              itemCount: recipesByName.length,
              itemBuilder: (BuildContext context, int index) {
                return new RecipeCardByName(
                  recipeByName: recipeListByName[index],
                  inFavorites: userFavorites.contains(
                      recipeListByName[index].id),
                  onFavoriteButtonPressed: _preferred, //_handleFavoritesListChanged
                );
              },
            ),
          ) else
            Expanded(
              child: ListView.builder(
                itemCount: recipesList.length,
                itemBuilder: (BuildContext context, int index) {
                  return new RecipeCard(
                    recipe: recipesList[index],
                    inFavorites: userFavorites.contains(recipesList[index].id),
                    onFavoriteButtonPressed: _preferred, //_handleFavoritesListChanged
                  );
                },
              ),
            ),
        ],
      );
    }


    Scaffold _buildSearchList() {
      return Scaffold(
        body: Stack(
          children: <Widget>[
            Container(
              height: MediaQuery
                  .of(context)
                  .size
                  .height,
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              decoration: BoxDecoration(
                color: Theme
                    .of(context)
                    .scaffoldBackgroundColor,
              ),
            ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(
                    vertical: !kIsWeb ? Platform.isIOS ? 60 : 30 : 30,
                    horizontal: 24),
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 20.0),
                    Text(
                      "What will you cook today?",
                      style: TextStyle(
                          fontSize: 20,
                          color: Theme
                              .of(context)
                              .indicatorColor,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Overpass'),
                    ),
                    Text(
                      "Just Enter Ingredients you have, separated by a comma, and we will show the best recipe for you",
                      style: TextStyle(
                          fontSize: 15,
                          color: Theme
                              .of(context)
                              .indicatorColor,
                          fontWeight: FontWeight.w300,
                          fontFamily: 'OverpassRegular'),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Container(
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: TextField(
                              controller: textEditingController,
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Theme
                                      .of(context)
                                      .indicatorColor,
                                  fontFamily: 'Overpass'),
                              decoration: InputDecoration(
                                hintText: "Enter Ingridients",
                                hintStyle: TextStyle(
                                    fontSize: 16,
                                    color: Theme
                                        .of(context)
                                        .indicatorColor
                                        .withOpacity(0.5),
                                    fontFamily: 'Merriweather'),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 16,
                          ),
                          InkWell(
                              onTap: () async {
                                if (textEditingController.text.isNotEmpty) {
                                  setState(() {
                                    _loading = true;
                                  });
                                  searchRecipes = new List();
                                  String url =
                                      "https://api.spoonacular.com/recipes/findByIngredients?ingredients=${textEditingController
                                      .text}&number=2&instructionsRequired=true&apiKey=2dd4ee0aa3394adf82d183eac1136543";
                                  var response = await http.get(Uri.parse(url));
                                  final body = response.body;
                                  final json = jsonDecode(body);
                                  final results = json as List<dynamic>;

                                  results.forEach((element) {
                                    SearchRecipe recipeModel = new SearchRecipe();
                                    recipeModel =
                                        SearchRecipe.fromMap(element);
                                    searchRecipes.add(recipeModel);
                                    print("$searchRecipes");
                                  });
                                  setState(() {
                                    _loading = false;
                                  });
                                  print("doing it");
                                } else {
                                  print("not doing it");
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    gradient: LinearGradient(
                                        colors: [
                                          const Color(0xffA2834D),
                                          const Color(0xffBC9A5F)
                                        ],
                                        begin: FractionalOffset.topRight,
                                        end: FractionalOffset.bottomLeft)),
                                padding: EdgeInsets.all(20),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Icon(
                                        Icons.search,
                                        size: 18,
                                        color: Colors.white
                                    ),
                                  ],
                                ),
                              )),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      children: [
                        Container(
                          child: Column(
                              children: List.generate(
                                  searchRecipes.length, (index) {
                                return Container(
                                  height: 600,
                                  width: 800,
                                  child: new SearchRecipeCard(
                                    searchRecipe: searchRecipes[index],
                                    inFavorites: userFavorites.contains(
                                        searchRecipes[index].id),
                                    onFavoriteButtonPressed: _preferred, //_handleFavoritesListChanged
                                  ),
                                );
                              })
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      );
    }

    Column _buildFavorites(List<Recipe> recipesList){
      return Column(
        children: <Widget>[
          SizedBox(height: 40.0),
          Text(
            "Favorites",
            style: TextStyle(
                fontSize: 20,
                color: Theme
                    .of(context)
                    .indicatorColor,
                fontWeight: FontWeight.w400,
                fontFamily: 'Overpass'),
          ),
          Text(
            "Here is your favorites list",
            style: TextStyle(
                fontSize: 15,
                color: Theme
                    .of(context)
                    .indicatorColor,
                fontWeight: FontWeight.w300,
                fontFamily: 'OverpassRegular'),
          ),
          SizedBox(height: 40.0),
          Container(
            child: Row(
              children: <Widget>[

                SizedBox(
                  width: 16,
                ),
              ],
            ),
          ),
          SizedBox(height: 30),
          Expanded(
              child: ListView.builder(
                itemCount: recipesList.length,
                itemBuilder: (BuildContext context, int index) {
                  return new RecipeCard(
                    recipe: recipesList[index],
                    inFavorites: userFavorites.contains(recipesList[index].id),
                    onFavoriteButtonPressed: _preferred, //_handleFavoritesListChanged
                  );
                },
              ),
            ),
        ],
      );
    }


    const double _iconSize = 20.0;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: PreferredSize(
          // We set Size equal to passed height (50.0) and infinite width:
          preferredSize: Size.fromHeight(50.0),
          child: AppBar(
            elevation: 2.0,
            bottom: TabBar(
              labelColor: Theme
                  .of(context)
                  .indicatorColor,
              tabs: [
                Tab(icon: Icon(Icons.restaurant, size: _iconSize)),
                Tab(icon: Icon(Icons.search, size: _iconSize)),
                Tab(icon: Icon(Icons.favorite, size: _iconSize)),
              ],
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(5.0),
          child: TabBarView(
            // Replace placeholders:
            children: [
              // Display recipes of type food:
              _buildRecipes(recipes, recipesByName

              ),
              // Display recipes of type drink:
              _buildSearchList(

              ),
              // Display favorite recipes:
              _buildFavorites(favRecipes),//Center(child: Text("Bla"))

            ],
          ),
        ),

      ),
    );
  }

  Future<void> fetchRecipes() async {
    final response = await RecipesApi.fetchRecipes();
    setState(() {
      recipes = response;
    });
  }

  Future<void> setList() async{
   final response2 = await FavoritesApi.setList();
   setState(() {
     favRecipes = response2;
   });
  }

  void Clear() {
    fetchRecipes();
    setState(() {
      recipesByName.clear();
    });
  }
}
