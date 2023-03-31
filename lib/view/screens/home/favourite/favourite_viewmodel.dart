import 'package:charity_app/localization/user_data.dart';
import 'package:charity_app/model/article/article.dart';
import 'package:charity_app/model/bookmark.dart';
import 'package:charity_app/model/common_model.dart';
import 'package:charity_app/model/data.dart';
import 'package:charity_app/persistance/api_provider.dart';
import 'package:charity_app/utils/utils.dart';
import 'package:stacked/stacked.dart';

class FavouriteViewModel extends BaseViewModel {
  ApiProvider _apiProvider = new ApiProvider();
  UserData _userData = new UserData();

  String token;

  List<Data> _elements;

  List<Data> get elements => _elements;

  CommonModel get instance {
    if(_elements!=null)
    return CommonModel.fromJson({"data": _elements.map((e) => e.toJson()).toList()});
    else return CommonModel(data: <Data>[], page: 0, pages: 0);
  }

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  List<Data> _folders = [];

  List<Data> get folders => _folders;

  Future<void> init() async {
    await getBookmarksFolders();
  }

  Future<void> getFavourite() async {
    _isLoading = true;
    _apiProvider.getBookMark().then((value) {
      _elements = value;
    }).catchError((error, trace) {
      print("Error: $error", level: 1);
      print(trace, level: 1);
    }).whenComplete(() => {_isLoading = false, notifyListeners()});
  }

  Future<void> getBookmarksFolders() async {
    _apiProvider.getBookMarkFolders().then((value) {
      _folders = value;
    }).catchError((error) {
      print("Error: $error", level: 1);
    }).whenComplete(() => {notifyListeners()});
  }
}
