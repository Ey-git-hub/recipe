import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:recipe/model/recipe.dart';

class RecipeNotifier extends AsyncNotifier<List<Recipe>>{
   final _dio=Dio();
  @override
    FutureOr<List<Recipe>> build() async {
     final response = await _dio.get('https://dummyjson.com/recipes');
     final List<dynamic> data=response.data['recipes'];
      return data.map((json)=>Recipe.fromJson(json)).toList();
    }
  }
final recipeNotifierProvider=AsyncNotifierProvider<RecipeNotifier,List<Recipe>>(RecipeNotifier.new);
final lactoseFreeFilterProvider = StateProvider<bool>((ref) => false);
final glutenFreeFilterProvider = StateProvider<bool>((ref) => false);


final filteredRecipesProvider = Provider<AsyncValue<List<Recipe>>>((ref) {
  final recipeState = ref.watch(recipeNotifierProvider);
  final isLactoseFree = ref.watch(lactoseFreeFilterProvider);
  final isGlutenFree = ref.watch(glutenFreeFilterProvider);
  return recipeState.when(
    loading: () => const AsyncValue.loading(),
    error: (err, stack) => AsyncValue.error(err, stack),
    data: (allRecipes) {
      List<Recipe> filtered = allRecipes;

      
      if (isLactoseFree) {
        filtered = filtered.where((recipe) {
          
          final hasDairy = recipe.ingredients.any((ing) =>
              ing.toLowerCase().contains('milk') ||
              ing.toLowerCase().contains('butter') ||
              ing.toLowerCase().contains('cheese'));
          return !hasDairy; 
        }).toList();
      }

      if (isGlutenFree) {
        filtered = filtered.where((recipe) {
        
          final hasGluten = recipe.ingredients.any((ing) =>
              ing.toLowerCase().contains('wheat') ||
              ing.toLowerCase().contains('flour'));
          return !hasGluten; 
        }).toList();
      }

      return AsyncValue.data(filtered);
    },
  );
});
