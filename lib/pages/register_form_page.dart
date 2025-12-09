import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/user.dart';
import 'user_info_page.dart';

class RegisterFormPage extends StatefulWidget {
  const RegisterFormPage({Key? key}) : super(key: key);

  @override
  _RegisterFormPageState createState() => _RegisterFormPageState();
}

class _RegisterFormPageState extends State<RegisterFormPage> {
  final _formKey = GlobalKey<FormState>();

  bool _hidePassword = true;

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _storyController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String? _selectedCountry;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _storyController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register Form"),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            _buildNameField(),
            const SizedBox(height: 10),
            _buildPhoneField(),
            const SizedBox(height: 10),
            _buildEmailField(),
            const SizedBox(height: 10),
            _buildCountryDropdown(),
            const SizedBox(height: 10),
            _buildStoryField(),
            const SizedBox(height: 10),
            _buildPasswordField(),
            const SizedBox(height: 10),
            _buildConfirmPasswordField(),
            const SizedBox(height: 20),
            _buildRegisterButton(),
          ],
        ),
      ),
    );
  }

  // ---------- Full Name ----------

  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      decoration: InputDecoration(
        labelText: 'Full Name *',
        hintText: 'What do people call you?',
        prefixIcon: const Icon(Icons.person),
        suffixIcon: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () => _nameController.clear(),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: const BorderSide(color: Colors.grey, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: const BorderSide(color: Colors.blue, width: 2.0),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter Full Name!!!!';
        }
        return null;
      },
    );
  }

  // ---------- Phone Number ----------

  Widget _buildPhoneField() {
    return TextFormField(
      controller: _phoneController,
      keyboardType: TextInputType.phone,
      inputFormatters: [
        FilteringTextInputFormatter(
          RegExp(r'^[()\d -]{1,15}$'),
          allow: true,
        ),
      ],
      decoration: InputDecoration(
        labelText: 'Phone Number *',
        hintText: 'Where can we reach you?',
        helperText: 'Phone format: (XXX)XXX-XXXX',
        prefixIcon: const Icon(Icons.call),
        suffixIcon: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () => _phoneController.clear(),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: const BorderSide(color: Colors.grey, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
          borderSide: const BorderSide(color: Colors.blue, width: 2.0),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      validator: (value) {
        if (!_validatorPhoneNumber(value ?? '')) {
          return "Input number, for example (xxx)xxx-xxxx";
        }
        return null;
      },
    );
  }

  bool _validatorPhoneNumber(String input) {
    final phoneExp = RegExp(r'^\(\d\d\d\)\d\d\d-\d\d\d\d');
    return phoneExp.hasMatch(input);
  }

  // ---------- Email ----------

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(
        labelText: 'Email Address *',
        hintText: 'Enter an email address',
        icon: Icon(Icons.mail),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Email is required';
        }
        if (!value.contains('@')) {
          return 'Email must contain @';
        }
        return null;
      },
    );
  }

  // ---------- Country (Dropdown) ----------

  Widget _buildCountryDropdown() {
    final countries = ['Ukraine', 'Poland', 'Germany', 'USA', 'Other'];

    return DropdownButtonFormField<String>(
      value: _selectedCountry,
      decoration: const InputDecoration(
        labelText: 'Country?',
        icon: Icon(Icons.map),
        border: OutlineInputBorder(),
      ),
      items: countries
          .map(
            (c) => DropdownMenuItem<String>(
              value: c,
              child: Text(c),
            ),
          )
          .toList(),
      onChanged: (value) {
        setState(() {
          _selectedCountry = value;
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a country';
        }
        return null;
      },
    );
  }

  // ---------- Life Story ----------

  Widget _buildStoryField() {
    return TextFormField(
      controller: _storyController,
      maxLines: 3,
      inputFormatters: [
        LengthLimitingTextInputFormatter(200),
      ],
      decoration: const InputDecoration(
        labelText: 'Life Story',
        hintText: 'Tell us about yourself',
        helperText: 'Keep it short, this is just a demo',
        border: OutlineInputBorder(),
      ),
    );
  }

  // ---------- Password ----------

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _hidePassword,
      maxLength: 8,
      decoration: InputDecoration(
        labelText: 'Password *',
        hintText: 'Enter the password',
        icon: const Icon(Icons.security),
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
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Password is required';
        }
        if (value.length > 8) {
          return 'Password must be max 8 characters';
        }
        return null;
      },
    );
  }

  // ---------- Confirm Password ----------

  Widget _buildConfirmPasswordField() {
    return TextFormField(
      controller: _confirmPasswordController,
      obscureText: _hidePassword,
      maxLength: 8,
      decoration: InputDecoration(
        labelText: 'Confirm Password *',
        hintText: 'Confirm the password',
        icon: const Icon(Icons.border_color),
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
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please confirm password';
        }
        if (value != _passwordController.text) {
          return 'Passwords do not match';
        }
        return null;
      },
    );
  }

  // ---------- Button ----------

  Widget _buildRegisterButton() {
    return SizedBox(
      height: 48,
      child: ElevatedButton(
        onPressed: _submitForm,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        child: const Text(
          "Register",
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  void _submitForm() async {
  if (_formKey.currentState!.validate()) {
    // 1. Створюємо об'єкт User з даних форми
    final user = User(
      name: _nameController.text,
      phone: _phoneController.text,
      email: _emailController.text,
      country: _selectedCountry ?? '',
      story: _storyController.text,
    );

  
    await showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Registration successful',
            style: TextStyle(color: Colors.green),
          ),
          content: Text(
            '${user.name} is now a verified register form',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop(); 
              },
              child: const Text(
                'Verified',
                style: TextStyle(color: Colors.green),
              ),
            ),
          ],
        );
      },
    );


    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserInfoPage(user: user),
      ),
    );
  }
}
}