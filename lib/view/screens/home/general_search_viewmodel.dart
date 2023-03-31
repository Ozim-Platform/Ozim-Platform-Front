import 'package:charity_app/model/article/article.dart';
import 'package:charity_app/model/common_model.dart';
import 'package:charity_app/model/diagnoses.dart';
import 'package:charity_app/model/skill_provider.dart';
import 'package:charity_app/persistance/api_provider.dart';
import 'package:charity_app/utils/utils.dart';
import 'package:stacked/stacked.dart';

class GeneralSearchViewModel extends BaseViewModel {
  ApiProvider _apiProvider = new ApiProvider();

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Article _article;
  Article get article => _article;

  ServiceProvider _service;
  ServiceProvider get service => _service;

  Diagnosis _diagnosis;
  Diagnosis get diagnosis => _diagnosis;

  setLoading() {
    _isLoading = true;
  }

  Future<void> search(String query) async {
    _isLoading = true;
    _apiProvider
        .searchArticle(query)
        .then((value) => {
              _article = value.article,
              _service = value.service,
              _diagnosis = value.diagnosis
            })
        .catchError((error) {
      print("Error: $error", level: 1);
    }).whenComplete(() => {_isLoading = false, notifyListeners()});
  }
}
