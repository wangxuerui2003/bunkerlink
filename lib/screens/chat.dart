import 'package:bunkerlink/services/message/service.dart';
import 'package:bunkerlink/widgets/CustomBottomNavigationBar.dart';
import 'package:bunkerlink/widgets/MyTextField.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageTextController = TextEditingController();
  final List<String> _messages = [];
  final FocusNode _focusNode = FocusNode();
  final MessageService _messageService = MessageService();

  @override
  void initState() {
    super.initState();
  }

  void _sendMessage() async {
    if (_messageTextController.text.isNotEmpty) {
      try {
        await _messageService.sendMessage(_messageTextController.text);
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.toString()),
          ),
        );
      }
      setState(() {
        _messages.add(_messageTextController.text);
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
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_messages[index]),
                );
              },
            ),
          ),
          _buildInputBar(),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {},
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
}
