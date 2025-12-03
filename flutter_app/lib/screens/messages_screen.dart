import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'dart:convert';
import 'dart:math';
import '../models/message.dart';
import '../constants/spacing.dart';
import '../constants/border_radius.dart';
import '../constants/colors.dart';

const kAgentResponses = [
  'How can I help?',
  'Let me look into that.',
  'Please give me a moment.',
  'That\'s a great question!',
  'Let me check on that for you.',
];

// Scroll constants
const kScrollDelay = Duration(milliseconds: 100);
const kScrollDuration = Duration(milliseconds: 300);
const kAgentReplyDelay = Duration(seconds: 1);
const kScrollThreshold = 50.0;
const kBubbleMaxWidth = 0.7;

// Font sizes
const kFontSizeSmall = 11.0;
const kFontSizeBadge = 12.0;
const kFontSizeMessage = 15.0;

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final _messages = <Message>[];
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  final _random = Random();
  var _unreadCount = 0;
  var _isAgentTyping = false;

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final messagesJson = prefs.getStringList('messages') ?? [];
    setState(() {
      _messages.clear();
      _messages.addAll(
        messagesJson.map((json) => Message.fromJson(jsonDecode(json))).toList(),
      );
    });
    _scrollToBottom();
  }

  Future<void> _saveMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final messagesJson = _messages.map((m) => jsonEncode(m.toJson())).toList();
    await prefs.setStringList('messages', messagesJson);
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    _addMessage(text, isUser: true);
    _controller.clear();
    _simulateAgentReply();
  }

  void _addMessage(String text, {required bool isUser}) {
    final message = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      isUser: isUser,
      timestamp: DateTime.now(),
    );

    setState(() => _messages.add(message));
    _saveMessages();
    _scrollToBottom();
  }

  void _simulateAgentReply() {
    setState(() => _isAgentTyping = true);
    _scrollToBottom();

    Future.delayed(kAgentReplyDelay, () {
      if (!mounted) return;
      setState(() => _isAgentTyping = false);
      
      final response = kAgentResponses[_random.nextInt(kAgentResponses.length)];
      _addMessage(response, isUser: false);
      setState(() => _unreadCount++);
    });
  }

  void _scrollToBottom() {
    Future.delayed(kScrollDelay, () {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: kScrollDuration,
        curve: Curves.easeOut,
      );
    });
  }

  void _clearUnread() {
    setState(() => _unreadCount = 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text('Messages'),
            if (_unreadCount > 0) ...[
              const SizedBox(width: Spacing.sm),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: Spacing.sm, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.badgeBackground,
                  borderRadius: BorderRadius.circular(AppBorderRadius.sm),
                ),
                child: Text(
                  '$_unreadCount',
                  style: const TextStyle(color: AppColors.badgeText, fontSize: kFontSizeBadge),
                ),
              ),
            ],
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                _clearUnread();
              },
              child: NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  if (notification is ScrollEndNotification) {
                    final isNearBottom = _scrollController.position.pixels >=
                        _scrollController.position.maxScrollExtent - kScrollThreshold;
                    if (isNearBottom) _clearUnread();
                  }
                  return false;
                },
                child: ListView.builder(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(Spacing.lg),
                  itemCount: _messages.length + (_isAgentTyping ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == _messages.length && _isAgentTyping) {
                      return _buildTypingIndicator();
                    }
                    final message = _messages[index];
                    return _buildMessageBubble(message);
                  },
                ),
              ),
            ),
          ),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Message message) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: Spacing.md),
        padding: const EdgeInsets.symmetric(horizontal: Spacing.lg, vertical: Spacing.md),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * kBubbleMaxWidth,
        ),
        decoration: BoxDecoration(
          color: message.isUser ? AppColors.messageBubbleSent : AppColors.messageBubbleReceived,
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.text,
              style: TextStyle(
                color: message.isUser ? AppColors.messageSentText : AppColors.messageReceivedText,
                fontSize: kFontSizeMessage,
              ),
            ),
            const SizedBox(height: Spacing.xs),
            Text(
              _formatTime(message.timestamp),
              style: TextStyle(
                color: message.isUser ? AppColors.timestampSentText : AppColors.timestampReceivedText,
                fontSize: kFontSizeSmall,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(Spacing.sm),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -1),
            blurRadius: 4,
            color: Colors.black.withOpacity(0.1),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: AppColors.inputBackground,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: Spacing.lg,
                  vertical: Spacing.sm,
                ),
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          const SizedBox(width: Spacing.sm),
          IconButton(
            onPressed: _sendMessage,
            icon: const Icon(Icons.send),
            color: AppColors.sendButton,
            style: IconButton.styleFrom(
              backgroundColor: AppColors.sendButtonBackground,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: Spacing.md),
        padding: const EdgeInsets.symmetric(horizontal: Spacing.lg, vertical: Spacing.md),
        decoration: BoxDecoration(
          color: AppColors.messageBubbleReceived,
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
        ),
        child: LoadingAnimationWidget.waveDots(
          color: AppColors.dotColor,
          size: 32,
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
