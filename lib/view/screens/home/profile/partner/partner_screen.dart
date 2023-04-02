import 'package:cached_network_image/cached_network_image.dart';
import 'package:charity_app/localization/language_constants.dart';
import 'package:charity_app/model/partner.dart';
import 'package:charity_app/persistance/api_provider.dart';
import 'package:charity_app/utils/constants.dart';
import 'package:charity_app/utils/device_size_config.dart';
import 'package:charity_app/view/components/custom/custom_html.dart';
import 'package:charity_app/view/widgets/custom/cutom_image_listview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class PartnerScreen extends StatefulWidget {
  Partner partner;
  PartnerScreen({Key key, this.partner}) : super(key: key);

  @override
  State<PartnerScreen> createState() => _PartnerScreenState();
}

class _PartnerScreenState extends State<PartnerScreen> {
  ApiProvider _apiProvider = ApiProvider();
  List<String> imgList = [];

  @override
  void initState() {
    widget.partner.images.forEach((element) {
      imgList.add(Constants.MAIN_HTTP + "/" + element.path);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        leading: InkWell(splashColor: Colors.transparent,
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: Color(
              0XFF777F83,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
        ),
        child: Column(
          children: [
            imgList.isNotEmpty
                ? Container(
                    width: SizeConfig.screenWidth,
                    child: ImageListview(
                      imgList: imgList,
                    ),
                  )
                : SizedBox(),
            PartnerCard(
              partner: widget.partner,
            ),
            CustomHtml(
              data: widget.partner.description,
            ),
          ],
        ),
      ),
      floatingActionButton: InkWell(splashColor: Colors.transparent,
          onTap: () async {
            _showAlertDialog(context);
          },
          child: Container(
            padding: const EdgeInsets.all(
              16,
            ),
            margin: const EdgeInsets.all(
              8,
            ),
            decoration: BoxDecoration(
              color: const Color(
                0XFF79BCB7,
              ),
              borderRadius: BorderRadius.circular(
                100,
              ),
            ),
            child: SvgPicture.asset(
              'assets/svg/icons/exchange_points.svg',
            ),
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  void _showAlertDialog(BuildContext context) async {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: const Text("points_exchange_confirmation"),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              getTranslated(context, 'no'),
            ),
          ),
          CupertinoDialogAction(
            child: Text(
              getTranslated(context, 'yes'),
            ),
            onPressed: () async {
              bool operationIsSuccessful =
                  await _apiProvider.exchangePoints(widget.partner.id);
              if (operationIsSuccessful) {
                showCupertinoModalPopup<void>(
                  context: context,
                  builder: (BuildContext context) => CupertinoAlertDialog(
                    title: const Text("successful_points_exchange"),
                    actions: <CupertinoDialogAction>[
                      CupertinoDialogAction(
                        onPressed: () {
                          widget.partner.exchangedPoints = true;
                          Navigator.pop(context);
                        },
                        child: Text(
                          // getTranslated(context, 'OK'),
                          "OK",
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                Navigator.of(context).pop();
                showCupertinoModalPopup<void>(
                  context: context,
                  builder: (BuildContext context) => CupertinoAlertDialog(
                    title: const Text("unsuccessful_points_exchange"),
                    actions: <CupertinoDialogAction>[
                      CupertinoDialogAction(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          // getTranslated(context, 'OK'),
                          "Ok",
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

class PartnerCard extends StatelessWidget {
  final Partner partner;
  const PartnerCard({Key key, this.partner}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.centerLeft,
              children: [
                Container(
                  height: 60.0,
                  width: 60.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    image: DecorationImage(
                      image: partner.image != null
                          ? CachedNetworkImageProvider(
                              Constants.MAIN_HTTP + partner.image.path)
                          : (partner.image == null
                              ? AssetImage('assets/image/article_image.png')
                              : CachedNetworkImageProvider(
                                  Constants.MAIN_HTTP + partner.image.path)),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 10.0, 40.0, 10.0),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        partner.name != null
                            ? partner.name
                            : (partner.title != null ? partner.title : ''),
                        style: TextStyle(
                          fontFamily: "Helvetica Neue",
                          fontSize: 23,
                          fontWeight: FontWeight.w700,
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
        SizedBox(height: SizeConfig.calculateBlockVertical(10)),
      ],
    );
  }
}
