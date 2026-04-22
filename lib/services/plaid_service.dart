import 'package:flutter/material.dart';
import 'package:plaid_flutter/plaid_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:moneyup/services/plaid_listener_service.dart';
import '/shared/widgets/plaid_connect_dialog.dart';

class PlaidService extends StatefulWidget {
  const PlaidService({super.key});

  @override
  State<PlaidService> createState() => _PlaidServiceState();
}

class _PlaidServiceState extends State<PlaidService> {
  String? _linkToken;
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';
  bool _isOpening = false;

  @override
  void initState() {
    super.initState();

    PlaidListenerService().init();
    _fetchLinkToken();
  }

  @override
  void dispose() {
    debugPrint('PlaidService dispose called');
    super.dispose();
  }

  Future<void> _fetchLinkToken() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
        _hasError = false;
        _errorMessage = '';
      });
    }

    try {
      debugPrint('Fetching link token...');
      final response = await Supabase.instance.client.functions
          .invoke('create-plaid-link-token')
          .timeout(const Duration(seconds: 15));

      debugPrint('Link token response status: ${response.status}');
      debugPrint('Link token response data: ${response.data}');

      if (response.status != 200) {
        throw Exception('Failed to get link token: ${response.status}');
      }

      final data = response.data as Map<String, dynamic>;
      final token = data['link_token'] as String?;

      if (token == null || token.isEmpty) {
        throw Exception('No link_token in response');
      }

      if (!mounted) return;

      setState(() {
        _linkToken = token;
        _isLoading = false;
      });

      debugPrint('Link token stored successfully');
    } catch (e, stack) {
      debugPrint('Link token error: $e\n$stack');
      if (!mounted) return;
      setState(() {
        _hasError = true;
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _openPlaidLink() async {
    debugPrint('_openPlaidLink called');

    if (_isOpening) {
      debugPrint('Plaid already opening, ignoring duplicate tap');
      return;
    }
    _isOpening = true;

    try {
      setState(() {
        _isLoading = true;
        _hasError = false;
      });

      debugPrint('Fetching fresh link token...');

      final response = await Supabase.instance.client.functions
          .invoke('create-plaid-link-token')
          .timeout(const Duration(seconds: 15));

      if (response.status != 200) {
        throw Exception('Failed to get link token');
      }

      final data = response.data as Map<String, dynamic>;
      final token = data['link_token'] as String?;

      if (token == null || token.isEmpty) {
        throw Exception('No link token returned');
      }

      debugPrint('Opening Plaid with fresh token');

      await PlaidLink.create(
        configuration: LinkTokenConfiguration(token: token),
      );

      await PlaidLink.open();

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });
    } catch (e, stack) {
      debugPrint('Error launching Plaid Link: $e\n$stack');
      if (!mounted) return;
      setState(() {
        _hasError = true;
        _errorMessage = e.toString();
        _isLoading = false;
      });
    } finally {
      _isOpening = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AddCardDialog(
      isLoading: _isLoading,
      hasError: _hasError,
      errorMessage: _errorMessage,
      onRetry: _fetchLinkToken,
      linkToken: _linkToken,
      onConnect: _openPlaidLink,
    );
  }
}