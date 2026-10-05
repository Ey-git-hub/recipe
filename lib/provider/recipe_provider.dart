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


// 3. ዋናው የማጣሪያ ሎጂክ (የተጣራውን የምግብ ዝርዝር ለ UI የሚያዘጋጅ)
final filteredRecipesProvider = Provider<AsyncValue<List<Recipe>>>((ref) {
  // የሶስቱንም ፕሮቫይደሮች ወቅታዊ ዳታ በ watch እንከታተላለን
  final recipeState = ref.watch(recipeNotifierProvider);
  final isLactoseFree = ref.watch(lactoseFreeFilterProvider);
  final isGlutenFree = ref.watch(glutenFreeFilterProvider);

  // ከ API የሚመጣው ዳታ ገና በመጫን ላይ (Loading) ወይም በስህተት (Error) ላይ ከሆነ ያንኑ ሁኔታ ለ UI ያስተላልፋል
  return recipeState.when(
    loading: () => const AsyncValue.loading(),
    error: (err, stack) => AsyncValue.error(err, stack),
    data: (allRecipes) {
      // ዳታው በስኬት ከተጫነ ማጣራት እንጀምራለን
      List<Recipe> filtered = allRecipes;

      // ተጠቃሚው Lactose-Free ካበራ
      if (isLactoseFree) {
        filtered = filtered.where((recipe) {
          // በቅመሞቹ ውስጥ ወተት (milk) ወይም ቅቤ (butter) ወይም አይብ (cheese) የሌለበትን ብቻ ያስቀራል
          final hasDairy = recipe.ingredients.any((ing) =>
              ing.toLowerCase().contains('milk') ||
              ing.toLowerCase().contains('butter') ||
              ing.toLowerCase().contains('cheese'));
          return !hasDairy; // የወተት ተዋጽኦ የሌላቸውን (true) የሆኑትን ብቻ ይመልሳል
        }).toList();
      }

      // ተጠቃሚው Gluten-Free ካበራ
      if (isGlutenFree) {
        filtered = filtered.where((recipe) {
          // በቅመሞቹ ውስጥ ስንዴ (wheat) ወይም ዱቄት (flour) የሌለበትን ብቻ ያስቀራል
          final hasGluten = recipe.ingredients.any((ing) =>
              ing.toLowerCase().contains('wheat') ||
              ing.toLowerCase().contains('flour'));
          return !hasGluten; // ግሉተን የሌላቸውን (true) የሆኑትን ብቻ ይመልሳል
        }).toList();
      }

      // የተጣራውን ዝርዝር በ AsyncValue.data ጠቅልሎ ይመልሳል
      return AsyncValue.data(filtered);
    },
  );
});
