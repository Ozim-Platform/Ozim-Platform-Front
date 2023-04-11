import 'package:charity_app/model/category.dart';
import 'package:charity_app/model/common_model.dart';
import 'package:charity_app/model/data.dart';
import 'package:charity_app/model/skill.dart';
import 'package:charity_app/persistance/api_provider.dart';
import 'package:charity_app/utils/utils.dart';
import 'package:stacked/stacked.dart';

class SkillViewModel extends BaseViewModel {
  ApiProvider _apiProvider = new ApiProvider();

  Skill _skill;

  Skill get skill => _skill;

  CommonModel get instance => _skill;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  List<Data> _folders = [];

  List<Data> get folders => _folders;

  List<Category> _category;

  Future<void> initModel(List<Category> category) async {
    _isLoading = true;
    _category = category;
    List<Future> futures = [
      getSkill(category),
      getBookMarks(),
    ];
    Future.wait(futures).whenComplete(() => {notifyListeners()});
  }

  Future<void> getBookMarks() async {
    _apiProvider
        .getBookMarkFoldersRecord(/*'skill'*/)
        .then((value) => {_folders = value})
        .catchError((error) {
      print("Error: $error", level: 1);
    }).whenComplete(() => {notifyListeners()});
  }

  Future<void> getSkill(List<Category> category) async {
    _isLoading = true;
    _category = category;
    _apiProvider
        .skill(category, 1)
        .then((value) => {
              _skill = value,
            })
        .catchError((error) {
      print("Error: $error", level: 1);
    }).whenComplete(() => {_isLoading = false, notifyListeners()});
  }

  Future<void> paginate() {
    // _isLoading = true;
    if (_skill.page < _skill.pages) {
      _apiProvider
          .skill(_category, _skill.page + 1)
          .then((value) => {
                _skill.data.addAll(value.data),
                _skill.page = value.page,
                _skill.pages = value.pages,
              })
          .catchError((error) {
        print("Error: $error", level: 1);
      }).whenComplete(() => {_isLoading = false, notifyListeners()});
    }
  }
}
