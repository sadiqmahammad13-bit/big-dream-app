import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  bool isClaiming = false;

  Future<void> claimReward(int currentCoins) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    setState(() {
      isClaiming = true;
    });

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .update({
      'coins': currentCoins + 50,
    });

    setState(() {
      isClaiming = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("You claimed 50 coins! 🎉")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: const Text(
          "BIG DREAM WALLET",
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
                final coins = data?['coins'] ?? 0;

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(25),
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            const Icon(
                              Icons.account_balance_wallet,
                              size: 60,
                              color: Colors.black,
                            ),
                            const SizedBox(height: 15),
                            Text(
                              "$coins Coins",
                              style: const TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const Text(
                              "Available Balance",
                              style: TextStyle(
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      ListTile(
                        tileColor: Colors.white10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        leading: const Icon(Icons.card_giftcard,
                            color: Colors.amber),
                        title: const Text(
                          "Daily Reward",
                          style: TextStyle(color: Colors.white),
                        ),
                        subtitle: const Text(
                          "Claim 50 FREE Coins",
                          style: TextStyle(color: Colors.grey),
                        ),
                        trailing: ElevatedButton(
                          onPressed:
                              isClaiming ? null : () => claimReward(coins),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber,
                          ),
                          child: isClaiming
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    color: Colors.black,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  "Claim",
                                  style: TextStyle(color: Colors.black),
                                ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ListTile(
                        tileColor: Colors.white10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        leading: const Icon(Icons.workspace_premium,
                            color: Colors.amber),
                        title: const Text(
                          "Premium Membership",
                          style: TextStyle(color: Colors.white),
                        ),
                        subtitle: const Text(
                          "Unlock all premium features",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
