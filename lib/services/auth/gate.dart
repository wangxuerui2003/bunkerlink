import 'package:bunkerlink/screens/login.dart';
import 'package:bunkerlink/screens/profile.dart';
import 'package:bunkerlink/services/auth/loginOrRegister.dart';
import 'package:bunkerlink/services/auth/service.dart';
import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:provider/provider.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      body: StreamBuilder<bool>(
        stream: authService.loginStatusStream,
        initialData: authService.isLoggedIn,
        builder: (context, snapshot) {
          if (snapshot.data ?? false) {
            return const ProfileScreen();
          } else {
            return const LoginOrRegister();
          }
        },
      ),
    );
  }
}
