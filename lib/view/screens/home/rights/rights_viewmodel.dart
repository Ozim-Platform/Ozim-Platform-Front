import 'package:charity_app/model/category.dart';
import 'package:charity_app/model/common_model.dart';
import 'package:charity_app/model/data.dart';
import 'package:charity_app/model/right.dart';
import 'package:charity_app/persistance/api_provider.dart';
import 'package:charity_app/utils/utils.dart';
import 'package:stacked/stacked.dart';

class RightViewModel extends BaseViewModel {
  ApiProvider _apiProvider = new ApiProvider();

  Right _right;

  Right get right => _right;

  CommonModel get instance => _right;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  List<Data> _folders = [];

  List<Data> get folders => _folders;

  List<Category> _category;

  Future<void> initModel(List<Category> category) async {
    _isLoading = true;
    List<Future> futures = [
      getRights(category),
      getBookMarks(),
    ];
    Future.wait(futures).whenComplete(() => {notifyListeners()});
  }

  Future<void> getBookMarks() async {
    _apiProvider
        .getBookMarkFoldersRecord(/*'right'*/)
        .then((value) => {_folders = value})
        .catchError((error) {
      print("Error: $error", level: 1);
    }).whenComplete(() => {notifyListeners()});
  }

  Future<void> getRights(List<Category> category) async {
    _isLoading = true;
    _category = category;
    _apiProvider
        .rights(category, 1)
        .then((value) => {_right = value})
        .catchError((error) {
      print("Error: $error", level: 1);
    }).whenComplete(() => {_isLoading = false, notifyListeners()});
  }

  Future<void> paginate() {
    // _isLoading = true;
    if (_right.page < _right.pages) {
      _apiProvider
          .rights(_category, _right.page + 1)
          .then((value) => {_right = value})
          .catchError((error) {
        print("Error: $error", level: 1);
      }).whenComplete(() => {_isLoading = false, notifyListeners()});
    }
  }
}
