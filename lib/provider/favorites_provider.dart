import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe/data/database_helper.dart';
import 'package:recipe/model/recipe.dart';

class FavoriteRecipesNotifier extends AsyncNotifier<List<Recipe>>{
  @override
  FutureOr<List<Recipe>> build() async{
    final json=await DatabaseHelper.instance.getFavorites();
    final fav=json.map((fav)=>Recipe.fromJson(fav)).toList();
    return fav;
  }
void toggleFavorite(Recipe recipe)async{
  final isFavorite=state.value!.any((r)=>r.id==recipe.id);
  if(!isFavorite){
    await DatabaseHelper.instance.insertFavorite(recipe);
    state=AsyncValue.data([...state.value!,recipe]);
  }else{
    await DatabaseHelper.instance.deleteFavorite(recipe.id);
    state=AsyncValue.data(state.value!.where((r)=>r.id!=recipe.id ).toList());
  }
}
}
final favoriteRecipesNotifier=AsyncNotifierProvider<FavoriteRecipesNotifier,List<Recipe>>(FavoriteRecipesNotifier.new);