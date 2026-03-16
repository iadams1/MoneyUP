import 'package:flutter/material.dart';

class NotificationDialog extends StatelessWidget{
  const NotificationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Notifications',
                style: TextStyle(
                  fontSize: 30
                ),
              ),
              // SingleChildScrollView(
              //   child: NotificationListener<ScrollNotification>(
              //     child: Container(),
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}