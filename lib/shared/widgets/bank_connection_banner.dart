import 'package:flutter/material.dart';

class BankConnectionSuccessBanner extends StatelessWidget {

  const BankConnectionSuccessBanner({
    super.key,
  });

  static void showBankConnectionSuccessBanner(
    OverlayState overlay, {
    Duration duration = const Duration(seconds: 5),
  }) {
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) {
        return _BannerHost(
          duration: duration,
          onDismissed: () {
            overlayEntry.remove();
          },
          child: const BankConnectionSuccessBanner(),
        );
      },
    );

    overlay.insert(overlayEntry);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                blurRadius: 12,
                offset: Offset(0, 4),
                color: Colors.black26,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 22,
                      child: Image.asset("assets/icons/bankIcon.png"),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "Connection Successful",
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  "Your bank as been successfully connected to your account!",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
    );
  }
}

class _BannerHost extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final VoidCallback onDismissed;

  const _BannerHost({
    required this.child,
    required this.duration,
    required this.onDismissed,
  });

  @override
  State<_BannerHost> createState() => _BannerHostState();
}

class _BannerHostState extends State<_BannerHost>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<Offset> animation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
      reverseDuration: const Duration(milliseconds: 250),
    );

    animation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: const Offset(0, 0),
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeOut,
        reverseCurve: Curves.easeIn,
      ),
    );

    controller.forward();

    Future.delayed(widget.duration, () async {
      await controller.reverse();
      widget.onDismissed();
      controller.dispose();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 65,
      left: 0,
      right: 0,
      child: SlideTransition(
        position: animation,
        child: widget.child,
      ),
    );
  }
}
