import 'package:flutter/material.dart';
import 'package:moneyup/features/home/screens/my_home_page.dart';
import 'package:moneyup/services/service_locator.dart';
import 'package:moneyup/shared/contrants/user_icons.dart';

class UserSelectScreen extends StatefulWidget {
  const UserSelectScreen({super.key});

  @override
  State<UserSelectScreen> createState() => _UserSelectScreen();
}

class _UserSelectScreen extends State<UserSelectScreen> {
  int _selectedUserIndex = 12;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadIcon();
  }

  Future<void> _loadIcon() async {
    final iconId = await profileService.getProfileIconId();

    if (!mounted) return;
    setState(() => _selectedUserIndex = iconId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        toolbarHeight: 0,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/mu_bg.png', fit: BoxFit.fill),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),

                  const Text(
                    'MONEYUP',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'SF Pro',
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'USER SELECTION',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'SF Pro',
                    ),
                  ),

                  const SizedBox(height: 5),

                  const Text(
                    "Your journey starts with you. Choose a profile to kick things off!",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'SF Pro',
                    ),
                  ),

                  const SizedBox(height: 5),

                  // Selected user image
                  Center(
                    child: Image.asset(
                      UserImages.byId(_selectedUserIndex),
                      width: 220,
                    ),
                  ),

                  const SizedBox(height: 5),

                  SizedBox(
                    height: 300,
                    child: GridView.builder(
                      itemCount: UserImages.all.length - 1,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                          ),
                      itemBuilder: (context, i) {
                        final bool isSelected = i == _selectedUserIndex;

                        return InkWell(
                          onTap: () => setState(() => _selectedUserIndex = i),
                          child: AnimatedScale(
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeOut,
                            scale: isSelected ? 1.2 : 1.0,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                border: Border.all(
                                  width: 2,
                                  color: isSelected
                                      ? const Color.fromARGB(255, 255, 255, 255)
                                      : const Color.fromARGB(0, 255, 255, 255),
                                ),
                                color: const Color.fromARGB(0, 255, 255, 255),
                              ),
                              padding: const EdgeInsets.all(0),
                              child: Image.asset(UserImages.all[i]),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Confirm / Skip buttons go here...
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const MyHomePage(title: ''),
                              ),
                            );
                          },
                          child: const Text(
                            "Skip For Now",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onPressed: _isSaving
                              ? null
                              : () async {
                                  final int iconId = _selectedUserIndex;

                                  try {
                                    setState(() => _isSaving = true);

                                    await profileService.saveProfileSelection(
                                      profileIconId: iconId,
                                    );

                                    if (!mounted) return;

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => const MyHomePage(title: ''),
                                      ),
                                    );
                                    
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text("Failed to save profile"),
                                      ),
                                    );
                                  } finally {
                                    if (mounted) {
                                      setState(() => _isSaving = false);
                                    }
                                  }
                                },
                          child: const Text(
                            "Continue",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
