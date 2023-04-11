import 'package:cached_network_image/cached_network_image.dart';
import 'package:charity_app/model/data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class ImageListview extends StatefulWidget {
  final List<String> imgList;
  BuildContext context;
  Function(int index, BuildContext context) goToBanner;
  ImageListview({Key key, this.imgList, this.context,this.goToBanner}) : super(key: key);

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
          height: 200,
          // margin: EdgeInsets.only(left: 16, right: 16),
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
                  if(widget.context!=null){

                  widget.goToBanner(index, context);
                  // pass data to this page
                  }
                },
                child: Container(
                  // margin: EdgeInsets.only(left: 16, right: 16, top: 32),
                  padding: EdgeInsets.only(
                    left: 24,
                    right: 24,
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
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.imgList.length,
            (index) => AnimatedContainer(
              duration: Duration(milliseconds: 200),
              margin: EdgeInsets.symmetric(horizontal: 4),
              width: 6,
              height: 6,
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
