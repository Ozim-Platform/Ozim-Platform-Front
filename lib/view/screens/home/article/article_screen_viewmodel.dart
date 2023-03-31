import 'package:charity_app/model/article/article.dart';
import 'package:charity_app/model/category.dart';
import 'package:charity_app/model/data.dart';
import 'package:charity_app/utils/utils.dart';
import 'package:charity_app/model/common_model.dart';
import 'package:charity_app/persistance/api_provider.dart';
import 'package:stacked/stacked.dart';

class ArticleViewModel extends BaseViewModel {
  ApiProvider _apiProvider = new ApiProvider();
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Article _article;

  Article get article => _article;

  CommonModel get instance => _article;

  List<Data> _folders = [];

  List<Data> get folders => _folders;

  Future<void> initModel(List<Category> category) async {
    _isLoading = true;
    List<Future> futures = [
      getAllArticle(category),
      getBookMarks(),
    ];

    Future.wait(futures).whenComplete(() => {notifyListeners()});
  }

  Future<void> getAllArticle(List<Category> category) async {
    _isLoading = true;
    _apiProvider
        .getArticle(category: category)
        .then((value) => {_article = value})
        .catchError((error, stacktrace) {
      print("Error: $error", level: 1);
    }).whenComplete(() => {_isLoading = false, notifyListeners()});
  }

  Future<void> getBookMarks() async {
    _apiProvider
        .getBookMarkFolders()
        .then((value) => {_folders = value})
        .catchError((error) {
      print("Error: $error", level: 1);
    }).whenComplete(() => {notifyListeners()});
  }

  Future<void> getArticle(int articleid) async {
    _apiProvider
        .getArticle(id: articleid)
        .then((value) => {

    })
        .catchError((error, stacktrace) {
      print("Error: $error", level: 1);
    });
  }
}
