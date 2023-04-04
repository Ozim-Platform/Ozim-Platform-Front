import 'dart:collection';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:charity_app/localization/user_data.dart';
import 'package:charity_app/model/article/article.dart';
import 'package:charity_app/model/base_response.dart';
import 'package:charity_app/model/category.dart';
import 'package:charity_app/model/child/child.dart';
import 'package:charity_app/model/common_model.dart';
import 'package:charity_app/model/data.dart';
import 'package:charity_app/model/diagnoses.dart';
import 'package:charity_app/model/faq.dart';
import 'package:charity_app/model/favourite.dart';
import 'package:charity_app/model/for_mother.dart';
import 'package:charity_app/model/forum/forum_category.dart';
import 'package:charity_app/model/forum/forum_detail.dart';
import 'package:charity_app/model/forum/forum_sub_category.dart';
import 'package:charity_app/model/inclusion.dart';
import 'package:charity_app/model/links.dart';
import 'package:charity_app/model/partner.dart';
import 'package:charity_app/model/questionnaire.dart';
import 'package:charity_app/model/right.dart';
import 'package:charity_app/model/search.dart';
import 'package:charity_app/model/skill.dart';
import 'package:charity_app/model/skill_provider.dart';
import 'package:charity_app/model/user/authorization.dart';
import 'package:charity_app/model/user/user_type.dart';
import 'package:charity_app/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

import 'exceptions.dart';

class ApiProvider {
  Client client = Client();
  UserData _userData = UserData();
  BuildContext context;

  final baseUrl = 'https://ozimplatform.kz/api';

  final baseHeader = {
    HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
    'authorization':
        '\$2y\$10\$nTX/1eBIlQQ0cu4rjt2ea.axCqSMY65dh./.OX0Vtet3w7dGaYfLW',
  };

  getHeaders() async {
    Map headers = baseHeader;
    headers['language'] = await getLang();
    headers['authorization'] = await getToken();
    return headers;
  }

  static Future<String> getToken() async {
    var token = await UserData().getToken();
    return token;
  }

  static Future<String> getLang() async {
    var lang = await UserData().getLang();
    return lang;
  }

  Future<Map<String, dynamic>> baseBody(
      String type, Map<String, dynamic> params) async {
    Map<String, dynamic> body = new HashMap();
    body['apiType'] = type;
    body['token'] = await _userData.getToken();
    body['params'] = params;
    return body;
  }

  String getQuery(Map<String, dynamic> params) {
    var result = "?";
    params.forEach((key, value) {
      result += '&$key=$value';
    });
    return result;
  }

  String getUrl(String baseUrl, String path, Map<String, dynamic> params) {
    return '$baseUrl$path${getQuery(params)}';
  }

  //user file
  Future<BaseResponses> registration(Map<String, dynamic> data) async {
    var responseJson;
    try {
      final response = await client.post(
          Uri.parse('$baseUrl/user/registration'),
          headers: await getHeaders(),
          body: jsonEncode(data));

      var res = json.decode(response.body.toString());
      print(res);
      responseJson = BaseResponses.fromJson(res);
    } on FetchDataException {
      throw FetchDataException("No Internet connection");
    }
    return responseJson;
  }

  Future<User> getUser() async {
    var responseJson;
    var token = await getToken();
    try {
      var language = await getLang();
      final response = await client.get(
        Uri.parse('$baseUrl/user'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
          'language': language,
          'authorization': token,
        },
      );
      var res = _response(response);
      responseJson = User.fromJson(res);
    } on FetchDataException {
      throw FetchDataException("No Internet connection");
    }
    return responseJson;
  }

  Future<Authorization> authorization(String username) async {
    var responseJson;
    try {
      String url = '$baseUrl/user/authorization?username=$username';
      final response = await client.get(
        Uri.parse(url),
        headers: {
          'language': 'ru',
          'authorization': 'null',
          HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8'
        },
      );
      // print(url);
      // print(response.request.headers);
      // print(response.request.url);
      // print(response.body.toString());
      // print(response.statusCode);
      var res = _response(response);
      responseJson = Authorization.fromJson(res);
    } on FetchDataException {
      throw FetchDataException("No Internet connection");
    }
    return responseJson;
  }

  Future<BaseResponses> getUserLanguage(Map<String, dynamic> data) async {
    var responseJson;

    try {
      final response = await client.post(Uri.parse('$baseUrl/user/language'),
          headers: await getHeaders(), body: jsonEncode(data));
      var res = _response(response);
      responseJson = BaseResponses.fromJson(res);
    } on FetchDataException {
      throw FetchDataException("No Internet connection");
    }
    return responseJson;
  }

  Future<BaseResponses> changeUser(
      Map<String, dynamic> data, String token) async {
    var responseJson;

    try {
      final response = await client.post(Uri.parse('$baseUrl/user'),
          headers: {
            'language': 'ru',
            'authorization': token,
            HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8'
          },
          body: jsonEncode(data));

      // //print(response.request);
      // //print(jsonEncode(data));
      // //print(response.request.headers);
      // //print(response.request.url);
      // //print(response.body);
      var res = _response(response);
      responseJson = BaseResponses.fromJson(res);
    } on FetchDataException {
      throw FetchDataException("No Internet connection");
    }
    return responseJson;
  }

