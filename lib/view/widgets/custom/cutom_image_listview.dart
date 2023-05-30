import 'package:cached_network_image/cached_network_image.dart';
import 'package:charity_app/model/data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ImageListview extends StatefulWidget {
  final List<String> imgList;
  BuildContext context;
  Function(int index, BuildContext context) goToBanner;
  ImageListview({Key key, this.imgList, this.context, this.goToBanner})
      : super(key: key);

  @override
  State<ImageListview> createState() => _ImageListviewState();
}

class _ImageListviewState extends State<ImageListview> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.width > 500 ? 200.h : 200.h,
          child: PageView.builder(
            itemCount: widget.imgList.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  if (widget.context != null) {
                    widget.goToBanner(index, context);
                    // pass data to this page
                  }
                },
                child: Container(
                  padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width > 500 ? 55.h : 37.h,
                    right:
                        MediaQuery.of(context).size.width > 500 ? 55.h : 37.h,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(
                      Radius.circular(28),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: widget.imgList[index],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 8.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.imgList.length,
            (index) => AnimatedContainer(
              duration: Duration(milliseconds: 200),
              margin: EdgeInsets.symmetric(horizontal: 4),
              width: 6.h,
              height: 6.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentIndex == index
                    ? Color(0XFF79BCB7)
                    : Color(0XFFC1C1C1),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
