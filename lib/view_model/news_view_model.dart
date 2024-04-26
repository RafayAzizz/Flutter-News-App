

import 'package:news_app/Model/news_category_model.dart';
import 'package:news_app/Model/news_headlines_model.dart';
import 'package:news_app/Repository/news_repository.dart';

class NewsViewModel {

  final _rep = NewsRepository();

  Future<TopHeadlinesModel> fetchNewsHeadlines(String channelName) async{
    final response = await _rep.fetchNewsHeadlines(channelName);
    return response;
  }

  Future<NewsCategoryModel> fetchNewsCategory(String category)async{
    // final _rep =NewsRepository();

    final response= _rep.fetchNewsCategory(category);
    return response;
  }
}