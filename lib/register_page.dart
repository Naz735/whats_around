import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  RegisterPage({super.key});

  Future<void> _register(BuildContext context) async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Please fill all fields")));
      return;
    }

    // TODO: Insert new user into SQLite database here

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Registered successfully")));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: Text("Register")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: "Email"),
              style: TextStyle(color: isDark ? Colors.white : Colors.black),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: "Password"),
              obscureText: true,
              style: TextStyle(color: isDark ? Colors.white : Colors.black),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _register(context),
              child: Text("Register"),
            ),
          ],
        ),
      ),
    );
  }
}
