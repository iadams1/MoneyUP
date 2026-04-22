import 'dart:async';
import 'package:flutter/material.dart';
import 'package:plaid_flutter/plaid_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '/services/supabase_service.dart';
import '/shared/widgets/error_system.dart';
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
  bool _linkCompleted = false;

  StreamSubscription<LinkSuccess>? _onSuccessSubscription;
  StreamSubscription<LinkExit>? _onExitSubscription;

  @override
  void initState() {
    super.initState();
    _fetchLinkToken();

    _onSuccessSubscription = PlaidLink.onSuccess.listen((success) async {
      debugPrint('PLAID SUCCESS FIRED');
      _linkCompleted = true;
      await _handlePlaidSuccess(success);
    });

    _onExitSubscription = PlaidLink.onExit.listen((exit) {
      debugPrint('PLAID EXIT FIRED');
      debugPrint('Plaid exit error: ${exit.error}');
      debugPrint('Plaid exit metadata: ${exit.metadata}');

      if (_linkCompleted) {
        debugPrint('Ignoring exit because success already completed');
        return;
      }

      if (exit.error != null && mounted) {
        setState(() {
          _hasError = true;
          _errorMessage = exit.error?.message ?? 'Connection cancelled';
          _isLoading = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _onSuccessSubscription?.cancel();
    _onExitSubscription?.cancel();
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

  Future<void> _handlePlaidSuccess(LinkSuccess success) async 
  {
    try 
    {
    final supabase = Supabase.instance.client;

        debugPrint('Plaid Success - Public Token: ${success.publicToken}');
        debugPrint('Institution from metadata: ${success.metadata.institution}');

        final exchangeResponse = await supabase.functions.invoke(
          'exchange-public-token',
          body: {
            'public_token': success.publicToken,
            // Send whatever we have, even if null
            'institution_id': success.metadata.institution?.id,
            'institution_name': success.metadata.institution?.name,
          },
        );

        if (exchangeResponse.status != 200) {
          throw Exception('Token exchange failed: ${exchangeResponse.status}');
        }

        final data = exchangeResponse.data as Map<String, dynamic>;
        if (data['success'] != true) {
          throw Exception(data['error'] ?? 'Exchange failed');
        }

        debugPrint('Plaid connection saved successfully');

        // Update profile flag
        final userId = supabase.auth.currentUser?.id;
        if (userId != null) {
          await supabase
              .from('profiles')
              .update({'has_plaid_connected': true})
              .eq('id', userId);
        }

        await SupabaseService().syncAll();

        if (!mounted) return;
        showDialog(
          context: context,
          builder: (_) => ErrorDialog(
            message: 'Bank account connected! Syncing data...',
            onButtonPressed: () => Navigator.pop(context),
          ),
        );

        Navigator.pushReplacementNamed(context, '/home');
      } catch (e, stack) {
        debugPrint('Plaid success error: $e\n$stack');
        if (mounted) {
          showDialog(
            context: context,
            builder: (_) => ErrorDialog(
              message: 'Failed to connect bank: $e',
              onButtonPressed: () => Navigator.pop(context),
            ),
          );
        }
    }
  }

  Future<void> _openPlaidLink() async {
    try {
      _linkCompleted = false;

      await _fetchLinkToken();

      if (_linkToken == null) {
        throw Exception('No link token available');
      }

      debugPrint('Opening Plaid with fresh token: $_linkToken');

      await PlaidLink.create(
        configuration: LinkTokenConfiguration(token: _linkToken!),
      );

      await PlaidLink.open();
    } catch (e, stack) {
      debugPrint('Error launching Plaid Link: $e\n$stack');

      if (!mounted) return;

      setState(() {
        _hasError = true;
        _errorMessage = e.toString();
        _isLoading = false;
      });
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