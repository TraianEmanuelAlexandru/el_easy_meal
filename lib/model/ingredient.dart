class Ingredient{
  final int id;
  final double amount;
  final String name;
  final String consistency;
  final String unit;

  Ingredient({this.consistency, this.amount, this.name, this.unit, this.id});

  factory Ingredient.fromMap(Map<String, dynamic> json){
    return Ingredient(

        id: json["id"],
        amount: json["amount"],
        name: json["name"],
        consistency: json["consistency"],
        unit: json["unit"]
    );
  }
}