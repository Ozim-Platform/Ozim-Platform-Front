import 'package:charity_app/localization/language_constants.dart';
import 'package:charity_app/model/category.dart';
import 'package:charity_app/model/data.dart';
import 'package:charity_app/persistance/api_provider.dart';
import 'package:charity_app/utils/device_size_config.dart';
import 'package:charity_app/utils/utils.dart';
import 'package:charity_app/view/components/custom/custom_container.dart';
import 'package:charity_app/view/components/custom_expansion_tile.dart';
import 'package:charity_app/view/components/favorite_link.dart';
import 'package:charity_app/view/components/no_data.dart';
import 'package:charity_app/view/components/swipet_container_favorite.dart';
import 'package:charity_app/view/screens/common/custom_tab_controller.dart';
import 'package:charity_app/view/screens/home/service_provider/service_provider_viewmodel.dart';
import 'package:charity_app/view/theme/app_color.dart';
import 'package:charity_app/view/theme/themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stacked/stacked.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;

class ServiceProviderScreen extends StatelessWidget {
  final List<Category> category;

  ServiceProviderScreen({Key key, @required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ServiceProviderViewModel>.reactive(
      builder: (context, model, child) => CustomTabController(
        title: getTranslated(context, 'service_provider'),
        list: category,
        model: model,
        buildMethod: getMainUI,
      ),
      onViewModelReady: (model) {
        model.initModel(category);
      },
      viewModelBuilder: () => ServiceProviderViewModel(),
    );
  }

  Widget getMainUI(BuildContext context, ServiceProviderViewModel model,
      String category, List<Category> allCategories) {
    return CustomContainer(
        child: getListUI(context, model, category, allCategories));
  }

  getListUI(context, ServiceProviderViewModel model, String category,
      List<Category> allCategories) {
    if (model.isLoading) {
      return CupertinoActivityIndicator();
    } else {
      if (model.links?.data != null && model.links.data.length > 0) {
        List list = getListOfInstancesByCategory(model.links.data, category);
        return Padding(
            padding: const EdgeInsets.all(10),
            child: BuildListServices(
              list: list,
              updateCallback: model.reloadData,
            ));
      } else {
        return Container(child: EmptyData());
      }
    }
  }
}

class BuildListServices extends StatelessWidget {
  const BuildListServices({
    Key key,
    @required this.list,
    this.updateCallback,
  }) : super(key: key);

  final List list;
  final Function updateCallback;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: list.length,
      // shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      itemBuilder: (context, i) {
        var data = list[i];
        return ServiceCard(data, updateCallback: updateCallback);
      },
    );
  }
}

class ServiceCard extends StatefulWidget {
  final Data data;
  final updateCallback;

  const ServiceCard(
    this.data, {
    this.updateCallback,
    Key key,
  }) : super(key: key);

  @override
  _ServiceCardState createState() => _ServiceCardState();
}

class _ServiceCardState extends State<ServiceCard> {
  final int baseRaring = 5;
  bool _swiped = false;
  List<Data> folders;
  ApiProvider _apiProvider = ApiProvider();
  bool _isExpanded = false;

  @override
  initState() {
    super.initState();
    init();
  }

  @override
  setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  _setGrade(BuildContext context, int instanceid, int grade) async {
    Navigator.of(context).pop();
    ApiProvider _apiProvider = ApiProvider();
    Map<String, dynamic> data = {
      'record_id': instanceid,
      'type': 'service_provider',
      'rating': grade
    };

    var res = await _apiProvider.setRating(data);
    if (widget.updateCallback != null) {
      widget.updateCallback();
    }
  }

