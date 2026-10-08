import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe/provider/favorites_provider.dart';
import 'package:recipe/screens/favorites_screen.dart';
import 'package:recipe/screens/recipe_screen.dart';

class MainNavigationScreen extends ConsumerWidget {
  const MainNavigationScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex=ref.watch(navigationIndexProvider);
    return Scaffold(body: IndexedStack(
      index: selectedIndex,
      children: [
        RecipeScreen(),
        FavoritesScreen()
      ],
    ),
    bottomNavigationBar: BottomNavigationBar(currentIndex:selectedIndex ,items: [
BottomNavigationBarItem(icon: Icon(Icons.home),label: 'Home',),
BottomNavigationBarItem(icon: Icon(Icons.favorite,),label: 'Favorites',),
    ],
    onTap: (index){
      ref.read(navigationIndexProvider.notifier).state=selectedIndex;
    
    },),);
  }
}