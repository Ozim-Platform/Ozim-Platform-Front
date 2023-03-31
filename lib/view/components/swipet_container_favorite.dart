import 'package:charity_app/custom_icons_icons.dart';
import 'package:charity_app/model/data.dart';
import 'package:charity_app/persistance/api_provider.dart';
import 'package:charity_app/utils/utils.dart';
import 'package:charity_app/view/screens/common/bottom_bar_detail_viemodel.dart';
import 'package:charity_app/view/theme/themes.dart';
import 'package:flutter/material.dart';

class SwipedContainerFavorite extends StatefulWidget {
  final bool _swiped;
  final Function swipedRight;
  final Function onForceUpdateList;
  final Data data;

  const SwipedContainerFavorite(
    this._swiped,
    this.onForceUpdateList,
    this.swipedRight, {
    this.data,
    Key key,
  }) : super(key: key);

  @override
  _SwipedContainerFavoriteState createState() => _SwipedContainerFavoriteState();
}

class _SwipedContainerFavoriteState extends State<SwipedContainerFavorite> {
  Data get data => widget.data;

  Function get swipedRight => widget.swipedRight;

  @override
  setState(fn) {
    // if (mounted) {
    super.setState(fn);
    // }
  }

  toTrash() {
    swipedRight();
    data.inBookmarks = false;
    removeInstanceFromFavorite(data.id, data.type);
  }

  Future<void> toFolder() async {
    ApiProvider _apiProvider = new ApiProvider();
    // List<Data> folders = await _apiProvider.getBookMarkFolders(type: data.type);
    print('call get folders');
    List<Data> folders = await _apiProvider.getBookMarkFolders();
    // print(folders);
    BottomBarDetailViewModel detailViewModel = BottomBarDetailViewModel(instance: this);
    detailViewModel.initContext(context, widget.data);
    detailViewModel.onBookMarks(context, widget.data, initFolders: folders);
    detailViewModel.addListener(() {
      widget.onForceUpdateList();
      swipedRight();
    });
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
      widget.onForceUpdateList();
    }).catchError((error) {
      print("Error: $error", level: 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 350),
      width: widget._swiped ? 172.0 : 0.0,
      curve: Curves.easeIn,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        excludeFromSemantics: true,
        onPanUpdate: (details) {
          int sensitivity = 2;
          if (details.delta.dx > sensitivity) {
            widget.swipedRight();
          }
        },
        child: Container(
          width: 172,
          height: 95,
          decoration: BoxDecoration(
              color: AppThemeStyle.orangeColor, borderRadius: BorderRadius.circular(25)),
          child: Wrap(
            clipBehavior: Clip.hardEdge,
            children: [
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () async {
                  await toFolder();
                },
                child: Container(
                  width: 86,
                  height: 95,
                  child: Icon(
                    CustomIcons.folder,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
              GestureDetector(
                onTap: toTrash,
                behavior: HitTestBehavior.translucent,
                child: Container(
                  width: 86,
                  height: 95,
                  decoration: BoxDecoration(
                    color: AppThemeStyle.pinkColor,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Icon(
                    CustomIcons.trash,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