  _setRating(String type, int index, data, BuildContext context) {
    int currentRating = toInt(data.rating);
    if (data.rated) return;
    int instanceId = data.id;
    int grade = type == 'rate' ? index + 1 : (currentRating + index + 1);
    String message =
        'Вы уверены, что хотите поставить оценку ' + grade.toString();

    return showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(message),
        actions: <Widget>[
          CupertinoDialogAction(
            child: Text(getTranslated(context, 'ok')),
            onPressed: () => {_setGrade(context, instanceId, grade)},
          ),
          CupertinoDialogAction(
            child: Text(getTranslated(context, 'cancel')),
            onPressed: () => {Navigator.of(context).pop()},
          ),
        ],
      ),
    );
  }

  _swipeLeft() {
    setState(() {
      _swiped = true;
    });
  }

  _swipeRight() {
    setState(() {
      _swiped = false;
    });
  }

  init() {
    _apiProvider.getBookMarkFolders().then((value) {
      setState(() {
        folders = value;
      });
    }).catchError((error) {
      print("Error: $error", level: 1);
    });
  }

  _buildAddress(String a) {
    String city = a.substring(0, a.indexOf(',') + 1);
    String ad = a.substring(a.indexOf(',') + 1).trim();
    return '$city\n$ad';
  }

  Widget _buildDescView({EdgeInsets padding}) {
    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        widget.data.description,
        style: AppThemeStyle.normalText,
      ),
    );
  }

  Widget _buildRatingView({EdgeInsets padding}) {
    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
                widget.data.rated
                    ? '${getTranslated(context, 'users_rating')} ${widget.data.rating.toDouble().toStringAsFixed(1)}'
                    : 'Вы можете оставить свою оценку',
                style: AppThemeStyle.normalText),
          ),
          Row(
            children: [
              ...List<Widget>.generate(toInt(widget.data.rating), (int index) {
                return GestureDetector(
                  onTap: () {
                    _setRating('rate', index, widget.data, context);
                  },
                  child: Icon(Icons.star, color: AppThemeStyle.orangeColor),
                );
              }),
              ...List<Widget>.generate(baseRaring - toInt(widget.data.rating),
                  (int index) {
                return GestureDetector(
                  onTap: () {
                    _setRating('norate', index, widget.data, context);
                  },
                  child: Icon(Icons.star,
                      color: AppThemeStyle.orangeColor.withOpacity(0.4)),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // print(widget.data.author);
    // print(widget.data.link);
    // print(widget.data.phone);
    return Container(
      padding: const EdgeInsets.all(0),
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: CustomExpansionTile(
        iconColor: const Color(0xFFACB1B4),
        onExpansionChanged: (val) {
          setState(() {
            _isExpanded = val;
          });
        },
        tilePadding: const EdgeInsets.only(right: 10),
        title: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  widget.data.title,
                  style: AppThemeStyle.subHeader,
                ),
              ),
              // Divider(
              //   height: 2,
              //   color: AppThemeStyle.primaryColor,
              // ),
              // if (widget.data.name != null)
              //   Padding(
              //     padding: const EdgeInsets.only(bottom: 15, top: 15),
              //     child: Row(
              //       children: [
              //         SvgPicture.asset(
              //           'assets/svg/icons/location.svg',
              //           width: 24,
              //           height: 24,
              //           fit: BoxFit.scaleDown,
              //         ),
              //         Flexible(
              //           child: Padding(
              //             padding: const EdgeInsets.only(left: 10),
              //             child: Text(
              //               widget.data.name,
              //               style: AppThemeStyle.normalText,
              //             ),
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // if (widget.data.rating != null && !_isExpanded) ...[
              //   Row(
              //     mainAxisAlignment: MainAxisAlignment.end,
              //     children: [
              //       Transform.translate(
              //         offset: const Offset(55, 10),
              //         child: _buildRatingView(padding: EdgeInsets.zero),
              //       ),
              //     ],
              //   )
              // ],
            ],
          ),
        ),
        subtitle: widget.data.name != null
            ? Column(
                children: [
                  _isExpanded
                      ? SizedBox.shrink()
                      : Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Divider(
                            height: 4,
                            color: const Color(0xFF62beb8),
                          ),
                        ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 15, 0, 15),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          'assets/svg/icons/location.svg',
                          width: 24,
                          height: 24,
                          fit: BoxFit.scaleDown,
                        ),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              _buildAddress(widget.data.name),
                              style: AppThemeStyle.normalText,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : SizedBox.shrink(),
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(20.0, 0, 35.0, 20.0),
                child: Column(
                  children: [
                    SizedBox(height: SizeConfig.calculateBlockVertical(10)),
                    // Text('asdasdasdas'),

                    // Align(
                    //   alignment: Alignment.centerLeft,
                    //   child: CustomHtml2(
                    //     data: widget.data.description,
                    //   ),
                    // ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Divider(
                        height: 2,
                        color: AppThemeStyle.primaryColor,
                      ),
                    ),
                    if (widget.data.description != null) _buildDescView(),
                    // Divider(
                    //   height: 2,
                    //   color: AppThemeStyle.primaryColor,
                    // ),
                    widget.data.name != null
                        ? Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 15),
                                child: Divider(
                                  height: 4,
                                  color: const Color(0xFF62beb8),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(15, 15, 0, 15),
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                      'assets/svg/icons/location.svg',
                                      width: 24,
                                      height: 24,
                                      fit: BoxFit.scaleDown,
                                    ),
                                    Flexible(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: Text(
                                          _buildAddress(widget.data.name),
                                          style: AppThemeStyle.normalText,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        : SizedBox.shrink(), //TODO: ??
                    widget.data.author != null
                        ? Padding(
                            padding: const EdgeInsets.fromLTRB(15, 5, 0, 15),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/svg/icons/person_outline.svg',
                                  width: 24,
                                  height: 24,
                                  fit: BoxFit.scaleDown,
                                ),
                                Flexible(
                                  child: Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Text(
                                        widget.data.author,
                                        style: AppThemeStyle.normalText,
                                      )),
                                )
                              ],
                            ),
                          )
                        : SizedBox.shrink(),
                    widget.data.phone != null
                        ? Padding(
                            padding: const EdgeInsets.fromLTRB(15, 5, 0, 15),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/svg/icons/phone.svg',
                                  color: AppColor.primary,
                                  width: 24,
                                  height: 24,
                                  fit: BoxFit.scaleDown,
                                ),
                                Flexible(
                                  child: Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Text(
                                        widget.data.phone,
                                        style: AppThemeStyle.normalText,
                                      )),
                                )
                              ],
                            ),
                          )
                        : SizedBox.shrink(),
                    widget.data.link != null
                        ? Padding(
                            padding: const EdgeInsets.fromLTRB(15, 5, 0, 15),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/svg/icons/web.svg',
                                  width: 24,
                                  height: 24,
                                  fit: BoxFit.scaleDown,
                                ),
                                Flexible(
                                    child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: InkWell(splashColor: Colors.transparent,
                                            onTap: () async {
                                              if (await launcher.canLaunch(
                                                  widget.data.link)) {
                                                launcher
                                                    .launch(widget.data.link);
                                              }
                                            },
                                            child: Text(widget.data.link,
                                                style: AppThemeStyle
                                                    .normalText)))),
                              ],
                            ),
                          )
                        : SizedBox.shrink(),
                    widget.data.email != null
                        ? Padding(
                            padding: const EdgeInsets.fromLTRB(10, 5, 0, 15),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/svg/icons/email.svg',
                                  color: AppColor.primary,
                                  width: 24,
                                  height: 24,
                                  fit: BoxFit.scaleDown,
                                ),
                                Padding(
                                    padding: const EdgeInsets.only(left: 5),
                                    child: Text(widget.data.email,
                                        style: AppThemeStyle.normalText)),
                              ],
                            ),
                          )
                        : SizedBox.shrink(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Divider(
                        height: 2,
                        color: AppThemeStyle.primaryColor,
                      ),
                    ),
                    if (widget.data.rating != null) _buildRatingView(),
                  ],
                ),
              ),
              Positioned(
                right: -5,
                bottom: -2,
                child: FavoriteLink(
                  data: widget.data,
                  swipeRight: _swipeRight,
                  swipeLeft: _swipeLeft,
                  onForceUpdateList: () {},
                ),
              ),
              SwipedContainerFavorite(
                _swiped,
                () {},
                _swipeRight,
                data: widget.data,
              )
            ],
          ),
        ],
      ),
    );
  }
}
