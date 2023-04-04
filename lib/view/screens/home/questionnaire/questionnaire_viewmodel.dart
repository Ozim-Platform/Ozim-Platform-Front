import 'dart:convert';
import 'dart:developer';

import 'package:charity_app/data/db/local_questionaires_db.dart';
import 'package:charity_app/model/questionnaire.dart';
import 'package:charity_app/persistance/api_provider.dart';
import 'package:charity_app/utils/toast_utils.dart';
import 'package:flutter/widgets.dart';

import 'package:http/http.dart';
import 'package:stacked/stacked.dart';

class QuestionnaireViewModel extends BaseViewModel {
  ApiProvider _apiProvider = ApiProvider();

  QuestionnaireData questionnaireData;

  List<QuestionPageData> questionairePageData = [];

  List<QuestionaireAnswer> questionaireAnswers = [];

  QuestionaireAnswers _questionaireAnswersToSend;

  TextEditingController emailController = TextEditingController();

  int childId;

  QuestionaireAnswer _currentQuestionaireAnswer;

  QuestionPageData _currentQuestionairePageData;

  int _currentStep = 0;

  int get currentStep => _currentStep;

  QuestionaireAnswer get currentQuestionaireAnswer =>
      _currentQuestionaireAnswer;

  QuestionPageData get currentQuestionairePageData =>
      _currentQuestionairePageData;

  String userEmail;

  QuestionnaireViewModel(QuestionnaireData passedQuestionnaireData, int childId,
      bool isResultModel) {
    this.childId = childId;
    init(passedQuestionnaireData, isResultModel);
  }

  Future<void> init(
      QuestionnaireData passedQuestionnaireData, bool isResultModel) async {
    setBusy(true);
    if (isResultModel) {
      passedQuestionnaireData.questionList.forEach(
        (element) {
          questionairePageData.add(element);
        },
      );

      passedQuestionnaireData.questionaireAnswers.answers.forEach(
        (element) {
          questionaireAnswers.add(element);
        },
      );

      questionnaireData = passedQuestionnaireData;
      _currentQuestionaireAnswer = questionaireAnswers[5];
      _currentQuestionairePageData = questionairePageData[5];
    } else {
      // check whether we have a local copy of the questionnaire answer

      QuestionaireAnswers locallyStoredAnswer =
          await getAvailableQuestionaireAnswers(
        passedQuestionnaireData.id,
        childId,
      );

      if (locallyStoredAnswer != null) {
        passedQuestionnaireData.questionList.forEach(
          (element) {
            questionairePageData.add(element);
          },
        );

        int haveAnswersTillIndex = hasAnswersTillScreen(locallyStoredAnswer);
        // int haveAnswersTillIndex = 0;

        for (int i = 0; i < passedQuestionnaireData.questionList.length; i++) {
          if (i <= haveAnswersTillIndex) {
            var currentLocallyStoredAnswer =
                locallyStoredAnswer.answers.elementAt(i);
            questionaireAnswers.add(
              currentLocallyStoredAnswer,
            );
          } else {
            questionaireAnswers.add(
              QuestionaireAnswer.withAnswerType(
                i,
                passedQuestionnaireData.questionList
                    .elementAt(
                      i,
                    )
                    .title,
              ),
            );
          }
        }

        _currentStep = haveAnswersTillIndex;
        questionnaireData = passedQuestionnaireData;

        _currentQuestionaireAnswer = questionaireAnswers[_currentStep];
        _currentQuestionairePageData = questionairePageData[_currentStep];
      } else {
        passedQuestionnaireData.questionList.forEach(
          (element) {
            questionairePageData.add(element);
          },
        );

        passedQuestionnaireData.questionList.forEach(
          (element) {
            questionaireAnswers.add(
              QuestionaireAnswer.withAnswerType(
                element.questionIndex,
                element.title,
              ),
            );
          },
        );

        questionnaireData = passedQuestionnaireData;
        _currentQuestionaireAnswer = questionaireAnswers[currentStep];
        _currentQuestionairePageData = questionairePageData[currentStep];
      }
    }

    notifyListeners();
    setBusy(false);
  }

  void nextStep() {
    // check whether a user had provided all answers

    _currentStep++;
    if (currentStep == 6) {
    } else {
      _currentQuestionairePageData = questionairePageData[currentStep];
      _currentQuestionaireAnswer = questionaireAnswers[currentStep];
    }
    notifyListeners();
  }

  void previousStep() {
    _currentStep--;
    _currentQuestionairePageData = questionairePageData[currentStep];
    _currentQuestionaireAnswer = questionaireAnswers[currentStep];
    notifyListeners();
  }

