import 'dart:async';
import 'package:flutter/material.dart';
import 'package:moneyup/services/supabase_service.dart';
import 'package:plaid_flutter/plaid_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Bank account connected! Syncing data...')),
        );

        Navigator.pushReplacementNamed(context, '/home');
      } catch (e, stack) {
        debugPrint('Plaid success error: $e\n$stack');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to connect bank: $e')),
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