import 'package:charity_app/utils/constants.dart';
import 'package:charity_app/view/widgets/avatar_iamge.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserImage extends StatelessWidget {
  const UserImage({
    Key key,
    @required this.userUrl,
    this.size = 45,
  }) : super(key: key);

  final String userUrl;
  final double size;
  @override
  Widget build(BuildContext context) {
    if (userUrl == null || userUrl == '') {
      return ClipOval(
        child: Image.asset(
          'assets/image/avatar.png',
          width: size,
          height: size,
        ),
      );
    } else {
      String url =
          userUrl.contains('http') ? userUrl : Constants.MAIN_HTTP + userUrl;
      return AvatarImage(
        imageUrl: url,
        size: size,
      );
    }
  }
}
