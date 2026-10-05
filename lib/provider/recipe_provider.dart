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
final recipeNotifierProvider=AsyncNotifierProvider<RecipeNotifier,List<Recipe >>(RecipeNotifier.new);

final lactoseFreeFilterProvider = StateProvider<bool>((ref) => false);


final glutenFreeFilterProvider = StateProvider<bool>((ref) => false);
