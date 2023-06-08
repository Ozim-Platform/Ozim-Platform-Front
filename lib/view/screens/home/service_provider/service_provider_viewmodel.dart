import 'package:charity_app/model/category.dart';
import 'package:charity_app/model/data.dart';
import 'package:charity_app/model/skill_provider.dart';
import 'package:charity_app/persistance/api_provider.dart';
import 'package:charity_app/utils/utils.dart';
import 'package:stacked/stacked.dart';

class ServiceProviderViewModel extends BaseViewModel {
  ApiProvider _apiProvider = new ApiProvider();

  ServiceProvider _links;

  ServiceProvider get links => _links;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  List<Category> _category = [];

  List<Category> get category => _category;

  List<Data> _folders = [];

  List<Data> get folders => _folders;

  Future<void> initModel(List<Category> category) async {
    _isLoading = true;
    List<Future> futures = [
      getServiceProvider(category),
      getBookMarks(),
    ];
    Future.wait(futures).whenComplete(() => {notifyListeners()});
  }

  Future<void> getBookMarks() async {
    _apiProvider
        .getBookMarkFoldersRecord(/*'service_provider'*/)
        .then((value) => {_folders = value})
        .catchError((error) {
      print("Error: $error", level: 1);
    }).whenComplete(() => {notifyListeners()});
  }

  Future<void> getServiceProvider(List<Category> category) async {
    _isLoading = true;
    _category = category;
    _apiProvider
        .serviceProvider(category, 1)
        .then((value) => {
              _category = category,
              _links = value,
              // _links.data.addAll(value.data) ,
              // _links.page = value.page,
              // _links.pages = value.pages,
              // _isLoading=false,
              // print(_links.toJson(), level: 2),
            })
        .catchError((error) {
      print("Error: $error");
    }).whenComplete(() => {_isLoading = false, notifyListeners()});
  }

  Future<void> reloadData() async {
    if (_category.isNotEmpty) {
      await getServiceProvider(_category);
    }
  }

  Future<void> paginate() {
    // _isLoading = true;
    if (_links.page < _links.pages) {
      _apiProvider
          .serviceProvider(_category, _links.page + 1)
          .then((value) => {
                _links.page = value.page,
                _links.pages = value.pages,
                _links.data.addAll(value.data),
              })
          .catchError((error) {
        print("Error: $error");
      }).whenComplete(() => {_isLoading = false, notifyListeners()});
    }
  }
}
