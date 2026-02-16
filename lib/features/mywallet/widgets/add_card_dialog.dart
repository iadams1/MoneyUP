import 'package:flutter/material.dart';
import 'package:moneyup/services/plaid_service.dart';

class AddCardDialog extends StatelessWidget {
  const AddCardDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 18),

                // cropped logo
                ClipRect(
                  child: Align(
                    alignment: Alignment.center,
                    heightFactor: 0.4,
                    child: Image.asset(
                      "assets/images/mu_logo_slogan.png",
                      color: Colors.black,
                      colorBlendMode: BlendMode.srcIn,
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text.rich(
                    TextSpan(
                      style: const TextStyle(
                        fontSize: 23,
                        color: Colors.black,
                        height: 1.1,
                      ),
                      children: const [
                        TextSpan(text: "MoneyUP uses "),
                        TextSpan(
                          text: "Plaid",
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        TextSpan(text: " to connect your account"),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 35),

            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                boxShadow: [
                  const BoxShadow(
                    color: Color.fromARGB(31, 0, 0, 0),
                    blurRadius: 12,
                  ),
                ],
              ),
              padding: EdgeInsets.fromLTRB(20, 45, 20, 45),
              child: SizedBox(
                width: 275,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Icon
                        SizedBox(
                          height: 25,
                          width: 25,
                          child: Image.asset("assets/icons/secureLink.png"),
                        ),

                        SizedBox(width: 15),

                        // Text
                        Expanded(
                          child: SizedBox(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Connect effortlessly",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "Plaid lets you securely connect your financial accounts in seconds",
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 30),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Icon
                        SizedBox(
                          height: 25,
                          width: 25,
                          child: Image.asset("assets/icons/eyeOff.png"),
                        ),

                        SizedBox(width: 15),

                        // Text
                        Expanded(
                          child: SizedBox(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Your data belongs to you",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "Plaid doesn't sell personal info, and will only use it with your permission",
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 30),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (_) => PlaidConnectScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      "Continue",
                      style: TextStyle(
                        fontSize: 20,
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
    );
  }
}
