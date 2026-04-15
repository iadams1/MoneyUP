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
  bool _linkCompleted = false;
  bool _isHandlingSuccess = false;

  StreamSubscription<LinkSuccess>? _onSuccessSubscription;
  StreamSubscription<LinkExit>? _onExitSubscription;
  StreamSubscription<LinkEvent>? _onEventSubscription;

  @override
  void initState() {
    super.initState();
    debugPrint('PlaidService initState called');
    debugPrint('Plaid listeners about to be set up...');
    _setupPlaidListeners();
    _fetchLinkToken();
  }

  void _setupPlaidListeners() {
    debugPrint('Setting up Plaid listeners...');

    _onSuccessSubscription ??= PlaidLink.onSuccess.listen((success) async {
      debugPrint('PLAID SUCCESS FIRED with publicToken: ${success.publicToken}');
      debugPrint('PLAID SUCCESS METADATA: ${success.metadata}');
      _linkCompleted = true;
      _isHandlingSuccess = true;

      try {
        await _handlePlaidSuccess(success);
      } finally {
        _isHandlingSuccess = false;
      }
    });

    _onExitSubscription ??= PlaidLink.onExit.listen((exit) {
      debugPrint(
        'PLAID EXIT FIRED with error: ${exit.error}, metadata: ${exit.metadata}',
      );

      if (_linkCompleted || _isHandlingSuccess) {
        debugPrint('Ignoring exit because success already completed or is being handled');
        return;
      }

      if (!mounted) {
        debugPrint('PLAID EXIT received but widget is no longer mounted');
        return;
      }

      final exitMessage = exit.error?.message ??
          'Plaid exited before success completed. Check debug logs for exit metadata.';

      setState(() {
        _hasError = true;
        _errorMessage = exitMessage;
        _isLoading = false;
      });

      debugPrint('PLAID EXIT set error state with message: $exitMessage');
    });

    _onEventSubscription ??= PlaidLink.onEvent.listen((event) {
      debugPrint('PLAID EVENT FIRED: ${event.name}, metadata: ${event.metadata}');
    });
  }

  @override
  void dispose() {
    debugPrint('PlaidService dispose called');
    _onSuccessSubscription?.cancel();
    _onExitSubscription?.cancel();
    _onEventSubscription?.cancel();
    super.dispose();
  }

  Future<void> _fetchLinkToken() async {
    if (_linkToken != null) {
      debugPrint('Link token already exists, skipping fetch');
      return;
    }

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

      if (!mounted) {
        debugPrint('Link token fetched but widget is no longer mounted');
        return;
      }

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

    if (_linkToken == null) {
      debugPrint('No link token present, fetching one now...');
      await _fetchLinkToken();

      if (_linkToken == null) {
        debugPrint('ERROR: No link token available to open Plaid.');
        if (!mounted) return;

        setState(() {
          _hasError = true;
          _errorMessage = 'Could not initialize Plaid because no link token was available.';
          _isLoading = false;
        });
        return;
      }
    }

    try {
      _linkCompleted = false;
      _isHandlingSuccess = false;

      if (mounted) {
        setState(() {
          _isLoading = true;
          _hasError = false;
          _errorMessage = '';
        });
      }

      debugPrint('Opening Plaid with token: $_linkToken');

      await PlaidLink.create(
        configuration: LinkTokenConfiguration(token: _linkToken!),
      );
      debugPrint('PlaidLink.create completed successfully');

      await PlaidLink.open();
      debugPrint('PlaidLink.open completed successfully');

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
    }
  }

  Future<void> _handlePlaidSuccess(LinkSuccess success) async {
    debugPrint('Handling Plaid success...');

    try {
      final supabase = Supabase.instance.client;
      final token = supabase.auth.currentSession?.accessToken;

      debugPrint('Supabase session exists: ${supabase.auth.currentSession != null}');
      debugPrint('Supabase user exists: ${supabase.auth.currentUser != null}');
      debugPrint('Supabase auth token exists: ${token != null}');

      if (token == null) {
        throw Exception('User is not signed in or session expired.');
      }

      final publicToken = success.publicToken;
      debugPrint('Plaid public token exists: ${publicToken.isNotEmpty}');

      if (publicToken.isEmpty) {
        throw Exception('Plaid public token is missing.');
      }

      debugPrint('Calling exchange-public-token Edge Function...');
      final exchangeResponse = await supabase.functions.invoke(
        'exchange-public-token',
        body: {'public_token': publicToken},
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 15));

      debugPrint('Edge function status: ${exchangeResponse.status}');
      debugPrint('Edge function data: ${exchangeResponse.data}');

      if (exchangeResponse.status != 200) {
        throw Exception('Token exchange failed: ${exchangeResponse.status}');
      }

      final data = exchangeResponse.data as Map<String, dynamic>;
      if (data['success'] != true) {
        throw Exception(data['error'] ?? 'Exchange did not succeed');
      }

      debugPrint('Starting local sync...');
      await SupabaseService().syncAll();
      debugPrint('Local sync completed.');

      final userId = supabase.auth.currentUser?.id;
      if (userId != null) {
        debugPrint('Updating has_plaid_connected for user $userId...');
        await supabase.from('profiles').update({
          'has_plaid_connected': true,
        }).eq('id', userId);
        debugPrint('Profile updated successfully.');
      } else {
        debugPrint('WARNING: No current user found to update profile.');
      }

      if (!mounted) {
        debugPrint('Plaid success finished but widget is no longer mounted');
        return;
      }

      setState(() {
        _linkToken = null;
        _isLoading = false;
        _hasError = false;
        _errorMessage = '';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bank account connected!')),
      );

      debugPrint('Navigating to /home...');
      Navigator.of(context).pushReplacementNamed('/home');
    } catch (e, stack) {
      debugPrint('Exchange error: $e\n$stack');

      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _hasError = true;
        _errorMessage = 'Failed to connect: $e';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to connect: $e')),
      );
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