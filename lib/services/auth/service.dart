import 'dart:async';
import 'package:bunkerlink/env/environment.dart';
import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';

class AuthService with ChangeNotifier {
  final PocketBase client = PocketBase(Environment.pocketbaseUri);

  StreamController<bool> loginStatusController =
      StreamController<bool>.broadcast();
  Stream<bool> get loginStatusStream => loginStatusController.stream;

  AuthService() {
    client.authStore.onChange.listen((e) {
      loginStatusController.add(client.authStore.isValid);
      notifyListeners();
    });
  }

  bool get isLoggedIn => client.authStore.isValid;

  Future<RecordAuth> login(String usernameOrEmail, String password) async {
    try {
      final authData = await client
          .collection('users')
          .authWithPassword(usernameOrEmail, password);
      return authData;
    } on ClientException catch (error) {
      throw error.response['message'];
    }
  }

  Future<RecordAuth> register(
      String username, String email, String password, String nickname) async {
    final body = <String, dynamic>{
      "username": username,
      "email": email,
      "emailVisibility": true,
      "password": password,
      "passwordConfirm": password,
      "nickname": nickname,
    };

    try {
      await client.collection('users').create(body: body);
      return await login(email, password);
    } on ClientException catch (error) {
      final data = error.response['data'];
      throw "${data.keys.first}: ${data.values.first['message']}";
    }
  }

  void logout() {
    client.authStore.clear();
  }

  @override
  void dispose() {
    loginStatusController.close();
    super.dispose();
  }
}