  Future<BaseResponses> changeUserAvatar(File file, String filepath) async {
    var responseJson;

    try {
      var uri = Uri.parse('$baseUrl/user/avatar/');
      var request = new http.MultipartRequest("POST", uri);

      http.MultipartFile multipartFile =
          await http.MultipartFile.fromPath('avatar', filepath);

      request.files.add(multipartFile);
      request.headers.addAll(await getHeaders());

      http.Response response = await http.Response.fromStream(
        await request.send(),
      );

      // //print(response.request.url);
      // //print(response.request.headers.toString());
      // //print(response.statusCode);
      // //print(response.body);

      var res = _response(response);
      responseJson = BaseResponses.fromJson(res);
    } on FetchDataException {
      throw FetchDataException("No Internet connection");
    }
    return responseJson;
  }

  //docs
  Future<BaseResponses> getAgreement() async {
    var responseJson;
    try {
      final response = await client.get(
        Uri.parse('$baseUrl/agreement'),
        headers: await getHeaders(),
      );
      var res = _response(response);
      responseJson = BaseResponses.fromJson(res);
    } on FetchDataException {
      throw FetchDataException("No Internet connection");
    }
    return responseJson;
  }

  Future<BaseResponses> getPolicy() async {
    var responseJson;
    try {
      final response = await client.get(
        Uri.parse('$baseUrl/rule'),
        headers: await getHeaders(),
      );
      var res = _response(response);
      responseJson = BaseResponses.fromJson(res);
    } on FetchDataException {
      throw FetchDataException("No Internet connection");
    }
    return responseJson;
  }

  Future<BaseResponses> postAgreement() async {
    var responseJson;
    try {
      final response = await client.post(Uri.parse('$baseUrl/agreement/'),
          headers: await getHeaders(), body: jsonEncode(null));
      var res = _response(response);
      responseJson = BaseResponses.fromJson(res);
    } on FetchDataException {
      throw FetchDataException("No Internet connection");
    }
    return responseJson;
  }

  Future<BaseResponses> postPolicy() async {
    var responseJson;
    try {
      final response = await client.post(Uri.parse('$baseUrl/rule/'),
          headers: await getHeaders(), body: jsonEncode(null));
      var res = _response(response);
      responseJson = BaseResponses.fromJson(res);
    } on FetchDataException {
      throw FetchDataException("No Internet connection");
    }
    return responseJson;
  }

  //language
  Future<Language> getLanguage() async {
    var responseJson;

    try {
      final response = await client.get(
        Uri.parse('$baseUrl/language'),
        headers: await getHeaders(),
      );
      var res = _response(response);
      responseJson = Language.fromJson(res);
    } on FetchDataException {
      throw FetchDataException("No Internet connection");
    }
    return responseJson;
  }

  //user type
  Future<List<UserType>> getUserType() async {
    var responseJson;
    try {
      final response = await client.get(
          Uri.parse("$baseUrl/user_type?language=ru"),
          headers: await getHeaders());

      // //print(response.request.url);
      // //print(response.body);
      // //print(response.statusCode);

      var res = _response(response) as List;
      responseJson = res.map((element) => UserType.fromJson(element)).toList();
    } on FetchDataException {
      throw FetchDataException("No Internet connection");
    }
    return responseJson;
  }

  Future<SearchData> searchArticle(String search) async {
    var responseJson;
    try {
      String url = '$baseUrl/article/search?search=$search&page=1';
      final response = await client.get(
        Uri.parse(url),
        headers: await getHeaders(),
      );
      var res = _response(response);

      var customMapArticle = {
        'page': res['page'],
        'pages': res['pages'],
        'data': res['articles'],
      };
      var customMapService = {
        'page': res['page'],
        'pages': res['pages'],
        'data': res['service_providers'],
      };

      var customMapDiagnoses = {
        'page': res['page'],
        'pages': res['pages'],
        'data': res['diagnoses'],
      };

      customMapArticle = _symplifyData(customMapArticle, null);
      Article article = Article.fromJson(customMapArticle);
      customMapService = _symplifyData(customMapService, null);
      ServiceProvider service = ServiceProvider.fromJson(customMapService);
      customMapDiagnoses = _symplifyData(customMapDiagnoses, null);
      Diagnosis diagnosis = Diagnosis.fromJson(customMapDiagnoses);

      responseJson = SearchData.fromJson({
        "article": article,
        "service": service,
        "diagnosis": diagnosis,
      });
    } on FetchDataException {
      throw FetchDataException("No Internet connection");
    }
    return responseJson;
  }

  Future<Article> getArticleIndexBookMark(String folder) async {
    var responseJson;

    try {
      final response = await client.get(
        Uri.parse('$baseUrl/article/index_bookmark?folder=$folder&page=1'),
        headers: await getHeaders(),
      );
      // //print(response.request.url);
      // //print(response.request.headers.toString());

      var res = _response(response);
      responseJson = Favourite.fromJson(res);
    } on FetchDataException {
      throw FetchDataException("No Internet connection");
    }
    return responseJson;
  }

