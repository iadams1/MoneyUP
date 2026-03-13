import 'package:flutter/material.dart';
import 'package:moneyup/shared/widgets/app_avatar.dart';
import '/features/profile/screens/profile.dart';

class ProfileMenuCard extends StatelessWidget{
  const ProfileMenuCard({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      offset: const Offset(0, 70),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white,
      onSelected: (value) {
        switch (value) {
          case 'profile':
            Navigator.push(
              context, 
              MaterialPageRoute(builder: (_) => const ProfileScreen()),
            );
            break;
          case 'logout':
            //  LOGOUT LOGIC
            break;
        }
      },
      itemBuilder: (context) => const [
        PopupMenuItem(
          value: 'profile',
          child: Row(
            children: [
              Icon(Icons.person, size: 20,),
              SizedBox(width: 10,),
              Text("Profile")
            ],
          ),
        ),
        PopupMenuItem(
          value: 'logout',
          child: Row(
            children: [
              Icon(Icons.logout_outlined, size: 20,),
              SizedBox(width: 10,),
              Text("Logout")
            ],
          ),
        ),
      ],
      child: AppAvatar(
        size: 60,
      ),
    );
  }
}