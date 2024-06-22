import 'package:bunkerlink/env/environment.dart';
import 'package:pocketbase/pocketbase.dart';

class AuthService {
  static final PocketBase client = PocketBase(Environment.pocketbaseUri);

  static bool isLoggedIn() {
    return client.authStore.isValid;
  }

  static Future<Map<String, dynamic>> login(String usernameOrEmail, String password) async {
    try {
      final authData = await client.collection('users').authWithPassword(
        usernameOrEmail,
        password
      );
      return {
        'status': 'success',
        'data': authData
      };
    } catch (error) {
      return {
        'status': 'failed',
        'data': error
      };
    }
  }

  static Future<Map<String, dynamic>> register(String username, String email, String password, String nickname) async {
    final body = <String, dynamic> {
      "username": username,
      "email": email,
      "emailVisibility": true,
      "password": password,
      "passwordConfirm": password,
      "nickname": nickname,
    };

    try {
      final record = await client.collection('users').create(body: body);
      return {
        'status': 'success',
        'data': record
      };
    } catch (error) {
      return {
        'status': 'failed',
        'data': error
      };
    }
  }

  static void logout() {
    client.authStore.clear();
  }
}
