import 'package:charity_app/model/article/article.dart';
import 'package:charity_app/model/diagnoses.dart';
import 'package:charity_app/model/skill_provider.dart';

class SearchData {
  Article article;
  ServiceProvider service;
  Diagnosis diagnosis;

  SearchData.fromJson(Map<String, dynamic> json) {
    article = json['article'];
    service = json['service'];
    diagnosis = json['diagnosis'];
  }
}
