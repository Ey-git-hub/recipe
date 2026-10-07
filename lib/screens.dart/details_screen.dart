import 'package:flutter/material.dart';
import 'package:recipe/model/recipe.dart';

class RecipesDetailsScreen extends StatelessWidget {
  const RecipesDetailsScreen({super.key, required this.recipe});
  final Recipe recipe;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(recipe.name),
       actions: [
        IconButton(onPressed: (){}, icon: Icon(Icons.heart_broken_outlined))
       ]),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: 'recipe.image-${recipe.image}',
              child: Image.network(
                recipe.image,
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(13),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.name,
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Ingridents:",
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    recipe.ingredients.map((ing) => '=> $ing').join('\n'),
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),

                  const SizedBox(height: 25),
                  const Text(
                    'Instructions:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                  const SizedBox(height: 25),
                  Text(
                    recipe.instructions
                        .asMap()
                        .entries
                        .map((entry) {
                          int idx = entry.key + 1;
                          return '$idx. ${entry.value}';
                        })
                        .join('\n\n'),
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
