class RecipeByName{

  final int id;
  final String title;
  final String image;
  final int duration;

  RecipeByName({this.duration, this.id, this.image, this.title});

  factory RecipeByName.fromMap(Map<String, dynamic> json) {
    return RecipeByName(

        id: json["id"],
        title: json["title"],
        image: "https://spoonacular.com/recipeImages/" + json["image"],
        duration: json["readyInMinutes"],

    );
  }
}