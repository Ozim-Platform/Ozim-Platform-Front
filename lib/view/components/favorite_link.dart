import 'package:charity_app/model/data.dart';
import 'package:charity_app/persistance/api_provider.dart';
import 'package:charity_app/view/screens/common/bottom_bar_detail_viemodel.dart';
import 'package:charity_app/view/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FavoriteLink extends StatelessWidget {
  const FavoriteLink({
    Key key,
    @required this.data,
    @required this.swipeLeft,
    @required this.swipeRight,
    @required this.onForceUpdateList,
  }) : super(key: key);

  final Data data;
  final Function swipeLeft;
  final Function swipeRight;
  final Function onForceUpdateList;

  onFavClick(BuildContext context) async {
    if (data.inBookmarks) {
      swipeRight();
      data.inBookmarks = false;
      removeInstanceFromFavorite(data.id, data.type);
    } else {
      List<Data> folders = await ApiProvider().getBookMarkFolders();
      BottomBarDetailViewModel detailViewModel =
          BottomBarDetailViewModel(instance: this);
      detailViewModel.initContext(context, data);
      detailViewModel.onBookMarks(context, data, initFolders: folders);
      detailViewModel.addListener(() {
        swipeRight();
        onForceUpdateList();
      });
    }
  }

  Future<void> removeInstanceFromFavorite(int id, String type) async {
    ApiProvider _apiProvider = ApiProvider();
    // print(data);
    Map<String, dynamic> data = {'type': type};
    // if (type == 'article') {
    //   data['article_id'] = id;
    // } else {
    data['record_id'] = id;
    // }
    _apiProvider.removeFromBookmarkStore(data).then((value) {
      onForceUpdateList();
    }).catchError((error) {
      print("Error: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.h,
      child: GestureDetector(
        excludeFromSemantics: true,
        onPanUpdate: (details) {
          int sensitivity = 2;
          if (details.delta.dx < -sensitivity) {
            swipeLeft();
          }
        },
        onTap: () => onFavClick(context),
        child: Stack(
          alignment: Alignment.centerRight,
          children: [
            Image.asset(
              'assets/image/favorite_shadow.png',
              width: MediaQuery.of(context).size.width > 500 ? 200.h : 50.h,
            ),
            Padding(
              padding: EdgeInsets.only(top: 5.w),
              child: Icon(
                data.inBookmarks == true
                    ? Icons.bookmark
                    : Icons.bookmark_outline,
                color: AppColor.primary,
                // size: MediaQuery.of(context).size.width > 500 ? 20.w : 20.w,
                size: 20.w,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
