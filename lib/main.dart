import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:story_v1/screens/auth_screen.dart';
import 'package:story_v1/screens/main_screen.dart';
import 'package:story_v1/screens/splash_screen.dart';
import 'package:story_v1/themes/app_themes.dart';
import 'package:story_v1/widgets/dust_engine.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Keep immersive, but be aware this hides the status bar permanently
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
      // Using 'builder' is the cleanest way to have a global background/overlay
      // that persists across all screens without nesting Scaffolds.
      builder: (context, child) {
        return Stack(
          children: [
            // 1. Background Dust
            Positioned.fill(child: const DustEngine()),

            // 2. The App Content (Auth/Main/Splash)
            // We wrap this in a Scaffold Messenger to ensure SnackBars work
            // even if the active screen doesn't have a Scaffold.
            Positioned.fill(
              child: child ?? const SizedBox.shrink(),
            ),

            // 3. Foreground Dust (Must ignore touches!)
            Positioned.fill(
              child: IgnorePointer(
                ignoring: true, // This allows clicks to pass through to the app
                child: const DustEngine(),
              ),
            ),
          ],
        );
      },
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SplashScreen();
          }
          if (snapshot.hasData) {
            return const MainScreen();
          }
          return const AuthScreen();
        },
      ),
    );
  }
}