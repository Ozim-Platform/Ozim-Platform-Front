import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:charity_app/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BlurredAvatar extends StatelessWidget {
  const BlurredAvatar({
    this.fieldKey,
    this.imageUrl,
    this.size,
  });
  final Key fieldKey;
  final String imageUrl;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: new BoxDecoration(
        color: Colors.grey,
        image: new DecorationImage(
          image: (imageUrl == null || imageUrl == '')
              ? AssetImage('assets/image/avatar_background.png')
              : CachedNetworkImageProvider(
                  'https://ozimplatform.kz/' + imageUrl),
          fit: BoxFit.cover,
        ),
        borderRadius: new BorderRadius.all(new Radius.circular(size / 2)),
      ),
      child: (imageUrl == null || imageUrl == '')
          ? Container(
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.0)),
              child: Icon(
                Icons.add_a_photo,
                color: Colors.white,
                size: 25.sp,
              ),
            )
          : null,
    );
  }
}