  Future<BaseResponses> saveFCM(String token) async {
    var responseJson;
    String mainTokent = await getToken();
    if (mainTokent != null) {
      try {
        String platform = Platform.isIOS ? 'ios' : 'android';
        String url = '$baseUrl/token/$platform/$token';
        final response =
            await client.post(Uri.parse(url), headers: await getHeaders());
        var res = _response(response);
        responseJson = BaseResponses.fromJson(res);
      } catch (e) {
        print(e, level: 1);
      }
    }
    return responseJson;
  }

  Future<BaseResponses> push(String email) async {
    var responseJson;
    try {
      String url = '$baseUrl/chat_push';
      Map<String, dynamic> data = {'email': email.toString()};
      final response = await client.post(Uri.parse(url),
          headers: await getHeaders(), body: jsonEncode(data));
      var res = _response(response);
      responseJson = BaseResponses.fromJson(res);
    } catch (e) {
      print(e, level: 1);
    }
    return responseJson;
  }

  ///получение списка закладок для favorite
  Future<List<Data>> getBookMark() async {
    List<Data> responseJson;
    try {
      String url = '$baseUrl/article/bookmark?page=1';
      final response =
          await client.get(Uri.parse(url), headers: await getHeaders());
      var res = _response(response);
      // print(url);
      // print(response.body);
      res = _symplifyData(res, null);
      responseJson = (Article.fromJson(res)).data;
    } on FetchDataException {
      throw FetchDataException("No Internet connection");
    }

    // List<String> types = [
    //   'right',
    //   'inclusion',
    //   'diagnosis',
    //   'for_parent',
    //   'service_provider',
    //   'skill'
    // ];

    // Map<String, Function> callbacks = {
    //   'right': (element) => Right.fromJson(element),
    //   'inclusion': (element) => Inclusion.fromJson(element),
    //   'diagnosis': (element) => Diagnosis.fromJson(element),
    //   'for_parent': (element) => For_Parent.fromJson(element),
    //   'service_provider': (element) => ServiceProvider.fromJson(element),
    //   'skill': (element) => Skill.fromJson(element)
    // };

    // await Future.forEach(types, (t) async {
    CommonModel data = await getBookMarkRecord(/*t, callbacks[t]*/);
    if (data != null) {
      // print(data);
      List<Data> newArray = data.data;
      responseJson.addAll(newArray);
    }
    // });
    print(responseJson);

    return responseJson;
  }

  ///получение списка закладок для favorite
  Future<CommonModel> getBookMarkRecord(
      /*String type, Function callback*/) async {
    var responseJson;
    try {
      // String url = '$baseUrl/record/bookmark?type=$type';
      String url = '$baseUrl/record/bookmark';
      final response =
          await client.get(Uri.parse(url), headers: await getHeaders());
      var res = _response(response);
      res = _symplifyData(res, null);
      // responseJson = callback(res);
      responseJson = CommonModel.fromJson(res);
      print(responseJson);
    } on FetchDataException {
      throw FetchDataException("No Internet connection");
    }
    return responseJson;
  }

  ///create bookmarks folder
  Future<BaseResponses> bookMarkStore(Map<String, dynamic> data) async {
    // if (data['type'] == 'article') {
    //   var responseJson;
    //   try {
    //     final response = await client.post(
    //         Uri.parse('$baseUrl/article/bookmark/store'),
    //         headers: await getHeaders(),
    //         body: jsonEncode(data));
    //     var res = _response(response);
    //     responseJson = BaseResponses.fromJson(res);
    //   } on FetchDataException {
    //     throw FetchDataException("No Internet connection");
    //   }
    //   return responseJson;
    // } else {
    var responseJson;
    try {
      final response = await client.post(
          Uri.parse('$baseUrl/record/bookmark/store'),
          headers: await getHeaders(),
          body: jsonEncode(data));
      var res = _response(response);
      responseJson = BaseResponses.fromJson(res);
    } on FetchDataException {
      throw FetchDataException("No Internet connection");
    }
    return responseJson;
    // }
  }

  ///get bookmarks folders
  Future<List<Data>> getBookMarkFolders({String type}) async {
    // List responseJson;
    // if (type != null) {
    //   if (type == 'article') {
    //     try {
    //       final response = await client.get(
    //           Uri.parse('$baseUrl/article/bookmark/folder?page=1'),
    //           headers: await getHeaders());
    //       var res = _response(response)['data'] as List;
    //       responseJson = res.map((e) => Data.fromJson(e)).toList();
    //     } on FetchDataException {
    //       throw FetchDataException("No Internet connection");
    //     }
    //   } else {
    //     responseJson = await getBookMarkFoldersRecord(type);
    //   }
    // } else {
    //   List<String> types = [
    //     'right',
    //     'inclusion',
    //     'diagnosis',
    //     'for_parent',
    //     'service_provider',
    //     'skill'
    //   ];

    // final response = await client.get(
    // Uri.parse('$baseUrl/article/bookmark/folder?page=1'),
    // headers: await getHeaders());
    // response.statusCode
    // print(response.body, level: 2);
    // var res = _response(response)['data'] as List;
    // responseJson = res.map((e) => Data.fromJson(e)).toList();

    // await Future.forEach(types, (el) async {
    List<Data> folders = await getBookMarkFoldersRecord(/*el*/);
    return folders;
    // print(folders.length);
    // responseJson.addAll(folders);
    // print(responseJson);
    // });
    // }
    // return responseJson;
  }

