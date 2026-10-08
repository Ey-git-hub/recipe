import 'dart:convert';

class Recipe {
  Recipe({
    required this.id,
    required this.name,
    required this.instructions,
    required this.ingredients, required this.image,
  });
  final int id;
  final String name;
  final List<String> instructions;
  final List<String> ingredients;
  final String image;

  Recipe copyWith(
    int? id,
    String? name,
    List<String>? instructions,
    List<String>? ingredients,
    String? image
  ) {
    return Recipe(
      id: id ?? this.id,
      name: name ?? this.name,
      instructions: instructions ?? this.instructions,
      ingredients: ingredients ?? this.ingredients,
      image: image??this.image
    );
  }

 Map<String, dynamic> toJson() {
  return {
    "id": id,
    "name": name,
    "image": image,
    "instructions": jsonEncode(instructions), 
    "ingredients": jsonEncode(ingredients),
  };
}


 factory Recipe.fromJson(Map<String, dynamic> json) {
  return Recipe(
    id: json["id"] as int,
    name: json["name"] as String,
    image: json["image"] as String,
    instructions: json["instructions"] is String 
        ? List<String>.from(jsonDecode(json["instructions"]))
        : List<String>.from(json["instructions"] as List),
    ingredients: json["ingredients"] is String 
        ? List<String>.from(jsonDecode(json["ingredients"]))
        : List<String>.from(json["ingredients"] as List),
  );
}

  }

