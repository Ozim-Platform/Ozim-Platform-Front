import 'package:charity_app/model/questionnaire.dart';

class ChildAge {
  int years;
  int months;

  ChildAge({this.years, this.months});

  ChildAge.fromInteger(int age) {
    years = age ~/ 12;
    months = age % 12;
  }
}

class Child {
  int childId;
  String name;
  String birthDate;
  int age;
  bool isGirl;
  List<QuestionnaireData> results = [];
  List<QuestionnaireData> newQuestionnaires = [];
  ChildAge childAge;
  int page;
  int pages;
  Child(
      {this.name,
      this.age,
      this.isGirl,
      this.birthDate,
      this.childId,
      this.newQuestionnaires,
      this.results,
      this.page,
      this.pages});

  Child.fromJson(Map<String, dynamic> json) {
    if (json['new_questionnaires'] is List == false) {
      // if user has new questionaires
      var newQuestionairesJsonList = json['new_questionnaires']
          as Map<String, dynamic>; // value here is a Map
      var questionareList =
          newQuestionairesJsonList.values; // values here is a List
      questionareList.forEach(
        (element) {
          element.forEach(
            (element1) {
              newQuestionnaires.add(
                QuestionnaireData.fromJson(
                  element1,
                  json['id'],
                ),
              );
            },
          );
        },
      );
    }

    if (json['results'] is List == false) {
      var resultsJsonList = json['results'] as Map<String, dynamic>;
      resultsJsonList.forEach(
        (key, value) {
          value.forEach(
            (mapOfQuestionaireData) {
              QuestionnaireData currentQuestonaireWithResultData =
                  QuestionnaireData.fromJson(
                      mapOfQuestionaireData["questionnaire"], childId);
              currentQuestonaireWithResultData.questionaireAnswers =
                  QuestionaireAnswers.fromJson(
                mapOfQuestionaireData["answers"],
                childId,
                // mapOfQuestionaireData["id"]
              );
              currentQuestonaireWithResultData.questionaireAnswers.answerId =
                  mapOfQuestionaireData["id"];
              results.add(currentQuestonaireWithResultData);
            },
          );
        },
      );
    }

    childId = json['id'];
    name = json['name'];
    birthDate = json['birth_date'];
    isGirl = json['gender'] == 1 ? true : false;
    age = json['age'];
    page = json['page'];
    pages = json['pages'];
    results = results;
    newQuestionnaires = newQuestionnaires;
  }

  ChildAge getAgeInDateTime() {
    if (childAge == null) {
      childAge = ChildAge.fromInteger(
        age,
      );
    }
    return childAge;
  }
}
