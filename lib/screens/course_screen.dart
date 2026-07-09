import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CourseScreen extends StatelessWidget {
  const CourseScreen({super.key});

  Future<void> completeCourse(
      BuildContext context, String courseId, int currentXp) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final userRef =
        FirebaseFirestore.instance.collection('users').doc(user.uid);
    final doc = await userRef.get();
    final completed =
        List<String>.from(doc.data()?['completedCourses'] ?? []);

    if (completed.contains(courseId)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("You already completed this course!")),
      );
      return;
    }

    completed.add(courseId);
    await userRef.update({
      'completedCourses': completed,
      'xp': currentXp + 20,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Course completed! +20 XP 🎉")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

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
      body: user == null
          ? const Center(
              child: Text(
                "Not logged in.",
                style: TextStyle(color: Colors.white),
              ),
            )
          : StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.amber),
                  );
                }

                final data = snapshot.data!.data() as Map<String, dynamic>?;
                final xp = data?['xp'] ?? 0;
                final completed =
                    List<String>.from(data?['completedCourses'] ?? []);

                final courses = [
                  {
                    'id': 'mindset',
                    'title': 'Mindset Mastery',
                    'subtitle': 'Build a strong success mindset.',
                    'icon': Icons.psychology,
                  },
                  {
                    'id': 'business',
                    'title': 'Business Basics',
                    'subtitle': 'Learn how to start a business.',
                    'icon': Icons.business_center,
                  },
                  {
                    'id': 'money',
                    'title': 'Money Management',
                    'subtitle': 'Control your money wisely.',
                    'icon': Icons.account_balance_wallet,
                  },
                  {
                    'id': 'speaking',
                    'title': 'Public Speaking',
                    'subtitle': 'Speak with confidence.',
                    'icon': Icons.mic,
                  },
                  {
                    'id': 'leadership',
                    'title': 'Leadership',
                    'subtitle': 'Become a great leader.',
                    'icon': Icons.groups,
                  },
                ];

                return ListView(
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
                    ...courses.map((course) {
                      final isDone = completed.contains(course['id']);
                      return Card(
                        color: Colors.white10,
                        margin: const EdgeInsets.only(bottom: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: ListTile(
                          leading: Icon(course['icon'] as IconData,
                              color: Colors.amber, size: 35),
                          title: Text(
                            course['title'] as String,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            course['subtitle'] as String,
                            style: const TextStyle(color: Colors.grey),
                          ),
                          trailing: IconButton(
                            icon: Icon(
                              isDone
                                  ? Icons.check_circle
                                  : Icons.play_circle_fill,
                              color: isDone ? Colors.green : Colors.amber,
                            ),
                            onPressed: () => completeCourse(
                                context, course['id'] as String, xp),
                          ),
                        ),
                      );
                    }),
                  ],
                );
              },
            ),
    );
  }
}
