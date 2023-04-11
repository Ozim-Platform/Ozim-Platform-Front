import 'dart:convert';
import 'dart:developer';

import 'package:charity_app/data/db/local_questionaires_db.dart';
import 'package:charity_app/localization/language_constants.dart';
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
  bool isLoading;
  List<TextEditingController> commentControllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];

  QuestionaireAnswer _currentQuestionaireAnswer;

  QuestionPageData _currentQuestionairePageData;

  int _currentStep = 0;

  int get currentStep => _currentStep;

  QuestionaireAnswer get currentQuestionaireAnswer =>
      _currentQuestionaireAnswer;

  QuestionPageData get currentQuestionairePageData =>
      _currentQuestionairePageData;

  String userEmail;

  QuestionnaireViewModel(
      {QuestionnaireData passedQuestionnaireData,
      int childId,
      bool isResultModel}) {
    this.childId = childId;
    init(passedQuestionnaireData, isResultModel);
  }

  Future<void> init(
      QuestionnaireData passedQuestionnaireData, bool isResultModel) async {
    // refactor all this piece of code
    setBusy(true);
    if (isResultModel) {
      actionIfResultModel(passedQuestionnaireData);
    } else {
      // check whether we have a local copy of the questionnaire answer

      QuestionaireAnswers locallyStoredAnswer =
          await getAvailableQuestionaireAnswers(
        passedQuestionnaireData.id,
        childId,
      );
      // act accrodingly
      if (locallyStoredAnswer != null) {
        actionIfStoredLocally(passedQuestionnaireData, locallyStoredAnswer);
      } else {
        actionIfNotStoredLocally(passedQuestionnaireData);
      }
    }

    notifyListeners();
    setBusy(false);
  }

  void actionIfResultModel(QuestionnaireData passedQuestionnaireData) {
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
  }

  void nextStep() {
    _currentStep++;
    if (currentStep == 6) {
    } else {
      _currentQuestionairePageData = questionairePageData[currentStep];
      _currentQuestionaireAnswer = questionaireAnswers[currentStep];
    }

    notifyListeners();
  }

  void previousStep(BuildContext context) {
    if (currentStep != null && currentStep != 0) {
      _currentStep--;
      _currentQuestionairePageData = questionairePageData[currentStep];
      _currentQuestionaireAnswer = questionaireAnswers[currentStep];
      notifyListeners();
    } else {
      // pop untill first route
      Navigator.of(context).pop();
    }
  }

  void setAnswerWithoutComment(int questionIndex, int answer) {
    // AnswerWithoutComment
    _currentQuestionaireAnswer.answers[questionIndex].value = answer;
    notifyListeners();
  }

  setAnswerWithCommentValue(int questionIndex, bool answer) {
    // AnswerWithComment
    _currentQuestionaireAnswer.answers[questionIndex].value = answer;
    notifyListeners();
  }

  setAnswerComment() {
    // iterate through the controllers and set the comment
    for (int i = 0; i < 6; i++) {
      _currentQuestionaireAnswer.answers[i].comment =
          commentControllers[i].text;
    }

    // AnswerWithComment
    // log(answer);
    // _currentQuestionaireAnswer.answers[questionIndex].comment = answer;
    notifyListeners();
  }

  void setUserEmail(String email) {
    userEmail = email;
  }

  Future<bool> submitQuestionnaire(context) async {
    // get values from the controllers and set them to the answer

    setAnswerComment();
    // create an object which will be converted to json and sent to server
    _questionaireAnswersToSend = QuestionaireAnswers(
      answers: questionaireAnswers,
      childId: childId,
    );

    Response response = await _apiProvider.sendQuestionaire(
      _questionaireAnswersToSend.toJson(_questionaireAnswersToSend),
    );

    if (response.statusCode == 200) {
      _questionaireAnswersToSend = QuestionaireAnswers.fromJson(
        jsonDecode(response.body)["answers"],
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
      answerId: _questionaireAnswersToSend.answerId,
      email: emailController.text,
    );

    if (responseStatus.statusCode == 200) {
      ToastUtils.toastSuccessGeneral(
        getTranslated(context, "success"),
        context,
      );
      Navigator.of(context).popUntil((route) => route.isFirst);
      return true;
    } else {
      ToastUtils.toastErrorGeneral(
        getTranslated(context, "error"),
        context,
      );

      return false;
    }
  }

  saveQuestionnaireAnswersLocally() async {
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

  actionIfStoredLocally(
    QuestionnaireData passedQuestionnaireData,
    QuestionaireAnswers locallyStoredAnswer,
  ) {
    passedQuestionnaireData.questionList.forEach(
      (element) {
        questionairePageData.add(element);
      },
    );

    int haveAnswersTillIndex = hasAnswersTillScreen(locallyStoredAnswer);

    for (int i = 0; i < passedQuestionnaireData.questionList.length; i++) {
      if (i <= haveAnswersTillIndex) {
        questionaireAnswers.add(
          locallyStoredAnswer.answers.elementAt(
            i,
          ),
        );
      } else {
        questionaireAnswers.add(
          QuestionaireAnswer.withAnswerType(
            i,
            passedQuestionnaireData.questionList.elementAt(i).title,
          ),
        );
      }
    }

    _currentStep = haveAnswersTillIndex;
    questionnaireData = passedQuestionnaireData;

    _currentQuestionaireAnswer = questionaireAnswers[_currentStep];
    _currentQuestionairePageData = questionairePageData[_currentStep];
  }

  actionIfNotStoredLocally(
    QuestionnaireData passedQuestionnaireData,
  ) {
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
