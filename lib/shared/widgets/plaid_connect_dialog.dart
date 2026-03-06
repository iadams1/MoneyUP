import 'package:flutter/material.dart';

class AddCardDialog extends StatelessWidget {
  final bool isLoading;
  final bool hasError;
  final String errorMessage;
  final VoidCallback onRetry;
  final String? linkToken;
  final VoidCallback onConnect;

  const AddCardDialog({
    super.key,
    required this.isLoading,
    required this.hasError,
    required this.errorMessage,
    required this.onRetry,
    required this.linkToken,
    required this.onConnect,
  });


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
                isLoading
            ? Expanded(
              child: Center(
                child: const CircularProgressIndicator(
                  color: Colors.black
                  )
                ),
            )
            : hasError
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 64, color: Colors.red),
                      const SizedBox(height: 16),
                      Text(
                        'Failed to prepare connection:\n$errorMessage',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.red),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: onRetry,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Retry'),
                      ),
                    ],
                  )
                : Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: linkToken != null ? onConnect : null,
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
