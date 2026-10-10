import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe/provider/auth_provider.dart';
import 'package:recipe/provider/favorites_provider.dart';
import 'package:recipe/provider/recipe_provider.dart';
import 'package:recipe/screens/details_screen.dart';

class RecipeScreen extends ConsumerWidget {
  const RecipeScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipeState = ref.watch(filteredRecipesProvider);
    final favoritesState = ref.watch(favoriteRecipesNotifier);
    return Scaffold(
      appBar: AppBar(
        title: Text("Delicious food recipes"),
        actions: [
          IconButton(
            onPressed: () {
              ref.read(authNotifierProvider.notifier).logOut();
            },
            icon: Icon(Icons.exit_to_app),
          ),
        ],
      ),
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
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RecipesDetailsScreen(recipe: recipe),
                  ),
                );
              },
              child: Container(
                // ለካርዱ ውብ ጠርዝና ፈዛዛ ጥላ እዚህ ጋር እንሰጠዋለን
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(16), // የዳር ጠርዞቹን በሚገባ ማጠፍ
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05), // በጣም ስስ የሆነ ውብ ጥላ
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start, // ጽሑፎቹ ከግራ እንዲጀምሩ
                  children: [
                    // 1. *** ፎቶውን እና የልብ ቁልፉን በአንድ ላይ የያዘው STACK ***
                    Stack(
                      children: [
                        // የምግቡ ፎቶ
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                          child: Image.network(
                            recipe.image,
                            height: 120,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        // የልብ ቁልፉን በፎቶው ላይ በቀኝ በኩል ጥግ ላይ ለመስቀል Positioned እንጠቀማለን
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            // በልብ ቁልፉ ዙሪያ ነጭ ክብ ጥላ እንዲኖረው ያደርጋል (ቁልፉ ጎልቶ እንዲታይ)
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              shape: BoxShape.circle,
                            ),
                            child: favoritesState.when(
                              loading: () => const SizedBox.shrink(),
                              error: (error, stackTrace) =>
                                  const SizedBox.shrink(),
                              data: (favList) {
                                final isFav = favList.any(
                                  (r) => r.id == recipe.id,
                                );
                                return Row(
                                  key: ValueKey('fav-row-${recipe.id}-$isFav'),
                                  children: [
                                    IconButton(
                                      constraints: const BoxConstraints(), // የነባሪውን IconButton padding ለማጥፋት
                                      padding: const EdgeInsets.all(8),
                                      onPressed: () {
                                        ref
                                            .read(
                                              favoriteRecipesNotifier.notifier,
                                            )
                                            .toggleFavorite(recipe);
                                      },
                                      icon: AnimatedSwitcher(
                                        duration: const Duration(
                                          milliseconds: 300,
                                        ),
                                        transitionBuilder: (child, animation) =>
                                            ScaleTransition(
                                              scale: animation,
                                              child: child,
                                            ),
                                        child: Icon(
                                          isFav
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                          color: isFav
                                              ? Colors.red
                                              : Colors.grey,
                                          key: ValueKey<bool>(isFav),
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),

                    // 2. የምግቡ ስም የሚቀመጥበት የታችኛው የካርዱ ክፍል
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        recipe.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
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
