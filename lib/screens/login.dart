import 'package:bunkerlink/services/auth/service.dart';
import 'package:bunkerlink/widgets/MyButton.dart';
import 'package:bunkerlink/widgets/MyTextField.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  final void Function()? onTap;
  const LoginScreen({
    super.key,
    required this.onTap,
  });

  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void handleLogin() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final email = emailController.text;
    final password = passwordController.text;

    try {
      await authService.login(email, password);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
          backgroundColor: Colors.red,
        ),
      );
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

              // email field
              MyTextField(
                controller: emailController,
                hintText: 'Email',
                obscureText: false,
                decoration: InputDecoration(
                  labelText: 'Username or Email',
                  prefixIcon:
                      const Icon(Icons.person, color: Colors.lightGreen),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),

              const SizedBox(height: 20.0),

              // password field
              MyTextField(
                controller: passwordController,
                hintText: "password",
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock, color: Colors.lightGreen),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),

              const SizedBox(height: 20.0),

              // login button
              MyButton(onTap: handleLogin, text: "Sign In"),

              const SizedBox(height: 20.0),

              // not a member? register now
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Not a member?"),
                  const SizedBox(width: 4),
                  TextButton(
                    onPressed: widget.onTap,
                    child: const Text("Register now"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
