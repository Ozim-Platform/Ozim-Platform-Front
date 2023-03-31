import 'package:charity_app/model/category.dart';
import 'package:charity_app/model/common_model.dart';
import 'package:charity_app/model/data.dart';
import 'package:charity_app/model/diagnoses.dart';
import 'package:charity_app/persistance/api_provider.dart';
import 'package:charity_app/utils/utils.dart';
import 'package:stacked/stacked.dart';

class DiagnosisViewModel extends BaseViewModel {
  ApiProvider _apiProvider = new ApiProvider();

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Diagnosis _diagnoses;

  Diagnosis get diagnoses => _diagnoses;

  CommonModel get instance => _diagnoses;

  List<Data> _folders = [];

  List<Data> get folders => _folders;

  Future<void> initModel(List<Category> category) async {
    _isLoading = true;
    List<Future> futures = [
      getDiagnoses(category),
      getBookMarks(),
    ];
    Future.wait(futures).whenComplete(() => {notifyListeners()});
  }

  Future<void> getBookMarks() async {
    _apiProvider
        .getBookMarkFoldersRecord(/*'diagnosis'*/)
        .then((value) => {_folders = value})
        .catchError((error) {
      print("Error: $error", level: 1);
    }).whenComplete(() => {notifyListeners()});
  }

  Future<void> getDiagnoses(List<Category> category) async {
    _isLoading = true;
    _apiProvider
        .getDiagnoses(category)
        .then((value) => {_diagnoses = value})
        .catchError((error) {
      print("Error: $error", level: 1);
    }).whenComplete(() => {_isLoading = false, notifyListeners()});
  }
}
