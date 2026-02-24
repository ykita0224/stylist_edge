import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'services/auth_service.dart';
import 'theme/app_theme.dart';
import 'screens/model/main_screen.dart';
import 'screens/stylist/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthService.instance.init();
  runApp(const StylistEdgeApp());
}

class StylistEdgeApp extends StatelessWidget {
  const StylistEdgeApp({super.key});

  @override
  Widget build(BuildContext context) {
    Widget home;
    if (AuthService.instance.isLoggedIn) {
      final user = AuthService.instance.currentUser!;
      home = user.isStylist ? const StylistMainScreen() : const ModelMainScreen();
    } else {
      home = const HomeScreen();
    }

    return MaterialApp(
      title: 'Stylist Edge',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      themeMode: ThemeMode.light,
      home: home,
    );
  }
}
