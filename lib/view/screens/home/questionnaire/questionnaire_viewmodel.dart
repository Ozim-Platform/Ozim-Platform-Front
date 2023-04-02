import 'dart:developer';

import 'package:charity_app/data/db/local_questionaires_db.dart';
import 'package:charity_app/model/questionnaire.dart';
import 'package:charity_app/persistance/api_provider.dart';
import 'package:http/http.dart';
import 'package:stacked/stacked.dart';

class QuestionnaireViewModel extends BaseViewModel {
  ApiProvider _apiProvider = ApiProvider();

  QuestionnaireData questionnaireData;
  List<QuestionPageData> questionairePageData = [];

  List<QuestionaireAnswer> questionaireAnswers = [];

  QuestionaireAnswers _questionaireAnswersToSend;
  int childId;
  QuestionaireAnswer _currentQuestionaireAnswer;
  QuestionPageData _currentQuestionairePageData;

  int _currentStep = 0;

  int get currentStep => _currentStep;

  QuestionaireAnswer get currentQuestionaireAnswer =>
      _currentQuestionaireAnswer;

  QuestionPageData get currentQuestionairePageData =>
      _currentQuestionairePageData;

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
      // if we do, we need to load it and display it to the user
      // how to get child id

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

        int haveAnswersTillIndex = 0;

        for (int i = 0; i < passedQuestionnaireData.questionList.length; i++) {
          if (localJsonHasAnyAnswerForThePage(
                  locallyStoredAnswer.answers.elementAt(i)) ==
              true) {
            var currentLocallyStoredAnswer =
                locallyStoredAnswer.answers.elementAt(i);
            questionaireAnswers.add(
              currentLocallyStoredAnswer,
            );
            haveAnswersTillIndex += 1;
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
      // _questionaireAnswersToSend = QuestionaireAnswers(
      //   answers: questionaireAnswers,
      //   childId: childId,
      //   // childId: questionnaireData.id,
      // );
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

  Future<bool> submitQuestionnaire(context) async {
    _questionaireAnswersToSend = QuestionaireAnswers(
      answers: questionaireAnswers,
      childId: childId,
      // childId: questionnaireData.id,
    );
    Response response = await _apiProvider.sendQuestionaire(
      _questionaireAnswersToSend.toJson(_questionaireAnswersToSend),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
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
    questionaireAnswer.answers.forEach(
      (element) {
        if (element.value != null) {
          hasAnyAnswer = true;
        }
      },
    );

    return hasAnyAnswer;
  }
}
