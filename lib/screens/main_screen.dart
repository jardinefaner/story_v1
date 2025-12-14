
import 'package:flutter/material.dart';
import 'package:story_v1/widgets/footer.dart';
import 'package:story_v1/widgets/header.dart';
import 'package:story_v1/widgets/seamless_waveform.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool _eyePressed = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      // resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // HEADER
          Positioned(
            top: 32,
            right: 32,
            left: 32,
            child: const Header(),
          ),
          Positioned(
            bottom: 32,
            right:32, // Adjusts for right
            left: 32,
            child: const Footer(),
          ),
          // Positioned(
          //   right: 0,
          //   top: 0,
          //   child: SizedBox(
          //     width: 32,
          //     height: double.infinity,
          //     child: Placeholder(),
          //   ),
          // ),
          Center(child: Text('Main Screen')),
        ],
      ),
    );
  }
}
