import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class ChatDetailScreen extends StatefulWidget {
  final String name;
  final Color avatarColor;
  final String chatId;
  final String otherUserId;

  const ChatDetailScreen({
    Key? key,
    required this.name,
    required this. avatarColor,
    required this.chatId,
    required this.otherUserId,
  }) : super(key: key);

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Gemini AI setup - Get your API key from: https://makersuite.google.com/app/apikey
  static const String _apiKey = 'AIzaSyAJ0S0GUTnZtBO4n2T24YreKWFCcZQWz1M'; // Replace with your API key
  late final GenerativeModel _model;
  bool _isAiTyping = false;

  @override
  void initState() {
    super.initState();
    // Initialize Gemini AI model
    _model = GenerativeModel(
      model: 'gemini-pro',
      apiKey: _apiKey,
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    final currentUser = _auth.currentUser;
    if (currentUser == null) return;

    final messageText = _messageController.text. trim();
    _messageController.clear();

    try {
      // Add user message to Firestore
      await _firestore
          .collection('chats')
          .doc(widget.chatId)
          .collection('messages')
          .add({
        'text': messageText,
        'senderId': currentUser.uid,
        'senderName': currentUser.email?.split('@')[0] ?? 'User',
        'timestamp': FieldValue.serverTimestamp(),
        'isRead': false,
      });

      // Update chat metadata
      await _firestore. collection('chats').doc(widget.chatId).set({
        'lastMessage': messageText,
        'lastMessageTime': FieldValue.serverTimestamp(),
        'participants': [currentUser.uid, widget.otherUserId],
      }, SetOptions(merge: true));

      _scrollToBottom();

      // Trigger AI auto-reply after 1 second
      _generateAiResponse(messageText);
    } catch (e) {
      debugPrint('Error sending message: $e');
      if (mounted) {
        ScaffoldMessenger.of(context). showSnackBar(
          const SnackBar(content: Text('Failed to send message')),
        );
      }
    }
  }

  Future<void> _generateAiResponse(String userMessage) async {
    // Wait 1 second before responding
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isAiTyping = true;
    });

    try {
      // Create a context-aware prompt for car marketplace conversations
      final prompt = '''
You are a helpful assistant for GetCars, a car marketplace app. A user just sent you this message: "$userMessage"

Respond in a friendly, helpful way about cars, buying/selling vehicles, or general chat.  Keep responses concise (1-3 sentences).  If they're asking about a specific car or feature, be enthusiastic and helpful.

Examples:
- If they ask about a car: Provide helpful info about features, pricing tips, or what to look for
- If they greet you: Greet back warmly and ask how you can help with their car needs
- If they ask about the app: Explain GetCars features clearly
- General chat: Be friendly and conversational

Your response:''';

      final content = [Content.text(prompt)];
      final response = await _model. generateContent(content);
      final aiReply = response.text ??  'Sorry, I couldn\'t process that.  Can you try again?';

      // Send AI response to Firestore
      await _firestore
          .collection('chats')
          . doc(widget.chatId)
          .collection('messages')
          . add({
        'text': aiReply,
        'senderId': widget.otherUserId,
        'senderName': widget.name,
        'timestamp': FieldValue.serverTimestamp(),
        'isRead': false,
        'isAiGenerated': true, // Mark as AI response
      });

      // Update chat metadata
      await _firestore. collection('chats').doc(widget.chatId).set({
        'lastMessage': aiReply,
        'lastMessageTime': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      _scrollToBottom();
    } catch (e) {
      debugPrint('Error generating AI response: $e');

      // Fallback to simple responses if AI fails
      final fallbackResponse = _getFallbackResponse(userMessage);
      await _firestore
          .collection('chats')
          .doc(widget.chatId)
          . collection('messages')
          .add({
        'text': fallbackResponse,
        'senderId': widget.otherUserId,
        'senderName': widget. name,
        'timestamp': FieldValue.serverTimestamp(),
        'isRead': false,
      });
    } finally {
      setState(() {
        _isAiTyping = false;
      });
    }
  }

  String _getFallbackResponse(String message) {
    final lowerMessage = message.toLowerCase();

    if (lowerMessage.contains('hello') || lowerMessage.contains('hi') || lowerMessage.contains('hey')) {
      return 'Hello! How can I help you with your car search today?  🚗';
    } else if (lowerMessage.contains('price') || lowerMessage.contains('cost')) {
      return 'Prices vary by model and condition. You can filter by price range in the search.  What\'s your budget? ';
    } else if (lowerMessage.contains('buy') || lowerMessage.contains('purchase')) {
      return 'Great! Browse our listings, favorite the ones you like, and message sellers directly through the app. ';
    } else if (lowerMessage.contains('sell')) {
      return 'To sell your car, go to the Sell tab, add photos and details, then post your listing. It\'s free!';
    } else if (lowerMessage.contains('how are you') || lowerMessage.contains('how r u')) {
      return 'I\'m doing great, thanks for asking! Ready to help you find the perfect car.  What are you looking for?';
    } else {
      return 'That\'s interesting!  Is there anything specific about cars or our app I can help you with?';
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 100), () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = _auth.currentUser?. uid;

    return Scaffold(
      backgroundColor: const Color(0xFFE8C87C),
      body: SafeArea(
        child: Column(
          children: [
            // Header with Back Button and Name
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
                              borderRadius: BorderRadius. circular(8),
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
                          IconButton(
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Color(0xFF1E3A5F),
                            ),
                            onPressed: () {
                              Navigator. pop(context);
                            },
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
                  const SizedBox(height: 16),
                  // User Info
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E3A5F),
                      borderRadius: BorderRadius. circular(12),
                    ),
                    child: Row(
                      children: [
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: widget.avatarColor,
                              child: const Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                            // AI Badge
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: const BoxDecoration(
                                  color: Colors.green,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.psychology,
                                  color: Colors.white,
                                  size: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    widget.name,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.purple,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Text(
                                      'AI',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              if (_isAiTyping)
                                const Text(
                                  'typing...',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.greenAccent,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const Text(
                          'Online',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors. green,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Chat Messages Area with Real-time Updates
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    . collection('chats')
                    .doc(widget.chatId)
                    .collection('messages')
                    .orderBy('timestamp', descending: false)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  final messages = snapshot.data?.docs ?? [];

                  if (messages.isEmpty) {
                    return const Center(
                      child: Text(
                        'No messages yet.  Start the conversation!',
                        style: TextStyle(
                          color: Color(0xFF1E3A5F),
                          fontSize: 16,
                        ),
                      ),
                    );
                  }

                  // Auto-scroll to bottom when new message arrives
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _scrollToBottom();
                  });

                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final messageData =
                      messages[index].data() as Map<String, dynamic>;
                      final isMe = messageData['senderId'] == currentUserId;
                      final messageText = messageData['text'] ??  '';
                      final timestamp = messageData['timestamp'] as Timestamp? ;
                      final isAiGenerated = messageData['isAiGenerated'] ?? false;

                      String timeString = '';
                      if (timestamp != null) {
                        final dateTime = timestamp.toDate();
                        timeString =
                        '${dateTime. hour}:${dateTime.minute.toString().padLeft(2, '0')}';
                      }

                      return Column(
                        children: [
                          if (index == 0 ||
                              _shouldShowTimestamp(messages, index, timestamp))
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Center(
                                child: Text(
                                  timeString,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ),
                            ),
                          // Message bubble
                          Align(
                            alignment: isMe
                                ?  Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                              constraints: BoxConstraints(
                                maxWidth:
                                MediaQuery.of(context).size.width * 0.7,
                              ),
                              decoration: BoxDecoration(
                                color: isMe
                                    ? Colors.white
                                    : isAiGenerated
                                    ? const Color(0xFF2C4A6F)
                                    : const Color(0xFF1E3A5F),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: isAiGenerated
                                    ?  [
                                  BoxShadow(
                                    color: Colors.purple.withOpacity(0.3),
                                    blurRadius: 8,
                                    spreadRadius: 1,
                                  )
                                ]
                                    : null,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (isAiGenerated && !isMe)
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 4),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: const [
                                          Icon(
                                            Icons.psychology,
                                            size: 12,
                                            color: Colors.purpleAccent,
                                          ),
                                          SizedBox(width: 4),
                                          Text(
                                            'AI Response',
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.purpleAccent,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  Text(
                                    messageText,
                                    style: TextStyle(
                                      color: isMe
                                          ?  const Color(0xFF1E3A5F)
                                          : Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
            // Typing indicator
            if (_isAiTyping)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E3A5F),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildTypingDot(0),
                          const SizedBox(width: 4),
                          _buildTypingDot(1),
                          const SizedBox(width: 4),
                          _buildTypingDot(2),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            // Message Input Area
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: TextField(
                        controller: _messageController,
                        decoration: const InputDecoration(
                          hintText: 'Type here',
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                        onSubmitted: (_) => _sendMessage(),
                        textInputAction: TextInputAction.send,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.attach_file, color: Colors.grey),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Attachment feature coming soon!')),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.send,
                      color: Color(0xFF1E3A5F),
                    ),
                    onPressed: _sendMessage,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypingDot(int index) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 600),
      builder: (context, double value, child) {
        return Transform.translate(
          offset: Offset(0, -5 * (value * (index % 2 == 0 ?  1 : -1))),
          child: Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape. circle,
            ),
          ),
        );
      },
    );
  }

  bool _shouldShowTimestamp(
      List<QueryDocumentSnapshot> messages, int index, Timestamp?  timestamp) {
    if (index == 0 || timestamp == null) return true;

    final prevTimestamp =
    (messages[index - 1].data() as Map<String, dynamic>)['timestamp']
    as Timestamp?;
    if (prevTimestamp == null) return true;

    final timeDiff =
        timestamp.toDate().difference(prevTimestamp. toDate()).inMinutes;
    return timeDiff > 5;
  }
}