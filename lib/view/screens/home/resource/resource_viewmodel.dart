import 'package:charity_app/model/category.dart';
import 'package:charity_app/model/links.dart';
import 'package:charity_app/persistance/api_provider.dart';
import 'package:charity_app/utils/utils.dart';
import 'package:stacked/stacked.dart';
import 'package:url_launcher/url_launcher.dart';

class ResourceViewModel extends BaseViewModel {
  ApiProvider _apiProvider = new ApiProvider();

  Links _links;
  Links get links => _links;

  List<Category> _category;
  List<Category> get category => _category;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isLoadingCategory = false;
  bool get isLoadingCategory => _isLoadingCategory;

  Future<void> getCategory() async {
    _isLoadingCategory = true;
    _apiProvider
        .getCategory()
        .then((value) => {
              _category = value,
            })
        .catchError((error) {
      //print("Error: $error");
    }).whenComplete(() => {_isLoadingCategory = false, notifyListeners()});
  }

  Future<void> getLinks(List<Category> category) async {
    _isLoading = true;
    _apiProvider
        .getLinks(category)
        .then((value) => {
              _links = value,
            })
        .catchError((error) {
      //print("Error: $error");
    }).whenComplete(() => {_isLoading = false, notifyListeners()});
  }

  Future<void> launchURL(String url, context) async {
    print(url);
    await goToUrl(url, context);
  }
}
