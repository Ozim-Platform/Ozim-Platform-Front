import 'package:charity_app/localization/language_constants.dart';
import 'package:charity_app/model/questionnaire.dart';
import 'package:charity_app/utils/device_size_config.dart';
import 'package:charity_app/view/components/no_data.dart';
import 'package:charity_app/view/screens/home/questionnaire/questionnaire_answer_screen.dart';
import 'package:charity_app/view/screens/home/questionnaire/questionnaire_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:charity_app/view/screens/home/questionnaire/questionaire_appbar.dart';

class QuestionnaireScreen extends StatefulWidget {
  final QuestionnaireData data;
  QuestionnaireViewModel viewModel;
  int childId;
  QuestionnaireScreen({
    Key key,
    this.data,
    this.viewModel,
    this.childId,
  }) : super(key: key);

  @override
  State<QuestionnaireScreen> createState() => _QuestionnaireScreenState();
}

class _QuestionnaireScreenState extends State<QuestionnaireScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<QuestionnaireViewModel>.reactive(
      viewModelBuilder: () {
        if (widget.viewModel != null) {
          return widget.viewModel;
        } else {
          return QuestionnaireViewModel(
            widget.data,
            widget.childId,
            false,
          );
        }
      },
      disposeViewModel: false,
      builder: (context, model, child) {
        if (model.isBusy) {
          return Container();
        } else {
          return Scaffold(
            appBar: customAppbarForQuestionaire(
              context: context,
              appBarTitle: '',
              appBarIncome: "Опросник",
            ),
            backgroundColor: Colors.white,
            body: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  getListUI(
                    context,
                    model,
                  ),
                  SizedBox(height: SizeConfig.calculateBlockVertical(10)),
                ],
              ),
            ),
            bottomNavigationBar: model.currentStep != 5
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        splashColor: Colors.transparent,
                        onTap: () {
                          model.saveQuestionnaireAnswersLocally();
                          Navigator.of(context).popUntil(
                            (route) => route.isFirst,
                          );
                        },
                        child: Container(
                          height: 50,
                          padding: EdgeInsets.only(left: 20),
                          child: Text(
                            // "Продолжить позже",
                            getTranslated(context, "continue_later"),

                            style: TextStyle(
                              color: Color(0XFFADB1B3),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: InkWell(
                          splashColor: Colors.transparent,
                          onTap: () {
                            if (model.currentQuestionaireAnswer.isComplete() ==
                                false) {
                              showCupertinoModalPopup<void>(
                                context: context,
                                builder: (BuildContext context) =>
                                    CupertinoAlertDialog(
                                  title: const Text("questionaire_incomplete"),
                                  actions: <CupertinoDialogAction>[
                                    CupertinoDialogAction(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        // getTranslated(context, 'OK'),
                                        "OK",
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              if (model.currentStep != 6) {
                                model.nextStep();
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => QuestionnaireScreen(
                                      data: widget.data,
                                      viewModel: model,
                                    ),
                                  ),
                                );
                              }
                              ;
                            }
                            ;
                          },
                          child: Container(
                            height: 50,
                            child: Text(
                              getTranslated(context, "next_question"),
                              style: TextStyle(
                                color: Color(0XFFF1BC62),
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : null,
          );
        }
      },
    );
  }

  getListUI(context, QuestionnaireViewModel model) {
    if (model.currentStep != 5) {
      return QuestionWidget(
        question: model.currentQuestionairePageData,
        answer: model.currentQuestionaireAnswer,
        model: model,
      );
    } else if (model.currentStep == 5) {
      return QuestionWithCommentWidget(
        questions: model.currentQuestionairePageData,
        answers: model.currentQuestionaireAnswer,
        model: model,
        isAnswerScreen: false,
      );
    } else {
      return Container(
        child: EmptyData(),
      );
    }
  }
}

class QuestionWithCommentWidget extends StatefulWidget {
  QuestionaireAnswer answers;
  QuestionPageData questions;
  QuestionnaireViewModel model;
  bool isAnswerScreen;
  QuestionWithCommentWidget({
    Key key,
    this.answers,
    this.questions,
    this.model,
    this.isAnswerScreen,
  }) : super(key: key);

  @override
  State<QuestionWithCommentWidget> createState() =>
      _QuestionWithCommentWidgetState();
}

class _QuestionWithCommentWidgetState extends State<QuestionWithCommentWidget> {
  List<TextEditingController> textControllersList = [];

  _onAnswerSelected(int questionIndex, bool value) {
    setState(() {
      widget.model.setAnswerWithCommentValue(questionIndex, value);
    });
  }

  _onCommentChanged(int questionIndex, String answer) {
    setState(() {
      widget.model.setAnswerComment(questionIndex, answer);
    });
  }

  @override
  void dispose() {
    super.dispose();

    int numberOfTextControllers = textControllersList.length;
    for (int i = 0; i < numberOfTextControllers; i++) {
      textControllersList[i].dispose();
    }
  }

  // TODO precache svgassets, since they are static
  // TODO: Clear all controllers on dispose method
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.only(
            left: 16,
            right: 16,
          ),
          shrinkWrap: true,
          itemCount: widget.questions.questions.length + 3,
          itemBuilder: (context, index) {
            TextEditingController _textEditingController =
                TextEditingController();
            int questionIndex = index - 2;
            index;
            if (index == 0) {
              return Padding(
                padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                child: Text(
                  widget.questions.title == null
                      ? "title"
                      : widget.questions.title,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w700,
                    color: const Color(0XFFF1BC62),
                  ),
                ),
              );
            } else if (questionIndex >= 0 && questionIndex < 6) {
              return Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      (questionIndex + 1).toString() +
                          ". " +
                          widget.questions.questions[questionIndex],
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w400,
                        color: Color(0XFF7F878B),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio(
                        value: true,
                        activeColor: Color(0XFFF1BC62),
                        groupValue: widget.model.currentQuestionaireAnswer
                            .answers[questionIndex].value,
                        onChanged: (value) {
                          widget.isAnswerScreen == true
                              ? print(value)
                              : _onAnswerSelected(questionIndex, value);
                          // _onAnswerSelected(index, value);
                        },
                      ),
                      Text(getTranslated(context, "yes")),
                      const SizedBox(width: 16),
                      Radio(
                        value: false,
                        activeColor: Color(0XFFF1BC62),
                        groupValue: widget.model.currentQuestionaireAnswer
                            .answers[questionIndex].value,
                        onChanged: (value) {
                          widget.isAnswerScreen == true
                              ? print(value)
                              : _onAnswerSelected(questionIndex, value);
                          // _onAnswerSelected(index, value);
                        },
                      ),
                      Text(getTranslated(context, "no")),
                    ],
                  ),
                  TextField(
                    enabled: !widget.isAnswerScreen,
                    controller: _textEditingController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      labelText: widget.isAnswerScreen == true
                          ? widget.answers.answers[questionIndex].comment
                          : 'Комментарии',
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              );
            } else if (index == 8) {
              return widget.isAnswerScreen == true
                  ? null
                  : InkWell(
                      splashColor: Colors.transparent,
                      onTap: () async {
                        if (widget.model.currentQuestionaireAnswer
                                .isComplete() ==
                            false) {
                          showCupertinoModalPopup<void>(
                            context: context,
                            builder: (BuildContext context) =>
                                CupertinoAlertDialog(
                              title: const Text("questionaire_incomplete"),
                              actions: <CupertinoDialogAction>[
                                CupertinoDialogAction(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    // getTranslated(context, 'OK'),
                                    "OK",
                                  ),
                                ),
                              ],
                            ),
                          );
                        } else {
                          bool success =
                              await widget.model.submitQuestionnaire(context);
                          if (success) {
                            widget.model.nextStep();
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => QuestionaireAnswerScreen(
                                  data: widget.model.questionnaireData,
                                  questionaireAnswers:
                                      widget.model.questionaireAnswers,
                                  model: widget.model,
                                ),
                              ),
                            );
                          }
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(
                            getTranslated(context, "get_questionaire_result"),
                            style: const TextStyle(
                              color: Color(0XFFF1BC62),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    );
            } else {
              return SizedBox();
            }
          },
        ),
      ],
    );
  }
}

