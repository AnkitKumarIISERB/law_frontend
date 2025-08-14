import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

void main() => runApp(LawGPTApp());

class LawGPTApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JustiFYI - Indian Law Assistant',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF121212),
        primaryColor: Colors.teal,
        textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.white)),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey[900],
          border: const OutlineInputBorder(),
        ),
      ),
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => ChatScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/logo.jpg', width: 150, height: 150),
            const SizedBox(height: 20),
            const Text(
              'JustiFYI',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.teal),
            ),
            const SizedBox(height: 10),
            const Text(
              'Your Indian Law Assistant',
              style: TextStyle(fontSize: 18, color: Colors.white70),
            ),
            const SizedBox(height: 40),
            const Text(
              'Created by Ankit',
              style: TextStyle(color: Colors.white30),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatMessage {
  final String userInput;
  final String bnsSection;
  final String explanation;

  ChatMessage({
    required this.userInput,
    required this.bnsSection,
    required this.explanation,
  });
}

class ChatScreen extends StatefulWidget {
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;
  bool _isTyping = false;

  Future<void> _sendQuery(String query) async {
    if (query.trim().isEmpty) return;

    setState(() {
      _isLoading = true;
      _isTyping = true;
    });
    _controller.clear();

    try {
      final response = await http.post(
        Uri.parse("https://ankitkumariiserb-legal_chatbot_backend.hf.space/ask"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"query": query}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        setState(() {
          _messages.add(ChatMessage(
            userInput: query,
            bnsSection: data['section'],
            explanation: data['answer'],
          ));
        });
      } else {
        _showError("Server Error: ${response.statusCode}");
      }
    } catch (e) {
      _showError("⚠️ Could not connect to server.\n$e");
    } finally {
      setState(() {
        _isLoading = false;
        _isTyping = false;
      });
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('⚖️ JustiFYI'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Center(child: Text("Created by Ankit", style: TextStyle(fontSize: 12, color: Colors.white54))),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (_, index) {
                if (_isTyping && index == _messages.length) {
                  return const Text("💬 LawGPT is typing...", style: TextStyle(color: Colors.teal));
                }
                final msg = _messages[index];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("🧑 You: ${msg.userInput}", style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text("📘 BNS Section:\n${msg.bnsSection}"),
                    const SizedBox(height: 8),
                    Text("💬 Explanation:\n${msg.explanation}"),
                    Divider(height: 32, color: Colors.grey[700]),
                  ],
                );
              },
            ),
          ),
          if (_isLoading) const LinearProgressIndicator(),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    onSubmitted: _sendQuery,
                    decoration: const InputDecoration(hintText: "Ask about Indian law..."),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.teal),
                  onPressed: () => _sendQuery(_controller.text),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
