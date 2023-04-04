import 'dart:async';
import 'dart:developer';

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
import 'package:charity_app/view/theme/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart';
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
          }
          return ListView(
            // physics: NeverScrollableScrollPhysics(),
            children: [
              MyPointsWidget(points: model.points),
              const ExchangePonintsInformationWidget(),
              PartnersList(partners: model.partners),
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
      margin: EdgeInsets.only(top: 40, bottom: 40, left: 95, right: 95),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Color(0XFFF1BC62),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              getTranslated(context, "my_points").toUpperCase(),
              style: TextStyle(
                fontFamily: "Helvetica Neue",
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Divider(
            height: 2,
            color: Colors.white,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              points.toString(),
              style: TextStyle(
                color: Colors.white,
                fontSize: 40,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ExchangePonintsInformationWidget extends StatelessWidget {
  const ExchangePonintsInformationWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 16, right: 16),
      margin: EdgeInsets.only(left: 16, right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          15,
        ),
      ),
      child: ExpandablePanel(
        disableBackgroundColor: false,
        headerTitle: getTranslated(
          context,
          "how_to_get_points",
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: Row(
            children: [
              Flexible(
                child: Text(
                  getTranslated(context, "information_on_getting_points"),
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Color(0XFF777F83),
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
  List<Partner> partners;
  // ValueNotifier<bool> isLoading;
  PartnersList({Key key, this.partners}) : super(key: key);

  @override
  _PartnersListState createState() => _PartnersListState();
}

class _PartnersListState extends State<PartnersList> {
  @override
  Widget build(BuildContext context) {
    return ExpandablePanel(
      headerTitle: getTranslated(context, "how_to_exchange_points"),
      disableBackgroundColor: true,
      child: _buildListView(),
    );
  }

  Widget _buildListView() {
    return ListView.separated(
      separatorBuilder: (context, index) => SizedBox(
        height: 10,
      ),
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
      itemCount: widget.partners.length,
      itemBuilder: (context, index) {
        return ResourcesCardBuilder(
          data: widget.partners[index],
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
                padding: EdgeInsets.all(16),
                child: Text(
                  widget.headerTitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Color(0XFF777F83),
                  ),
                ),
              ),
              Icon(
                _isExpanded ? Icons.expand_less : Icons.expand_more,
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
  const ResourcesCardBuilder({
    Key key,
    this.data,
  }) : super(key: key);

  final Partner data;

  @override
  _CardBuilderState createState() => _CardBuilderState();
}

class _CardBuilderState extends State<ResourcesCardBuilder> {
  Partner get data => widget.data;
  ExchangePointsViewModel exchangePointsViewModel;
  @override
  initState() {
    super.initState();

    InAppPurchaseDataRepository().hasActiveSubscription.addListener(
      () {
        setState(
          () {},
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75,
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          15.0,
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
                  15,
                ),
              ),
              height: 75,
              child: Row(
                children: [
                  Container(
                    child: Stack(
                      alignment: Alignment.centerLeft,
                      children: [
                        Container(
                          height: 75.0,
                          width: 75.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              15.0,
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
                      padding: const EdgeInsets.fromLTRB(
                        10.0,
                        10.0,
                        40.0,
                        10.0,
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
                                fontSize: 18,
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
                                fontSize: 14,
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
              alignment: Alignment.centerRight,
              child: SvgPicture.asset("assets/svg/partner_rectangle.svg"),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(
                  right: 12.0,
                ),
                child: Text(
                  data.price.toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            InkWell(
              splashColor: Colors.transparent,
              onTap: () async {
                if (InAppPurchaseDataRepository().hasActiveSubscription.value ==
                    true) {
                  bool exchangedPoints = await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => PartnerScreen(partner: data),
                    ),
                  );

                  if (exchangedPoints) {
                    setState(() {
                      data.exchangedPoints = exchangedPoints;
                    });
                    exchangePointsViewModel.getPoints();
                  }
                } else {
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
                          height: 75,
                          width: double.infinity,
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
