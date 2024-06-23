import 'package:bunkerlink/env/environment.dart';
import 'package:bunkerlink/services/pocketbase.dart';
import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:provider/provider.dart';

class MessageService {
  final PocketBase client = PocketBaseClient().client;

  MessageService();

  Future<void> sendMessage(String message) async {
    await client.collection('users').authRefresh();
    try {
      await client.collection('messages').create(body: {
        "content": message,
        'owner': client.authStore.model.id,
      });
    } on ClientException catch (error) {
      throw error.response['message'];
    }
  }
}
