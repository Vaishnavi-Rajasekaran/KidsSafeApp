import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _messages = [];

  Future<void> sendMessage() async {
    final messageText = _controller.text.trim();
    if (messageText.isEmpty) return;

    setState(() {
      _messages.add("You: $messageText");
    });

    final url = Uri.parse('http://172.16.46.2:5000/check_message'); // Backend IP
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'message': messageText}),
      );

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        if (result['flagged'] == true) {
          setState(() {
            _messages.add("⚠️ Alert sent to parent.");
          });
        } else {
          setState(() {
            _messages.add("✅ Message checked, no issues.");
          });
        }
      } else {
        setState(() {
          _messages.add("❌ Server error: ${response.statusCode}");
        });
      }
    } catch (e) {
      setState(() {
        _messages.add("❌ Could not connect to backend.");
      });
      print('Error: $e');
    }

    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chat Monitor')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _messages.length,
                itemBuilder: (context, index) => ListTile(
                  title: Text(_messages[index]),
                ),
              ),
            ),
            TextField(
              controller: _controller,
              decoration: InputDecoration(labelText: 'Type your message'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: sendMessage,
              child: Text('Send'),
            ),
          ],
        ),
      ),
    );
  }
}
