import 'package:charity_app/localization/language_constants.dart';
import 'package:charity_app/localization/user_data.dart';
import 'package:charity_app/persistance/api_provider.dart';
import 'package:charity_app/utils/formatters.dart';
import 'package:charity_app/view/screens/home/profile/add_child/add_child_screen.dart';
import 'package:charity_app/view/screens/home/profile/profile_screen.dart';
import 'package:charity_app/view/screens/home/questionnaire/all_questionaires_screen.dart';
import 'package:charity_app/view/screens/home/questionnaire/questionnaire_screen.dart';
import 'package:charity_app/view/screens/home/questionnaire/questionnaire_viewmodel.dart';
import 'package:charity_app/view/screens/home/questionnaire/results/all_questionaire_results_screen.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter_svg/svg.dart';
import 'package:charity_app/model/child/child.dart';

class ChildResultsScreen extends StatefulWidget {
  const ChildResultsScreen({Key key}) : super(key: key);

  @override
  State<ChildResultsScreen> createState() => _ChildResultsScreenState();
}

class _ChildResultsScreenState extends State<ChildResultsScreen> {
  AppBar appBar;

  List<Child> children = [];

  bool _isLoading = false;
  ApiProvider _apiProvider = ApiProvider();
  bool hasError = false;
  @override
  void initState() {
    profileScreenAppBar(context, true).then(
      (value) => setState(
        () {
          appBar = value;
        },
      ),
    );
    fetchChildrenResults();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: _isLoading ? _buildLoadingWidget() : _buildLoadedWidget(),
    );
  }

  Widget _buildLoadingWidget() {
    return Container(
      height: 150,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildLoadedWidget() {
    return hasError
        ? Center(
            child: Container(
              child: Text(getTranslated(context, "error")),
            ),
          )
        : ListView.builder(
            padding: EdgeInsets.only(
              left: 40.w,
              right: 40.w,
              top: 61.w,
            ),
            itemCount: children.length,
            itemBuilder: (context, index) {
              return ChildPreview(
                child: children[index],
              );
            },
          );
  }

  fetchChildrenResults() async {
    setState(() {
      _isLoading = true;
    });
    try {
      children = await _apiProvider.getChildren();
    } catch (e) {
      setState(() {
        hasError = true;
      });
    }
    setState(() {
      _isLoading = false;
    });
  }
}

class ChildPreview extends StatelessWidget {
  final Child child;
  const ChildPreview({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 32.0.w),
      child: Container(
        // height: 116.w,
        decoration: BoxDecoration(
          color: const Color(0xFFFFFFFFFFF),
          borderRadius: BorderRadius.circular(20.w),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AddChildScreen(
                      child: child,
                    ),
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.only(
                    left: 22.w, right: 12.w, top: 21.w, bottom: 10.w),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      child.isGirl
                          ? "assets/svg/icons/girl_result.svg"
                          : "assets/svg/icons/boy_result.svg",
                      height: 40.w,
                    ),
                    SizedBox(
                      width: 20.w,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          child.name,
                          style: TextStyle(
                              color: child.isGirl
                                  ? const Color(0XFFF08390)
                                  : const Color(0XFF6CBBD9),
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w700),
                        ),
                        Text(
                          getAgeString(
                            context,
                            ChildAge.fromInteger(child.age),
                          ),
                          style: TextStyle(
                            color: Color(0XFF777F83),
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 45.w,
              padding: EdgeInsets.only(left: 14.w, right: 14.w),
              decoration: BoxDecoration(
                color: child.isGirl
                    ? const Color(0XFFF08390)
                    : const Color(0XFF6CBBD9),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20.w),
                  bottomRight: Radius.circular(20.w),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    splashColor: Colors.transparent,
                    onTap: () {
                      // make a check whether the child has any new questionnaires
                      // String email = await UserData().getEmail();

                      if (child.newQuestionnaires.first != null) {
                        QuestionnaireViewModel questionnaireViewModel =
                            QuestionnaireViewModel(
                          passedQuestionnaireData:
                              child.newQuestionnaires.first,
                          childId: child.childId,
                          isResultModel: false,
                          // userEmail: email,
                        );

                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: ((context) => QuestionnaireScreen(
                                  childId: child.childId,
                                  data: child.newQuestionnaires.first,
                                  viewModel: questionnaireViewModel,
                                )),
                          ),
                        );
                      }
                    },
                    child: Text(
                      getTranslated(context, "take_test"),
                      style: TextStyle(
                        color: child.newQuestionnaires.isNotEmpty
                            ? const Color(0xFFFFFFFFFFF)
                            : const Color.fromARGB(153, 255, 255, 255),
                        fontWeight: child.newQuestionnaires.isNotEmpty
                            ? FontWeight.w500
                            : FontWeight.normal,
                        fontSize: 15.sp,
                      ),
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 20.w,
                    color: const Color(0xFFFFFFFFFFF),
                  ),
                  InkWell(
                    splashColor: Colors.transparent,
                    onTap: () {
                      // make a check whether the child has any results
                      if (child.results != null && child.results.isNotEmpty) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => AllQuestionareResultsScreen(
                              child: child,
                            ),
                          ),
                        );
                      }
                    },
                    child: Text(
                      getTranslated(context, "watch_test_results"),
                      style: TextStyle(
                        color: child.results.isNotEmpty
                            ? const Color(0xFFFFFFFFFFF)
                            : const Color.fromARGB(153, 255, 255, 255),
                        fontWeight: child.results.isNotEmpty
                            ? FontWeight.w500
                            : FontWeight.normal,
                        fontSize: 15.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
