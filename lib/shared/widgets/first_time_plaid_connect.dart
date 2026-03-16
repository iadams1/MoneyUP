import 'package:hexcolor/hexcolor.dart';
import 'package:moneyup/services/plaid_service.dart';
import 'package:moneyup/services/service_locator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

Future<void> showFirstTimePlaidConnect(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  final hasShown = prefs.getBool('hasShownPlaidConnect') ?? false;

  if (!hasShown) {
    if (!context.mounted) return;
  }

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [HexColor("2F2473"), HexColor("1A497F")],
                ),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  const BoxShadow(
                    color: Color.fromARGB(31, 0, 0, 0),
                    blurRadius: 12,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: SizedBox(
                  width: 25,
                  height: 25,
                  child: Image.asset("assets/icons/thumbsUp.png"),
                ),
              ),
            ),

            SizedBox(width: 15),

            // Text & Buttons
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Wanna Add a New Card to Your Account?",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 19),
                  ),

                  SizedBox(height: 10),

                  Text(
                    "Account's ready, but your money trail's still blank. Connect a card to show your moves or handle it later.",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15.5,
                      color: const Color.fromARGB(255, 138, 138, 138),
                    ),
                  ),

                  SizedBox(height: 10),

                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () async {
                            await profileService.markPlaidConnectDialogSeen();
                            if (!context.mounted) return;
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Skip for Now",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: const Color.fromARGB(255, 116, 116, 116),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onPressed: () async {
                            await profileService.markPlaidConnectDialogSeen();
                            if (!context.mounted) return;
                            Navigator.pop(context);
                            await showDialog(
                              context: context,
                              builder: (_) => const PlaidService(),
                            );
                          },
                          child: Text(
                            "Add a Card",
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );

  await prefs.setBool('hasShownPlaidConnect', true);
}