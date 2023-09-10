
import 'package:el_easy_meal/model/ingredient.dart';
import 'package:el_easy_meal/model/recipe.dart';
import 'package:el_easy_meal/services/favorites_api.dart';
import 'package:el_easy_meal/ui/screens/home.dart';
import 'package:el_easy_meal/ui/widgets/recipe_image.dart';
import 'package:el_easy_meal/ui/widgets/recipe_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailScreen extends StatefulWidget {
  final Recipe recipe;
  final bool inFavorites;

  DetailScreen(this.recipe, this.inFavorites);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  ScrollController _scrollController;
  bool _inFavorites;
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
                    RecipeImage(widget.recipe.image),
                    RecipeTitle(widget.recipe, 20.0),
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
            IngredientsView(widget.recipe.ingredients),
            PreparationView(widget.recipe.instruction),
          ],
          controller: _tabController,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _preferred(widget.recipe.id.toString()),
        child: Icon(Icons.favorite),
        elevation: 2.0,
        focusColor: Theme.of(context).buttonColor,
        shape: CircleBorder(),
      ),
    );
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

