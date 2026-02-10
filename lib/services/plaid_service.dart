import 'dart:async';
import 'package:flutter/material.dart';
import 'package:moneyup/services/service_locator.dart';
import 'package:plaid_flutter/plaid_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class PlaidConnectScreen extends StatefulWidget {
  const PlaidConnectScreen({super.key});

  @override
  State<PlaidConnectScreen> createState() => _PlaidConnectScreenState();
}

class _PlaidConnectScreenState extends State<PlaidConnectScreen> {
  String? _linkToken;
  bool _isLoading = true; // Start true since we fetch immediately
  bool _hasError = false;
  String? _errorMessage;
  StreamSubscription? _plaidSuccessStream;

  final _supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    _fetchLinkToken();

    _plaidSuccessStream = PlaidLink.onSuccess.listen(_onPlaidSuccess);

    PlaidLink.onExit.listen((exit) {
      if (exit.error != null) {
        debugPrint('Plaid exited with error: ${exit.error?.message}');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Plaid setup cancelled or failed: ${exit.error?.message ?? "Unknown error"}',
              ),
            ),
          );
        }
      }
    });

    // Optional: for debugging Plaid events
    // PlaidLink.onEvent.listen((event) => debugPrint('Plaid event: ${event.name}'));
  }

  @override
  void dispose() {
    _plaidSuccessStream?.cancel();
    super.dispose();
  }

  Future<void> _fetchLinkToken() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
      _errorMessage = null;
    });

    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        throw Exception('No authenticated user found');
      }

      final response = await _supabase.functions.invoke(
        'create-plaid-link-token',
        body: {},
      );

      if (response.status == 200) {
        final data = response.data as Map<String, dynamic>;
        final linkToken = data['link_token'] as String?;
        if (linkToken == null || linkToken.isEmpty) {
          throw Exception('No link_token returned from function');
        }
        setState(() {
          _linkToken = linkToken;
        });
      } else {
        throw Exception(
          'Function error: ${response.status} - ${response.data ?? "No data"}',
        );
      }
    } catch (e) {
      debugPrint('Link token fetch error: $e');
      setState(() {
        _hasError = true;
        _errorMessage = e.toString();
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to prepare Plaid: $e')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _onPlaidSuccess(LinkSuccess success) async {
    try {
      final exchangeResponse = await _supabase.functions.invoke(
        'exchange-public-token',
        body: {
          'public_token': success.publicToken,
          // OPTIONAL: pass metadata so backend can store institution name without extra calls
          'institution_id': success.metadata.institution?.id,
          'institution_name': success.metadata.institution?.name,
        },
      );



      debugPrint('exchange response: status=${exchangeResponse.status} data=${exchangeResponse.data}');

      if (exchangeResponse.status != 200) {
        throw Exception(
          'Exchange failed: ${exchangeResponse.status} - ${exchangeResponse.data ?? "No data"}',
        );
      }

      final data = exchangeResponse.data as Map<String, dynamic>;

      // If your function returns { success: true, connection: {...} }
      if (data['success'] != true) {
        throw Exception(data['error'] ?? 'Exchange failed (no success flag)');
      }

      final connection = data['connection'] as Map<String, dynamic>?;
      final itemId = connection?['item_id'] as String?;

      if (itemId == null) {
        throw Exception('Missing connection.item_id in response');
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bank connected! Item: $itemId')),
      );

      supabaseService.syncAll();
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      debugPrint('Plaid success handling error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save connection: $e')),
        );
      }
    }
  }

  void _openPlaidLink() async {
    if (_linkToken == null) return;

    final configuration = LinkTokenConfiguration(
      token: _linkToken!,
    );

    try {
      await PlaidLink.create(configuration: configuration);
      PlaidLink.open();
    } catch (e) {
      debugPrint("Error launching Plaid Link: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to open Plaid: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Connect Bank Account')),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : _hasError
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 64, color: Colors.red),
                      const SizedBox(height: 16),
                      Text(
                        'Failed to prepare connection:\n$_errorMessage',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.red),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: _fetchLinkToken,
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
                        onPressed: _linkToken != null ? _openPlaidLink : null,
                        icon: const Icon(Icons.account_balance),
                        label: const Text('Connect with Plaid (Sandbox)'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 32, vertical: 16),
                          textStyle: const TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }
}