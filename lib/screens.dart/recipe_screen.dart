import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe/provider/recipe_provider.dart';

class RecipeScreen extends ConsumerWidget {
  const RecipeScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipeState = ref.watch(recipeNotifierProvider);
    return Scaffold(
      appBar: AppBar(),
      body: recipeState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text(error.toString())),
        data: (recipes) => GridView.builder(
          itemCount: recipes.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.8,
          ),
          itemBuilder: (context, index) {
            final recipe = recipes[index];
            return Card(
              elevation: 3,
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.food_bank, size: 50, color: Colors.orange),
                    const SizedBox(height: 10),
                    Text(
                      recipe.name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      maxLines: 2, // ስሙ በጣም ረጅም ከሆነ እንዳይበላሽ
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
