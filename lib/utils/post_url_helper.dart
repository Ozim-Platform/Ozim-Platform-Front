import 'package:charity_app/model/data.dart';
import 'package:charity_app/persistance/api_provider.dart';
import 'package:charity_app/view/screens/common/bottom_bar_detail.dart';
import 'package:flutter/material.dart';

class PostUrlHelper {
  static String generateUrl(String type, int id) {
    return "https://ozimplatform.kz/ul/post?type=$type&id=$id";
  }

  static void handleUrl(Uri uri, BuildContext context) async {
    final List<String> pathSegments = uri.pathSegments;
    if (pathSegments.length < 2 || pathSegments[1] != 'post') {
      return;
    }
    final api = ApiProvider();
    final Map<String, String> queryParameters = uri.queryParameters;
    int id = int.tryParse(queryParameters['id']);
    String type = queryParameters['type'];
    if (id != null && type != null) {
      String typeForResponse = type;
      switch (type) {
        case 'diagnosis':
          typeForResponse = 'diagnose';
          break;
        case 'right':
          typeForResponse = 'rights';
          break;
      }
      Data data = await api.getArticleById(id, typeForResponse);

      if (data != null) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => BottomBarDetail(
              data: data,
              type: data.type,
              needTabBars: false,
            ),
          ),
        );
      }
    }
  }
}
