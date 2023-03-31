import 'package:charity_app/model/child/child.dart';
import 'package:charity_app/model/questionnaire.dart';
import 'package:charity_app/view/screens/home/profile/profile_screen.dart';
import 'package:charity_app/view/screens/home/questionnaire/questionnaire_screen.dart';
import 'package:flutter/material.dart';

class AllQuesionaresScreen extends StatefulWidget {
  Child child;
  AllQuesionaresScreen({Key key, this.child}) : super(key: key);

  @override
  State<AllQuesionaresScreen> createState() => _AllQuesionaresScreenState();
}

class _AllQuesionaresScreenState extends State<AllQuesionaresScreen> {
  AppBar appBar;
  @override
  void initState() {
    profileScreenAppBar(context, true).then((value) => setState(() {
          appBar = value;
        }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFFF6F6FA),
      appBar: appBar,
      body: Container(
        child: ListView.builder(
          itemCount: widget.child.newQuestionnaires.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return Padding(
                padding: EdgeInsets.only(top: 32),
                child: Text(
                  "Выберите нужный результат",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0XFF79BCB7),
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }
            return QuestionarePreview(
                questionnaireData: widget.child.newQuestionnaires[index - 1],
                childId: widget.child.childId,);
          },
        ),
      ),
    );
  }
}
// TODO: Display all questionnaires for this child
class QuestionarePreview extends StatelessWidget {
  QuestionnaireData questionnaireData;
  int childId;
  QuestionarePreview({Key key, this.questionnaireData, this.childId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => QuestionnaireScreen(
              data: questionnaireData,
              childId:childId,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: EdgeInsets.fromLTRB(24, 16, 24, 16),
        margin: EdgeInsets.all(24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              questionnaireData.age.toString() + " месяцев",
              style: TextStyle(
                color: Color(0XFF778083),
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),

            Icon(
              Icons.arrow_forward_ios,
              color: Color(0XFF79BCB7),
            ),
          ],
        ),
      ),
    );
  }
}
