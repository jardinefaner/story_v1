import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _firebase = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();

  // Compiled regex for performance
  static final _passwordRegex = RegExp(
    r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$',
  );

  var _isLogin = true;
  var _isAuthenticating = false;
  var _obscurePassword = true;
  var _enteredEmail = '';
  var _enteredPassword = '';

  void _submit() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) return;

    _formKey.currentState!.save();

    setState(() => _isAuthenticating = true);

    try {
      if (_isLogin) {
        await _firebase.signInWithEmailAndPassword(
          email: _enteredEmail,
          password: _enteredPassword,
        );
      } else {
        await _firebase.createUserWithEmailAndPassword(
          email: _enteredEmail,
          password: _enteredPassword,
        );
      }
    } on FirebaseAuthException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.message ?? 'Authentication failed.'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    } finally {
      if (mounted) setState(() => _isAuthenticating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // We use Center + SingleChildScrollView to ensure the form
    // stays in the middle but scrolls if the keyboard covers it.
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // LOGO
          Icon(
            Icons.remove_red_eye_outlined,
            size: 100,
            // Make sure the logo is visible against the dust background
            color: colorScheme.primary.withOpacity(0.9),
          ),
          const SizedBox(height: 30),

          // FORM CARD
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // EMAIL
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Email Address',
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        autocorrect: false,
                        textCapitalization: TextCapitalization.none,
                        autofillHints: const [AutofillHints.email],
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value == null || !value.contains('@')) {
                            return 'Please enter a valid email.';
                          }
                          return null;
                        },
                        onSaved: (value) => _enteredEmail = value!,
                      ),
                      const SizedBox(height: 16),

                      // PASSWORD
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(_obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined),
                            onPressed: () {
                              setState(() => _obscurePassword = !_obscurePassword);
                            },
                          ),
                        ),
                        obscureText: _obscurePassword,
                        autofillHints: const [AutofillHints.password],
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => _submit(),
                        validator: (value) {
                          if (value == null || value.length < 8) {
                            return 'Password is too short.';
                          }
                          if (!_isLogin && !_passwordRegex.hasMatch(value)) {
                            return 'Requires Upper, Lower, Number & Symbol.';
                          }
                          return null;
                        },
                        onSaved: (value) => _enteredPassword = value!,
                      ),

                      const SizedBox(height: 24),

                      // SUBMIT BUTTON
                      if (_isAuthenticating)
                        const CircularProgressIndicator()
                      else
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                            onPressed: _submit,
                            style: FilledButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: Text(_isLogin ? 'Login' : 'Sign Up'),
                          ),
                        ),

                      const SizedBox(height: 12),

                      // SWITCH MODE
                      if (!_isAuthenticating)
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _isLogin = !_isLogin;
                              _formKey.currentState?.reset();
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
    );
  }
}