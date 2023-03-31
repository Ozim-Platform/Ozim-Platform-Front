import 'package:charity_app/utils/constants.dart';
import 'package:charity_app/view/components/user_image.dart';
import 'package:charity_app/view/screens/other/comment_screen.dart';
import 'package:charity_app/view/theme/themes.dart';
import 'package:flutter/material.dart';

class CommentDetailsView extends StatelessWidget {
  const CommentDetailsView({Key key, @required this.detailsModel}) : super(key: key);

  final CommentDetailsModel detailsModel;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                UserImage(
                  userUrl: detailsModel?.userData?.avatar ?? "",
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Text(
                    detailsModel?.userData?.name ?? "",
                    style: TextStyle(
                      fontSize: 19,
                      letterSpacing: 0.1,
                      color: Constants.mainTextColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              detailsModel.title,
              style: TextStyle(
                fontSize: 19,
                letterSpacing: 0.1,
                color: Constants.mainTextColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              detailsModel.description,
              style: AppThemeStyle.normalText,
            )
          ],
        ),
      ),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
    );
  }
}
