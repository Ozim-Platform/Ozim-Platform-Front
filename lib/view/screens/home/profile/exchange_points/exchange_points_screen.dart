import 'package:cached_network_image/cached_network_image.dart';
import 'package:charity_app/data/in_app_purchase/in_app_purchase_data_repository.dart';
import 'package:charity_app/localization/language_constants.dart';
import 'package:charity_app/model/partner.dart';
import 'package:charity_app/utils/constants.dart';
import 'package:charity_app/utils/device_size_config.dart';
import 'package:charity_app/view/components/locked_card_overlay.dart';
import 'package:charity_app/view/screens/home/profile/exchange_points/exchange_points_viewmodel.dart';
import 'package:charity_app/view/screens/home/profile/partner/partner_screen.dart';
import 'package:charity_app/view/screens/home/profile/profile_screen.dart';
import 'package:charity_app/view/screens/home/subscription/subscription_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stacked/stacked.dart';

class ExchangePointsScreen extends StatefulWidget {
  const ExchangePointsScreen({Key key}) : super(key: key);

  @override
  State<ExchangePointsScreen> createState() => _ExchangePointsScreenState();
}

class _ExchangePointsScreenState extends State<ExchangePointsScreen> {
  AppBar appBar;

  @override
  void initState() {
    profileScreenAppBar(context, true).then((value) => setState(() {
          appBar = value;
        }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      backgroundColor: Color(0XFFF6F6FA),
      body: ViewModelBuilder<ExchangePointsViewModel>.reactive(
        viewModelBuilder: () => ExchangePointsViewModel(),
        onViewModelReady: (viewModel) => viewModel.init(),
        builder: (context, model, child) {
          if (model.isBusy) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (model.hasError) {
            return Center(
              child: Container(
                child: Text(getTranslated(context, "error")),
              ),
            );
          } else
            return ListView(
              children: [
                MyPointsWidget(points: model.points),
                const GetPointsInformationWidget(),
                SizedBox(
                  height: 19.w,
                ),
                const ExchangePointsInformationWidget(),
                SizedBox(
                  height: 35.w,
                ),
                PartnersList(
                  model: model,
                ),
              ],
            );
        },
      ),
    );
  }
}

class MyPointsWidget extends StatelessWidget {
  final int points;
  const MyPointsWidget({Key key, this.points}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 42.w, bottom: 32.w, left: 95.w, right: 95.w),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.w),
        color: Color(0XFFF1BC62),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 8.0.w),
            child: Text(
              getTranslated(context, "my_points").toUpperCase(),
              style: TextStyle(
                fontFamily: "Helvetica Neue",
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Divider(
            height: 2,
            color: Colors.white,
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 8.0.w),
            child: Text(
              points == null ? "0" : points.toString(),
              style: TextStyle(
                color: Colors.white,
                fontSize: 40.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GetPointsInformationWidget extends StatelessWidget {
  const GetPointsInformationWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 16.w, right: 16.w),
      margin: EdgeInsets.only(left: 20.w, right: 20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          15.w,
        ),
      ),
      child: ExpandablePanel(
        disableBackgroundColor: false,
        headerTitle: getTranslated(
          context,
          "how_to_get_points",
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.w, 8.w, 16.w, 0.w),
          child: Row(
            children: [
              Flexible(
                child: Text(
                  getTranslated(context, "information_on_getting_points"),
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Color(0XFF777F83),
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ExchangePointsInformationWidget extends StatefulWidget {
  const ExchangePointsInformationWidget({Key key}) : super(key: key);

  @override
  State<ExchangePointsInformationWidget> createState() =>
      _ExchangePointsInformationWidgetState();
}

class _ExchangePointsInformationWidgetState
    extends State<ExchangePointsInformationWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 16.w, right: 16.w),
      margin: EdgeInsets.only(left: 20.w, right: 20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          15.w,
        ),
      ),
      child: ExpandablePanel(
        disableBackgroundColor: false,
        headerTitle: getTranslated(
          context,
          "how_to_exchange_points",
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.w, 8.w, 16.w, 0.w),
          child: Row(
            children: [
              Flexible(
                child: Text(
                  getTranslated(context, "information_for_exchange_points"),
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Color(0XFF777F83),
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PartnersList extends StatefulWidget {
  ExchangePointsViewModel model;

  PartnersList({Key key, this.model}) : super(key: key);

  @override
  _PartnersListState createState() => _PartnersListState();
}

class _PartnersListState extends State<PartnersList> {
  @override
  Widget build(BuildContext context) {
    return _buildListView();
  }

  Widget _buildListView() {
    return ListView.separated(
      separatorBuilder: (context, index) => SizedBox(
        height: 18.w,
      ),
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      padding: EdgeInsets.only(
        left: 20.w,
        right: 20.w,
        bottom: 18.w,
      ),
      itemCount: widget.model.partners.length,
      itemBuilder: (context, index) {
        return ResourcesCardBuilder(
          model: widget.model,
          index: index,
        );
      },
    );
  }
}

class ExpandablePanel extends StatefulWidget {
  final String headerTitle;
  final Widget child;
  final bool disableBackgroundColor;

  ExpandablePanel({this.headerTitle, this.child, this.disableBackgroundColor});

  @override
  _ExpandablePanelState createState() => _ExpandablePanelState();
}

class _ExpandablePanelState extends State<ExpandablePanel> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: EdgeInsets.all(16.w),
                child: Text(
                  widget.headerTitle,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Color(0XFF777F83),
                    fontSize: 16.sp,
                  ),
                ),
              ),
              Icon(
                _isExpanded ? Icons.expand_less : Icons.expand_more,
                size: 25.sp,
              ),
            ],
          ),
        ),
        if (_isExpanded) widget.child,
      ],
    );
  }
}

class ResourcesCardBuilder extends StatefulWidget {
  ExchangePointsViewModel model;
  int index;
  ResourcesCardBuilder({
    Key key,
    this.model,
    this.index,
  }) : super(key: key);

  @override
  _CardBuilderState createState() => _CardBuilderState();
}

class _CardBuilderState extends State<ResourcesCardBuilder> {
  int get index => widget.index;
  ExchangePointsViewModel get model => widget.model;
  Partner data;

  @override
  initState() {
    super.initState();
    data = model.partners[index];
    InAppPurchaseDataRepository().hasActiveSubscription.addListener(
      () {
        if (mounted) {
          setState(() {});
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75.w,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          15.0.w,
        ),
      ),
      child: ColorFiltered(
        colorFilter: data.exchangedPoints == true
            ? ColorFilter.mode(
                Colors.grey,
                BlendMode.saturation,
              )
            : ColorFilter.mode(
                Colors.transparent,
                BlendMode.saturation,
              ),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(
                  15.w,
                ),
              ),
              height: 75.w,
              child: Row(
                children: [
                  Container(
                    child: Stack(
                      alignment: Alignment.centerLeft,
                      children: [
                        Container(
                          height: 75.0.w,
                          width: 75.0.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              15.0.w,
                            ),
                            image: DecorationImage(
                              image: data.image != null
                                  ? CachedNetworkImageProvider(
                                      Constants.MAIN_HTTP + data.image.path)
                                  : (data.image == null
                                      ? AssetImage(
                                          'assets/image/article_image.png')
                                      : CachedNetworkImageProvider(
                                          Constants.MAIN_HTTP +
                                              data.image.path)),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        10.0.w,
                        10.0.w,
                        40.0.w,
                        10.0.w,
                      ),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              data.name != null
                                  ? data.name
                                  : (data.title != null ? data.title : ''),
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14.sp,
                                color: Color(0XFF6B6F72),
                              ),
                              textAlign: TextAlign.start,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Spacer(),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              data.title != null
                                  ? data.title
                                  : (data.name != null ? data.name : ''),
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14.sp,
                                color: Color(0XFF6B6F72),
                              ),
                              textAlign: TextAlign.start,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: SvgPicture.asset(
                "assets/svg/partner_rectangle.svg",
                height: MediaQuery.of(context).size.width > 500 ? 100.h : 70.h,
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.only(
                  right: 9.0.w,
                  top: 38.h,
                  bottom: 12.h,
                ),
                child: Text(
                  data.price.toString(),
                  // textScaleFactor: SizeConfig.textScaleFactor(),
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20.sp,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: InkWell(
                splashColor: Colors.transparent,
                onTap: () async {
                  if (InAppPurchaseDataRepository()
                          .hasActiveSubscription
                          .value ==
                      true) {
                    await Navigator.of(context)
                        .push(
                      MaterialPageRoute(
                        builder: (context) => PartnerScreen(
                          partner: data,
                          userPoints: model.points,
                        ),
                      ),
                    )
                        .then(
                      (value) {
                        model.init();
                      },
                    );
                  } else if (InAppPurchaseDataRepository()
                              .hasActiveSubscription
                              .value ==
                          false ||
                      InAppPurchaseDataRepository()
                              .hasActiveSubscription
                              .value ==
                          null) {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => SubscriptionScreen(),
                      ),
                    );
                  }
                },
                child:
                    InAppPurchaseDataRepository().hasActiveSubscription.value !=
                            true
                        ? LockedCardOverlay()
                        : SizedBox(
                            height: 75.h,
                            width: double.infinity,
                          ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
