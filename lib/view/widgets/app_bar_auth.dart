import 'package:charity_app/view/theme/themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:theme_provider/theme_provider.dart';

widgetAppBarAuth(context, {String title = '', String lang = 'uz'}) {
  var theme = ThemeProvider.controllerOf(context).theme.data;
  return AppBar(
    title: Text(
      title,
      style: AppThemeStyle.appBarStyle,
    ),
    leading: IconButton(
      iconSize: 18.0,
      splashRadius: 20,
      icon: Icon(Icons.arrow_back_ios),
      onPressed: () => Navigator.of(context).pop(),
    ),
    elevation: 0,
    actions: <Widget>[
      Padding(
        padding: const EdgeInsets.only(right: 10.0),
        child: CupertinoButton(
          onPressed: () {},
          padding: const EdgeInsets.all(0.0),
          child: Container(
            margin: const EdgeInsets.all(8.0),
            padding: const EdgeInsets.all(9.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(13.0),
                border: Border.all(color: Colors.grey)),
            child: Icon(
              Icons.language_outlined,
              color: theme.iconTheme.color,
            ),
          ),
        ),
      ),
    ],
  );
}

widgetAppBarAuthTitle(context) {
  return AppBar(
    backgroundColor: Colors.transparent,
    title: Text(
      '',
      style: AppThemeStyle.appBarStyle,
    ),
    leading: IconButton(
      splashRadius: 20,
      icon: SvgPicture.asset(
        'assets/svg/icons/menu.svg',
        width: 24,
        height: 24,
        fit: BoxFit.scaleDown,
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    ),
    elevation: 0,
    actions: <Widget>[
      Padding(
        padding: const EdgeInsets.only(right: 20),
        child: SvgPicture.asset('assets/svg/Icon_notification_outline.svg'),
      )
    ],
  );
}

widgetAppBarTitle(
  context, {
  String title = '',
  bool hasLeading = true,
  Color color,
  Function onPressed,
}) {
  return AppBar(
    centerTitle: true,
    elevation: 0,
    backgroundColor: color == null ? Colors.transparent : color,
    title: Text(title, style: AppThemeStyle.appBarStyle),
    leading: hasLeading
        ? IconButton(
            iconSize: 25.0,
            splashRadius: 20,
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onPressed: () =>
                onPressed == null ? Navigator.of(context).pop() : onPressed(),
          )
        : null,
    // bottom: PreferredSize(
    //   preferredSize: Size.fromHeight(20.0),
    //   child: Container(
    //     decoration: BoxDecoration(
    //       color: Colors.white,
    //       borderRadius: BorderRadius.only(
    //         topLeft: Radius.circular(20.0),
    //         topRight: Radius.circular(20.0),
    //       ),
    //     ),
    //     height: 20.0,
    //   ),
    // ),
  );
}

class ConcaveAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double height;
  final Color backgroundColor;

  const ConcaveAppBar({
    Key key,
    @required this.height,
    @required this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.fromHeight(height),
      painter: _ConcaveAppBarPainter(
        backgroundColor: backgroundColor,
        curveHeight: 20,
        cornerRadius: 20,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}

class _ConcaveAppBarPainter extends CustomPainter {
  final Color backgroundColor;
  final double curveHeight;
  final double cornerRadius;

  _ConcaveAppBarPainter({
    @required this.backgroundColor,
    @required this.curveHeight,
    @required this.cornerRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = backgroundColor;
    final path = Path();

    // Start drawing from the bottom-left corner of the appbar
    path.moveTo(0, size.height - cornerRadius);

    // Draw a straight line to the bottom-right corner of the appbar
    path.lineTo(size.width, size.height - cornerRadius);

    // Draw a quadratic bezier curve to the bottom-right corner of the curve
    path.quadraticBezierTo(
      size.width,
      size.height - cornerRadius - curveHeight,
      size.width - cornerRadius,
      size.height - curveHeight,
    );

    // Draw a straight line to the top-right corner of the curve
    path.lineTo(cornerRadius, size.height - curveHeight);

    // Draw a quadratic bezier curve to the top-left corner of the curve
    path.quadraticBezierTo(
      0,
      size.height - curveHeight,
      0,
      size.height - curveHeight - cornerRadius,
    );

    // Draw a straight line to the bottom-left corner of the appbar
    path.lineTo(0, size.height - cornerRadius);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_ConcaveAppBarPainter oldDelegate) {
    return oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.curveHeight != curveHeight ||
        oldDelegate.cornerRadius != cornerRadius;
  }
}

// class _ConvexAppBarPainter extends CustomPainter {
//   final Color backgroundColor;
//   final double borderRadius;
//   _ConvexAppBarPainter(this.backgroundColor, this.borderRadius);

//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()..color = backgroundColor;
//     final path = Path();

//     path.moveTo(borderRadius, 0);
//     path.lineTo(size.width - borderRadius, 0);
//     path.quadraticBezierTo(size.width + borderRadius, size.height / 2,
//         size.width - borderRadius, size.height);
//     path.lineTo(borderRadius, size.height);
//     path.quadraticBezierTo(-borderRadius, size.height / 2, borderRadius, 0);

//     canvas.drawPath(path, paint);
//   }

//   @override
//   bool shouldRepaint(_ConvexAppBarPainter oldDelegate) {
//     return oldDelegate.backgroundColor != backgroundColor ||
//         oldDelegate.borderRadius != borderRadius;
//   }
// }
