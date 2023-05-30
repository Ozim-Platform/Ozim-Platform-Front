import 'dart:async';

import 'package:charity_app/utils/constants.dart';
import 'package:charity_app/utils/device_size_config.dart';
import 'package:charity_app/utils/utils.dart';
import 'package:charity_app/view/theme/themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomHtml extends StatelessWidget {
  KeyedSubtree player;

  CustomHtml({
    Key key,
    @required this.data,
    this.style,
    this.player,
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
      customRenders: {
        tagMatcher("iframe"): CustomRender.widget(
          widget: (context, buildChildren) {
            // Do something with buildChildren, such as get the source
            final attrs = context.tree.element?.attributes;
            if (attrs != null) {
              var width = double.tryParse(attrs['width'] ?? "");
              var height = double.tryParse(attrs['height'] ?? "");
              final regex = RegExp(
                  r'(?:https?:)?\/\/(?:www\.)?youtube\.com\/embed\/([a-zA-Z0-9_-]+)');
              final match = regex.firstMatch(attrs['src']);
              String string;
              if (match != null) {
                final link = match.group(0);
                if (!link.startsWith('https://')) {
                  final httpsLink = 'https:' + link;
                  string =
                      httpsLink; // Output: https://www.youtube.com/embed/iV9QWFR7nQ0
                } else {
                  string =
                      link; // Output: https://www.youtube.com/embed/iV9QWFR7nQ0
                }
              }

              return Center(
                child: Container(
                  padding: EdgeInsets.only(top: 16.w),
                  child: player,
                ),
              );
            } else {
              return Container(height: 0);
            }
          },
        ),
        tagMatcher("img"): CustomRender.widget(
          widget: (context, buildChildren) {
            final attrs = context.tree.element?.attributes;
            if (attrs != null) {
              var width = SizeConfig.screenWidth;
              context.tree.element.attributes['style'] = 'width: ${width}px;';
              return Container(
                // width: SizeConfig.screenWidth,
                // height: 300,
                child: Html(
                  data: context.tree.element?.outerHtml ?? "",
                ),
              );
            }
            return Container();
          },
        )
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
        _typeStyle = TextStyle(
          // fontFamily: 'Arial',
          fontSize: 16.sp,
          color: Constants.mainTextColor,
          fontWeight: FontWeight.normal,
        );
        break;
      case 'header':
        _typeStyle = TextStyle(
          // fontFamily: 'Arial',
          fontSize: 23.sp,
          letterSpacing: 0.1,

          color: Constants.mainTextColor,
          fontWeight: FontWeight.bold,
        );

        break;
      case 'subheader':
        _typeStyle = AppThemeStyle.subHeader.copyWith(
          fontSize: 19.sp,
        );
        break;
      default:
        _typeStyle = TextStyle(
          fontSize: 16.sp,
          color: Constants.mainTextColor,
          fontWeight: FontWeight.normal,
        );
        break;
    }

    TextStyle _style = style != null ? style : _typeStyle;

    return Style(
      fontSize: FontSize(
        _style.fontSize.spMin,
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
  KeyedSubtree player;
  CustomHtml2({
    Key key,
    @required this.data,
    this.style,
    this.player,
  }) : super(key: key);

  final String data;
  final TextStyle style;

  Future<void> _linkAction(String url, BuildContext cont) async {
    if (url != null) {
      await goToUrl(url, cont);
    }
  }

  @override
  Widget build(BuildContext buildcontext) {
    return Html(
      data: data,
      style: {
        // "iframe": buildStyle(
        //   margin: EdgeInsets.symmetric(vertical: 16.0.w),
        // ),

        'body': buildStyle(),
        'ul, ol': buildStyle(
          margin: EdgeInsets.symmetric(vertical: 16.0.w),
        ),
        'p,h5,h6': buildStyle(
          margin: EdgeInsets.symmetric(
            vertical: 16.0.w,
          ),
        ),
        'li': buildStyle(
          margin: EdgeInsets.only(
            bottom: 16.0.w,
          ),
        ),
        'span': buildStyle(),
        'h1,h2': buildStyle(type: 'header'),
        'h3,h4, bold, strong': buildStyle(type: 'subheader'),
        'img': buildStyle(),
        'a': buildStyle(
          type: 'a',
          margin: EdgeInsets.symmetric(
            horizontal: 20.w,
            vertical: 50.w,
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
          buildcontext,
        );
      },
      customRenders: {
        tagMatcher("iframe"): CustomRender.widget(
          widget: (context, buildChildren) {
            // Do something with buildChildren, such as get the source
            final attrs = context.tree.element?.attributes;
            if (attrs != null) {
              var width = double.tryParse(attrs['width'] ?? "");
              var height = double.tryParse(attrs['height'] ?? "");
              final regex = RegExp(
                  r'(?:https?:)?\/\/(?:www\.)?youtube\.com\/embed\/([a-zA-Z0-9_-]+)');
              final match = regex.firstMatch(attrs['src']);
              String string;
              if (match != null) {
                final link = match.group(0);
                if (!link.startsWith('https://')) {
                  final httpsLink = 'https:' + link;
                  string =
                      httpsLink; // Output: https://www.youtube.com/embed/iV9QWFR7nQ0
                } else {
                  string =
                      link; // Output: https://www.youtube.com/embed/iV9QWFR7nQ0
                }
              }

              return Center(
                child: Container(
                  padding: EdgeInsets.only(top: 16.w),
                  child: player,
                ),
              );
            } else {
              return Container(height: 0);
            }
          },
        ),
        tagMatcher("img"): CustomRender.widget(
          widget: (context, buildChildren) {
            final attrs = context.tree.element?.attributes;
            if (attrs != null) {
              var width = SizeConfig.screenWidth;
              context.tree.element.attributes['style'] = 'width: ${width}px;';
              return Container(
                // width: SizeConfig.screenWidth,
                // height: 300,
                child: Html(
                  data: context.tree.element?.outerHtml ?? "",
                ),
              );
            }
            return Container();
          },
        )
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
        _typeStyle = AppThemeStyle.subHeader.copyWith();
        break;
      case 'img':
        _typeStyle = AppThemeStyle.subHeader.copyWith();
        break;
      case 'a':
        _typeStyle = AppThemeStyle.subHeader.copyWith();
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
