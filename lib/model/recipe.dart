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
      "instructions": instructions,
      "ingredients": ingredients,
      "image":image
    };
  }

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json["id"] as int,
      name: json["name"] as String,
      instructions: List<String>.from(json["instructions"] as List),
      ingredients: List<String>.from(json["ingredients"] as List),
      image: json["image"]as String
    );
  }
}
