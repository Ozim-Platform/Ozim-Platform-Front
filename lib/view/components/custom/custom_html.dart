import 'package:charity_app/utils/utils.dart';
import 'package:charity_app/view/theme/themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class CustomHtml extends StatelessWidget {
  const CustomHtml({
    Key key,
    @required this.data,
    this.style,
  }) : super(key: key);

  final String data;
  final TextStyle style;

  Future<void> _linkAction(String url, BuildContext cont) async {
    if (url != null) {
      await goToUrl(url, cont);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Html(
      data: data,
      style: {
        'body': buildStyle(),
        'ul, ol': buildStyle(
          margin: const EdgeInsets.symmetric(
            vertical: 16.0,
          ),
          padding: const EdgeInsets.only(
            left: 16.0,
          ),
        ),
        'p,h5,h6': buildStyle(
          margin: const EdgeInsets.symmetric(
            vertical: 16.0,
          ),
        ),
        'li': buildStyle(
          margin: const EdgeInsets.only(
            bottom: 16.0,
          ),
        ),
        'span': buildStyle(),
        'h1,h2': buildStyle(
          type: 'header',
        ),
        'h3,h4, bold, strong': buildStyle(
          type: 'subheader',
        ),
      },
      onLinkTap: (String url, RenderContext cont, Map<String, String> map,
          element) async {
        await _linkAction(url, context);
      },
    );
  }

  Style buildStyle({
    type = 'normal',
    padding = const EdgeInsets.all(
      0,
    ),
    margin = const EdgeInsets.all(
      0,
    ),
  }) {
    TextStyle _typeStyle;
    switch (type) {
      case 'normal':
        _typeStyle = AppThemeStyle.normalText;
        break;
      case 'header':
        _typeStyle = AppThemeStyle.headerPrimaryColor;
        break;
      case 'subheader':
        _typeStyle = AppThemeStyle.subHeader.copyWith(
          fontSize: 19,
        );
        break;
      default:
        _typeStyle = AppThemeStyle.normalText;
        break;
    }

    TextStyle _style = style != null ? style : _typeStyle;

    return Style(
      fontSize: FontSize(
        _style.fontSize,
      ),
      fontFamily: _style.fontFamily,
      fontWeight: _style.fontWeight,
      color: _style.color,
      padding: padding,
      // margin: Margins.all(
      //   0,
      // ),
    );
  }
}

class CustomHtml2 extends StatelessWidget {
  const CustomHtml2({
    Key key,
    @required this.data,
    this.style,
  }) : super(key: key);

  final String data;
  final TextStyle style;

  Future<void> _linkAction(String url, BuildContext cont) async {
    if (url != null) {
      await goToUrl(url, cont);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Html(
      data: data,
      style: {  
        'iframe': buildStyle(
          margin: const EdgeInsets.symmetric(vertical: 16.0),
          padding: const EdgeInsets.only(left: 16.0),
        ),
        'body': buildStyle(),
        'ul, ol': buildStyle(
          margin: const EdgeInsets.symmetric(vertical: 16.0),
          padding: const EdgeInsets.only(left: 16.0),
        ),
        'p,h5,h6': buildStyle(
          margin: const EdgeInsets.symmetric(
            vertical: 16.0,
          ),
        ),
        'li': buildStyle(
          margin: const EdgeInsets.only(
            bottom: 16.0,
          ),
        ),
        'span': buildStyle(),
        'h1,h2': buildStyle(type: 'header'),
        'h3,h4, bold, strong': buildStyle(type: 'subheader'),
        'img': buildStyle(),
        'a': buildStyle(
          type: 'a',
          margin: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 50,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 0,
          ),
        ),
      },
      onLinkTap: (String url, RenderContext cont, Map<String, String> map,
          element) async {
        await _linkAction(
          url,
          context,
        );
      },
    );
  }

  Style buildStyle({
    type = 'normal',
    padding = const EdgeInsets.all(
      0,
    ),
    margin = const EdgeInsets.all(
      0,
    ),
  }) {
    TextStyle _typeStyle;
    switch (type) {
      case 'normal':
        _typeStyle = AppThemeStyle.normalText;
        break;
      case 'header':
        _typeStyle = AppThemeStyle.headerPrimaryColor;
        break;
      case 'subheader':
        _typeStyle = AppThemeStyle.subHeader.copyWith(
          fontSize: 19,
        );
        break;
      case 'img':
        _typeStyle = AppThemeStyle.subHeader.copyWith(
          fontSize: 19,
        );
        break;
      case 'a':
        _typeStyle = AppThemeStyle.subHeader.copyWith(
          fontSize: 19,
        );
        break;
      default:
        _typeStyle = AppThemeStyle.normalText;
        break;
    }

    TextStyle _style = style != null ? style : _typeStyle;

    return Style(
      fontSize: FontSize(
        _style.fontSize,
      ),
      fontFamily: _style.fontFamily,
      fontWeight: _style.fontWeight,
      color: _style.color,
      padding: padding,
      // margin: Margins.all(0),
    );
  }
}
