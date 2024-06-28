import 'dart:async';
import 'package:bunkerlink/models/message.dart';
import 'package:bunkerlink/services/pocketbase.dart';
import 'package:geolocator/geolocator.dart';
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
      userId: client.authStore.model?.id,
    );

    try {
      await client.collection('messages').create(body: newMessage.toJson());
      final user =
          await client.collection('users').getOne(client.authStore.model!.id);
      List<dynamic> userMessages = user.data['messages'] ?? [];
      userMessages.add(newMessage.toJson());
      await client
          .collection('users')
          .update(client.authStore.model!.id, body: {'messages': userMessages});
    } on ClientException catch (error) {
      throw error.response['message'];
    }
  }

  Future<void> sendSOS(Position position) async {
    Message newMessage = Message(
      text: "SOS: ${position.latitude}, ${position.longitude}",
      userId: null,
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
          .getList(page: 1, perPage: 50, expand: 'userId');
      List<Message> messages =
          response.items.map((e) => Message.fromJson(e.toJson())).toList();
      _messages.addAll(messages);
      _messagesController.add(messages);
      return messages;
    } on ClientException catch (e) {
      throw e.response['message'];
    }
  }

  void subscribeToMessages() {
    client.collection('messages').subscribe('*', (e) async {
      RecordModel msgModel = await client
          .collection('messages')
          .getOne(e.record!.id, expand: 'userId');
      _messages.add(Message.fromJson(msgModel.toJson()));
      _messagesController.add(_messages);
    });
  }

  Stream<List<Message>> get messagesStream => _messagesController.stream;

  void unsubscribeFromMessages() {
    _messagesController.close();
    client.collection('messages').unsubscribe('*');
  }
}
