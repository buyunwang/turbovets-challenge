import 'package:flutter/material.dart';

// App color constants
class AppColors {
  AppColors._();
  
  // Message bubbles
  static const messageBubbleSent = Colors.blue;
  static final messageBubbleReceived = Colors.grey[300]!;
  
  // Text colors
  static const messageSentText = Colors.white;
  static const messageReceivedText = Colors.black87;
  static const timestampSentText = Colors.white70;
  static final timestampReceivedText = Colors.black54;
  
  // UI elements
  static final inputBackground = Colors.grey[100]!;
  static const badgeBackground = Colors.red;
  static const badgeText = Colors.white;
  static const sendButton = Colors.blue;
  static final sendButtonBackground = Colors.blue[50]!;
  
  // Loading
  static final dotColor = Colors.grey[600]!;
}
