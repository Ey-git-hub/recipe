import 'package:flutter/material.dart';
import 'package:recipe/model/recipe.dart';

class RecipesDetailsScreen extends StatelessWidget{
  const RecipesDetailsScreen({super.key, required this.recipe});
  final Recipe recipe;
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text(recipe.name),),);
  }

}