import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class WeeklyLoginProgress extends StatelessWidget {
  final List<bool> weekLogins;
  final List<String> labels;
  final int? todayIndex;

  const WeeklyLoginProgress({
    super.key,
    required this.weekLogins,
    this.labels = const ['M', 'T', 'W', 'Th', 'F', 'Sa', 'Su'],
    this.todayIndex,
  }) : assert(weekLogins.length == 7, 'weekLogins must have 7 values'),
       assert(labels.length == 7, 'labels must have 7 values');

  bool _isSegmentActive(int index) {
    return weekLogins[index] && weekLogins[index + 1];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(weekLogins.length * 2 - 1, (index) {
            if (index.isEven) {
              final dayIndex = index ~/ 2;

              return _DayCircle(
                completed: weekLogins[dayIndex],
                label: labels[dayIndex],
                isToday: todayIndex == dayIndex,
              );
            } else {
              final segmentIndex = index ~/ 2;

              return Expanded(
                child: _SegmentLine(
                  active: _isSegmentActive(segmentIndex),
                ),
              );
            }
          }),
        ),
      ],
    );
  }
}

class _DayCircle extends StatelessWidget {
  final bool completed;
  final String label;
  final bool isToday;

  const _DayCircle({
    required this.completed,
    required this.label,
    required this.isToday,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = completed
        ? HexColor("2A367D")
        : isToday
            ? HexColor("2A367D")
            : Colors.grey.shade400;

    final fillColor = completed ? HexColor("2A367D") : Colors.white;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TweenAnimationBuilder<double>(
          tween: Tween<double>(end: completed ? 1.0 : 0.0),
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOutBack,
          builder: (context, value, child) {
            final scale = completed ? 1.0 + (0.08 * value) : 1.0;

            return Transform.scale(
              scale: scale,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: fillColor,
                  border: Border.all(
                    color: borderColor,
                    width: isToday ? 2.4 : 2,
                  ),
                  boxShadow: completed
                    ? const [
                        BoxShadow(
                          color: Color(0x332A367D),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ]
                    : null,
                ),
                child: Center(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    transitionBuilder: (child, animation) {
                      return ScaleTransition(
                        scale: animation,
                        child: FadeTransition(
                          opacity: animation,
                          child: child,
                        ),
                      );
                    },
                    child: completed
                        ? const Icon(
                            Icons.check,
                            key: ValueKey('checked'),
                            color: Colors.white,
                            size: 18,
                          )
                        : const SizedBox(
                            key: ValueKey('unchecked'),
                          ),
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isToday ? FontWeight.w700 : FontWeight.w500,
            color: isToday ? Colors.black : Colors.grey.shade700,
          ),
        ),
      ],
    );
  }
}

class _SegmentLine extends StatelessWidget {
  final bool active;

  const _SegmentLine({
    required this.active,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 13),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
        height: 4,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: active ? HexColor("2A367D") : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(999),
        ),
      ),
    );
  }
}