  void setAnswerWithoutComment(int questionIndex, int answer) {
    log("questionIndex: $questionIndex");
    // AnswerWithoutComment
    _currentQuestionaireAnswer.answers[questionIndex].value = answer;
    notifyListeners();
  }

  void setAnswerWithCommentValue(int questionIndex, bool answer) {
    // AnswerWithComment
    _currentQuestionaireAnswer.answers[questionIndex].value = answer;
    notifyListeners();
  }

  void setAnswerComment(int questionIndex, String answer) {
    // AnswerWithComment

    _currentQuestionaireAnswer.answers[questionIndex].comment = answer;
    notifyListeners();
  }

  void setUserEmail(String email) {
    userEmail = email;
  }

  Future<bool> submitQuestionnaire(context) async {
    _questionaireAnswersToSend = QuestionaireAnswers(
      answers: questionaireAnswers,
      childId: childId,
    );

    Response response = await _apiProvider.sendQuestionaire(
      _questionaireAnswersToSend.toJson(_questionaireAnswersToSend),
    );

    if (response.statusCode == 200) {
      _questionaireAnswersToSend = QuestionaireAnswers.fromJson(
        jsonDecode(response.body),
        childId,
      );

      questionaireAnswers = _questionaireAnswersToSend.answers;

      return true;
    } else {
      return false;
    }
  }

  Future<bool> sendResultsToEmail(BuildContext context) async {
    if (_questionaireAnswersToSend == null) {
      _questionaireAnswersToSend = questionnaireData.questionaireAnswers;
    }

    var responseStatus = await _apiProvider.sendQuestionaireResultsToEmail(
      _questionaireAnswersToSend.answerId,
      emailController.text,
    );
    if (responseStatus.statusCode == 200) {
      ToastUtils.toastSuccessGeneral("success", context);
      Navigator.of(context).popUntil((route) => route.isFirst);
      return true;
    } else {
      ToastUtils.toastErrorGeneral("error", context);

      return false;
    }
  }

  void saveQuestionnaireAnswersLocally() async {
    QuestionaireAnswers _questionaireAnswerToSaveLocally = QuestionaireAnswers(
      answers: questionaireAnswers,
      childId: childId,
    );

    Map<String, dynamic> mapToSave =
        _questionaireAnswerToSaveLocally.toSaveLocally(
      questionnaireData.id,
    );

    String key = "child_$childId" + "_questionaire${questionnaireData.id}";

    await SharedPreferencesHelper(key: key).saveData(mapToSave);
  }

  Future<QuestionaireAnswers> getAvailableQuestionaireAnswers(
      int questionaireId, int _childId) async {
    String key = "child_$_childId" + "_questionaire${questionaireId}";

    Map<dynamic, dynamic> localData =
        await SharedPreferencesHelper(key: key).readData();

    if (localData != null) {
      return QuestionaireAnswers.fromLocal(
        localData,
        _childId,
      );
    }
  }

  bool localJsonHasAnyAnswerForThePage(QuestionaireAnswer questionaireAnswer) {
    bool hasAnyAnswer = false;
    // iterate through a list of the answers and check untill which page do we have answers
    // return that page
    questionaireAnswer.answers.forEach(
      (element) {
        if (element.value != null) {
          hasAnyAnswer = true;
        }
      },
    );

    return hasAnyAnswer;
  }

  int hasAnswersTillScreen(QuestionaireAnswers questionaireAnswers) {
    int haveAnswersTillIndex = 0;
    int numberOfAnswersForCurrentPage = 0;
    int i = 0;
    int j = 0;

    for (int i = 0; i < 6; i += 1) {
      for (int j = 0; j < 6; j += 1) {
        log("i:$i");
        log("j:$j");
        if (questionaireAnswers.answers[i].answers[j].value != null) {
          numberOfAnswersForCurrentPage += 1;
        }
      }

      if (numberOfAnswersForCurrentPage == 5) {
        haveAnswersTillIndex += 1;
        numberOfAnswersForCurrentPage = 0;
      } else {
        return haveAnswersTillIndex;
      }
    }

    return haveAnswersTillIndex;
  }
}

    // for (; i < 5; i++) {
    //   //
    //   for (; j < 5; i++) {
    //     log("i: $i");
    //     log("j: $j");

    //     if (questionaireAnswers.answers[i].answers[j].value != null) {
    //       numberOfAnswersForCurrentPage += 1;
    //     }
    //     ;
    //     j += 1;
    //   }

    //   if (numberOfAnswersForCurrentPage == 5) {
    //     haveAnswersTillIndex += 1;
    //     numberOfAnswersForCurrentPage = 0;
    //   } else {
    //     return haveAnswersTillIndex;
    //   }
    //   i += 1;
    // }