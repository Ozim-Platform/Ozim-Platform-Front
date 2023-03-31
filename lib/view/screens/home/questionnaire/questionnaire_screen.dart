import 'package:charity_app/localization/language_constants.dart';
import 'package:charity_app/model/questionnaire.dart';
import 'package:charity_app/utils/device_size_config.dart';
import 'package:charity_app/view/components/no_data.dart';
import 'package:charity_app/view/screens/home/questionnaire/questionnaire_answer_screen.dart';
import 'package:charity_app/view/screens/home/questionnaire/questionnaire_viewmodel.dart';
import 'package:charity_app/view/widgets/app_bar_auth.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

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
          );
        }
      },
      disposeViewModel: false,
      builder: (context, model, child) {
        if (model.isBusy) {
          return Container();
        } else {
          return Scaffold(
            appBar: widgetAppBarTitle(context,
                title: "Опросник",
                hasLeading: true,
                color: Color(0XFFF1BC62), onPressed: () {
              if (model.currentStep != 0) {
                model.previousStep();
                Navigator.of(context).pop();
              } else {
                Navigator.of(context).pop();
              }
            }),
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
                        onTap: () {
                          Navigator.of(context).popUntil(
                            (route) => route.isFirst,
                          );
                        },
                        child: Container(
                          height: 50,
                          padding: EdgeInsets.only(left: 20),
                          child: Text(
                            "Продолжить позже",
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
                          onTap: () {
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
                          },
                          child: Container(
                            height: 50,
                            child: Text(
                              "Далее",
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
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.only(left: 16, right: 16, top: 32),
          shrinkWrap: true,
          itemCount: widget.questions.questions.length + 1,
          itemBuilder: (context, index) {
            if (index < 6) {
              return Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      (index + 1).toString() +
                          ". " +
                          widget.questions.questions[index],
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
                        groupValue: widget.model.currentQuestionaireAnswer
                            .answers[index].value,
                        onChanged: (value) {
                          widget.isAnswerScreen == true
                              ? print(value)
                              : _onAnswerSelected(index, value);
                          // _onAnswerSelected(index, value);
                        },
                      ),
                      Text(getTranslated(context, "yes")),
                      SizedBox(width: 16),
                      Radio(
                        value: false,
                        groupValue: widget.model.currentQuestionaireAnswer
                            .answers[index].value,
                        onChanged: (value) {
                          widget.isAnswerScreen == true
                              ? print(value)
                              : _onAnswerSelected(index, value);
                          // _onAnswerSelected(index, value);
                        },
                      ),
                      Text(getTranslated(context, "no")),
                    ],
                  ),
                  TextField(
                    onChanged: (String value) {
                      widget.isAnswerScreen == true
                          ? print(value)
                          : _onCommentChanged(index, value);
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      labelText: widget.isAnswerScreen == true
                          ? widget.answers.answers[index].comment
                          : 'Комментарии',
                    ),
                  ),
                  SizedBox(height: 16),
                ],
              );
            } else {
              return widget.isAnswerScreen == true
                  ? null
                  : InkWell(
                      onTap: () {
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
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(
                            "Получить результат",
                            style: TextStyle(
                              color: Color(0XFFF1BC62),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    );
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
      padding: EdgeInsets.only(left: 16, right: 16, top: 32),
      shrinkWrap: true,
      itemCount: widget.question.questions.length,
      itemBuilder: (BuildContext context, int index) {
        final questionIndex = index;
        return Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                (index + 1).toString() +
                    ". " +
                    widget.question.questions[index],
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w400,
                  color: Color(0XFF7F878B),
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
                      activeColor: Color(0XFFF1BC62),
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
      },
    );
  }
}