  ///добавление статьи в закладки в конретную папку
  Future<BaseResponses> storeBookmark(Map<String, dynamic> data) async {
    BaseResponses responseJson;
    // if (data['type'] == 'article') {
    //   responseJson =
    //       await _sendApiRequestBase('article/bookmark/store_article', data);
    // } else {
    responseJson =
        await _sendApiRequestBase('record/bookmark/to_bookmark', data);
    // }
    return responseJson;
  }

  ///перемещение статьи в другую папку
  Future<BaseResponses> moveBookmark(Map<String, dynamic> data) async {
    BaseResponses responseJson;
    // if (data['type'] == 'article') {
    //   responseJson =
    //       await _sendApiRequestBase('article/bookmark/move_article', data);
    // } else {
    responseJson =
        await _sendApiRequestBase('record/bookmark/move_record', data);
    // }
    return responseJson;
  }

  ///удаление статьи из закладки
  Future<BaseResponses> removeFromBookmarkStore(
      Map<String, dynamic> data) async {
    var responseJson;
    String url;
    // if (data['type'] == 'article') {
    //   url = '$baseUrl/article/bookmark/article';
    // } else {
    url = '$baseUrl/record/bookmark/delete';
    // }

    try {
      final response = await client.post(Uri.parse(url),
          headers: await getHeaders(), body: jsonEncode(data));
      var res = _response(response);
      responseJson = BaseResponses.fromJson(res);
    } on FetchDataException {
      throw FetchDataException("No Internet connection");
    }
    return responseJson;
  }

  ///переимаенование папки
  Future<BaseResponses> bookMarkUpdate(
      Map<String, dynamic> data, String type) async {
    BaseResponses responseJson;
    // if (type == 'article') {
    //   responseJson = await _sendApiRequestBase('article/bookmark/update', data);
    // } else {
    data['type'] = type;
    responseJson = await _sendApiRequestBase('record/bookmark/update', data);
    // }
    return responseJson;
  }

  /// delete folder bookmark
  Future<BaseResponses> bookMarkDelete(int id, String type) async {
    var responseJson;
    // if (type == 'article') {
    //   try {
    //     final response = await client.delete(
    //         Uri.parse('$baseUrl/article/bookmark/$id'),
    //         headers: await getHeaders());
    //     var res = _response(response);
    //     responseJson = BaseResponses.fromJson(res);
    //   } on FetchDataException {
    //     throw FetchDataException("No Internet connection");
    //   }
    // } else {
    try {
      final response = await client.delete(
          // Uri.parse('$baseUrl/record/bookmark/$id/?type=$type'),
          Uri.parse('$baseUrl/record/bookmark/$id'),
          headers: await getHeaders());
      var res = _response(response);
      responseJson = BaseResponses.fromJson(res);
    } on FetchDataException {
      throw FetchDataException("No Internet connection");
    }
    // }
    return responseJson;
  }

  ///get bookmarks folders
  Future<List<Data>> getBookMarkFoldersRecord(/*String type*/) async {
    var responseJson;
    try {
      final response = await client.get(
          Uri.parse('$baseUrl/record/bookmark/folder?page=1'),
          headers: await getHeaders());
      var res = _response(response)['data'] as List;
      responseJson = res.map((e) => Data.fromJson(e)).toList();
      // print(responseJson);
    } on FetchDataException {
      throw FetchDataException("No Internet connection");
    }
    return responseJson;
  }

  Future<BaseResponses> articleRemoveComment(Map<String, dynamic> data) async {
    var responseJson;
    try {
      final response = await client.get(
        Uri.parse('$baseUrl/article/comment/1'),
        headers: await getHeaders(),
      );
      var res = _response(response);
      responseJson = BaseResponses.fromJson(res);
    } on FetchDataException {
      throw FetchDataException("No Internet connection");
    }
    return responseJson;
  }

  ///forum category
  Future<CommonModel> getBanner() async {
    var responseJson;
    String lang = await getLang();
    try {
      final response = await client.get(
        Uri.parse('$baseUrl/banner?language=$lang'),
        headers: await getHeaders(),
      );

      var res = _response(response) as List;
      List sortedData = [];
      res.forEach((element) {
        var el = element['record'];
        el['preview'] = element['image'];
        el['type'] = element['type'];
        sortedData.add(el);
      });

      Map<String, dynamic> result = {"data": sortedData, "page": 1, "pages": 1};
      result = _symplifyData(result, null);
      responseJson = CommonModel.fromJson(result);
    } on FetchDataException {
      throw FetchDataException("No Internet connection");
    }
    return responseJson;
  }

