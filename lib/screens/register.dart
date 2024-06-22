import 'package:bunkerlink/widgets/MyButton.dart';
import 'package:bunkerlink/widgets/MyTextField.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  final void Function()? onTap;

  const RegisterScreen({
    super.key,
    required this.onTap,
  });

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmController = TextEditingController();

  void handleRegister() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
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

              // password confirm field
              MyTextField(
                controller: passwordConfirmController,
                hintText: "confirm password",
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  prefixIcon: const Icon(Icons.lock, color: Colors.lightGreen),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),

              const SizedBox(height: 20.0),

              // sign up button
              MyButton(onTap: handleRegister, text: "Sign up"),

              const SizedBox(height: 20.0),

              // not a member? register now
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already a member?"),
                  const SizedBox(width: 4),
                  TextButton(
                    onPressed: widget.onTap,
                    child: const Text("Login now"),
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
