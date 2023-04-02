import 'package:charity_app/localization/language_constants.dart';
import 'package:charity_app/utils/device_size_config.dart';
import 'package:charity_app/view/components/custom_expansion_tile.dart';
import 'package:charity_app/view/components/no_data.dart';
import 'package:charity_app/view/theme/themes.dart';
import 'package:charity_app/view/widgets/app_bar_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:charity_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'faq_viewmodel.dart';
import 'package:html/parser.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class FaqScreen extends StatelessWidget {
  String _parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString = parse(document.body.text).documentElement.text;

    return parsedString;
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<FaqViewModel>.reactive(
      builder: (context, model, child) => ModalProgressHUD(
        inAsyncCall: model.isLoading,
        color: Colors.white,
        dismissible: false,
        progressIndicator: CupertinoActivityIndicator(),
        child: Scaffold(
          backgroundColor: AppThemeStyle.pinkColor,
          appBar: widgetAppBarTitle(context),
          body: Column(
            children: <Widget>[
              Text(
                getTranslated(context, 'faq'),
                style: AppThemeStyle.headerWhite,
              ),
              SizedBox(height: SizeConfig.calculateBlockVertical(30)),
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topLeft: const Radius.circular(40),
                      topRight: const Radius.circular(40)),
                  child: Container(
                    width: SizeConfig.screenWidth,
                    color: const Color.fromRGBO(244, 244, 244, 1),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: mainUI(model),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      onViewModelReady: (model) {
        model.getFaqData();
      },
      viewModelBuilder: () => FaqViewModel(),
    );
  }

  Widget mainUI(FaqViewModel viewModel) {
    if (viewModel.isLoading) return Container();
    if (viewModel.faq != null && viewModel.faq.data.length > 0) {
      return ListView.builder(
          itemCount: viewModel.faq.data.length,
          itemBuilder: (context, i) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: SizeConfig.calculateBlockVertical(5)),
                CustomExpansionTile(
                  maintainState: true,
                  initiallyExpanded: i == 0,
                  backgroundColor: Colors.transparent,
                  collapsedBackgroundColor: Colors.transparent,
                  title: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      viewModel.faq.data[i].title,
                      style: AppThemeStyle.subHeader,
                      textAlign: TextAlign.start,
                    ),
                  ),
                  titleDecoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25.0),
                    border: Border.all(color: Colors.white, width: 1.0),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        _parseHtmlString(viewModel.faq.data[i].description),
                        style: AppThemeStyle.normalText,
                        textAlign: TextAlign.start,
                      ),
                    )
                  ],
                ),
                /* Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  color: Colors.white,
                  elevation: 0,
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: 20, right: 20, top: 10, bottom: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  viewModel.faq.data[i].title,
                                  style: AppThemeStyle.subHeader,
                                  textAlign: TextAlign.start,
                                ),
                              ),
                              Icon(
                                Icons.keyboard_arrow_down,
                                size: 30,
                                color: AppThemeStyle.primaryColor,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    viewModel.faq.data[i].description,
                    style: AppThemeStyle.normalText,
                    textAlign: TextAlign.start,
                  ),
                ),*/
              ],
            );
          });
    } else {
      return Container(child: EmptyData());
    }
  }
}
