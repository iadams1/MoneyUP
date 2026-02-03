import 'dart:async'; // Moved to top
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:plaid_flutter/plaid_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

class PlaidConnectScreen extends StatefulWidget {
  const PlaidConnectScreen({super.key});

  @override
  State<PlaidConnectScreen> createState() => _PlaidConnectScreenState();
}

class _PlaidConnectScreenState extends State<PlaidConnectScreen> {
  String? _linkToken;
  bool _isLoading = false;
  StreamSubscription? _plaidSuccessStream;

  final _supabase = Supabase.instance.client;
  final String _createLinkTokenUrl = 'https://dnzgsfovhbxsxlbpvzbt.supabase.co/functions/v1/plaidSandboxLinkToken';
  final String _exchangeUrl = 'https://dnzgsfovhbxsxlbpvzbt.supabase.co/functions/v1/exchange-public-token';

  @override
  void initState() {
    super.initState();
    _fetchLinkToken();

    // Initialize the listener ONCE
    _plaidSuccessStream = PlaidLink.onSuccess.listen(_onPlaidSuccess);

    PlaidLink.onExit.listen((exit) {
      if (exit.error != null) {
        debugPrint('Plaid exited with error: ${exit.error?.message}');
      }
    });
  }

  @override
  void dispose() {
    _plaidSuccessStream?.cancel(); // Important for performance
    super.dispose();
  }

  Future<void> _fetchLinkToken() async {
    setState(() => _isLoading = true);
    try {
      final userId = _supabase.auth.currentUser!.id;
      final res = await http.post(
        Uri.parse(_createLinkTokenUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'user_id': userId}),
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        setState(() => _linkToken = data['link_token']);
      } else {
        throw Exception('Failed to get link token');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _onPlaidSuccess(LinkSuccess success) async {
    try {
      final userId = _supabase.auth.currentUser!.id;
      final res = await http.post(
        Uri.parse(_exchangeUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'public_token': success.publicToken,
          'user_id': userId,
        }),
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        
        await _supabase.from('plaid_items').insert({
          'user_id': userId,
          'access_token': data['access_token'],
          'item_id': data['item_id'],
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Bank connected successfully!')),
          );
          Navigator.pushReplacementNamed(context, '/home');
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  void _openPlaidLink() async {
    if (_linkToken == null) return;

    try {
      // 1. Prepare the configuration object
      LinkTokenConfiguration configuration = LinkTokenConfiguration(
        token: _linkToken!,
      );

      // 2. CREATE the handler (This is the new required step)
      // This "warms up" the native Plaid SDK.
      await PlaidLink.create(configuration: configuration);

      // 3. OPEN the link (Now takes no arguments)
      PlaidLink.open();
      
    } catch (e) {
      debugPrint("Error launching Plaid: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to launch Plaid.')),
        );
      }
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Connect Bank Account')),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Use fake sandbox credentials:\nUsername: user_good\nPassword: pass_good',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: _linkToken != null ? _openPlaidLink : null,
                    child: const Text('Connect with Plaid (Sandbox)'),
                  ),
                ],
              ),
      ),
    );
  }
}