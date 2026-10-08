import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe/provider/favorites_provider.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favState = ref.watch(favoriteRecipesNotifier);

    return Scaffold(
      appBar: AppBar(title: const Text("የተወዳጅ ምግቦች ዝርዝር")),
      body: favState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('ስህተት ተከስቷል፦ $error')),
        
        data: (favorites) {
          if (favorites.isEmpty) {
            return const Center(
              child: Text(
                'ምንም ተወዳጅ ያደረግከው ምግብ የለም!',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: favorites.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7, 
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemBuilder: (BuildContext context, int index) {
              final fav = favorites[index];
              
              return Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          fav.image,
                          height: 100,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        fav.name,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 5),
                      
                    
                      Row(
                        key: ValueKey('fav-screen-row-${fav.id}'),
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            onPressed: () {
                              
                              ref.read(favoriteRecipesNotifier.notifier).toggleFavorite(fav);
                            },
                            icon: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              transitionBuilder: (child, animation) =>
                                  ScaleTransition(scale: animation, child: child),
                              child: const Icon(
                                Icons.favorite, 
                                color: Colors.red,
                                key: ValueKey<bool>(true),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ); // 
            },
          );
        },
      ),
    );
  }
}
