import 'package:charity_app/localization/language_constants.dart';
import 'package:charity_app/utils/constants.dart';
import 'package:charity_app/utils/device_size_config.dart';
import 'package:charity_app/view/components/custom_expansion_tile.dart';
import 'package:charity_app/view/components/search_field_ui.dart';
import 'package:charity_app/view/screens/home/general_search_viewmodel.dart';
import 'package:charity_app/view/theme/themes.dart';
import 'package:charity_app/view/widgets/custom/custom_check_box.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'article/search/search_screen.dart';

class GeneralSearchScreen extends StatefulWidget {
  GeneralSearchScreen({Key key, this.canPop = false}) : super(key: key);

  final bool canPop;

  @override
  _GeneralSearchScreenState createState() => _GeneralSearchScreenState();
}

class _GeneralSearchScreenState extends State<GeneralSearchScreen> {
  final TextEditingController search = new TextEditingController();
  final List<String> listCities = [
    'Весь Казахстан',
    'Нур-Султан',
    'Алматы',
    'Шымкент'
  ];

  final List<String> listAreas = [
    'Акмолинская область',
    'Актюбинская область',
    'Алматинская область',
    'Атырауская область',
    'Восточно-Казахстанская область',
    'Жамбылская область',
    'Западно-Казахстанская область',
    'Карагандинская область',
    'Костанайская область',
    'Кызылординская область',
    'Мангистауская область',
    'Павлодарская область',
    'Северо-Казахстанская область',
    'Туркестанская область',
  ];

  final List<String> listAges = [
    'Все возраста',
    '0-3 месяца',
    '3-6 месяцев',
    '6-9 месяцев',
    '9-12 месяцев',
    '12-18 месяцев',
    '18-24 месяцев',
    '24-36 месяцев',
  ];

  final List<String> listDiagnosis = [
    'Все диагнозы',
    'Аутизм',
    'ДЦП',
    'Олигрофрения',
    'Синдром Дауна',
    'Эпилепсия',
  ];

  final List<String> listOrganisation = [
    'Все огранизации',
    'Фонд',
    'Центр',
    'КППК',
  ];

  final List<String> listServises = [
    'Все услуги',
    'Государственные',
    'Коммерческие',
  ];

  List<bool> listCitiesValue = [];
  List<bool> listAreasValue = [];
  List<bool> listAgesValue = [];
  List<bool> listDiagnosisValue = [];
  List<bool> listOrganisationValue = [];
  List<bool> listServisesValue = [];

  @override
  void initState() {
    initValues();
    // TODO: implement initState
    super.initState();
  }

  initValues() {
    listCitiesValue = List.generate(listCities.length, (index) => false);
    listAreasValue = List.generate(listAreas.length, (index) => false);
    listAgesValue = List.generate(listAges.length, (index) => false);
    listDiagnosisValue = List.generate(listDiagnosis.length, (index) => false);
    listOrganisationValue =
        List.generate(listOrganisation.length, (index) => false);
    listServisesValue = List.generate(listServises.length, (index) => false);
  }

  selectAll(List list, bool value) {
    return List.generate(list.length, (index) => value);
  }

  final _scrollController = ScrollController();

  listCitiesChanged(int position, bool value) {
    if (position == 0) {
      listCitiesValue = selectAll(listCitiesValue, value);
      listAreasValue = selectAll(listAreasValue, value);
    } else
      listCitiesValue[position] = value;

    setState(() {});
  }

  listAreasChanged(int position, bool value) {
    listAreasValue[position] = value;
    setState(() {});
  }

  listAgesChanged(int position, bool value) {
    if (position == 0)
      listAgesValue = selectAll(listAgesValue, value);
    else
      listAgesValue[position] = value;

    setState(() {});
  }

  listDiagnosisChanged(int position, bool value) {
    if (position == 0)
      listDiagnosisValue = selectAll(listDiagnosisValue, value);
    else
      listDiagnosisValue[position] = value;

    setState(() {});
  }

  listOrganisationChanged(int position, bool value) {
    if (position == 0) {
      listOrganisationValue = selectAll(listOrganisationValue, value);
    } else {
      listOrganisationValue[position] = value;
    }
    setState(() {});
  }

  listServisesChanged(int position, bool value) {
    if (position == 0) {
      listServisesValue = selectAll(listServisesValue, value);
    } else {
      listServisesValue[position] = value;
    }
    setState(() {});
  }

  startSearch() {}