  ///faq
  Future<Faq> getFaq() async {
    var responseJson;
    var lang = await ApiProvider.getLang();
    try {
      final response = await client.get(
        Uri.parse('$baseUrl/faq?language=$lang'),
        headers: await getHeaders(),
      );
      var res = _response(response);
      responseJson = Faq.fromJson(res);
    } on FetchDataException {
      throw FetchDataException("No Internet connection");
    }
    return responseJson;
  }

  ///forum category
  Future<List<ForumCategory>> getForumCategory() async {
    var responseJson;
    String lang = await getLang();
    try {
      final response = await client.get(
        Uri.parse('$baseUrl/forum_category?language=$lang'),
        headers: await getHeaders(),
      );

      var res = _response(response) as List;
      // print(res);
      responseJson = res.map((e) => ForumCategory.fromJson(e)).toList();
    } on FetchDataException {
      throw FetchDataException("No Internet connection");
    }
    return responseJson;
  }

  ///forum subcategory
  Future<List<ForumSubCategory>> getForumSubCategory() async {
    var responseJson;
    String lang = await getLang();
    try {
      String url = '$baseUrl/forum_subcategory?language=$lang';
      final response = await client.get(
        Uri.parse(url),
        headers: await getHeaders(),
      );
      var res = _response(response) as List;
      responseJson = res.map((e) => ForumSubCategory.fromJson(e)).toList();
    } on FetchDataException {
      throw FetchDataException("No Internet connection");
    }
    return responseJson;
  }

  Future<ForumDetail> getForumDetail(String subcategory, {int page = 1}) async {
    var responseJson;
    try {
      String lang = await _userData.getLang();
      final response = await client.get(
        Uri.parse(
            '$baseUrl/forum?language=$lang&subcategory=$subcategory&page=' +
                page.toString()),
        headers: await getHeaders(),
      );
      //print(response.headers);
      //print(response.request.url);
      var res = _response(response);
      // print(res);
      responseJson = ForumDetail.fromJson(res);
    } on FetchDataException {
      throw FetchDataException("No Internet connection");
    }
    return responseJson;
  }

  Future<BaseResponses> postForum(Map<String, dynamic> data) async {
    var responseJson;
    try {
      final response = await client.post(Uri.parse('$baseUrl/forum'),
          headers: await getHeaders(), body: jsonEncode(data));
      var res = _response(response);
      // print(res);
      // print(data);
      responseJson = BaseResponses.fromJson(res);
    } on FetchDataException {
      throw FetchDataException("No Internet connection");
    }
    return responseJson;
  }

  ///category
  Future<List<Category>> getCategory() async {
    // var token = await _userData.getToken();
    // print(token);
    // this.getUser(token);

    var responseJson;
    var lang = await _userData.getLang();
    // print('cats ' + lang);
    try {
      final response = await client.get(
        Uri.parse('$baseUrl/category?language=$lang'),
        headers: await getHeaders(),
      );
      var res = _response(response) as List;
      responseJson = res.map((e) => Category.fromJson(e)).toList();
    } on FetchDataException {
      throw FetchDataException("No Internet connection");
    }
    return responseJson;
  }

  /// diagnoses
  Future<Diagnosis> getDiagnoses(List<Category> category) async {
    var responseJson;
    responseJson = await _sendApiRequestType(
        category, 'diagnoses', (element) => Diagnosis.fromJson(element));
    return responseJson;
  }

  /// skill
  Future<Skill> skill(List<Category> category) async {
    var responseJson;
    responseJson = await _sendApiRequestType(
        category, 'skill', (element) => Skill.fromJson(element));
    return responseJson;
  }

  ///resource
  Future<Links> getLinks(List<Category> category) async {
    var responseJson;
    responseJson = await _sendApiRequestType(
        category, 'links', (element) => Links.fromJson(element));
    return responseJson;
  }

  /// article
  Future<Article> getArticle({List<Category> category, int id}) async {
    var responseJson;
    if (category != null) {
      responseJson = await _sendApiRequestType(
          category, 'article', (element) => Article.fromJson(element));
    } else {
      if (id != null) {
        var lang = await ApiProvider.getLang();
        String method = 'article';
        String apiUrl = '$baseUrl/$method?language=$lang&page=1&id=$id';
        try {
          final response = await client.get(
            Uri.parse(apiUrl),
            headers: await getHeaders(),
          );
          var res = _response(response);
          if (res['data'] != null) {
            var data = res['data'] as List;
            data.forEach((element) {
              element['category'] = element['category']['sysName'];
            });
            res['data'] = data;
          }
          responseJson = Article.fromJson(res);
        } on FetchDataException {
          throw FetchDataException("No Internet connection");
        }
      }
    }
    return responseJson;
  }

  /// service_provider
  Future<ServiceProvider> serviceProvider(List<Category> category) async {
    var responseJson;
    responseJson = await _sendApiRequestType(category, 'service_provider',
        (element) => ServiceProvider.fromJson(element));
    return responseJson;
  }

