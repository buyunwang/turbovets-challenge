import 'dart:io';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../constants/spacing.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late final WebViewController controller;
  bool isLoading = true;
  String? errorMessage;

  // Use 10.0.2.2 for Android emulators, localhost for iOS/desktop
  String get dashboardUrl {
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:4200';
    }
    return 'http://localhost:4200';
  }

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            setState(() {
              isLoading = true;
              errorMessage = null;
            });
          },
          onPageFinished: (url) {
            setState(() {
              isLoading = false;
            });
          },
          onWebResourceError: (error) {
            setState(() {
              isLoading = false;
              errorMessage = 'Failed to load dashboard: ${error.description}';
            });
          },
        ),
      )
      ..loadRequest(Uri.parse(dashboardUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.reload();
        },
        child: Stack(
          children: [
            WebViewWidget(controller: controller),
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
          if (errorMessage != null)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(Spacing.standard),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 48,
                    ),
                    const SizedBox(height: Spacing.standard),
                    Text(
                      errorMessage!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: Spacing.standard),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          errorMessage = null;
                          isLoading = true;
                        });
                        controller.loadRequest(Uri.parse(dashboardUrl));
                      },
                      child: const Text('Refresh'),
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
}
