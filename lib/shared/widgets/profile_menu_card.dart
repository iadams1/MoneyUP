import 'package:flutter/material.dart';

import '/features/auth/screens/user_select.dart';
import '/shared/widgets/app_avatar.dart';
import '/shared/widgets/logout_dialog.dart';

class ProfileMenuCard extends StatelessWidget{
  const ProfileMenuCard({super.key,});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      offset: const Offset(0, 70),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white,
      onSelected: (value) async{
        switch (value) {
          case 'profile':
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const UserSelectScreen()),
            );
            break;
          case 'logout':
            await LogoutDialog.show(context);
            break;
        }
      },
      itemBuilder: (context) => const [
        PopupMenuItem(
          value: 'profile',
          child: Row(
            children: [
              Icon(Icons.person, size: 20,),
              SizedBox(width: 5),
              Text("Edit Avatar")
            ],
          ),
        ),
        PopupMenuItem(
          value: 'logout',
          child: Row(
            children: [
              Icon(Icons.logout_outlined, size: 20,),
              SizedBox(width: 5),
              Text("Log Out")
            ],
          ),
        ),
      ],
      child: AppAvatar(size: 60),
    );
  }
}