  getQuery() {
    String query = '';
    String cities = getAnswers(listCities, listCitiesValue);
    String areas = getAnswers(listAreas, listAreasValue, skip: false);
    String ages = getAnswers(listAges, listAgesValue);
    String organisation = getAnswers(listOrganisation, listOrganisationValue);
    String service = getAnswers(listServises, listServisesValue);

    if (search.text != null && search.text != '') {
      query += search.text;
    }
    query = popQuery(query, cities);
    query = popQuery(query, areas);
    query = popQuery(query, ages);
    query = popQuery(query, organisation);
    query = popQuery(query, service);

    return query;
  }

  getAnswers(List arrayData, List valueArray, {bool skip = true}) {
    List result = [];
    arrayData.asMap().forEach((key, value) {
      // (valueArray[key] && !skip) || (skip && key != 0)
      if (valueArray[key]) {
        result.add(value);
      }
    });
    return result.join(',');
  }

  popQuery(query, answers) {
    if (answers != '') {
      if (query != '') {
        query += ',';
      }
      query += answers;
    }
    return query;
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<GeneralSearchViewModel>.reactive(
      builder: (context, model, child) {
        _startSearching(String string) async {
          String query = getQuery();
          if (query != '') {
            query = query;
            await model.search(query);
          }
        }

        _startSearching2() async {
          await _startSearching('');
        }

        if (!model.isLoading &&
            model.article != null &&
            model.service != null &&
            model.diagnosis != null) {
          model.setLoading();
          WidgetsBinding.instance.addPostFrameCallback(
            (_) => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => SearchScreen(
                  model.article,
                  model.service,
                  model.diagnosis,
                  canPop: true,
                ),
              ),
            ),
          );
        }

        return Scaffold(
          appBar: widget.canPop
              ? AppBar(
                  centerTitle: true,
                  elevation: 0,
                  title: Text('', style: AppThemeStyle.appBarStyle),
                  leading: IconButton(
                    iconSize: 18.0,
                    splashRadius: 20,
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: const Color(0xFF758084),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  backgroundColor: Colors.transparent,
                )
              : null,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: SearchFieldUI(
                      controller: search,
                      text: '',
                      showCursor: true,
                      onFieldSubmitted: _startSearching,
                      keyboardType: TextInputType.text,
                      inputAction: TextInputAction.done,
                      hintText: getTranslated(context, 'search_msg'),
                      suffixIcon: IconButton(
                        splashRadius: 25,
                        icon: Icon(
                          Icons.search,
                          color: const Color(0xFF758084),
                        ),
                        onPressed: _startSearching2,
                      ),
                    ),
                  ),
                  SizedBox(height: SizeConfig.calculateBlockVertical(30)),
                  CustomExpansionTile(
                    tilePadding: const EdgeInsets.all(0),
                    iconColor: const Color(0xFFACB1B4),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          getTranslated(context, 'region'),
                          style: AppThemeStyle.subHeaderBigger,
                        ),
                        // Icon(Icons.keyboard_arrow_down)
                      ],
                    ),
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        controller: _scrollController,
                        itemCount: listCities.length,
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ///Subheaders
                              if (index == 1)
                                Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Text(
                                    'Выбрать город',
                                    style: AppThemeStyle.subHeaderBigger,
                                  ),
                                ),
                              if (index == 4)
                                Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Text(
                                    'Выбрать область',
                                    style: AppThemeStyle.subHeaderBigger,
                                  ),
                                ),
                              CustomCheckboxListTile(
                                  title: Text(
                                    listCities[index],
                                    style: AppThemeStyle.normalText.copyWith(
                                        fontWeight: listCitiesValue[index]
                                            ? FontWeight.bold
                                            : FontWeight.normal),
                                  ),
                                  value: listCitiesValue[index],
                                  onChanged: (val) =>
                                      listCitiesChanged(index, val)),
                            ],
                          );
                        },
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        controller: _scrollController,
                        itemCount: listAreas.length,
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ///Subheaders
                              if (index == 0)
                                Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Text(
                                    'Выбрать область',
                                    style: AppThemeStyle.subHeaderBigger,
                                  ),
                                ),
                              CustomCheckboxListTile(
                                  title: Text(
                                    listAreas[index],
                                    style: AppThemeStyle.normalText.copyWith(
                                        fontWeight: listAreasValue[index]
                                            ? FontWeight.bold
                                            : FontWeight.normal),
                                  ),
                                  value: listAreasValue[index],
                                  onChanged: (val) =>
                                      listAreasChanged(index, val)),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: SizeConfig.calculateBlockVertical(2)),
                  Divider(
                    height: 2,
                    color: Constants.mainTextColor,
                  ),
                  SizedBox(height: SizeConfig.calculateBlockVertical(3)),
                  CustomExpansionTile(
                    tilePadding: const EdgeInsets.all(0),
                    iconColor: const Color(0xFFACB1B4),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          getTranslated(context, 'year_old'),
                          style: AppThemeStyle.subHeaderBigger,
                        ),
                        // Icon(Icons.keyboard_arrow_down)
                      ],
                    ),
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        controller: _scrollController,
                        itemCount: listAges.length,
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemBuilder: (BuildContext context, int index) {
                          return CustomCheckboxListTile(
                              title: Text(
                                listAges[index],
                                style: AppThemeStyle.normalText.copyWith(
                                    fontWeight: listAgesValue[index]
                                        ? FontWeight.bold
                                        : FontWeight.normal),
                              ),
                              value: listAgesValue[index],
                              onChanged: (val) =>
                                  {listAgesChanged(index, val)});
                        },
                      )
                    ],
                  ),
                  SizedBox(height: SizeConfig.calculateBlockVertical(2)),
                  Divider(
                    height: 2,
                    color: Constants.mainTextColor,
                  ),
                  SizedBox(height: SizeConfig.calculateBlockVertical(3)),
                  CustomExpansionTile(
                    tilePadding: const EdgeInsets.all(0),
                    iconColor: const Color(0xFFACB1B4),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          getTranslated(context, 'diagnosis'),
                          style: AppThemeStyle.subHeaderBigger,
                        ),
                        // Icon(Icons.keyboard_arrow_down)
                      ],
                    ),
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        controller: _scrollController,
                        itemCount: listDiagnosis.length,
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemBuilder: (BuildContext context, int index) {
                          return CustomCheckboxListTile(
                              title: Text(
                                listDiagnosis[index],
                                style: AppThemeStyle.normalText.copyWith(
                                    fontWeight: listDiagnosisValue[index]
                                        ? FontWeight.bold
                                        : FontWeight.normal),
                              ),
                              value: listDiagnosisValue[index],
                              onChanged: (val) =>
                                  listDiagnosisChanged(index, val));
                        },
                      )
                    ],
                  ),
                  SizedBox(height: SizeConfig.calculateBlockVertical(2)),
                  Divider(
                    height: 2,
                    color: Constants.mainTextColor,
                  ),
                  SizedBox(height: SizeConfig.calculateBlockVertical(3)),
                  CustomExpansionTile(
                    tilePadding: const EdgeInsets.all(0),
                    iconColor: const Color(0xFFACB1B4),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          getTranslated(context, 'organization'),
                          style: AppThemeStyle.subHeaderBigger,
                        ),
                        // Icon(Icons.keyboard_arrow_down)
                      ],
                    ),
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        controller: _scrollController,
                        itemCount: listOrganisation.length,
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemBuilder: (BuildContext context, int index) {
                          return CustomCheckboxListTile(
                              title: Text(
                                listOrganisation[index],
                                style: AppThemeStyle.normalText.copyWith(
                                    fontWeight: listOrganisationValue[index]
                                        ? FontWeight.bold
                                        : FontWeight.normal),
                              ),
                              value: listOrganisationValue[index],
                              onChanged: (val) =>
                                  {listOrganisationChanged(index, val)});
                        },
                      )
                    ],
                  ),
                  SizedBox(height: SizeConfig.calculateBlockVertical(2)),
                  Divider(
                    height: 2,
                    color: Constants.mainTextColor,
                  ),
                  SizedBox(height: SizeConfig.calculateBlockVertical(3)),
                  CustomExpansionTile(
                    tilePadding: const EdgeInsets.all(0),
                    iconColor: const Color(0xFFACB1B4),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          getTranslated(context, 'service'),
                          style: AppThemeStyle.subHeaderBigger,
                        ),
                        // Icon(Icons.keyboard_arrow_down)
                      ],
                    ),
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        controller: _scrollController,
                        itemCount: listServises.length,
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemBuilder: (BuildContext context, int index) {
                          return CustomCheckboxListTile(
                              title: Text(
                                listServises[index],
                                style: AppThemeStyle.normalText.copyWith(
                                    fontWeight: listServisesValue[index]
                                        ? FontWeight.bold
                                        : FontWeight.normal),
                              ),
                              value: listServisesValue[index],
                              onChanged: (val) =>
                                  {listServisesChanged(index, val)});
                        },
                      )
                    ],
                  ),
                  SizedBox(height: SizeConfig.calculateBlockVertical(2)),
                  Divider(
                    height: 2,
                    color: Constants.mainTextColor,
                  ),
                  SizedBox(height: SizeConfig.calculateBlockVertical(3)),
                ],
              ),
            ),
          ),
        );
      },
      onViewModelReady: (model) {},
      viewModelBuilder: () => GeneralSearchViewModel(),
    );
  }
}
