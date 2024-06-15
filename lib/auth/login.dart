import 'package:bunkerlink/auth/service.dart';
import 'package:flutter/material.dart';

class LoginScaffold extends StatefulWidget {
  const LoginScaffold({super.key});

  @override
  _LoginScaffoldState createState() => _LoginScaffoldState();
}

class _LoginScaffoldState extends State<LoginScaffold> {
  String username = '';
  String password = '';
  String error = '';

  void handleLogin() async {
    if (username.isEmpty || password.isEmpty) {
      return;
    }

    final result = await AuthService.login(username, password);
    if (result['status'] == 'success') {
      Navigator.pushNamed(context, '/chat');
    } else {
      setState(() {
        error = "Invalid username or password";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Username or Email',
              ),
              onChanged: (value) => setState(() => username = value),
            ),
            const SizedBox(height: 20.0),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
              obscureText: true, // Hide password characters
              onChanged: (value) => setState(() => password = value),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: handleLogin,
              child: const Text('Login'),
            ),
            Visibility(
              visible: error.isNotEmpty, // Show only if error message exists
              child: Text(
                error,
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }
}