import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe/provider/auth_provider.dart';
import 'package:recipe/screens.dart/login.dart';
import 'package:recipe/screens.dart/recipe_screen.dart';
import 'package:recipe/widgets/main_navigation_screen.dart';

void main() {
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final authState=ref.watch(authNotifierProvider);
    return MaterialApp(
      title: 'Recipe',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: authState.when(
        data: (token)=>token==null ? const LoginScreen(): const MainNavigationScreen()
        , 
        error: (error,stack)=>Scaffold(body: Center(child: Text('Error $error'),),),
        loading: ()=>Scaffold(body: Center(child: CircularProgressIndicator(),),)),
    );  
  }
}