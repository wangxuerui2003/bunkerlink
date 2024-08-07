import 'package:bunkerlink/screens/profile.dart';
import 'package:bunkerlink/services/auth/loginOrRegister.dart';
import 'package:bunkerlink/services/auth/service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthGate extends StatelessWidget {
  final Widget screen;
  const AuthGate({super.key, this.screen = const ProfileScreen()});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      body: StreamBuilder<bool>(
        stream: authService.loginStatusStream,
        initialData: authService.isLoggedIn,
        builder: (context, snapshot) {
          if (snapshot.data ?? false) {
            return screen;
          } else {
            return const LoginOrRegister();
          }
        },
      ),
    );
  }
}
