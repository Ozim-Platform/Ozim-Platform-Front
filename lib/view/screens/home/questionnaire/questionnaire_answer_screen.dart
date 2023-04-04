import 'dart:developer';

import 'package:charity_app/localization/language_constants.dart';
import 'package:charity_app/model/questionnaire.dart';
import 'package:charity_app/utils/device_size_config.dart';
import 'package:charity_app/view/components/bottom_modal_sheet.dart';
import 'package:charity_app/view/components/btn_ui_icon.dart';
import 'package:charity_app/view/components/text_field_ui.dart';
import 'package:charity_app/view/screens/home/questionnaire/questionnaire_screen.dart';
import 'package:charity_app/view/screens/home/questionnaire/questionnaire_viewmodel.dart';
import 'package:charity_app/view/screens/other/hide_keyboard_widget.dart';
import 'package:charity_app/view/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:charity_app/view/screens/home/questionnaire/questionaire_appbar.dart';
import 'package:flutter_svg/svg.dart';

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
        appBarIncome: getTranslated(context, "questionnaire"),
        callback: () =>
            Navigator.of(context).popUntil((route) => route.isFirst),
        age: widget.data.age,
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
                    getTranslated(context, "general"),
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
              onTap: () async {
                getEmailFromUser(context, widget.model);
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
    );
  }

  void getEmailFromUser(
    BuildContext _context,
    QuestionnaireViewModel model,
  ) {
    showModalBottomSheet(
        isScrollControlled: true,
        builder: (BuildContext context) {
          return SingleChildScrollView(
            child: Container(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    SizeConfig.calculateBlockHorizontal(24.0),
                    SizeConfig.calculateBlockVertical(24.0),
                    SizeConfig.calculateBlockHorizontal(24.0),
                    0.0,
                  ), // content padding
                  child: Column(
                    children: [
                      Form(
                        child: TextFieldUI(
                          controller: model.emailController,
                          // onFieldSubmitted: (_) =>
                          //     FocusScope.of(context).nextFocus(),
                          inputAction: TextInputAction.done,
                          text: getTranslated(_context, 'email'),
                          hintText:
                              getTranslated(_context, 'send_reset_pass_email'),
                        ),
                      ),
                      SizedBox(height: SizeConfig.calculateBlockVertical(25)),
                      BtnUIIcon(
                        height: SizeConfig.calculateBlockVertical(55),
                        isLoading: false,
                        textColor: Colors.white,
                        color: AppColor.gmail,
                        text: getTranslated(_context, 'send_email'),
                        icon: SvgPicture.asset('assets/svg/auth/gmail.svg'),
                        onTap: () async {
                          if (model.emailController.text.isNotEmpty) {
                            await model.sendResultsToEmail(
                              _context,
                            );
                          }
                          // send back to the profile screen
                          // show in error using ToastUtils in case of error
                        },
                      ),
                      SizedBox(height: SizeConfig.calculateBlockVertical(25)),
                    ],
                  ),
                ) // From with TextField inside

                ),
          );
        },
        context: _context);
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
            Row(
              children: [
                Container(
                  width: _paddingValue / 60 * SizeConfig.getFullWidth() - 52,
                ),
                Icon(
                  Icons.circle,
                  color: Colors.white,
                  size: 20,
                ),
              ],
            )
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
