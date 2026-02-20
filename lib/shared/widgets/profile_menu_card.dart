import 'package:flutter/material.dart';
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
      child: Container(
        padding: EdgeInsets.all(0),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            width: 3,
            color: const Color.fromARGB(255, 121, 121, 121),
          ),
        ),
        child: CircleAvatar(
          radius: 25,
          backgroundImage: AssetImage('assets/icons/profileIcon.png'),
          backgroundColor: Colors.transparent,
        ),
      ),
    );
  }
}