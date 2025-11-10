import 'package:flutter/material.dart';
import 'account_subscreens/chat_list_screen.dart';
import 'account_subscreens/feedback_screen.dart';
import 'account_subscreens/notifications_screen.dart';
import 'account_subscreens/faq_screen.dart';
import 'account_subscreens/about_screen.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header Section with Profile
              Container(
                width: double.infinity,
                color: const Color(0xFFE8C87C),
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Top Bar with Logo and Menu
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
                        IconButton(
                          icon: const Icon(
                            Icons.menu,
                            color: Color(0xFF1E3A5F),
                          ),
                          onPressed: () {},
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    // Profile Picture
                    Container(
                      width: 120,
                      height: 120,
                      decoration: const BoxDecoration(
                        color: Color(0xFF1E3A5F),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person,
                        size: 70,
                        color: Color(0xFFE8C87C),
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Upload Image Button
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Upload Image',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1E3A5F),
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              // Menu Items
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildMenuItem(
                      context,
                      'E Mail ID',
                      Icons.email_outlined,
                          () {},
                    ),
                    const SizedBox(height: 12),
                    _buildMenuItem(
                      context,
                      'Phone number',
                      Icons.phone_outlined,
                          () {},
                    ),
                    const SizedBox(height: 12),
                    _buildMenuItem(
                      context,
                      'Chats',
                      Icons.chat_outlined,
                          () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ChatListScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildMenuItem(
                      context,
                      'Feedback',
                      Icons.chat_bubble_outline,
                          () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const FeedbackScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildMenuItem(
                      context,
                      'Notifications',
                      Icons.notifications_outlined,
                          () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const NotificationsScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildMenuItem(
                      context,
                      "FAQ's",
                      Icons.help_outline,
                          () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const FaqScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildMenuItem(
                      context,
                      'About',
                      Icons.info_outline,
                          () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AboutScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    _buildMenuItem(
                      context,
                      'Log out',
                      Icons.logout_outlined,
                          () {
                        // Add logout functionality here
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(
      BuildContext context,
      String title,
      IconData icon,
      VoidCallback onPressed,
      ) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(25),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1E3A5F),
                  ),
                ),
                Icon(
                  icon,
                  color: const Color(0xFF1E3A5F),
                  size: 24,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}