import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AICoachScreen extends StatefulWidget {
  const AICoachScreen({super.key});

  @override
  State<AICoachScreen> createState() => _AICoachScreenState();
}

class _AICoachScreenState extends State<AICoachScreen> {
  final questionController = TextEditingController();
  String aiResponse =
      "Hello! I'm your BIG DREAM AI Coach. I'll motivate you every day to achieve your goals.";
  bool isLoading = false;

 static const String apiKey = String.fromEnvironment('GEMINI_API_KEY');

  Future<void> askAI() async {
    final question = questionController.text.trim();
    if (question.isEmpty) return;

    setState(() {
      isLoading = true;
    });

    try {
      final url = Uri.parse(
          "https://generativelanguage.googleapis.com/v1beta/models/gemini-flash-latest:generateContent");

      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "X-goog-api-key": apiKey,
        },
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {
                  "text":
                      "You are a motivational life coach called BIG DREAM AI Coach. Give short, encouraging, practical advice. User's question: $question"
                }
              ]
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final text = data['candidates'][0]['content']['parts'][0]['text'];
        setState(() {
          aiResponse = text;
        });
      } else {
        setState(() {
          aiResponse = "Sorry, I couldn't respond right now. Please try again.";
        });
      }
    } catch (e) {
      setState(() {
        aiResponse = "Something went wrong. Check your internet connection.";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
      questionController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "AI DREAM COACH",
          style: TextStyle(
            color: Colors.amber,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.amber,
                    child: Icon(
                      Icons.smart_toy,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: isLoading
                        ? const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: CircularProgressIndicator(
                              color: Colors.amber,
                            ),
                          )
                        : Text(
                            aiResponse,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: questionController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Ask your AI Coach...",
                hintStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.white10,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                ),
                onPressed: isLoading ? null : askAI,
                child: const Text(
                  "Ask AI",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Today's Motivation",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                "Dreams don't work unless you do. Every small step you take today brings you closer to your BIG DREAM.",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
