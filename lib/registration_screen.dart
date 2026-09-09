import 'package:flutter/material.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  // Lets us validate all TextFormFields at once.
  final _formKey = GlobalKey<FormState>();

  // Controllers store and read the text from each field.
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _hidePassword = true;
  bool _hideConfirmPassword = true;
  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();

    // Rebuild the screen when the user types so the Register button
    // can turn on only after every field is valid.
    final controllers = [
      _firstNameController,
      _lastNameController,
      _emailController,
      _passwordController,
      _confirmPasswordController,
    ];

    for (final controller in controllers) {
      controller.addListener(_updateFormValidity);
    }
  }

  @override
  void dispose() {
    // Controllers must be disposed to avoid memory leaks.
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _updateFormValidity() {
    final isValid =
        _validateName(_firstNameController.text, 'First name') == null &&
        _validateName(_lastNameController.text, 'Last name') == null &&
        _validateEmail(_emailController.text) == null &&
        _validatePassword(_passwordController.text) == null &&
        _validateConfirmPassword(_confirmPasswordController.text) == null;

    if (isValid != _isFormValid) {
      setState(() {
        _isFormValid = isValid;
      });
    }
  }

  String? _validateName(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    if (value.trim().length < 2) {
      return '$fieldName must be at least 2 characters';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }

    final email = value.trim();
    final atIndex = email.indexOf('@');
    final hasDotAfterAt = atIndex != -1 && email.indexOf('.', atIndex) != -1;

    if (!hasDotAfterAt) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  void _register() {
    // Hide the keyboard first, then check the form again.
    FocusScope.of(context).unfocus();

    if (_formKey.currentState!.validate()) {
      _showSuccessDialog();
    }
  }

  void _showSuccessDialog() {
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    final email = _emailController.text.trim();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Registration Successful'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('First Name: $firstName'),
              const SizedBox(height: 8),
              Text('Last Name: $lastName'),
              const SizedBox(height: 8),
              Text('Email: $email'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _clearForm();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _clearForm() {
    _formKey.currentState!.reset();
    _firstNameController.clear();
    _lastNameController.clear();
    _emailController.clear();
    _passwordController.clear();
    _confirmPasswordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    // GestureDetector lets the user tap outside a field to close the keyboard.
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Register'),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: SafeArea(
          // SingleChildScrollView prevents overflow when the keyboard opens.
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(Icons.person_add_alt_1, size: 72, color: Colors.teal),
                  const SizedBox(height: 12),
                  const Text(
                    'Create Account',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Fill in your details to register.',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _firstNameController,
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'First Name',
                      prefixIcon: Icon(Icons.person_outline),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => _validateName(value, 'First name'),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _lastNameController,
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Last Name',
                      prefixIcon: Icon(Icons.person_outline),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => _validateName(value, 'Last name'),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email_outlined),
                      border: OutlineInputBorder(),
                    ),
                    validator: _validateEmail,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _hidePassword,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: const Icon(Icons.lock_outline),
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _hidePassword ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _hidePassword = !_hidePassword;
                          });
                        },
                      ),
                    ),
                    validator: _validatePassword,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: _hideConfirmPassword,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) {
                      if (_isFormValid) {
                        _register();
                      }
                    },
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      prefixIcon: const Icon(Icons.lock_outline),
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _hideConfirmPassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _hideConfirmPassword = !_hideConfirmPassword;
                          });
                        },
                      ),
                    ),
                    validator: _validateConfirmPassword,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    // The button stays disabled until every field is valid.
                    onPressed: _isFormValid ? _register : null,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Register'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