class QuestionWidget extends StatefulWidget {
  QuestionPageData question;
  QuestionaireAnswer answer;
  QuestionnaireViewModel model;

  QuestionWidget({this.question, this.answer, this.model});

  @override
  _QuestionWidgetState createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget> {
  _onAnswerSelected(int currentQuestionIndex, int value) {
    setState(() {
      widget.model.setAnswerWithoutComment(currentQuestionIndex, value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
      shrinkWrap: true,
      itemCount: widget.question.questions.length + 1,
      itemBuilder: (BuildContext context, int index) {
        final questionIndex = index - 1;
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Text(
              widget.question.title == null ? "title" : widget.question.title,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w700,
                color: const Color(0XFFF1BC62),
              ),
            ),
          );
        } else {
          return Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  (questionIndex + 1).toString() +
                      ". " +
                      widget.question.questions[questionIndex],
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w400,
                    color: const Color(0XFF7F878B),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      Radio(
                        value: 10,
                        activeColor: const Color(0XFFF1BC62),
                        groupValue: widget.model.currentQuestionaireAnswer
                            .answers[questionIndex].value,
                        onChanged: (dynamic value) {
                          _onAnswerSelected(questionIndex, value);
                        },
                      ),
                      Text(
                        getTranslated(context, "yes"),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          fontFamily: "Helvetica Neue",
                          color: Color(0XFF778083),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                        activeColor: Color(0XFFF1BC62),
                        value: 5,
                        groupValue: widget.model.currentQuestionaireAnswer
                            .answers[questionIndex].value,
                        onChanged: (dynamic value) {
                          _onAnswerSelected(questionIndex, value);
                        },
                      ),
                      Text(
                        getTranslated(context, "sometimes"),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          fontFamily: "Helvetica Neue",
                          color: Color(0XFF778083),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                        value: 0,
                        activeColor: Color(0XFFF1BC62),
                        groupValue: widget.model.currentQuestionaireAnswer
                            .answers[questionIndex].value,
                        onChanged: (dynamic value) {
                          _onAnswerSelected(questionIndex, value);
                        },
                      ),
                      Text(
                        getTranslated(context, "no"),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          fontFamily: "Helvetica Neue",
                          color: Color(0XFF778083),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 16,
              ),
            ],
          );
        }
      },
    );
  }
}
