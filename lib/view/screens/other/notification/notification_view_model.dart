import 'package:charity_app/localization/user_data.dart';
import 'package:charity_app/persistance/api_provider.dart';
import 'package:stacked/stacked.dart';

class NotificationViewModel extends BaseViewModel {
  ApiProvider _apiProvider = new ApiProvider();
  UserData _userData = new UserData();
  
  bool _isLoading = true;
  bool get isLoading => _isLoading;

  String _username;
  String get username => _username;

  String _avatar;
  String get avatar => _avatar;

  String _userType;
  String get userType => _userType;
  
  Future<void> init() async {
    _username = await _userData.getUsername();
    _avatar = await _userData.getAvatar();
    _userType = await _userData.getUserType();
    _isLoading = false;
    notifyListeners();
  }

  
}
