import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
          Positioned(
            top: 32,
            right: 32,
            child: OutlinedButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              child: const Icon(Icons.logout),
            ),
          ),
          Positioned(
            bottom: 32,
            right: 24,
            left: 32,
            child: Container(
              decoration: BoxDecoration(
                color: _eyePressed
                    ? Theme.of(context).colorScheme.primary.withAlpha(25)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(100),
                border: Border.all(
                  width: 1,
                  color: _eyePressed
                      ? Theme.of(context).colorScheme.primary
                      : Colors.transparent,
                ),
              ),
              padding: const EdgeInsets.fromLTRB(32, 8, 8, 8),
              child: Row(
                children: [
                  if (_eyePressed)
                    Flexible(
                      child: Form(
                        child: TextFormField(
                          decoration: const InputDecoration(
                            hintText: 'What is up?',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),

                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      setState(() => _eyePressed = !_eyePressed);
                    },
                    icon: !_eyePressed
                        ? Icon(
                            Icons.remove_red_eye_outlined,
                            size: 48,
                            color: Theme.of(context).colorScheme.primary,
                          )
                        : Icon(Icons.panorama_fish_eye, size: 48),
                  ),
                ],
              ),
            ),
          ),
          Center(child: Text('Main Screen')),
        ],
      ),
    );
  }
}
