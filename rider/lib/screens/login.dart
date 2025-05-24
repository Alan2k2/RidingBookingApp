import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final _loginFormKey = GlobalKey<FormState>();
  final _registerFormKey = GlobalKey<FormState>();

  final _loginUsername = TextEditingController();
  final _loginPassword = TextEditingController();

  final _regUsername = TextEditingController();
  final _regPassword = TextEditingController();
  final _regConfirm = TextEditingController();
  final _regPhone = TextEditingController();
  final _regPincode = TextEditingController();
  final _regPlace = TextEditingController();

  bool _loginObscure = true;
  bool _regObscure = true;
  bool _confirmObscure = true;

  String _selectedCategory = 'User';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  Future<void> _login() async {
    if (_loginFormKey.currentState!.validate()) {
      try {
        final response = await http.post(
          Uri.parse('http://192.168.29.177:5000/api/auth/login'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'username': _loginUsername.text.trim(),
            'password': _loginPassword.text,
          }),
        );

        final data = jsonDecode(response.body);
        if (response.statusCode == 200) {
          String category = data['category'];

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Welcome ${data['username']} ($category)"),
              backgroundColor: Colors.green,
            ),
          );

          // Navigate to the correct dashboard
          switch (category) {
            case 'User':
              Navigator.pushReplacementNamed(context, '/home');
              break;
            case 'Rider':
              Navigator.pushReplacementNamed(context, '/rider');
              break;
            case 'Admin':
              Navigator.pushReplacementNamed(context, '/admin');
              break;
            default:
              _showError("Unknown user category");
          }
        } else {
          _showError(data['message'] ?? "Login failed");
        }
      } catch (e) {
        _showError("Something went wrong. Please try again.");
      }
    }
  }

  Future<void> _register() async {
    if (_registerFormKey.currentState!.validate()) {
      if (_regPassword.text != _regConfirm.text) {
        _showError("Passwords do not match");
        return;
      }

      try {
        final response = await http.post(
          Uri.parse('http://192.168.29.177:5000/api/auth/register'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'username': _regUsername.text.trim(),
            'password': _regPassword.text,
            'category': _selectedCategory,
            'phone': _regPhone.text.trim(),
            'pincode': _regPincode.text.trim(),
            'place': _regPlace.text.trim(),
          }),
        );

        final data = jsonDecode(response.body);
        if (response.statusCode == 201 || response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Registration successful! Please login."),
              backgroundColor: Colors.green,
            ),
          );
          _tabController.animateTo(0);
        } else {
          _showError(data['message'] ?? "Registration failed");
        }
      } catch (e) {
        _showError("Something went wrong. Please try again.");
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  Widget _textField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
    bool obscureText = false,
    void Function()? toggleObscure,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword ? obscureText : false,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        suffixIcon:
            isPassword
                ? IconButton(
                  icon: Icon(
                    obscureText ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: toggleObscure,
                )
                : null,
        border: const OutlineInputBorder(),
      ),
      validator:
          (value) =>
              value == null || value.trim().isEmpty
                  ? 'Please enter $label'
                  : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 40),
            TabBar(
              controller: _tabController,
              tabs: const [Tab(text: "Login"), Tab(text: "Register")],
              labelColor: theme.primaryColor,
              unselectedLabelColor: Colors.grey,
              indicatorColor: theme.primaryColor,
            ),
            const SizedBox(height: 20),
            const Icon(Icons.lock, size: 80),
            const SizedBox(height: 20),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [_buildLoginForm(theme), _buildRegisterForm(theme)],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginForm(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _loginFormKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _textField(
              controller: _loginUsername,
              label: "Username",
              icon: Icons.person,
            ),
            const SizedBox(height: 20),
            _textField(
              controller: _loginPassword,
              label: "Password",
              icon: Icons.lock,
              isPassword: true,
              obscureText: _loginObscure,
              toggleObscure: () {
                setState(() => _loginObscure = !_loginObscure);
              },
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: _login,
              icon: const Icon(Icons.login),
              label: const Text("Login"),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRegisterForm(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _registerFormKey,
        child: Column(
          children: [
            _textField(
              controller: _regUsername,
              label: "Username",
              icon: Icons.person,
            ),
            const SizedBox(height: 20),
            _textField(
              controller: _regPassword,
              label: "Password",
              icon: Icons.lock,
              isPassword: true,
              obscureText: _regObscure,
              toggleObscure: () {
                setState(() => _regObscure = !_regObscure);
              },
            ),
            const SizedBox(height: 20),
            _textField(
              controller: _regConfirm,
              label: "Confirm Password",
              icon: Icons.lock_outline,
              isPassword: true,
              obscureText: _confirmObscure,
              toggleObscure: () {
                setState(() => _confirmObscure = !_confirmObscure);
              },
            ),
            const SizedBox(height: 20),
            _textField(
              controller: _regPhone,
              label: "Phone Number",
              icon: Icons.phone,
            ),
            const SizedBox(height: 20),
            _textField(
              controller: _regPincode,
              label: "Pincode",
              icon: Icons.pin_drop,
            ),
            const SizedBox(height: 20),
            _textField(
              controller: _regPlace,
              label: "Place",
              icon: Icons.location_city,
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Select Category:",
                style: theme.textTheme.titleMedium,
              ),
            ),
            ListTile(
              title: const Text("User"),
              leading: Radio(
                value: 'User',
                groupValue: _selectedCategory,
                onChanged: (value) {
                  setState(() => _selectedCategory = value!);
                },
              ),
            ),
            ListTile(
              title: const Text("Rider"),
              leading: Radio(
                value: 'Rider',
                groupValue: _selectedCategory,
                onChanged: (value) {
                  setState(() => _selectedCategory = value!);
                },
              ),
            ),
            ListTile(
              title: const Text("Admin"),
              leading: Radio(
                value: 'Admin',
                groupValue: _selectedCategory,
                onChanged: (value) {
                  setState(() => _selectedCategory = value!);
                },
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: _register,
              icon: const Icon(Icons.person_add),
              label: const Text("Register"),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _loginUsername.dispose();
    _loginPassword.dispose();
    _regUsername.dispose();
    _regPassword.dispose();
    _regConfirm.dispose();
    _regPhone.dispose();
    _regPincode.dispose();
    _regPlace.dispose();
    super.dispose();
  }
}