  /// rights
  Future<Right> rights(List<Category> category) async {
    var responseJson;
    responseJson = await _sendApiRequestType(
        category, 'rights', (element) => Right.fromJson(element));
    return responseJson;
  }

  /// inclusion
  Future<Inclusion> inclusion(List<Category> category) async {
    var responseJson;
    responseJson = await _sendApiRequestType(
        category, 'inclusion', (element) => Inclusion.fromJson(element));
    return responseJson;
  }

  ///for_mother
  Future<For_Parent> forMother(List<Category> category) async {
    var responseJson;
    responseJson = await _sendApiRequestType(
        category, 'for_parent', (element) => For_Parent.fromJson(element));
    return responseJson;
  }

  ///article comment
  Future<List<DataComment>> articleComment(int articleid, int page) async {
    var responseJson;
    var lang = await ApiProvider.getLang();
    String method = 'article/comments?article_id=$articleid';
    String apiUrl = '$baseUrl/$method?language=$lang&page=$page';
    try {
      final response = await client.get(
        Uri.parse(apiUrl),
        headers: await getHeaders(),
      );

      var res = _response(response)['data'] as List;
      responseJson = res.map((e) => DataComment.fromJson(e)).toList();
    } on FetchDataException {
      throw FetchDataException("No Internet connection");
    }
    return responseJson;
  }

  Future<List<Partner>> fetchAllPartners() async {
    List<Partner> partnerData = [];
    var lang = await ApiProvider.getLang();
    int page = 1;
    String apiUrl = '$baseUrl/partner?page=$page';
    try {
      log("fetching all partners");
      final response = await client.get(
        Uri.parse(apiUrl),
        headers: await getHeaders(),
      );

      var res = _response(response);
      partnerData = PartnerData.fromJson(res).data;
    } on FetchDataException {
      throw FetchDataException("Failed to fetch partners");
    }
    return partnerData;
  }

  ///forum comment
  Future<List<DataComment>> forumComment(int forumid, int page) async {
    var responseJson;
    var lang = await ApiProvider.getLang();
    String method = 'forum/comments?id=$forumid';
    String apiUrl = '$baseUrl/$method&language=$lang&page=$page';
    try {
      final response = await client.get(
        Uri.parse(apiUrl),
        headers: await getHeaders(),
      );

      var res = _response(response)['data'] as List;
      responseJson = res.map((e) => DataComment.fromJson(e)).toList();
    } on FetchDataException {
      throw FetchDataException("No Internet connection");
    }
    return responseJson;
  }

  ///other comment
  Future<List<DataComment>> recordComment(
      int recordid, String type, int page) async {
    var responseJson;
    var lang = await ApiProvider.getLang();
    String method = 'record/comments?record_id=$recordid&type=$type';
    String apiUrl = '$baseUrl/$method&language=$lang&page=$page';

    try {
      final response =
          await client.get(Uri.parse(apiUrl), headers: await getHeaders());
      var res = _response(response) as List;
      responseJson = res.map((e) => DataComment.fromJson(e)).toList();
    } on FetchDataException {
      throw FetchDataException("No Internet connection");
    }
    return responseJson;
  }

  ///article comment send
  Future<BaseResponses> articleCommentStore(Map<String, dynamic> data) async {
    //todo: here
    BaseResponses responseJson =
        await _sendApiRequestBase('article/comment/store', data);
    return responseJson;
  }

  ///other comment send
  Future<BaseResponses> otherCommentStore(Map<String, dynamic> data) async {
    //todo: here
    BaseResponses responseJson =
        await _sendApiRequestBase('record/comment', data);
    return responseJson;
  }

  ///forum comment send
  Future<BaseResponses> forumCommentStore(Map<String, dynamic> data) async {
    //todo: here
    BaseResponses responseJson =
        await _sendApiRequestBase('forum/comment', data);
    return responseJson;
  }

  ///article view
  Future<BaseResponses> articleView(Map<String, dynamic> data) async {
    // print('view : ${data['article_id']}');
    BaseResponses responseJson =
        await _sendApiRequestBase('article/view', data);
    return responseJson;
  }

  ///article like
  Future<BaseResponses> articleLike(Map<String, dynamic> data) async {
    BaseResponses responseJson =
        await _sendApiRequestBase('article/like', data);
    return responseJson;
  }

  ///article unlike
  Future<BaseResponses> articleDislike(Map<String, dynamic> data) async {
    BaseResponses responseJson =
        await _sendApiRequestBase('article/unlike', data);
    return responseJson;
  }

  ///other view
  Future<BaseResponses> otherView(Map<String, dynamic> data) async {
    BaseResponses responseJson = await _sendApiRequestBase('record/view', data);
    return responseJson;
  }

  ///other like
  Future<BaseResponses> otherLike(Map<String, dynamic> data) async {
    BaseResponses responseJson = await _sendApiRequestBase('record/like', data);
    return responseJson;
  }

