import 'package:flutter/material.dart';

class CategoryInfo {
  final String text;
  final String whyItMatters;
  final List<String> bestPractices;

  const CategoryInfo({
    required this.text,
    required this.whyItMatters,
    required this.bestPractices,
  });
}

const Map<String, CategoryInfo> categoryInfoMap = {
  'Budgeting': CategoryInfo(
    text: 'The process of creating a plan for how to spend and svae your money. It helps you understand your income, track expenses, and allocate funds toward your financial goals.',
    whyItMatters: 'Budgeting matters because it empowers you to make informed decisions, avoid debt, and prepare for unexpected costs. It reduces financial stress by giving you clarity and confidence, and it accelerates progress toward goals like saving for a trip, paying off loans, or investing in your future.',
    bestPractices: [
      'Track your spending consistently to understand your habits and make informed adjustments.',
      'Set specific financial goals so your budget reflects what matters most to you.',
      'Review and update your budget regularly to stay aligned with changes in income, expenses, or priority.',
    ],
  ),
  'Credit': CategoryInfo(
    text: 'The ability to borrow funds or obtain goods/services with the promise to pay it back later. It is your financial history that shows how reliably you borrow money.',
    whyItMatters: 'Credit matters because it determines your ability to borrow, get a loan, a job, housing, insurance, and many more.',
    bestPractices: [
      'Pay bills on time to avoid interest charges.',
      'Keep credit utilization below 30 percent as using too much of your available credit suggests high risks.',
      'Only apply for new credit when necessary as it could cause a temporary dip to your score.',
    ],
  ),
  'Debt': CategoryInfo(
    text: 'A strategic process of organizing, reducing, and paying off unsecured debts by creating a budget.',
    whyItMatters: 'Debt management matter because it enables you to avoid bankruptcy, lower interest costs, and pay off debt within three to five years.',
    bestPractices: [
      'Prioritize high-interest debt to minimize long term costs.',
      'Create a realistic budget to identify areas that need to be cut back and allocate more money towards debt repayment.',
      'Avoid using credit cards for non-essential purchases to stop adding to your debt.',
    ],
  ),
  'Savings': CategoryInfo(
    text: 'Savings are funds that are reserved for future use, emergencies, or retirement, providing financial security and flexibily.',
    whyItMatters: 'Savings matter because it builds financial security, reduces financial stress, prepares for unexpected expenses, and it enables financial independence.',
    bestPractices: [
      'Set up automatic, recurring transfers from your checking to your savings account to ensure consistent savings.',
      'Use high-yield savings accounts to maximize interest earnings, with having separate accounts for specific goals.',
      'Define clear, short and long-term financial goals to keep motivation high.',
    ],
  ),
  'Banking': CategoryInfo(
    text: 'It is financial institutions that protect money for others. It allows deposits, provides loans, and facilitates money transfers.',
    whyItMatters: 'Banking matters becuase it provides security for savings, access to credit, and efficient payment systems.',
    bestPractices: [
      'Set up accounting, transfer, and password change alerts.',
      'Have strong authentication, using unique, complex passwords for each account and enable Multi-Factor Authentication.',
      'Only use secure, private Wi-fi, avoiding public networks.',
    ],
  ),
  'Investing': CategoryInfo(
    text: 'The process of buying assets with the goal of generating more money over time. It builds wealth for long-term goals but involves risks, as the value of investments can fall instead of rise.',
    whyItMatters: 'Investing matters because it builds long-term wealth, protects against inflation, and achieve financial independence.',
    bestPractices: [
      'Diversify investments across different asset classes to reduce volatility and risk.',
      'Research and understand what you are investing in, including fees and potential risks.',
      'Ignore short-term market noise and avoid panic selling during downturns; buy and hold for long-term growth.',
    ],
  ),
};

Widget bulletItem(String text) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Icon(
            Icons.circle,
            size: 8,
            color: Colors.black,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontFamily: 'SF Pro',
              fontSize: 16,
              height: 1
            ),
          ),
        ),
      ],
    ),
  );
}