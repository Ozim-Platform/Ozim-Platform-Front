import 'dart:developer';

import 'package:charity_app/model/base_response.dart';
import 'package:charity_app/model/questionnaire.dart';
import 'package:charity_app/persistance/api_provider.dart';
import 'package:charity_app/utils/toast_utils.dart';
import 'package:http/http.dart';
import 'package:stacked/stacked.dart';
import 'package:toast/toast.dart';

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

  QuestionnaireViewModel(QuestionnaireData passedQuestionnaireData,int childId) {
    this.childId = childId;
    init(passedQuestionnaireData);
  }

  void init(QuestionnaireData passedQuestionnaireData) {
    setBusy(true);
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
          ),
        );
      },
    );

    questionnaireData = passedQuestionnaireData;
    _currentQuestionaireAnswer = questionaireAnswers[currentStep];
    _currentQuestionairePageData = questionairePageData[currentStep];
    notifyListeners();
    setBusy(false);
  }

  void nextStep() {
    _currentStep++;
    if (currentStep == 6) {
      _questionaireAnswersToSend = QuestionaireAnswers(
        answers: questionaireAnswers,
        childId: childId,
        // childId: questionnaireData.id,
      );
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
    Response response = await _apiProvider.sendQuestionaire(
      _questionaireAnswersToSend.toJson(_questionaireAnswersToSend),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
