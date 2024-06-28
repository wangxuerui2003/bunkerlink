import 'package:bunkerlink/models/message.dart';
import 'package:bunkerlink/services/chat/service.dart';
import 'package:bunkerlink/widgets/ChatBubble.dart';
import 'package:bunkerlink/widgets/CustomBottomNavigationBar.dart';
import 'package:bunkerlink/widgets/MyTextField.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pocketbase/pocketbase.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageTextController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ChatService _chatService = ChatService();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _initMessages();
    _chatService.subscribeToMessages();
  }

  Future<void> _initMessages() async {
    try {
      await _chatService.initMessages();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
        ),
      );
    }
  }

  void _sendMessage() async {
    if (_messageTextController.text.isNotEmpty) {
      try {
        await _chatService.sendMessage(_messageTextController.text);
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.toString()),
          ),
        );
      }
      setState(() {
        _messageTextController.clear();
        _focusNode.requestFocus();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(child: _buildMessageList()),
          _buildInputBar(),
        ],
      ),
    );
  }

  Widget _buildInputBar() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
      ),
      child: Row(
        children: [
          Expanded(
            child: MyTextField(
              controller: _messageTextController,
              hintText: 'Type a message',
              obscureText: false,
              focusNode: _focusNode,
              onSubmitted: (value) {
                _sendMessage();
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }

  // build message list
  Widget _buildMessageList() {
    return StreamBuilder(
      stream: _chatService.messagesStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Message> records = snapshot.data!;
          // Scroll to bottom on new data
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_scrollController.hasClients) {
              _scrollController.animateTo(
                _scrollController.position.maxScrollExtent,
                duration: Duration(milliseconds: 100),
                curve: Curves.easeOut,
              );
            }
          });
          return ListView.builder(
            controller: _scrollController,
            itemCount: records.length,
            itemBuilder: (context, index) {
              // Message message = records[index];
              return _buildMessageItem(records[index]);
            },
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  // build message item
  Widget _buildMessageItem(Message message) {
    // align sender message to the right and other messages to the left
    var alignment = message.userId == _chatService.client.authStore.model?.id
        ? Alignment.centerRight
        : Alignment.centerLeft;
    var crossAxisAlignment =
        message.userId == _chatService.client.authStore.model?.id
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start;
    var mainAxisAlignment =
        message.userId == _chatService.client.authStore.model?.id
            ? MainAxisAlignment.end
            : MainAxisAlignment.start;

    return Container(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: crossAxisAlignment,
          mainAxisAlignment: mainAxisAlignment,
          children: [
            Text(message.userData?['nickname'] ?? 'Unknown'),
            Chatbubble(text: message.text),
          ],
        ),
      ),
    );
  }
}