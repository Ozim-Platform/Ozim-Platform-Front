import 'package:charity_app/localization/user_data.dart';
import 'package:charity_app/view/components/user_image.dart';
import 'package:charity_app/view/screens/home/profile/add_child/add_child_screen.dart';
import 'package:charity_app/view/screens/home/profile/child_results/child_results_screen.dart';
import 'package:charity_app/view/screens/home/profile/exchange_points/exchange_points_screen.dart';
import 'package:charity_app/view/screens/other/notification/notification_screen.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  AppBar appBar;

  @override
  void initState() {
    profileScreenAppBar(context, false).then((value) => setState(() {
          appBar = value;
        }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: ListView(
        padding: EdgeInsets.only(
          top: 60,
        ),
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChildResultsScreen(),
                ),
              );
            },
            child: ProfileScreenListWidget(
              type: "results",
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NotificationScreen(),
                ),
              );
            },
            child: ProfileScreenListWidget(
              type: "discussions",
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ExchangePointsScreen(),
                ),
              );
            },
            child: ProfileScreenListWidget(
              type: "points",
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileScreenListWidget extends StatefulWidget {
  final String type;

  ProfileScreenListWidget({Key key, this.type}) : super(key: key);

  @override
  State<ProfileScreenListWidget> createState() =>
      _ProfileScreenListWidgetState();
}

class _ProfileScreenListWidgetState extends State<ProfileScreenListWidget> {
  Color color;

  SvgPicture icon;
  String text;

  @override
  void initState() {
    switch (widget.type) {
      case 'results':
        color = Color(0XFFF1BC62);
        icon = SvgPicture.asset('assets/svg/icons/profile_results.svg');
        text = "results";
        break;
      case 'discussions':
        color = Color(0XFF6CBBD9);
        icon = SvgPicture.asset('assets/svg/icons/profile_discussion.svg');
        text = "discussions";
        break;
      case 'points':
        color = Color(0XFFF08390);
        icon = SvgPicture.asset('assets/svg/icons/profile_points.svg');
        text = "points";
        break;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 33.0, right: 33.0, bottom: 8),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: icon,
          ),
          Expanded(
            child: Container(
              padding:
                  EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                  topLeft: Radius.circular(25),
                ),
                color: color,
              ),
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: "Helvetica Neue",
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future<AppBar> profileScreenAppBar(
    BuildContext context, bool showLeadingIcon) async {
  UserData _userData = new UserData();

  String _username = await _userData.getUsername();

  String _avatar = await _userData.getAvatar();

  String _userType = await _userData.getUserType();

  return AppBar(
    elevation: 0.0,
    backgroundColor: Color(0xFF79BCB7),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        bottom: Radius.circular(40),
      ),
    ),
    leading: showLeadingIcon == true
        ? Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: IconButton(
              iconSize: 20.0,
              splashRadius: 20,
              icon: Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          )
        : SizedBox(),
    bottom: PreferredSize(
      preferredSize: Size.fromHeight(90),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 30, bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                UserImage(
                  userUrl: _avatar,
                  size: 60,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        _username,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontFamily: "Helvetica Neue",
                          color: Colors.white,
                          fontSize: 23,
                        ),
                      ),
                      Text(
                        _userType == null ? "" : _userType,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontFamily: "Helvetica Neue",
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 32.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddChildScreen(),
                        ),
                      );
                    },
                    child: SvgPicture.asset(
                      "assets/svg/icons/add_child.svg",
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
