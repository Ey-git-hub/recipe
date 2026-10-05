import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe/provider/recipe_provider.dart';
import 'package:recipe/screens.dart/details_screen.dart';

class RecipeScreen extends ConsumerWidget {
  const RecipeScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipeState = ref.watch(filteredRecipesProvider);
    return Scaffold(
      appBar: AppBar(title: Text("Delicious food recipes")),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.orange),
              child: Text(
                "Food Filter",
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
            ),
            Consumer(
              builder: ((context, ref, child) {
                final islactosFree = ref.watch(lactoseFreeFilterProvider);
                return SwitchListTile(
                  title: Text("lactos free"),
                  value: islactosFree,
                  onChanged: (value) {
                    ref.read(lactoseFreeFilterProvider.notifier).state = value;
                  },
                );
              }),
            ),
            Consumer(
              builder: ((context, ref, child) {
                final isglutenFree = ref.watch(glutenFreeFilterProvider);
                return SwitchListTile(
                  title: Text("Gluten free"),
                  value: isglutenFree,
                  onChanged: (value) {
                    ref.read(glutenFreeFilterProvider.notifier).state = value;
                  },
                );
              }),
            ),
          ],
        ),
      ),
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
            return GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>RecipesDetailsScreen(recipe: recipe,)));
              },
              child: Card(
                elevation: 3,
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          recipe.image,
                          height: 100,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
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
              ),
            );
          },
        ),
      ),
    );
  }
}
