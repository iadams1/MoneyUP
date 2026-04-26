import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class TermsDialog extends StatelessWidget {
  final bool isProfile;
  final bool isSignUp;

  const TermsDialog({
    super.key,
    required this.isProfile,
    required this.isSignUp,
  });

  static Future<bool?> showTermsSignUpDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return TermsDialog(isProfile: false, isSignUp: true);
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: Colors.white,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.75,
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(6, 6, 6, 0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text(
                  "Terms & Conditions",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          
              Divider(height: 1),
          
              // Scrollable Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
          
                      // 1.
                      Text(
                        "1. Description of Service",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(height: 7),
                      Text(
                        "MoneyUp is a financial technology platform designed to help users manage personal finances through budgeting tools, transaction tracking, financial insights, and educational content. MoneyUp may integrate with third-party financial service providers, including Plaid, to securely access financial account data.",
                      ),
                      SizedBox(height: 9),
                      Text(
                        "MoneyUp does not provide banking services. We are not a bank, financial institution, or investment advisor.",
                      ),
          
                      SizedBox(height: 15),
          
                      // 2.
                      Text(
                        "2. Eligibility",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(height: 7),
                      Text(
                        "To use MoneyUp, you must:",
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("• "),
                          Expanded(
                            child: Text("Be at least 18 years old (or the age of majority in your jurisdiction)"),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("• "),
                          Expanded(
                            child: Text("Provide accurate and complete registration information"),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("• "),
                          Expanded(
                            child: Text("Use the Service only for lawful purposes"),
                          ),
                        ],
                      ),
                      SizedBox(height: 9),
                      Text(
                        "If you are under 18, use may be permitted only with parental or guardian consent.",
                      ),
          
                      SizedBox(height: 15),
          
                      // 3.
                      Text(
                        "3. User Accounts and Security",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(height: 7),
                      Text(
                        "You are responsible for:",
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("• "),
                          Expanded(
                            child: Text("Maintaining the confidentiality of your login credentials"),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("• "),
                          Expanded(
                            child: Text("All activity that occurs under your account"),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("• "),
                          Expanded(
                            child: Text("Notifying us immediately of unauthorized access"),
                          ),
                        ],
                      ),
                      SizedBox(height: 9),
                      Text(
                        "MoneyUp uses industry-standard security practices, including password hashing (e.g., bcrypt) and encrypted data storage, but no system is completely secure.",
                      ),
          
                      SizedBox(height: 15),
          
                      // 4.
                      Text(
                        "4. Financial Data and Third-Party Integration",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(height: 7),
                      Text(
                        "By linking your financial accounts:",
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("• "),
                          Expanded(
                            child: Text("You authorize MoneyUp to access and retrieve your financial data through third-party providers such as Plaid"),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("• "),
                          Expanded(
                            child: Text("You acknowledge that your data is subject to the third party’s privacy policy and terms"),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("• "),
                          Expanded(
                            child: Text("MoneyUp is not responsible for errors, delays, or interruptions caused by third-party services"),
                          ),
                        ],
                      ),
                      SizedBox(height: 9),
                      Text(
                        "We do not store your bank credentials directly.",
                      ),
          
                      SizedBox(height: 15),
          
                      // 5.
                      Text(
                        "5. No Financial Advice",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(height: 7),
                      Text(
                        "MoneyUp provides tools, analytics, and educational content for informational purposes only.",
                      ),
                      Text(
                        "We do not provide:",
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("• "),
                          Expanded(
                            child: Text("Financial advice"),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("• "),
                          Expanded(
                            child: Text("Investment recommendations"),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("• "),
                          Expanded(
                            child: Text("Tax or legal advice"),
                          ),
                        ],
                      ),
                      SizedBox(height: 9),
                      Text(
                        "Any decisions you make based on MoneyUp are your sole responsibility.",
                      ),
          
                      SizedBox(height: 15),
          
                      // 6.
                      Text(
                        "6. User Responsibilities",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(height: 7),
                      Text(
                        "You agree not to:",
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("• "),
                          Expanded(
                            child: Text("Use the platform for fraudulent or illegal activity"),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("• "),
                          Expanded(
                            child: Text("Attempt to reverse-engineer, disrupt, or exploit the system"),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("• "),
                          Expanded(
                            child: Text("Upload malicious code or attempt unauthorized access"),
                          ),
                        ],
                      ),
                      SizedBox(height: 9),
                      Text(
                        "Violation of these terms may result in suspension or termination of your account.",
                      ),
          
                      SizedBox(height: 15),
          
                      // 7.
                      Text(
                        "7. Data Privacy",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(height: 7),
                      Text(
                        "Your use of MoneyUp is also governed by our Privacy Policy. We collect and process data to:",
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("• "),
                          Expanded(
                            child: Text("Provide core functionality (budgeting, transactions, insights)"),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("• "),
                          Expanded(
                            child: Text("Improve system performance and user experience"),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("• "),
                          Expanded(
                            child: Text("Deliver personalized financial insights"),
                          ),
                        ],
                      ),
                      SizedBox(height: 9),
                      Text(
                        "Violation of these terms may result in suspension or termination of your account.Sensitive data is encrypted and access is restricted using role-based controls.",
                      ),
          
                      SizedBox(height: 15),
          
                      // 8.
                      Text(
                        "8. Intellectual Property",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(height: 7),
                      Text(
                        "All content, features, and functionality of MoneyUp including design, code, branding, and analytics models are the intellectual property of MoneyUp and may not be copied, modified, or distributed without permission.",
                      ),
                      
                      SizedBox(height: 15),
          
                      // 9.
                      Text(
                        "9. Service Availability",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(height: 7),
                      Text(
                        "We strive to provide reliable service, but we do not guarantee:",
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("• "),
                          Expanded(
                            child: Text("Continuous, uninterrupted access"),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("• "),
                          Expanded(
                            child: Text("Error-free functionality"),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("• "),
                          Expanded(
                            child: Text("Compatibility with all devices or systems"),
                          ),
                        ],
                      ),
                      SizedBox(height: 9),
                      Text(
                        "MoneyUp may be updated, modified, or temporarily unavailable due to maintenance or system issues.",
                      ),
          
                      SizedBox(height: 15),
          
                      // 10.
                      Text(
                        "10. Limitation of Liability",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(height: 7),
                      Text(
                        "To the fullest extent permitted by law, MoneyUp is not liable for:",
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("• "),
                          Expanded(
                            child: Text("Financial losses or damages resulting from use of the Service"),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("• "),
                          Expanded(
                            child: Text("Errors in transaction data or account balances"),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("• "),
                          Expanded(
                            child: Text("Third-party service failures (e.g., Plaid or financial institutions)"),
                          ),
                        ],
                      ),
                      SizedBox(height: 9),
                      Text(
                        "Your use of the platform is at your own risk.",
                      ),
          
                      SizedBox(height: 15),
          
                      // 11.
                      Text(
                        "11. Termination",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(height: 7),
                      Text(
                        "We reserve the right to:",
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("• "),
                          Expanded(
                            child: Text("Suspend or terminate your account at any time for violation of these Terms"),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("• "),
                          Expanded(
                            child: Text("Remove access to the Service without prior notice in cases of misuse or security risk"),
                          ),
                        ],
                      ),
                      SizedBox(height: 9),
                      Text(
                        "You may stop using MoneyUp at any time.",
                      ),
          
                      SizedBox(height: 15),
          
                      // 12.
                      Text(
                        "12. Changes to Terms",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(height: 7),
                      Text(
                        "We may update these Terms periodically. Continued use of the Service after changes are posted constitutes acceptance of the updated Terms.",
                      ),
          
                      SizedBox(height: 15),
          
                      // 13.
                      Text(
                        "13. Governing Law",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(height: 7),
                      Text(
                        "These Terms shall be governed by and interpreted in accordance with the laws of the United States and the State of Arkansas.",
                      ),
          
                      SizedBox(height: 15),
          
                      // 14.
                      Text(
                        "14. Contact Information",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(height: 7),
                      Text(
                        "If you have questions about these Terms, contact us at:",
                      ),
                      Text(
                        "Email: customerservice@moneyup.com",
                      ),
                      Text(
                        "Company: MoneyUp",
                      ),
          
                      SizedBox(height: 20),
          
                      // Actions for isSignUp
                      isSignUp ? 
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.pop(context, false);
                                  },
                                  child: Text(
                                    "Decline",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                        Navigator.pop(context, true);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      shadowColor: Colors.transparent,
                                      padding: EdgeInsets.zero,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                    ),
                                    child: Ink(
                                      height: 40,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [HexColor('#124074'), HexColor('#332677')],
                                        ),
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "Accept",
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          )
                      : const SizedBox.shrink(),  
                    ],
                  )
                ),
              ),
          
              // Actions for isProfile
              isProfile? 
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: SizedBox(
                    height: 40,
                    child: Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        child: Ink(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [HexColor('#124074'), HexColor('#332677')],
                            ),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Center(
                            child: Text(
                              "Close",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              : const SizedBox(height: 20),     
            ],
          ),
        ),
      ),
    );
  }
}
