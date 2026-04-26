import 'package:moneyup/core/config/env_config.dart';

class SupabaseConfig {
  static String get url => EnvConfig.supabaseUrl;
  static String get key => EnvConfig.supabaseKey;
}
