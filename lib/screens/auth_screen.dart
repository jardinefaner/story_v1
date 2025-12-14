import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final _firebase = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _form = GlobalKey<FormState>();
  bool _isLogin = true;
  String _email = '';
  String _password = '';

  void _submit() async {
    final isValid = _form.currentState!.validate();

    if (!isValid) return;

    _form.currentState!.save();
    try {
      if (_isLogin) {
        final credentials = await _firebase.signInWithEmailAndPassword(
          email: _email,
          password: _password,
        );

      } else {
        final credentials = await _firebase.createUserWithEmailAndPassword(
          email: _email,
          password: _password,
        );
      }
    } on FirebaseAuthException catch (error) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.message ?? 'Authentication failed.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Story LOGO
            Container(
              margin: const EdgeInsets.only(top: 32),
              width: 200,
              height: 200,
              child: Icon(
                Icons.remove_red_eye_outlined,
                size: 160,
                color: Theme.of(context).colorScheme.primary.withAlpha(225),
              ),
            ),

            // FORM
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 32),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: _form,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // EMAIL ADDRESS input
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Email Address',
                          ),
                          keyboardType: TextInputType.emailAddress,
                          autocorrect: false,
                          textCapitalization: TextCapitalization.none,
                          validator: (value) {
                            if (value == null ||
                                value.trim().isEmpty ||
                                !value.contains('@')) {
                              return 'Please enter a valid email address.';
                            }

                            return null;
                          },
                          onSaved: (value) {
                            _email = value!;
                          },
                        ),

                        // PASSWORD
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Password',
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Password is required.';
                            }
                            // Regex for minimum 8 characters, at least one uppercase,
                            // one lowercase, one digit, and one special character.
                            // You can customize the special characters within the [ ... ] block.
                            String pattern =
                                r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
                            RegExp regex = RegExp(pattern);

                            if (!regex.hasMatch(value)) {
                              return 'Password must be at least 8 characters and include: uppercase, lowercase, digit, and special character (!@#\$&*~).';
                            }

                            return null; // The password is valid
                          },
                          onSaved: (value) {
                            _password = value!;
                          },
                        ),

                        const SizedBox(height: 24),

                        OutlinedButton(
                          onPressed: _submit,
                          child: Text(_isLogin ? 'Login' : 'Sign Up'),
                        ),

                        TextButton(
                          onPressed: () {
                            setState(() {
                              _isLogin = !_isLogin;
                            });
                          },
                          child: Text(
                            _isLogin
                                ? 'Create an account'
                                : 'I already have an account',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
