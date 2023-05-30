import 'package:charity_app/custom_icons_icons.dart';
import 'package:charity_app/localization/language_constants.dart';
import 'package:charity_app/model/data.dart';
import 'package:charity_app/utils/constants.dart';
import 'package:charity_app/utils/device_size_config.dart';
import 'package:charity_app/view/screens/common/bottom_bar_detail_viemodel.dart';
import 'package:charity_app/view/screens/common/custom_recrod_details.dart';
import 'package:charity_app/view/theme/app_color.dart';
import 'package:charity_app/view/theme/themes.dart';
import 'package:charity_app/view/widgets/custom/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:stacked/stacked.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:html/parser.dart' as html;

String parseHtmlStringToYoutubeId(document) {
  var iframe = document.querySelector(
      'iframe[src^="https://www.youtube.com"], iframe[src^="http://www.youtube.com"], iframe[src^="//www.youtube.com"]');
  if (iframe != null) {
    var youtubeUrl = iframe?.attributes['src'];
    return youtubeUrl;
  }
  return null;
}

class BottomBarDetail extends StatefulWidget {
  final Data data;
  final instance;
  final String type;
  final List allcategories;
  final String category;
  final TabController parentController;
  final bool needTabBars;
  final Function disposeCallback;

  const BottomBarDetail(
      {Key key,
      @required this.data,
      this.type,
      this.instance,
      this.allcategories,
      this.category,
      this.parentController,
      this.needTabBars = true,
      this.disposeCallback})
      : super(key: key);

  @override
  BottomBarDetailState createState() => BottomBarDetailState();
}

class BottomBarDetailState extends State<BottomBarDetail>
    with SingleTickerProviderStateMixin {
  Data get data => widget.data;
  bool canPop = true;
  YoutubePlayerController _controller;

  @override
  initState() {
    String url = parseHtmlStringToYoutubeId(html.parse(data.description));

    _controller = YoutubePlayerController.fromVideoId(
      videoId: url != null ? YoutubePlayerController.convertUrlToId(url) : "",
      autoPlay: false,
      params: YoutubePlayerParams(showFullscreenButton: true),
    );

    super.initState();
  }

  @override
  dispose() {
    if (widget.disposeCallback != null) {
      widget.disposeCallback();
    }
    _controller.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _controller.setFullScreenListener((value) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
          overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top]);
    });
    return ViewModelBuilder<BottomBarDetailViewModel>.reactive(
      builder: (context, model, child) {
        if (!widget.needTabBars) {
          return Scaffold(
            appBar: customAppbar(
                controller: null,
                context: context,
                category: [],
                appBarTitle: '',
                appBarIncome: getTranslated(context, widget.type),
                withTabs: false),
            body: fakeBlock(context, model),
          );
        }

        return Container(
          color: Colors.grey[50],
          child: SafeArea(
            bottom: true,
            right: false,
            left: false,
            top: true,
            child: DefaultTabController(
              length: widget.allcategories.length,
              child: YoutubePlayerScaffold(
                  controller: _controller,
                  aspectRatio: 4 / 3,
                  fullscreenOrientations: [
                    DeviceOrientation.portraitUp,
                  ],
                  builder: (_context, player) {
                    // model.context = _context;
                    return Scaffold(
                      appBar: customAppbar(
                        controller: widget.parentController,
                        context: context,
                        category: widget.allcategories,
                        appBarTitle: '',
                        appBarIncome: getTranslated(context, widget.type),
                      ),
                      body: TabBarView(
                        controller: widget.parentController,
                        physics: NeverScrollableScrollPhysics(),
                        children: List<Widget>.generate(
                            widget.allcategories.length, (int index) {
                          return fakeBlock(
                            context,
                            model,
                            player,
                          );
                        }),
                      ),
                    );
                  }),
            ),
          ),
        );
      },
      onViewModelReady: (model) {
        model.initContext(context, widget.data);
      },
      viewModelBuilder: () =>
          BottomBarDetailViewModel(instance: widget.instance),
    );
  }

  Widget fakeBlock(BuildContext context, model, [KeyedSubtree player]) {
    final size = SizeConfig.calculateBlockVertical(22);

    return Scaffold(
      backgroundColor: AppColor.primary,
      body: Column(
        children: <Widget>[
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                  topLeft: const Radius.circular(40),
                  topRight: const Radius.circular(40)),
              child: Container(
                color: AppColor.white,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 0),
                  child: mainUI(model, player),
                ),
              ),
            ),
          ),
        ],
      ),
      // listen for changes
      bottomNavigationBar: Container(
        // height: 70.h,
        child: BottomNavigationBar(
          onTap: (i) async {
            await model.onTabTapped(i);
          },
          type: BottomNavigationBarType.fixed,
          currentIndex: model.currentIndex,
          selectedItemColor: AppThemeStyle.primaryColor,
          items: [
            BottomNavigationBarItem(
                label: '',
                icon: ValueListenableBuilder(
                  valueListenable: model.dataValueNotifier,
                  builder: (context, value, child) {
                    if (value.isLiked == true) {
                      return Icon(
                        CustomIcons.heart,
                        semanticLabel: getTranslated(context, "leave_like"),
                        color: AppThemeStyle.primaryColor,
                        size: size,
                      );
                    } else {
                      return Icon(
                        CustomIcons.heart_outline,
                        semanticLabel: getTranslated(context, "leave_like"),
                        color: Constants.ligtherMainTextColor,
                        size: size,
                      );
                    }
                  },
                )),
            BottomNavigationBarItem(
              label: '',
              icon: Icon(
                CustomIcons.sending,
                color: Constants.ligtherMainTextColor,
                semanticLabel: getTranslated(context, "leave_comment"),
                size: size,
              ),
            ),
            BottomNavigationBarItem(
              label: '',
              icon: Icon(
                Icons.share_outlined,
                color: Constants.ligtherMainTextColor,
                size: size,
                semanticLabel: getTranslated(context, "share_publication"),
              ),
            ),
            BottomNavigationBarItem(
              label: '',
              icon: ValueListenableBuilder(
                valueListenable: model.dataValueNotifier,
                builder: (context, value, child) {
                  if (value.inBookmarks == true)
                    return Icon(
                      CustomIcons.favorite,
                      color: AppThemeStyle.primaryColor,
                      semanticLabel: getTranslated(context, "add_to_favorite"),
                      size: size - 2,
                    );
                  else {
                    return Icon(
                      Icons.bookmark_outline,
                      size: size + 5,
                      semanticLabel: getTranslated(context, "add_to_favorite"),
                      color: Constants.ligtherMainTextColor,
                    );
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget mainUI(BottomBarDetailViewModel viewModel, KeyedSubtree player) {
    return CustomRecordDetails(
      data: widget.data,
      model: viewModel,
      player: player,
    );
  }
}
