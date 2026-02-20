import 'package:flutter/material.dart';

class PlaidConnectionWidget extends StatelessWidget {
  final bool isLoading;
  final bool hasError;
  final String errorMessage;
  final VoidCallback onRetry;
  final String? linkToken;
  final VoidCallback onConnect;

  // NEW: Add this callback so the parent can handle navigation to home
  // (or pass a route name if you prefer named navigation)
  final VoidCallback onSkip;

  const PlaidConnectionWidget({
    super.key,
    required this.isLoading,
    required this.hasError,
    required this.errorMessage,
    required this.onRetry,
    required this.linkToken,
    required this.onConnect,
    required this.onSkip,  // ← new required param
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Connect Bank Account')),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : hasError
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 64, color: Colors.red),
                      const SizedBox(height: 16),
                      Text(
                        'Failed to prepare connection:\n$errorMessage',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.red),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: onRetry,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Retry'),
                      ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Use fake sandbox credentials:\n'
                        'Username: user_good\n'
                        'Password: pass_good',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 40),
                      ElevatedButton.icon(
                        onPressed: linkToken != null ? onConnect : null,
                        icon: const Icon(Icons.account_balance),
                        label: const Text('Connect with Plaid (Sandbox)'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                          textStyle: const TextStyle(fontSize: 18),
                        ),
                      ),
                      const SizedBox(height: 24), // Space between buttons
                      TextButton(
                        onPressed: onSkip,
                        child: const Text(
                          'SKIP FOR NOW',
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      // Alternative style: more prominent skip button
                      // OutlinedButton(
                      //   onPressed: onSkip,
                      //   child: const Text('Connect later'),
                      // ),
                    ],
                  ),
      ),
    );
  }
}