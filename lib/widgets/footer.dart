import 'package:flutter/material.dart';

class Footer extends StatefulWidget {
  const Footer({super.key});

  @override
  State<Footer> createState() => _FooterState();
}

class _FooterState extends State<Footer> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        OutlinedButton(
          onPressed: () {},
          child: const Text('Storyteller'),
        ),
        const Spacer(),
        OutlinedButton(
          onPressed: () {},
          child: const Icon(Icons.logout),
        ),
        const Spacer(),
        OutlinedButton(
          onPressed: () {},
          child: const Icon(Icons.settings),
        ),
      ]
    );
  }
}