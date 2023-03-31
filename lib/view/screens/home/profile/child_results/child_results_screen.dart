import 'package:charity_app/persistance/api_provider.dart';
import 'package:charity_app/view/screens/home/profile/profile_screen.dart';
import 'package:charity_app/view/screens/home/questionnaire/all_questionaires_screen.dart';

import 'package:flutter/material.dart';

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

  @override
  void initState() {
    profileScreenAppBar(context, true).then((value) => setState(() {
          appBar = value;
        }));
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
    return ListView.builder(
      padding: EdgeInsets.only(
        left: 40,
        right: 40,
        top: 61,
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

    children = await _apiProvider.getChildren();

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
      padding: const EdgeInsets.only(bottom: 32.0),
      child: Container(
        height: 116,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding:
                  EdgeInsets.only(left: 22, right: 20, top: 21, bottom: 10),
              child: Row(
                children: [
                  SvgPicture.asset(
                    child.isGirl
                        ? "assets/svg/icons/girl_result.svg"
                        : "assets/svg/icons/boy_result.svg",
                    height: 40,
                    // width: 35,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        child.name,
                        style: TextStyle(
                            color: child.isGirl
                                ? Color(0XFFF08390)
                                : Color(0XFF6CBBD9),
                            fontSize: 18,
                            fontWeight: FontWeight.w700),
                      ),
                      Text(
                        child.age.toString(),
                        style: TextStyle(
                          color: Color(0XFF777F83),
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              height: 45,
              padding: EdgeInsets.only(left: 14, right: 14),
              decoration: BoxDecoration(
                color: child.isGirl ? Color(0XFFF08390) : Color(0XFF6CBBD9),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => AllQuesionaresScreen(
                            child: child,
                          ),
                        ),
                      );
                    },
                    child: Text(
                      "Пройти тест",
                      style: TextStyle(
                        color: child.newQuestionnaires.isNotEmpty
                            ? Colors.white
                            : Color.fromARGB(153, 255, 255, 255),
                      ),
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 20,
                    color: Colors.white,
                  ),
                  InkWell(
                      onTap: () {},
                      child: Text(
                        "Смотреть результаты",
                        style: TextStyle(
                          color: child.results.isNotEmpty
                              ? Colors.white
                              : Color.fromARGB(153, 255, 255, 255),
                        ),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
