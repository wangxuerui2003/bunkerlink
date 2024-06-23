import 'package:bunkerlink/services/pocketbase.dart';
import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';

class ChatService {
  final PocketBase client = PocketBaseClient().client;

  ChatService();

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
