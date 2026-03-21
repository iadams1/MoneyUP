import 'package:flutter/material.dart';
import 'package:moneyup/shared/widgets/notification_dialog.dart';

void showNotificationDropdown(BuildContext context) {
  showGeneralDialog(
    context: context,
    barrierLabel: 'Notifications',
    barrierDismissible: true,
    barrierColor: Colors.black54,
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (context, animation, secondaryAnimation) {
      return const NotificationDropdown();
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final offsetAnimation = Tween<Offset>(
        begin: const Offset(0, -1),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        ),
      );

      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    },
  );
}