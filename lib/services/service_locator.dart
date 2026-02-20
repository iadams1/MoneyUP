import 'package:moneyup/services/profile_service.dart';

import '/services/article_service.dart';
import '/services/supabase_service.dart';
import '/services/budget_service.dart';
import '/services/my_wallet_service.dart';

final supabaseService = SupabaseService();
final budgetService = BudgetService();
final articleService = ArticleService();
final walletService = MyWalletService();
final profileService = ProfileService();