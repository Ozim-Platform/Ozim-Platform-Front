import 'dart:developer';

import 'package:charity_app/model/questionnaire.dart';

class Child {
  int childId;
  String name;
  String birthDate;
  int age;
  bool isGirl;
  List<QuestionnaireData> results = [];
  List<QuestionnaireData> newQuestionnaires = [];

  Child(
      {this.name,
      this.age,
      this.isGirl,
      this.birthDate,
      this.childId,
      this.newQuestionnaires});

  Child.fromJson(Map<String, dynamic> json) {
    if (json['new_questionnaires'] is List == false) {
      var newQuestionairesJsonList = json['new_questionnaires']
          as Map<String, dynamic>; // value here is a Map
      var questionareList =
          newQuestionairesJsonList.values; // values here is a List
      questionareList.forEach(
        (element) {
          element.forEach(
            (element1) {
              newQuestionnaires
                  .add(QuestionnaireData.fromJson(element1, json['id']));
            },
          );
        },
      );
    }

    // if (json['results'] is List == false) {
    //   var resultsJsonList = json['results'] as Map<String, dynamic>;
    //   results = [];
    //   resultsJsonList.forEach(
    //     (key, value) {
    //       value = value as List<dynamic>;
    //       value.forEach(
    //         (element) {
    //           results.add(QuestionnaireData.fromJson(element, json['id']));
    //         },
    //       );
    //     },
    //   );
    // }

    childId = json['id'];
    name = json['name'];
    birthDate = json['birthDate'];
    isGirl = json['gender'] == 1 ? true : false;
    age = json['age'];
    results = results;
    newQuestionnaires = newQuestionnaires;
  }
}
