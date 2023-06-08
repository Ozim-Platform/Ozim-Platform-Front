import 'package:charity_app/model/article/article.dart';
import 'package:charity_app/model/common_model.dart';
import 'package:charity_app/model/data.dart';
import 'package:charity_app/model/diagnoses.dart';
import 'package:charity_app/model/skill_provider.dart';
import 'package:charity_app/persistance/api_provider.dart';
import 'package:charity_app/utils/utils.dart';
import 'package:stacked/stacked.dart';

class SearchViewModel extends BaseViewModel {
  ApiProvider _apiProvider = new ApiProvider();

  SearchViewModel(this.art, this.serv, this.diag);
  Article art;
  ServiceProvider serv;
  Diagnosis diag;

  Article _article;
  Article get article => _article;

  ServiceProvider _service;
  ServiceProvider get service => _service;

  Diagnosis _diagnosis;
  Diagnosis get diagnosis => _diagnosis;

  CommonModel get instance => (_article.data.isNotEmpty)
      ? _article
      : (_diagnosis.data.isNotEmpty ? _diagnosis : _service);

  List<Data> _folders = [];

  List<Data> get folders => _folders;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  initData() async {
    _isLoading = false;
    _article = art;
    _service = serv;
    _diagnosis = diag;
    await getBookMarks();
    notifyListeners();
  }

  Future<void> getBookMarks() async {
    _apiProvider
        .getBookMarkFolders()
        .then((value) => {_folders = value})
        .catchError((error) {
      print("Error: $error", level: 1);
    }).whenComplete(() => {notifyListeners()});
  }

  paginate() {}
}
