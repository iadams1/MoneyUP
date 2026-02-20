import 'package:flutter/material.dart';
import 'package:moneyup/features/mywallet/widgets/wallet_card.dart';
import 'package:moneyup/models/linked_card.dart';
import 'package:moneyup/services/service_locator.dart';

class PrimaryCardView extends StatefulWidget{
  final List<LinkedCard>? cards;

  const PrimaryCardView({
    super.key,
    this.cards,
  });

  @override
  State<PrimaryCardView> createState() => _PrimaryWalletCardState();
}

class _PrimaryWalletCardState extends State<PrimaryCardView> {
  LinkedCard? _primary;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(covariant PrimaryCardView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.cards != widget.cards) {
      setState(() {
        _pickPrimary(widget.cards ?? const []);
      });
    }
  }

  Future<void> _load() async {
    try {
      final cards = widget.cards ?? await walletService.fetchLinkedCards();
      if (!mounted) return;

      setState(() {
        _pickPrimary(cards);
      });
    } catch (e) {
      debugPrint("PrimaryWalletCard load error: $e");
    }
  }

  void _pickPrimary(List<LinkedCard> cards) {
    _primary = null;

    for (final c in cards) {
      if (c.isActive == true) {
        _primary = c;
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_primary == null) {
      return SizedBox(
        height: 100,
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: const Center(
            child: Text(
              "No cards linked so far. Hit the button to start exploring your wallet!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w600
              ),
            )
          ),
        ),
      );
    }

    final c = _primary!;

    return WalletCard(
      cardId: 0,
      bankName: c.bankName ?? "Unknown Bank",
      mask: c.mask,
      currentAmount: c.currentBalance ?? 0,
      cardholderName: c.cardholderName ?? "",
    );
  }
}