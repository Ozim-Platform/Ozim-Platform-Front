import 'package:charity_app/localization/language_constants.dart';
import 'package:charity_app/utils/device_size_config.dart';
import 'package:charity_app/utils/formatters.dart';
import 'package:charity_app/view/components/custom/custom_badge.dart';
import 'package:charity_app/view/components/user_image.dart';
import 'package:charity_app/view/theme/app_color.dart';
import 'package:charity_app/view/theme/themes.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NoticeCard extends StatefulWidget {
  final Map<String, dynamic> data;
  final bool needNotice;

  const NoticeCard(this.data, {Key key, this.needNotice = false})
      : super(key: key);

  @override
  _NoticeCardState createState() => _NoticeCardState();
}

class _NoticeCardState extends State<NoticeCard> {
  String _avatar = '';

  @override
  initState() {
    _avatar = widget.data['avatar'];
    _tryGetFireBaseAvatar();
    super.initState();
  }

  _tryGetFireBaseAvatar() async {
    if (_avatar == null || _avatar == '') {
      String _email = widget.data['email'];
      Reference ref = FirebaseStorage.instance.ref('users/$_email/avatar.png');
      try {
        String avatar = await ref.getDownloadURL();
        _avatar = avatar;
        setState(() {});
      } catch (e) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.0,
      color: AppColor.scaffoldBackground,
      child: Container(
        height: widget.needNotice ? 118.w : 90.w,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UserImage(
              userUrl: _avatar,
              size: 60.w,
            ),
            SizedBox(width: SizeConfig.calculateBlockVertical(20)),
            Expanded(
              child: Stack(
                alignment: Alignment.centerRight,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.data['name'],
                        style: AppThemeStyle.subHeaderBigger,
                      ),
                      if (widget.needNotice)
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 5.w),
                          child: Text(
                            getTranslated(context, 'notice_reply_annotation'),
                            style: AppThemeStyle.normalTextItalic,
                            // textScaleFactor: SizeConfig.textScaleFactor(),
                          ),
                        ),
                      Padding(
                        padding: EdgeInsets.only(top: 2.w, right: 30.w),
                        child: SizedBox(
                          height: 40.w,
                          child: Text(
                            widget.data['messages'].length > 0
                                ? widget.data['messages'].last['message']
                                : widget.data['email'],
                            style: AppThemeStyle.normalText,
                            maxLines: 2,
                            // textScaleFactor: SizeConfig.textScaleFactor(),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      Expanded(child: SizedBox()),
                      Container(
                        height: 1.w,
                        width: double.infinity,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Color(0xffDEDEDE),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: EdgeInsets.only(top: 2.w),
                          child: Text(
                            dateFormatter2(getDate(widget.data['timecreated'],
                                milliseconds: true)),
                            style: AppThemeStyle.normalTextLighter,
                            // textScaleFactor: SizeConfig.textScaleFactor(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (widget.data['unread'] > 0)
                    BadgeMessagesNotice(widget.data['unread'])
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
