import 'package:charity_app/localization/language_constants.dart';
import 'package:charity_app/model/questionnaire.dart';
import 'package:charity_app/utils/device_size_config.dart';
import 'package:charity_app/utils/toast_utils.dart';
import 'package:charity_app/view/components/no_data.dart';
import 'package:charity_app/view/screens/home/questionnaire/questionnaire_answer_screen.dart';
import 'package:charity_app/view/screens/home/questionnaire/questionnaire_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stacked/stacked.dart';
import 'package:charity_app/view/screens/home/questionnaire/questionaire_appbar.dart';

import 'package:charity_app/model/child/child.dart';
import 'package:charity_app/utils/formatters.dart';

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
            passedQuestionnaireData: widget.data,
            childId: widget.childId,
            isResultModel: false,
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
              appBarTitle: getTranslated(context, "questionnaire"),
              appBarIncome: getTranslated(context, "for_age") +
                  " " +
                  getAgeString(
                    context,
                    ChildAge.fromInteger(widget.data.age),
                  ),
              callback: () => model.previousStep(context),
              age: widget.data.age,
            ),
            backgroundColor: Colors.white,
            body: SafeArea(
              child: Container(
                padding: EdgeInsets.only(
                  left: 24.w,
                  right: 24.w,
                  top: 10.w,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),
                ),
                child: ListView(
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  children: <Widget>[
                    Text(
                      getTranslated(context, "asses_these_questions"),
                      style: TextStyle(
                        color: Color(0XFF777F83),
                        fontWeight: FontWeight.w400,
                        fontSize: 16.sp,
                      ),
                    ),
                    getListUI(
                      context,
                      model,
                    ),
                    SizedBox(height: SizeConfig.calculateBlockVertical(10)),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: model.currentStep != 5
                ? Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).padding.bottom),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          splashColor: Colors.transparent,
                          splashFactory: NoSplash.splashFactory,
                          onTap: () {
                            model.saveQuestionnaireAnswersLocally();
                            Navigator.of(context).popUntil(
                              (route) => route.isFirst,
                            );
                          },
                          child: Container(
                            height: 50,
                            padding: EdgeInsets.only(
                              left: 24.w,
                              top: 8.w,
                            ),
                            child: Text(
                              getTranslated(context, "continue_later"),
                              style: TextStyle(
                                color: Color(0XFFADB1B3),
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          splashFactory: NoSplash.splashFactory,
                          splashColor: Colors.transparent,
                          onTap: () {
                            if (model.currentQuestionaireAnswer.isComplete() ==
                                false) {
                              showCupertinoModalPopup<void>(
                                context: context,
                                builder: (BuildContext context) =>
                                    CupertinoAlertDialog(
                                  title: Text(
                                    getTranslated(
                                      context,
                                      "questionaire_incomplete",
                                    ),
                                  ),
                                  actions: <CupertinoDialogAction>[
                                    CupertinoDialogAction(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text(
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
                            padding: EdgeInsets.only(
                              right: 24.w,
                              top: 8.w,
                            ),
                            child: Text(
                              getTranslated(context, "next_question"),
                              style: TextStyle(
                                color: Color(0XFFF1BC62),
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
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
    setState(
      () {
        widget.model.setAnswerWithCommentValue(questionIndex, value);
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListView.builder(
          physics: BouncingScrollPhysics(),
          shrinkWrap: true,
          itemCount: widget.questions.questions.length + 3,
          itemBuilder: (context, index) {
            int questionIndex = index - 2;
            if (index == 0) {
              return Padding(
                padding: EdgeInsets.only(top: 20.0.w, bottom: 23.0.w),
                child: Text(
                  widget.questions.title == null
                      ? "title"
                      : widget.questions.title,
                  style: TextStyle(
                    fontSize: 20.0.sp,
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
                        fontSize: 16.0.sp,
                        fontWeight: FontWeight.w400,
                        color: Color(0XFF7F878B),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 16.0.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Radio(
                          value: true,
                          activeColor: Color(0XFFF1BC62),
                          groupValue: widget.model.currentQuestionaireAnswer
                              .answers[questionIndex].value,
                          onChanged: (value) {
                            widget.isAnswerScreen == true
                                ? print(value)
                                : _onAnswerSelected(
                                    questionIndex,
                                    value,
                                  );
                          },
                        ),
                        Text(
                          getTranslated(context, "yes").toUpperCase(),
                        ),
                        SizedBox(width: 16.sp),
                        Radio(
                          value: false,
                          activeColor: Color(0XFFF1BC62),
                          groupValue: widget.model.currentQuestionaireAnswer
                              .answers[questionIndex].value,
                          onChanged: (value) {
                            widget.isAnswerScreen == true
                                ? print(value)
                                : _onAnswerSelected(
                                    questionIndex,
                                    value,
                                  );
                          },
                        ),
                        Text(
                          getTranslated(context, "no").toUpperCase(),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: 16.0.sp,
                    ),
                    child: questionnaireTextField(
                      questionIndex,
                    ),
                  ),
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
                              title: Text(
                                getTranslated(
                                  context,
                                  "questionaire_incomplete",
                                ),
                              ),
                              actions: <CupertinoDialogAction>[
                                CupertinoDialogAction(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    "OK",
                                  ),
                                ),
                              ],
                            ),
                          );
                        } else {
                          if (widget.model.isLoading.value == false) {
                            bool status =
                                await widget.model.submitQuestionnaire(context);
                            if (status) {
                              widget.model.nextStep();
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      QuestionaireAnswerScreen(
                                    data: widget.model.questionnaireData,
                                    questionaireAnswers:
                                        widget.model.questionaireAnswers,
                                    model: widget.model,
                                  ),
                                ),
                              );
                            } else {
                              ToastUtils.toastErrorGeneral("error", context);
                            }
                          }
                        }
                      },
                      child: Padding(
                        padding: EdgeInsets.all(8.0.w),
                        child: Center(
                          child: Text(
                            getTranslated(context, "get_questionaire_result"),
                            style: TextStyle(
                              color: Color(0XFFF1BC62),
                              fontSize: 16.sp,
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

  Widget questionnaireTextField(
    int questionIndex,
  ) {
    if (widget.isAnswerScreen &&
        widget.answers.answers[questionIndex].comment != null) {
      widget.model.commentControllers[questionIndex].text =
          widget.answers.answers[questionIndex].comment;
      return TextField(
        maxLines: null,
        minLines: 1,
        enabled: !widget.isAnswerScreen,
        controller: widget.model.commentControllers[questionIndex],
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              15.0.w,
            ),
            borderSide: BorderSide(
              color: Color(
                0XFFCECECE,
              ),
              width: 1.0,
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              15.0.w,
            ),
            borderSide: BorderSide(
              color: Color(
                0XFFCECECE,
              ),
              width: 1.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              15.0.w,
            ),
            borderSide: BorderSide(
              color: Color(
                0XFFCECECE,
              ),
              width: 1.0,
            ),
          ),
          filled: true,
          fillColor: Color(0XFFF4F4F4),
        ),
      );
    } else if (widget.isAnswerScreen == false) {
      return TextField(
        maxLines: null,
        minLines: 1,
        enabled: !widget.isAnswerScreen,
        controller: widget.model.commentControllers[questionIndex],
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              15.0.w,
            ),
            borderSide: BorderSide(
              color: Color(
                0XFFCECECE,
              ),
              width: 1.0,
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              15.0.w,
            ),
            borderSide: BorderSide(
              color: Color(
                0XFFCECECE,
              ),
              width: 1.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              15.0.w,
            ),
            borderSide: BorderSide(
              color: Color(
                0XFFCECECE,
              ),
              width: 1.0,
            ),
          ),
          focusColor: Color(
            0XFFF4F4F4,
          ),
          filled: true, //<-- SEE HERE
          fillColor: Color(0XFFF4F4F4),
          labelText: 'Комментарии',
        ),
      );
    } else {
      return Container();
    }
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
      physics: BouncingScrollPhysics(),
      scrollDirection: Axis.vertical,
      padding: EdgeInsets.only(
        top: 20.w,
      ),
      shrinkWrap: true,
      itemCount: widget.question.questions.length + 1,
      itemBuilder: (BuildContext context, int index) {
        final questionIndex = index - 1;
        if (index == 0) {
          return Padding(
            padding: EdgeInsets.only(bottom: 23.0.w),
            child: Text(
              widget.question.title == null ? "title" : widget.question.title,
              style: TextStyle(
                fontSize: 20.0.sp,
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
                    fontSize: 16.0.sp,
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
                        getTranslated(context, "yes").toUpperCase(),
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
                        getTranslated(context, "sometimes").toUpperCase(),
                        style: TextStyle(
                          fontSize: 14.sp,
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
                        getTranslated(context, "no").toUpperCase(),
                        style: TextStyle(
                          fontSize: 14.sp,
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
                height: 27.w,
              ),
            ],
          );
        }
      },
    );
  }
}
