import 'package:charity_app/model/data.dart';
import 'package:charity_app/persistance/api_provider.dart';
import 'package:charity_app/view/screens/common/bottom_bar_detail_viemodel.dart';
import 'package:charity_app/view/theme/app_color.dart';
import 'package:flutter/material.dart';

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
      width: 60,
      height: 40,
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
          alignment: Alignment.center,
          children: [
            Image.asset(
              'assets/image/favorite_shadow.png',
            ),
            Padding(
              padding: const EdgeInsets.only(left: 22, top: 5),
              child: Icon(
                data.inBookmarks == true
                    ? Icons.bookmark
                    : Icons.bookmark_outline,
                color: AppColor.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
