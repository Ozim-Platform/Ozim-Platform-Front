import 'package:charity_app/localization/language_constants.dart';
import 'package:charity_app/model/child/child.dart';
import 'package:charity_app/model/questionnaire.dart';
import 'package:charity_app/utils/formatters.dart';
import 'package:charity_app/view/screens/home/profile/profile_screen.dart';
import 'package:charity_app/view/screens/home/questionnaire/questionnaire_answer_screen.dart';
import 'package:charity_app/view/screens/home/questionnaire/questionnaire_viewmodel.dart';
import 'package:flutter/material.dart';

class AllQuestionareResultsScreen extends StatefulWidget {
  Child child;
  AllQuestionareResultsScreen({Key key, this.child}) : super(key: key);

  @override
  State<AllQuestionareResultsScreen> createState() =>
      _AllQuesionareResultsScreenState();
}

class _AllQuesionareResultsScreenState
    extends State<AllQuestionareResultsScreen> {
  AppBar appBar;
  @override
  void initState() {
    profileScreenAppBar(context, true).then(
      (value) => setState(
        () {
          appBar = value;
        },
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFFF6F6FA),
      appBar: appBar,
      body: Container(
        child: ListView.builder(
          itemCount: widget.child.results.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return Padding(
                padding: const EdgeInsets.only(top: 32),
                child: Text(
                  getTranslated(context, "choose_nedded_result"),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0XFF79BCB7),
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }
            return QuestionareAnswerPreview(
              questionnaireData: widget.child.results[index - 1],
              childId: widget.child.childId,
            );
          },
        ),
      ),
    );
  }
}

// TODO: Display all questionnaires for this child
class QuestionareAnswerPreview extends StatelessWidget {
  QuestionnaireData questionnaireData;
  int childId;
  QuestionareAnswerPreview({Key key, this.questionnaireData, this.childId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => QuestionaireAnswerScreen(
              model: QuestionnaireViewModel(
                passedQuestionnaireData:questionnaireData,
                childId:childId,
                isResultModel:true,
              ),
              data: questionnaireData,
              questionaireAnswers:
                  questionnaireData.questionaireAnswers.answers,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0XFFFFFFFFF),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
        margin: const EdgeInsets.all(24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              getAgeString(
                context,
                ChildAge.fromInteger(questionnaireData.age),
              ),
              style: const TextStyle(
                color: Color(0XFF778083),
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Color(0XFF79BCB7),
            ),
          ],
        ),
      ),
    );
  }
}
