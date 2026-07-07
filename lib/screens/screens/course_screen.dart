import 'package:flutter/material.dart';

class CourseScreen extends StatelessWidget {
  const CourseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "BIG DREAM ACADEMY",
          style: TextStyle(
            color: Colors.amber,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            "Continue Learning",
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 25),
          courseCard(
            "Mindset Mastery",
            "Build a strong success mindset.",
            Icons.psychology,
          ),
          courseCard(
            "Business Basics",
            "Learn how to start a business.",
            Icons.business_center,
          ),
          courseCard(
            "Money Management",
            "Control your money wisely.",
            Icons.account_balance_wallet,
          ),
          courseCard(
            "Public Speaking",
            "Speak with confidence.",
            Icons.mic,
          ),
          courseCard(
            "Leadership",
            "Become a great leader.",
            Icons.groups,
          ),
        ],
      ),
    );
  }

  Widget courseCard(
    String title,
    String subtitle,
    IconData icon,
  ) {
    return Card(
      color: Colors.white10,
      margin: const EdgeInsets.only(bottom: 18),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.amber, size: 35),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(color: Colors.grey),
        ),
        trailing: const Icon(
          Icons.play_circle_fill,
          color: Colors.amber,
        ),
      ),
    );
  }
}
