import 'package:charity_app/localization/user_data.dart';
import 'package:charity_app/model/faq.dart';
import 'package:charity_app/utils/utils.dart';
import 'package:charity_app/persistance/api_provider.dart';
import 'package:stacked/stacked.dart';

class FaqViewModel extends BaseViewModel {
  ApiProvider _apiProvider = new ApiProvider();

  Faq _faq;

  Faq get faq => _faq;

  bool _isLoading = true;

  bool get isLoading => _isLoading;
  
  Future<void> getFaqData() async {
    _isLoading = true;
    _apiProvider.getFaq().then((value) => {_faq = value}).catchError((error) {
      print("Error: $error", level: 1);
    }).whenComplete(() => {_isLoading = false, notifyListeners()});
  }
}
