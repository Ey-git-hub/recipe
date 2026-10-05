class Recipe{
  Recipe({required this.id, required this.name, required this.instructions, required this.ingredients});
  final int id;
  final String name;
  final List<String> instructions;
  final List<String> ingredients;


  Recipe copyWith(int? id,String? name,List<String>? instructions,List<String>? ingredients){
    return Recipe(
      id: id?? this.id, 
      name: name??this.name, 
      instructions: instructions??this.instructions, 
      ingredients: ingredients??this.ingredients);
  }
  Map<String,dynamic> toJson( ){
  return {
"id":id,
"name":name,
"instructions":instructions,
"ingredients":ingredients
  };
}
factory Recipe.fromJson(Map<String,dynamic> json){
return Recipe(
  id:json["id"] as int, 
  name: json["name"] as String,
  instructions: List<String>.from(json["instructions"] as List),
  ingredients: List<String>.from(json["ingredients"] as List)
  );
}
}



