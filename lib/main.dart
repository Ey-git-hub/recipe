import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe/notification/notification_service.dart';
import 'package:recipe/provider/auth_provider.dart';
import 'package:recipe/screens/login.dart';
import 'package:recipe/widgets/main_navigation_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.instance.initNotification();
  await NotificationService.instance.requestPermission();

  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    return MaterialApp(
      title: 'Recipe',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.orange,
          brightness: Brightness.light,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.orange,
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 2,
        ),
        cardTheme: CardThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 3,
        ),
      ),

      home: authState.when(
        data: (token) =>
            token == null ? const LoginScreen() : const MainNavigationScreen(),
        error: (error, stack) =>
            Scaffold(body: Center(child: Text('Error $error'))),
        loading: () =>
            Scaffold(body: Center(child: CircularProgressIndicator())),
      ),
    );
  }
}
