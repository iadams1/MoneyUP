import 'package:flutter/material.dart';
import 'package:moneyup/shared/widgets/weekly_login_progress.dart';

class StreakBanner extends StatelessWidget {
  final int currentStreak;
  final int longestStreak;
  final List<bool> weekLogins;

  const StreakBanner({
    super.key,
    required this.currentStreak,
    required this.longestStreak,
    required this.weekLogins,
  });

  static void showStreakBanner(
    BuildContext context, {
    required int currentStreak,
    required int longestStreak,
    required List<bool> weekLogins,
    Duration duration = const Duration(seconds: 5),// MAKE 5 SECONDS 
  }) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;
    late AnimationController controller;

    controller = AnimationController(
      vsync: Navigator.of(context),
      duration: const Duration(milliseconds: 350),
      reverseDuration: const Duration(milliseconds: 250),
    );

    final animation =
        Tween<Offset>(
          begin: const Offset(0, -1),
          end: const Offset(0, 0),
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Curves.easeOut,
            reverseCurve: Curves.easeIn,
          ),
        );

    overlayEntry = OverlayEntry(
      builder: (context) {
        return Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: SlideTransition(
            position: animation,
            child: StreakBanner(
              currentStreak: currentStreak,
              longestStreak: longestStreak,
              weekLogins: weekLogins,
            ),
          ),
        );
      },
    );

    overlay.insert(overlayEntry);
    controller.forward();

    Future.delayed(duration, () async {
      await controller.reverse();
      overlayEntry.remove();
      controller.dispose();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                      child: Image.asset("assets/icons/fireFlame.png"),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "$currentStreak-day Streak",
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      "Longest streak: $longestStreak days",
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                SizedBox(
                  width: double.infinity,
                  child: WeeklyLoginProgress(
                    weekLogins: weekLogins,
                    todayIndex: DateTime.now().weekday - 1,
                  ),
                ),
              ],
            ),
          ),

        ),
      ),
    );
  }
}
