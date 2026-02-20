import 'package:flutter/material.dart';
import 'package:moneyup/services/service_locator.dart';
import 'package:moneyup/shared/contrants/user_icons.dart';
import 'package:moneyup/shared/widgets/gradient_ring_avatar.dart';

class AppAvatar extends StatelessWidget {
  final double size;
  final double ringWidth;
  final double gap;
  final double imageScale;
  final VoidCallback? onTap;

  const AppAvatar({
    super.key,
    this.size = 62,
    this.ringWidth = 3,
    this.gap = 5,
    this.imageScale = 1.45,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final avatar = ValueListenableBuilder<int>(
      valueListenable: profileService.iconIdNotifier,
      builder: (context, iconId, _) {
        return GradientRingAvatar(
          assetPath: UserImages.byId(iconId),
          size: size,
          ringWidth: ringWidth,
          gap: gap,
          imageScale: imageScale,
        );
      },
    );

    return onTap == null
        ? avatar
        : InkWell(
            borderRadius: BorderRadius.circular(999),
            onTap: onTap,
            child: avatar,
          );
  }
}