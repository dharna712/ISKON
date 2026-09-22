import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'state/prefs.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppPrefs.instance.init();
  runApp(const IskonApp());
}

class IskonApp extends StatelessWidget {
  const IskonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shloka Saathi',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: const HomeScreen(),
    );
  }
}
