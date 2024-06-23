import 'package:bunkerlink/env/environment.dart';
import 'package:pocketbase/pocketbase.dart';

class PocketBaseClient {
  static final PocketBaseClient _instance = PocketBaseClient._internal();
  final PocketBase client = PocketBase(Environment.pocketbaseUri);

  factory PocketBaseClient() {
    return _instance;
  }

  PocketBaseClient._internal();
}
