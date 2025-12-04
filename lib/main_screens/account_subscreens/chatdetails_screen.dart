import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import '../../providers/auth_provider.dart';
import '../../providers/chat_provider.dart';

class ChatDetailScreen extends ConsumerStatefulWidget {
  final String name;
  final Color avatarColor;
  final String chatId;
  final String otherUserId;

  const ChatDetailScreen({
    Key?  key,
    required this.name,
    required this.avatarColor,
    required this.chatId,
    required this.otherUserId,
  }) : super(key: key);

  @override
  ConsumerState<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends ConsumerState<ChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // Gemini AI setup
  static const String _apiKey = 'AIzaSyAJ0S0GUTnZtBO4n2T24YreKWFCcZQWz1M';
  late final GenerativeModel _model;
  bool _isAiTyping = false;

  @override
  void initState() {
    super.initState();
    _model = GenerativeModel(
      model: 'gemini-pro',
      apiKey: _apiKey,
    );
    _markAsRead();
  }

  void _markAsRead() async {
    final currentUser = ref.read(authStateProvider). value;
    if (currentUser != null) {
      final chatService = ref.read(chatServiceProvider);
      await chatService.markMessagesAsRead(widget.chatId, currentUser.uid);
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    if (_messageController. text.trim().isEmpty) return;

    final currentUser = ref.read(authStateProvider).value;
    if (currentUser == null) return;

    final chatService = ref. read(chatServiceProvider);
    final messageText = _messageController.text. trim();
    _messageController.clear();

    try {
      await chatService.sendMessage(
        chatId: widget.chatId,
        senderId: currentUser. uid,
        senderName: currentUser.displayName ??  'User',
        text: messageText,
      );

      _scrollToBottom();

      // Trigger AI auto-reply after 1 second
      _generateAiResponse(messageText);
    } catch (e) {
      _showSnackBar('Error sending message: $e');
    }
  }

  Future<void> _generateAiResponse(String userMessage) async {
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isAiTyping = true;
    });

    try {
      final prompt = '''
You are a helpful assistant for GetCars, a car marketplace app. A user just sent you this message: "$userMessage"

Respond in a friendly, helpful way about cars, buying/selling vehicles, or general chat. Keep responses concise (1-3 sentences). If they're asking about a specific car or feature, be enthusiastic and helpful.

Examples:
- If they ask about a car: Provide helpful info about features, pricing tips, or what to look for
- If they greet you: Greet back warmly and ask how you can help with their car needs
- If they ask about the app: Explain GetCars features clearly
- General chat: Be friendly and conversational

Your response:''';

      final content = [Content. text(prompt)];
      final response = await _model.generateContent(content);
      final aiReply = response.text ??  'Sorry, I couldn\'t process that. Can you try again?';

      final chatService = ref.read(chatServiceProvider);
      await chatService.sendMessage(
        chatId: widget.chatId,
        senderId: widget.otherUserId,
        senderName: widget.name,
        text: aiReply,
        isAiGenerated: true,
      );

      _scrollToBottom();
    } catch (e) {
      print('Error generating AI response: $e');

      final fallbackResponse = _getFallbackResponse(userMessage);
      final chatService = ref.read(chatServiceProvider);
      await chatService.sendMessage(
        chatId: widget.chatId,
        senderId: widget.otherUserId,
        senderName: widget.name,
        text: fallbackResponse,
        isAiGenerated: false,
      );
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
      return 'Prices vary by model and condition. You can filter by price range in the search.  What\'s your budget?';
    } else if (lowerMessage. contains('buy') || lowerMessage.contains('purchase')) {
      return 'Great!  Browse our listings, favorite the ones you like, and message sellers directly through the app. ';
    } else if (lowerMessage.contains('sell')) {
      return 'To sell your car, go to the Sell tab, add photos and details, then post your listing.  It\'s free!';
    } else if (lowerMessage.contains('how are you') || lowerMessage.contains('how r u')) {
      return 'I\'m doing great, thanks for asking! Ready to help you find the perfect car.  What are you looking for?';
    } else {
      return 'That\'s interesting! Is there anything specific about cars or our app I can help you with?';
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 100), () {
        _scrollController. animateTo(
          _scrollController. position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF1E3A5F),
      ),
    );
  }

  String _formatTime(DateTime time) {
    return DateFormat('h:mm a').format(time);
  }

  @override
  Widget build(BuildContext context) {
    final messagesAsync = ref.watch(chatMessagesProvider(widget.chatId));
    final currentUser = ref.watch(authStateProvider). value;

    return Scaffold(
      backgroundColor: const Color(0xFFE8C87C),
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
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.menu,
                          color: Color(0xFF1E3A5F),
                        ),
                        onPressed: () => _showOptionsMenu(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // User Info
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E3A5F),
                      borderRadius: BorderRadius.circular(12),
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
                                  Icons. psychology,
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
                                      color: Colors. purple,
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
            // Messages List
            Expanded(
              child: messagesAsync.when(
                data: (messages) {
                  if (messages.isEmpty) {
                    return const Center(
                      child: Text(
                        'No messages yet\nStart the conversation! ',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF1E3A5F),
                          fontSize: 16,
                        ),
                      ),
                    );
                  }

                  // Auto-scroll to bottom
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _scrollToBottom();
                  });

                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    reverse: true,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      final isMe = message.senderId == currentUser?.uid;

                      return Align(
                        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size. width * 0.7,
                          ),
                          decoration: BoxDecoration(
                            color: isMe
                                ? Colors.white
                                : message.isAiGenerated
                                ?  const Color(0xFF2C4A6F)
                                : const Color(0xFF1E3A5F),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: message.isAiGenerated
                                ? [
                              BoxShadow(
                                color: Colors.purple. withOpacity(0.3),
                                blurRadius: 8,
                                spreadRadius: 1,
                              )
                            ]
                                : null,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (message.isAiGenerated && !isMe)
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
                                message.text,
                                style: TextStyle(
                                  color: isMe ?  const Color(0xFF1E3A5F) : Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _formatTime(message.timestamp),
                                style: TextStyle(
                                  fontSize: 10,
                                  color: isMe ? Colors.grey[600] : Colors.grey[300],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFF1E3A5F),
                  ),
                ),
                error: (error, stack) => Center(
                  child: Text('Error: $error'),
                ),
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
            // Message Input
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
                      _showSnackBar('Attachment feature coming soon!');
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

  void _showOptionsMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.red),
              title: const Text('Delete Chat', style: TextStyle(color: Colors.red)),
              onTap: () async {
                Navigator.pop(context);
                final currentUser = ref.read(authStateProvider).value;
                if (currentUser != null) {
                  final chatService = ref.read(chatServiceProvider);
                  await chatService.deleteChat(widget.chatId, currentUser.uid);
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}