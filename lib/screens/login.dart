import 'package:bunkerlink/auth/authservice.dart';
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
      setState(() {
        error = "Username and password cannot be empty";
      });
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
        foregroundColor: Colors.black, // To make the title color black
        elevation: 0, // Removes the shadow under the AppBar
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/bunker.png',
                width: 100,
                height: 100,
              ),
              const SizedBox(height: 20.0),
              const Text(
                'Bunkerlink',
                style: TextStyle(
                  fontSize: 36.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20.0),
              const Text(
                'Join us now!',
                style: TextStyle(
                  fontSize: 18.0,
                ),
                textAlign: TextAlign.center, // Center the text
              ),
              const SizedBox(height: 40.0),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Username or Email',
                  prefixIcon: const Icon(Icons.person, color: Colors.lightGreen),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                onChanged: (value) => setState(() => username = value),
              ),
              const SizedBox(height: 20.0),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock, color: Colors.lightGreen),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                obscureText: true,
                onChanged: (value) => setState(() => password = value),
              ),
              const SizedBox(height: 20.0),
              SizedBox(
                width: 200.0,
                child: ElevatedButton(
                  onPressed: handleLogin,
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all<Color>(Colors.lightGreen),
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.login,
                        color: Colors.white,
                      ),
                      SizedBox(width: 8.0),
                      Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              Visibility(
                visible: error.isNotEmpty,
                child: Text(
                  error,
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
