import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chatdetails_screen.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({Key? key}) : super(key: key);

  String _generateChatId(String userId1, String userId2) {
    // Generate consistent chat ID regardless of order
    final ids = [userId1, userId2].. sort();
    return '${ids[0]}_${ids[1]}';
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance. currentUser?.uid ??  '';

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              color: const Color(0xFFE8C87C),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E3A5F),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'GC',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFE8C87C),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Get Cars',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF1E3A5F),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.search,
                              color: Color(0xFF1E3A5F),
                            ),
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.menu,
                              color: Color(0xFF1E3A5F),
                            ),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Chat Title
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Lets ',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E3A5F),
                        ),
                      ),
                      const Text(
                        'Chat',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.waving_hand,
                        color: Colors.orange[700],
                        size: 28,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            // Chat List
            Expanded(
              child: Container(
                color: const Color(0xFFE8C87C),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ListView(
                  children: [
                    _buildChatItem(
                      context,
                      'Mehak Akhtar',
                      'Hello',
                      '2 hours',
                      Colors.blue,
                      _generateChatId(currentUserId, 'user_mehak'),
                      'user_mehak',
                    ),
                    const SizedBox(height: 12),
                    _buildChatItem(
                      context,
                      'Aqsa',
                      'Hey!',
                      '4 hours',
                      Colors. orange,
                      _generateChatId(currentUserId, 'user_aqsa'),
                      'user_aqsa',
                    ),
                    const SizedBox(height: 12),
                    _buildChatItem(
                      context,
                      'Noor',
                      'How are uh?',
                      '10 hours',
                      Colors.green,
                      _generateChatId(currentUserId,'user_noor'),
                      'user_noor',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatItem(
      BuildContext context,
      String name,
      String lastMessage,
      String time,
      Color avatarColor,
      String chatId,
      String otherUserId,
      ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey. withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatDetailScreen(
                  name: name,
                  avatarColor: avatarColor,
                  chatId: chatId,
                  otherUserId: otherUserId,
                ),
              ),
            );
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: avatarColor,
                  child: const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight. bold,
                          color: Color(0xFF1E3A5F),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        lastMessage,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}