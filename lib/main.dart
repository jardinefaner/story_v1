import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:story_v1/screens/auth_screen.dart';
import 'package:story_v1/themes/app_themes.dart';
import 'package:story_v1/widgets/dust_engine.dart';
import 'firebase_options.dart';

import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppThemes.light,
      darkTheme: AppThemes.dark,
      themeMode: ThemeMode.system,
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Positioned.fill(child: const DustEngine()),
            Positioned.fill(child: AuthScreen()),
          ],
        ),
      ),
    );
  }
}
