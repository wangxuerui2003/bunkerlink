import 'dart:async';
import 'package:bunkerlink/models/user.dart';
import 'package:bunkerlink/services/pocketbase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pocketbase/pocketbase.dart';

class AuthService with ChangeNotifier {
  final PocketBase client = PocketBaseClient().client;
  static const _storage = FlutterSecureStorage();

  StreamController<bool> loginStatusController =
      StreamController<bool>.broadcast();
  Stream<bool> get loginStatusStream => loginStatusController.stream;

  AuthService() {
    _loadAndApplyAuthToken();
    client.authStore.onChange.listen((e) {
      loginStatusController.add(client.authStore.isValid);
      notifyListeners();
    });
  }

  Future<void> _saveAuthToken(String? token) async {
    if (token == null) {
      await _storage.delete(key: 'authToken');
    } else {
      await _storage.write(key: 'authToken', value: token);
    }
  }

  Future<void> _loadAndApplyAuthToken() async {
    final token = await _storage.read(key: 'authToken');
    if (token != null) {
      client.authStore.save(token, null);
      RecordAuth model = await client.collection('users').authRefresh();
      client.authStore.save(token, model.record);
    }
  }

  bool get isLoggedIn => client.authStore.isValid;

  Future<RecordAuth> login(String usernameOrEmail, String password) async {
    try {
      final authData = await client
          .collection('users')
          .authWithPassword(usernameOrEmail, password);
      await _saveAuthToken(authData.token);
      client.authStore.save(authData.token, authData.record);
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

  Future<User> getUser() async {
    if (!client.authStore.isValid) {
      return User(
        id: '',
        nickname: '',
        username: '',
        email: '',
      );
    }
    final record =
        await client.collection('users').getOne(client.authStore.model?.id);
    final user = User.fromJson(record.toJson());
    final avatarFilename = record.getListValue<String>('avatar').first;
    if (avatarFilename != "") {
      final avatarUrl =
          client.files.getUrl(record, avatarFilename, thumb: '100x250');
      user.setAvatar(avatarUrl.toString());
    }
    return user;
  }

  void logout() {
    client.authStore.clear();
    _saveAuthToken(null);
  }

  @override
  void dispose() {
    loginStatusController.close();
    super.dispose();
  }
}
