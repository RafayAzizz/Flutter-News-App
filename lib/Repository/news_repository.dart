import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:news_app/Model/news_category_model.dart';
import 'package:news_app/Model/news_headlines_model.dart';




class NewsRepository{

  Future<TopHeadlinesModel> fetchNewsHeadlines(String channelName)async{

    String url = "https://newsapi.org/v2/top-headlines?sources=${channelName}&apiKey=c3b0cb07596e45808586b0329d10555e";
    final response = await http.get(Uri.parse(url));
    if(response.statusCode == 200){
      final body = jsonDecode(response.body);
      return TopHeadlinesModel.fromJson(body);
    }

    throw Exception('Error');


  }

  Future<NewsCategoryModel> fetchNewsCategory(String category)async{
    String url = "https://newsapi.org/v2/everything?q=${category}&apiKey=c3b0cb07596e45808586b0329d10555e";
    final response = await http.get(Uri.parse(url));

    if(response.statusCode == 200){
      final body= jsonDecode(response.body);
      return NewsCategoryModel.fromJson(body);

    }
    throw Exception('Error');
  }

}