  ///other unlike
  Future<BaseResponses> otherDislike(Map<String, dynamic> data) async {
    BaseResponses responseJson =
        await _sendApiRequestBase('record/unlike', data);
    return responseJson;
  }

  Future<BaseResponses> setRating(Map<String, dynamic> data) async {
    BaseResponses responseJson =
        await _sendApiRequestBase('record/rating', data);
    return responseJson;
  }

  ///questionnaire
  // Future<QuestionnaireData> getQuestionnaire(List<Category> category) async {
  //   var responseJson;
  //   responseJson = await _sendApiRequestType(category, 'questionnaire',
  //       (element) => QuestionnaireData.fromJson(element,));
  //   return responseJson;
  // }

  // Future<BaseResponses> sendQuestionnaire(Map<String, dynamic> data) async {
  //   BaseResponses responseJson =
  //       await _sendApiRequestBase('questionnaire', data);
  //   return responseJson;
  // }

  ///my comment
  Future<List<DataComment>> myComment() async {
    var responseJson;
    var lang = await ApiProvider.getLang();
    String method = 'article/comment';
    String apiUrl = '$baseUrl/$method?language=$lang&page=1';
    try {
      final response = await client.get(
        Uri.parse(apiUrl),
        headers: await getHeaders(),
      );
      var res = _response(response)['data'] as List;

      res.forEach((element) {
        element['instance'] = 'article';
        element['instance_id'] =
            element['article'] != null ? element['article']['id'] : null;
      });

      responseJson = res.map((e) => DataComment.fromJson(e)).toList();
    } on FetchDataException {
      throw FetchDataException("No Internet connection");
    }
    return responseJson;
  }

  ///my forum comment
  Future<List<DataComment>> myForumComment() async {
    var responseJson;
    var lang = await ApiProvider.getLang();
    String method = 'forum/comment';
    String apiUrl = '$baseUrl/$method?language=$lang&page=1';
    try {
      final response = await client.get(
        Uri.parse(apiUrl),
        headers: await getHeaders(),
      );

      var res = _response(response)['data'] as List;
      res.forEach((element) {
        element['instance'] = 'forum';
        if (element['forum'] != null) {
          if (element['forum']['subcategory'] != null) {
            element['instance_id'] =
                element['forum']['subcategory']['sys_name'];
            element['instance_rus'] = element['forum']['subcategory']['name'];
          }
        }
      });

      responseJson = res.map((e) => DataComment.fromJson(e)).toList();
    } on FetchDataException {
      throw FetchDataException("No Internet connection");
    }
    return responseJson;
  }

  ///base helper
  Future<BaseResponses> _sendApiRequestBase(String method, data) async {
    BaseResponses responseJson;
    var lang = await _userData.getLang();
    try {
      String apiUrl = '$baseUrl/$method';
      data['language'] = lang;
      // print(apiUrl);
      // print(data);
      final response = await client.post(Uri.parse(apiUrl),
          headers: await getHeaders(), body: jsonEncode(data));
      // print(response.request.url);
      // print(response.body);
      var res = _response(response);
      // print(res);
      if (res is List) {
        if (res.isEmpty) {
          res = {'success': 'Успешно'};
        }
      }
      if (res == null) {
        res = {'error': 'Ошибка'};
      }
      // print(res);

      responseJson = BaseResponses.fromJson(res);
    } on FetchDataException {
      // print('error', level: 1);
      throw FetchDataException("No Internet connection");
    }
    return responseJson;
  }

  ///type helper
  Future _sendApiRequestType(
      List<Category> category, String method, callback) async {
    var responseJson;
    var lang = await _userData.getLang();
    try {
      String apiUrl = '$baseUrl/$method?language=$lang&page=1';
      Map<String, dynamic> result = {"page": null, "pages": null, "data": []};

      if (category.isEmpty) {
        final response = await client.get(
          Uri.parse(apiUrl),
          headers: await getHeaders(),
        );
        var res = _response(response);
        // print(res);
        res = _symplifyData(res, null);
        result = res;
      } else {
        await Future.forEach(category, (cat) async {
          final response = await client.get(
            Uri.parse(apiUrl + getCatUrl(cat)),
            headers: await getHeaders(),
          );
          var res = _response(response);
          res = _symplifyData(res, cat.sysName);

          if (result['page'] == null) {
            result['page'] = res['page'];
          }
          if (result['pages'] == null) {
            result['pages'] = res['pages'];
          }
          result['data'].addAll(res['data']);
        });
      }
      // print(result);
      var t = callback(result);
      // print(t);
      responseJson = t;
    } on FetchDataException {
      print('Error', level: 1);
      throw FetchDataException("No Internet connection");
    }
    return responseJson;
  }

  void initContext(BuildContext context) {
    this.context = context;
  }

