import 'dart:developer';

import 'package:charity_app/localization/language_constants.dart';
import 'package:charity_app/model/questionnaire.dart';
import 'package:charity_app/utils/device_size_config.dart';
import 'package:charity_app/utils/toast_utils.dart';
import 'package:charity_app/view/screens/home/questionnaire/questionnaire_screen.dart';
import 'package:charity_app/view/screens/home/questionnaire/questionnaire_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:charity_app/view/screens/home/questionnaire/questionaire_appbar.dart';

class QuestionaireAnswerScreen extends StatefulWidget {
  QuestionnaireData data;
  List<QuestionaireAnswer> questionaireAnswers;
  QuestionnaireViewModel model;
  QuestionaireAnswerScreen({
    Key key,
    @required this.data,
    @required this.questionaireAnswers,
    @required this.model,
  }) : super(key: key);

  @override
  State<QuestionaireAnswerScreen> createState() =>
      _QuestionaireAnswerScreenState();
}

class _QuestionaireAnswerScreenState extends State<QuestionaireAnswerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbarForQuestionaire(
        context: context,
        appBarTitle: '',
        appBarIncome: "Опросник",
      ),

      backgroundColor: Colors.white,
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: widget.data.questionList.length + 2,
        itemBuilder: (BuildContext context, index) {
          if (index < 5) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    widget.data.questionList[index].title != null
                        ? widget.data.questionList[index].title
                        : "No title",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Color(0XFF6CBBD9),
                    ),
                  ),
                ),
                ResultSlider(
                  answer: widget.questionaireAnswers[index],
                  question: widget.data.questionList[index],
                ),
              ],
            );
          } else if (index == 5) {
            return InformationHolderWidget();
          } else if (index == 6) {
            return Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "General",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Color(0XFFF1BC62),
                    ),
                  ),
                ),
                QuestionWithCommentWidget(
                  questions: widget.data.questionList[5],
                  answers: widget.questionaireAnswers[5],
                  model: widget.model,
                  isAnswerScreen: true,
                ),
              ],
            );
          } else {
            return InkWell(
              splashColor: Colors.transparent,
              onTap: () async {
                CupertinoAlertDialog(
                  title: const Text("points_exchange_confirmation"),
                  actions: <CupertinoDialogAction>[
                    CupertinoDialogAction(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        getTranslated(context, 'no'),
                      ),
                    ),
                    CupertinoDialogAction(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        getTranslated(context, 'no'),
                      ),
                    ),
                  ],
                );
                bool status = await widget.model.submitQuestionnaire(context);
                if (status == true) {
                  ToastUtils.toastSuccessGeneral("success", context);
                  Navigator.of(context).pop();
                } else {
                  ToastUtils.toastErrorGeneral("error", context);
                }
              },
              child: Container(
                margin: EdgeInsets.only(bottom: 16, left: 32, right: 32),
                child: Center(
                  child: Text(
                    getTranslated(context, "send_results_to_email"),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0XFFFFFFFF),
                    ),
                  ),
                ),
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Color(0XFFF1BC62),
                ),
              ),
            );
          }
        },
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // floatingActionButton:
    );
  }
}

class ResultSlider extends StatelessWidget {
  QuestionPageData question;
  List<Color> colors = [];
  QuestionaireAnswer answer;

  ResultSlider({Key key, this.question, this.answer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double _paddingValue = 0;
    question.ranges.forEach((key, value) {
      Color color = Color(int.parse(key.replaceAll("#", "0xFF")));
      colors.add(color);
    });

    answer.answers.forEach(
      (element) {
        _paddingValue += element.value;
      },
    );

    _paddingValue = (_paddingValue /
        60 *
        SizeConfig.screenWidth /
        MediaQuery.of(context)
            .devicePixelRatio); // -32 because of padding at the parent widget with value 32

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        child: Stack(
          children: [
            Container(
              height: 20,
              width: SizeConfig.screenWidth,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 3,
                      itemBuilder: (BuildContext context, index) {
                        return Container(
                          height: 20,
                          width: double.parse(
                                  question.ranges.values.elementAt(index)) /
                              60 *
                              SizeConfig.screenWidth,
                          color: colors[index],
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: _paddingValue),
              child: Icon(
                Icons.circle,
                color: Colors.white,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InformationHolderWidget extends StatelessWidget {
  const InformationHolderWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontSize: 16,
          color: Color(0XFF777F83),
        ),
        children: [
          TextSpan(
            text: 'Если общий балл ребенка находится в ',
          ),
          TextSpan(
              text: 'зеленом поле', style: TextStyle(color: Color(0XFF79BCB7))),
          TextSpan(
            text:
                ', он выше порогового значения, и развитие ребенка идет по графику.\n',
          ),
          TextSpan(
            text: '\nЕсли общий балл ребенка находится в ',
          ),
          TextSpan(
            text: 'оранжевом поле',
            style: TextStyle(
              color: Color(0XFFF2C477),
            ),
          ),
          TextSpan(
            text:
                ', он близок к пороговому значению. Обеспечьте учебную деятельность и контролируйте.\n',
          ),
          TextSpan(
            text: '\nЕсли общий балл ребенка находится в ',
          ),
          TextSpan(
              text: 'голубом поле', style: TextStyle(color: Color(0XFF6CBBD9))),
          TextSpan(
            text:
                ', он ниже порогового значения. Может потребоваться дополнительная оценка профессионала.\n',
          ),
        ],
      ),
    );
  }
}
