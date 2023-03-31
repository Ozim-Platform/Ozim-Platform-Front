import 'package:charity_app/utils/constants.dart';
import 'package:charity_app/view/screens/other/notification/messages.dart';
import 'package:charity_app/view/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class NavigationChat extends StatefulWidget {
  const NavigationChat(
    this.mainBuilder,
    this.context,
    this.model, {
    Key key,
  }) : super(key: key);
  final mainBuilder;
  final context;
  final model;

  // final FirebaseAuth _auth = FirebaseAuth.instance;

  static _NavigationChatState of(BuildContext context) =>
      context.findAncestorStateOfType();

  @override
  _NavigationChatState createState() => _NavigationChatState();
}

class _NavigationChatState extends State<NavigationChat> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  update() {
    setState(() {});
  }

  @override
  Widget build(BuildContext _context) {
    return Navigator(
      key: navigationChat,
      initialRoute: '/',
      onGenerateRoute: (RouteSettings settings) {
        Widget Function(
            BuildContext context, Animation<double>, Animation<double>) builder;

        int duration = 450;
        var user;
        if (settings.arguments != null) {
          if ((settings.arguments as Map)["navigate"] != null) {
            var navigationSpeed = (settings.arguments as Map)["navigate"];
            if (navigationSpeed == 'fast') {
              duration = 0;
            }
          }
          if ((settings.arguments as Map)["user"] != null) {
            user = (settings.arguments as Map)["user"];
          }
        }

        if (settings.name == '/') {
          builder = (BuildContext context, animation, secondaryAnimation) =>
              // widget.mainBuilder(widget.index);
              widget.mainBuilder(widget.context, widget.model);
        } else {
          builder = getRouteBuilder(settings.name, user);
        }

        return PageRouteBuilder(
          settings: settings,
          pageBuilder: builder,
          transitionsBuilder: transitionBuilderIn,
          transitionDuration: Duration(milliseconds: duration),
          reverseTransitionDuration: Duration(milliseconds: 250),
          barrierColor: AppColor.scaffoldBackground,
        );
      },
    );
  }
}

getRouteBuilder(String routname, user) {
  Widget Function(BuildContext context, Animation<double>, Animation<double>)
      builder;
  switch (routname) {
    case '/messages':
      builder = (BuildContext context, animation, secondaryAnimation) =>
          Messages(user: user);
      break;
    default:
      throw Exception('Invalid route: $routname');
  }
  return builder;
}

extension NavigatorStateExtension on NavigatorState {
  void pushNamedIfNotCurrent(String routeName, {Object arguments}) {
    if (!isCurrent(routeName)) {
      pushNamed(routeName, arguments: arguments);
    }
  }

  void pushNamedWithoutHistory(String routeName, {Object arguments}) {
    pushNamedAndRemoveUntil(routeName, (route) {
      return route.settings.name == '/' ? true : false;
    }, arguments: arguments);
  }

  void pushNamedWithoutHistoryIfNotCurrent(String routeName,
      {Object arguments}) {
    if (!isCurrent(routeName)) {
      pushNamedAndRemoveUntil(routeName, (route) {
        return route.settings.name == '/' ? true : false;
      }, arguments: arguments);
    }
  }

  bool isCurrent(String routeName) {
    bool isCurrent = false;
    popUntil((route) {
      if (route.settings.name == routeName) {
        isCurrent = true;
      }
      return true;
    });
    return isCurrent;
  }
}

Widget transitionBuilderIn(
    BuildContext context, animation, secondaryAnimation, Widget child) {
  var begin = Offset(1.0, 0.0);
  var end = Offset.zero;
  var curve = Curves.ease;
  var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
  return SlideTransition(
    position: animation.drive(tween),
    child: child,
  );
}

Widget transitionBuilderOut(
    BuildContext context, animation, secondaryAnimation, Widget child) {
  var begin = Offset.zero;
  var end = Offset(-1.0, 0.0);
  var curve = Curves.ease;
  var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
  return SlideTransition(
    position: animation.drive(tween),
    child: child,
  );
}