  dynamic _response(Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = json.decode(response.body.toString());
        //print(responseJson);
        return responseJson;
      case 400:
        if (context != null) {
          Navigator.of(context).pushReplacementNamed('/NotFoundPage');
          throw BadRequestException(response.body.toString());
        }
        break;
      case 401:
        //print("401 error");
        if (context != null) {
          Navigator.of(context).pushReplacementNamed('/NotFoundPage');
          throw UnauthorisedException(response.body.toString());
        }
        break;
      case 403:
        if (context != null) {
          Navigator.of(context).pushReplacementNamed('/NotFoundPage');
          throw UnauthorisedException(response.body.toString());
        }
        break;
      case 500:
      default:
        if (context != null) {
          Navigator.of(context).pushReplacementNamed('/NotFoundPage');
          throw FetchDataException(
              'Error occurred while Communication with Server with StatusCode : ${response.statusCode}');
        }
        break;
    }
    if (response.body != null) {
      var responseJson = json.decode(response.body.toString());
      return responseJson;
    }
  }

  _symplifyData(res, customcategory) {
    if (res['data'] != null) {
      var data = res['data'] as List;
      data.forEach((element) {
        if (element['category'] != null) {
          element['type'] = element['category']['type']['sys_name'];
        }

        element['category'] = customcategory != null
            ? customcategory
            : (element['category'] != null
                ? element['category']['sys_name']
                : null);

        if (element['bookmark_folder'] != null) {
          if (element['bookmark_folder']['folder'] != null) {
            if (element['bookmark_folder']['folder']['name'] != null)
              element['bookmark_folder'] =
                  element['bookmark_folder']['folder']['name'];
          } else if (element['bookmark_folder']['name'] != null) {
            element['bookmark_folder'] = element['bookmark_folder']['name'];
          }
        }

        if (element['type'] != null) {
          if (element['type'] is String) {
          } else {
            element['type'] = element['type']['sys_name'] != null
                ? element['type']['sys_name']
                : null;
          }
        }
      });
      res['data'] = data;
    }

    return res;
  }

  ///get article by id
  Future<Data> getArticleById(int id, String type) async {
    // print('view : ${data['article_id']}');
    // var lang = await _userData.getLang();
    final response = await client.get(
        Uri.parse('$baseUrl/article/search-by-category/$type/$id'),
        headers: await getHeaders());
    var res = _response(response);
    if (res is Map && res.isNotEmpty) {
      final result = res.values.first;
      if (result is List) {
        return Data.fromJson(result.first);
      } else {
        return null;
      }
    }
    return null;
  }

  // get children
  Future<List<Child>> getChildren() async {
    List<Child> returnList = [];
    try {
      final response = await client.get(Uri.parse('$baseUrl/user/children'),
          headers: await getHeaders());
      var res = _response(response);

      if (res is Map && res.isNotEmpty) {
        final result = res.values.first;
        if (result is List) {
          result.forEach((element) {
            returnList.add(Child.fromJson(element));
          });
        }
      }
    } catch (e) {
      throw e;
    }

    return returnList;
  }

  // create child
  Future<bool> createChild(String name, String birthDate, int gender) async {
    Map<dynamic, dynamic> requestBody = {
      "name": name,
      "birth_date": birthDate,
      "gender": gender,
    };

    try {
      final response = await client.post(
        Uri.parse(
          '$baseUrl/user/children',
        ),
        headers: await getHeaders(),
        body: jsonEncode(
          requestBody,
        ),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw e;
    }
  }

  // receive points
  Future<void> receivePoints() async {
    try {
      var response = await client.post(
        Uri.parse('$baseUrl/user/get_points'),
        headers: await getHeaders(),
      );

      log("receivePointsStatusCode is: " + response.statusCode.toString());
    } catch (e) {
      throw e;
    }
  }

  // exchange points
  Future<bool> exchangePoints(int partnerId) async {
    try {
      Map<dynamic, dynamic> _requestBody = {
        "partner_id": partnerId,
      };

      var response = await client.post(
        Uri.parse('$baseUrl/partner'),
        headers: await getHeaders(),
        body: jsonEncode(_requestBody),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw e;
    }
  }

  Future<List> getSubscriptionIds() async {
    List<String> returnList = [];
    try {
      // check whether user is authorised
      final response = await client.get(
        Uri.parse('$baseUrl/user/subscription'),
        headers: await getHeaders(),
      );
      var res = _response(response);

      if (res is Map && res.isNotEmpty) {
        final result = res.values.first;
        if (result is List) {
          result.forEach((element) {
            returnList.add(element);
          });
        }
      }
    } catch (e) {
      throw e;
    }
    return returnList;
  }

  Future<Response> sendQuestionaire(Map<String, dynamic> data) async {
    try {
      var _body = json.encode(data);
      final response = await client.post(
        Uri.parse('$baseUrl/questionnaire'),
        headers: await getHeaders(),
        body: _body,
      );
      return response;
    } catch (e) {
      throw e;
    }
  }

  Future<Response> sendQuestionaireResultsToEmail(
    int answerId,
    String email,
  ) async {
    Map<String, dynamic> data = {
      'answer_id': answerId,
      'email': email,
    };
    try {
      final response = await client.post(
        Uri.parse('$baseUrl/questionnaire/send'),
        headers: await getHeaders(),
        body: json.encode(data),
      );

      return response;
    } catch (e) {
      throw e;
    }
  }
}
