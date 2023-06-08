import 'package:charity_app/data/db/local_questionaires_db.dart';
import 'package:charity_app/model/child/child.dart';
import 'package:charity_app/model/questionnaire.dart';
import 'package:charity_app/persistance/api_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:stacked/stacked.dart';

class ProfileViewModel extends BaseViewModel {
  ApiProvider _apiProvider = new ApiProvider();

  bool _isLoading = false;

  ValueNotifier<bool> shouldShowChildQuestionaire = ValueNotifier(false);

  List<Child> _children = [];
  List<Child> get children => _children;
  ValueNotifier<bool> navigateToAddChild = ValueNotifier(false);

  Child childToDisplay;
  QuestionnaireData questionnaireDataToDisplay;

  // iterate through all children, when meet new questionaire check if we already notified the user about it
  // if not then notify and save the date of notification

  Future<void> initModel(var childIdFromPush) async {
    _isLoading = true;
    checkNewQuestionaires(childIdFromPush);
  }

  Future<List<Child>> getChildren() async {
    _children = await _apiProvider.getChildren();
    _children.length != 0
        ? navigateToAddChild.value = false
        : navigateToAddChild.value = true;
    notifyListeners();
    return _children;
  }

  // we should check whether a user has child with available questionaire
  Future<void> checkNewQuestionaires(var childIdFromPush) async {
    List<Child> children = [];

    children = await getChildren();
    if (children.length != 0) {
      navigateToAddChild.value = false;
    } else {
      navigateToAddChild.value = true;
    }
    notifyListeners();
    if (childIdFromPush != null) {
      children.forEach(
        (element) {
          if (element.childId == childIdFromPush) {
            childToDisplay = element;
            questionnaireDataToDisplay = element.newQuestionnaires[0];
            questionnaireDataToDisplay = element.newQuestionnaires[0];
            shouldShowChildQuestionaire.value = true;
          }
        },
      );
    }
    if (childIdFromPush == null) {
      for (Child child in children) {
        {
          if (child.newQuestionnaires.length > 0) {
            // check if we already notified the user about this new questioanire

            // key would be a child_id and questionnaire_id

            String key = "local_notification_child_" +
                child.childId.toString() +
                "questionaire_" +
                child.newQuestionnaires[0].id.toString();

            var notificationDate =
                await SharedPreferencesHelper(key: key).readNotificationDate();

            if (notificationDate != null) {
              // we already notified the user about this new questionaire

              // calculate the difference between current date and the date of notification

              // if the difference is more than 7 days then notify again
              Duration differenceBetweenPreviousShow =
                  DateTime.now().difference(
                DateTime.parse(notificationDate),
              );

              if (differenceBetweenPreviousShow.compareTo(
                    Duration(days: 7),
                  ) >=
                  0) {
                // notify

                // save
                childToDisplay = child;
                questionnaireDataToDisplay = child.newQuestionnaires[0];
                shouldShowChildQuestionaire.value = true;
                await SharedPreferencesHelper(key: key).saveNotificationDate(
                  DateTime.now().toString(),
                );
                break;
              } else {
                shouldShowChildQuestionaire.value = false;
                break;
              }
            } else {
              childToDisplay = child;
              questionnaireDataToDisplay = child.newQuestionnaires[0];
              shouldShowChildQuestionaire.value = true;
              await SharedPreferencesHelper(key: key)
                  .saveNotificationDate(DateTime.now().toString());
              break;
            }
          }
        }
      }
    }

    notifyListeners();
  }

  Future<void> doNotShowNotification() {
    shouldShowChildQuestionaire.value = false;

    notifyListeners();
  }
}
