import 'dart:async';

import 'package:flutter/material.dart';
import 'package:plaid_flutter/plaid_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:moneyup/shared/widgets/plaid_service.dart';

 // Adjust path to match your folder structure

class PlaidConnectScreen extends StatefulWidget {
  const PlaidConnectScreen({super.key});

  @override
  State<PlaidConnectScreen> createState() => _PlaidConnectScreenState();
}

class _PlaidConnectScreenState extends State<PlaidConnectScreen> {
  String? _linkToken;
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';

  StreamSubscription<LinkSuccess>? _onSuccessSubscription;

  @override
  void initState() {
    super.initState();
    _fetchLinkToken();

    _onSuccessSubscription = PlaidLink.onSuccess.listen(_handlePlaidSuccess);
    PlaidLink.onExit.listen((exit) {
      if (exit.error != null) {
        debugPrint('Plaid exit with error: ${exit.error}');
        if (mounted) {
          setState(() {
            _hasError = true;
            _errorMessage = exit.error?.message ?? 'Connection cancelled';
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _onSuccessSubscription?.cancel();
    super.dispose();
  }

  Future<void> _fetchLinkToken() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
      _errorMessage = '';
    });

    try {
      final response = await Supabase.instance.client.functions.invoke(
        'create-plaid-link-token',
      );

      if (response.status != 200) {
        throw Exception('Failed to get link token: ${response.status}');
      }

      final data = response.data as Map<String, dynamic>;
      final token = data['link_token'] as String?;

      if (token == null || token.isEmpty) {
        throw Exception('No link_token in response');
      }

      if (mounted) {
        setState(() {
          _linkToken = token;
          _isLoading = false;
        });
      }
    } catch (e, stack) {
      debugPrint('Link token error: $e\n$stack');
      if (mounted) {
        setState(() {
          _hasError = true;
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }

Future<void> _handlePlaidSuccess(LinkSuccess success) async {
  try {
    final exchangeResponse = await Supabase.instance.client.functions.invoke(
      'exchange-public-token',
      body: {
        'public_token': success.publicToken,
      },
    );

    if (exchangeResponse.status != 200) {
      throw Exception('Token exchange failed: ${exchangeResponse.status}');
    }

    final data = exchangeResponse.data as Map<String, dynamic>;
    if (data['success'] != true) {
      throw Exception(data['error'] ?? 'Exchange did not succeed');
    }

    debugPrint('Plaid connection saved successfully');

    // ────────────────────────────────────────────────
    // NEW: Mark that the user has completed Plaid onboarding
    final supabase = Supabase.instance.client;
    final userId = supabase.auth.currentUser?.id;

    if (userId != null) {
      final updateResult = await supabase
          .from('profiles')
          .update({'has_plaid_connected': true})
          .eq('id', userId)
          .maybeSingle();

      if (updateResult == null) {
        debugPrint('Warning: No profile row found to update for user $userId');
      } else {
        debugPrint('has_plaid_connected set to true for user $userId');
      }
    } else {
      debugPrint('Warning: No current user when trying to update profile');
    }
    // ────────────────────────────────────────────────

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Bank account connected!')),
    );

    Navigator.pushReplacementNamed(context, '/home');
  } catch (e, stack) {
    debugPrint('Exchange error: $e\n$stack');
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to connect: $e')),
      );
    }
  }
}

  void _openPlaidLink() async {
    if (_linkToken == null) return;

    try {
      await PlaidLink.create(
        configuration: LinkTokenConfiguration(token: _linkToken!),
      );
      PlaidLink.open();
    } catch (e) {
      debugPrint('Error launching Plaid Link: $e');
      if (mounted) {
        setState(() {
          _hasError = true;
          _errorMessage = e.toString();
        });
      }






    }
  }

  @override
  Widget build(BuildContext context) {
    return PlaidConnectionWidget(
      isLoading: _isLoading,
      hasError: _hasError,
      errorMessage: _errorMessage,
      onRetry: _fetchLinkToken,
      linkToken: _linkToken,
      onConnect: _openPlaidLink,
      onSkip: () {
          // Navigate to home when user skips
          Navigator.pushReplacementNamed(context, '/home');
      }
    );
  }
}