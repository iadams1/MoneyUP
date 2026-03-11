import 'package:flutter/material.dart';
import 'package:moneyup/models/article.dart';
import 'package:moneyup/models/daily_tip.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


class ArticleService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<List<Article>> fetchRandomArticles() async {
    final response = await _client.rpc(
      'get_random_articles',
      params: {'p_limit': 2},
    );

    final rows = List<Map<String, dynamic>>.from(response);
    return rows.map(Article.fromJson).toList();
  }

  Future<List<DailyTip>> fetchDailyTips() async {
    debugPrint('fetchDailyTips CALLED');

    final response = await _client.rpc('get_today_tips');

    debugPrint('fetchDailyTips RESPONSE: $response');

    final rows = List<Map<String, dynamic>>.from(response);
    return rows.map(DailyTip.fromJson).toList();
  }

  Future<List<Article>> getArticleByCategory(String category) async {
    final response = await _client
        .from('Educational')
        .select('*')
        .eq('category', category);

    final rows = List<Map<String, dynamic>>.from(response);
    return rows.map(Article.fromJson).toList();
  }

  Future<List<Article>> getAllArticles() async {
    final response = await _client
        .from('Educational')
        .select('*')        
        .order('created_at', ascending: false); 

    final rows = List<Map<String, dynamic>>.from(response);
    return rows.map(Article.fromJson).toList();
  }

  Future<Article> getArticleById(int id) async {
    final response = await _client
        .from('Educational')
        .select('*')
        .eq('id', id)
        .single();

    return Article.fromJson(response);
  }
}