import 'package:flutter/material.dart';
import 'db_helper.dart';

class RegisterPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final dbHelper = DBHelper();

  Future<void> _register(BuildContext context) async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Please fill all fields")));
      return;
    }

    await dbHelper.registerUser(email, password);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Registered successfully")));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Register")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: "Password"),
              obscureText: true,
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
