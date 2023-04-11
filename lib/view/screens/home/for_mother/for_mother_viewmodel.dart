import 'package:charity_app/model/category.dart';
import 'package:charity_app/model/common_model.dart';
import 'package:charity_app/model/data.dart';
import 'package:charity_app/model/for_mother.dart';
import 'package:charity_app/persistance/api_provider.dart';
import 'package:charity_app/utils/utils.dart';
import 'package:stacked/stacked.dart';

class For_ParentViewModel extends BaseViewModel {
  ApiProvider _apiProvider = new ApiProvider();

  For_Parent _formother;

  For_Parent get formother => _formother;

  CommonModel get instance => _formother;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  List<Data> _folders = [];

  List<Data> get folders => _folders;

  List<Category> _category;

  Future<void> initModel(List<Category> category) async {
    _isLoading = true;
    List<Future> futures = [
      getForMother(category),
      getBookMarks(),
    ];
    Future.wait(futures).whenComplete(() => {notifyListeners()});
  }

  Future<void> getForMother(List<Category> category) async {
    _isLoading = true;
    _category = category;
    _apiProvider
        .forMother(category, 1)
        .then((value) => {
              // _formother.data.addAll( value.data),
              _formother = value,
              // _formother.page = value.page,
              // _formother.pages = value.pages,
              //                 _isLoading = false,

            })
        .catchError((error) {
      print("Error: $error", level: 1);
    }).whenComplete(() => {_isLoading = false, notifyListeners()});
  }

  Future<void> getBookMarks() async {
    _apiProvider
        .getBookMarkFoldersRecord(/*'for_parent'*/)
        .then((value) => {_folders = value})
        .catchError((error) {
      print("Error: $error", level: 1);
    }).whenComplete(() => {notifyListeners()});
  }

  Future<void> paginate() {
    // _isLoading = true;
    notifyListeners();
    if (_formother.page < _formother.pages) {
      return _apiProvider
          .forMother(_category, _formother.page + 1)
          .then((value) => {
                _formother.data.addAll(value.data),
                _formother.page = value.page,
                _formother.pages = value.pages,
                _isLoading = false,
              })
          .catchError((error) {
        print("Error: $error", level: 1);
      }).whenComplete(() => {_isLoading = false, notifyListeners()});
    }
  }
}
