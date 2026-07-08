import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
          "PROFILE",
          style: TextStyle(
            color: Colors.amber,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
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
                final name = data?['name'] ?? 'BIG DREAM User';
                final coins = data?['coins'] ?? 0;
                final xp = data?['xp'] ?? 0;
                final level = data?['level'] ?? 1;
                final streak = data?['streak'] ?? 0;

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.amber,
                        child: Icon(
                          Icons.person,
                          size: 70,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        user.email ?? '',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 30),
                      Row(
                        children: [
                          Expanded(
                            child: profileCard(
                              "Level",
                              "$level",
                              Icons.workspace_premium,
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: profileCard(
                              "Coins",
                              "$coins",
                              Icons.monetization_on,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: profileCard(
                              "XP",
                              "$xp",
                              Icons.star,
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: profileCard(
                              "Streak",
                              "$streak Days",
                              Icons.local_fire_department,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      ListTile(
                        leading: const Icon(Icons.flag, color: Colors.amber),
                        title: const Text(
                          "My Goals",
                          style: TextStyle(color: Colors.white),
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios,
                            color: Colors.grey),
                        onTap: () {},
                      ),
                      ListTile(
                        leading:
                            const Icon(Icons.settings, color: Colors.amber),
                        title: const Text(
                          "Settings",
                          style: TextStyle(color: Colors.white),
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios,
                            color: Colors.grey),
                        onTap: () {},
                      ),
                      ListTile(
                        leading: const Icon(Icons.logout, color: Colors.red),
                        title: const Text(
                          "Logout",
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () async {
                          await FirebaseAuth.instance.signOut();
                          if (context.mounted) {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const LoginScreen()),
                              (route) => false,
                            );
                          }
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  Widget profileCard(
    String title,
    String value,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: Colors.amber,
            size: 35,
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
