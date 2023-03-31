import 'package:charity_app/model/category.dart';
import 'package:charity_app/model/common_model.dart';
import 'package:charity_app/model/data.dart';
import 'package:charity_app/model/inclusion.dart';
import 'package:charity_app/persistance/api_provider.dart';
import 'package:charity_app/utils/utils.dart';
import 'package:stacked/stacked.dart';

class InclusionViewModel extends BaseViewModel {
  ApiProvider _apiProvider = new ApiProvider();

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Inclusion _inclusion;

  Inclusion get inclusion => _inclusion;

  CommonModel get instance => _inclusion;

  List<Data> _folders = [];

  List<Data> get folders => _folders;

  Future<void> initModel(List<Category> category) async {
    _isLoading = true;
    List<Future> futures = [
      getInclusion(category),
      getBookMarks(),
    ];
    Future.wait(futures).whenComplete(() => {notifyListeners()});
  }

  Future<void> getBookMarks() async {
    _apiProvider
        .getBookMarkFoldersRecord(/*'inclusion'*/)
        .then((value) => {_folders = value})
        .catchError((error) {
      print("Error: $error", level: 1);
    }).whenComplete(() => {notifyListeners()});
  }

  Future<void> getInclusion(List<Category> category) async {
    _isLoading = true;
    _apiProvider
        .inclusion(category)
        .then((value) => {_inclusion = value})
        .catchError((error) {
      print("Error: $error", level: 1);
    }).whenComplete(() => {_isLoading = false, notifyListeners()});
  }
}
