import 'dart:async';

import 'package:bunkerlink/models/message.dart';
import 'package:bunkerlink/services/pocketbase.dart';
import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';

class ChatService {
  final PocketBase client = PocketBaseClient().client;
  final StreamController<List<Message>> _messagesController =
      StreamController<List<Message>>.broadcast();
  final List<Message> _messages = [];

  ChatService();

  Future<void> initMessages() async {
    List<Message> messages = await getNextPageMessages();
    _messagesController.add(messages);
  }

  Future<void> sendMessage(String message) async {
    Message newMessage = Message(
      text: message,
      senderId: client.authStore.model?.id,
    );

    try {
      await client.collection('messages').create(body: newMessage.toJson());
    } on ClientException catch (error) {
      throw error.response['message'];
    }
  }

  Future<List<Message>> getNextPageMessages() async {
    try {
      final response = await client
          .collection('messages')
          .getList(page: 1, perPage: 50, expand: 'sender');
      List<Message> messages =
          response.items.map((e) => Message.fromJson(e.data)).toList();
      _messages.addAll(messages);
      _messagesController.add(messages);
      return messages;
    } on ClientException catch (e) {
      throw e.response['message'];
    }
  }

  void subscribeToMessages() {
    client.collection('messages').subscribe('*', (e) {
      _messages.add(Message.fromJson(e.record!.data));
      _messagesController.add(_messages);
    });
  }

  Stream<List<Message>> get messagesStream => _messagesController.stream;

  @override
  void dispose() {
    _messagesController.close();
    client.collection('messages').unsubscribe('*');
  }
}
