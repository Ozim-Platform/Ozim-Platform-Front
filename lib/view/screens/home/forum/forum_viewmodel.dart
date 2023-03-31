import 'package:charity_app/localization/user_data.dart';
import 'package:charity_app/model/forum/forum_category.dart';
import 'package:charity_app/model/forum/forum_sub_category.dart';
import 'package:charity_app/persistance/api_provider.dart';
import 'package:charity_app/utils/utils.dart';
import 'package:stacked/stacked.dart';

class ForumViewModel extends BaseViewModel {
  ApiProvider _apiProvider = new ApiProvider();

  List<ForumCategory> _forumCategory;
  List<ForumCategory> get forumCategory => _forumCategory;

  List<ForumSubCategory> _forumSubCategory;
  List<ForumSubCategory> get forumSubCategory => _forumSubCategory;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  Future<void> fetchAllData() async {
    await getForumSubCategory();
    await getForumCategory();
    // await getForumsDetails();
  }

  Future<void> getForumCategory() async {
    _isLoading = true;
    _apiProvider
        .getForumCategory()
        .then((value) => {_forumCategory = value})
        .catchError((error) {
      print("Error: $error", level: 1);
    }).whenComplete(() => {_isLoading = false, notifyListeners()});
  }

  Future<void> getForumSubCategory() async {
    _apiProvider
        .getForumSubCategory()
        .then((value) => {_forumSubCategory = value})
        .catchError((error, trace) {
      print("Error: $error", level: 1);
      print(trace, level: 1);
    }).whenComplete(() => {_isLoading = false, notifyListeners()});
  }
}
