import 'package:charity_app/model/forum/forum_detail.dart';
import 'package:charity_app/model/forum/forum_sub_category.dart';
import 'package:charity_app/persistance/api_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'forum_detail.dart';

class ForumDetailViewModel extends BaseViewModel {
  ApiProvider _apiProvider = new ApiProvider();
  ForumSubCategory forumSubCategory;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  ForumDetail _forumDetail;
  ForumDetail get forumDetail => _forumDetail;

  Future<void> getForumCategory(String subcategory) async {
    _isLoading = true;
    _apiProvider
        .getForumDetail(subcategory)
        .then((value) => {
              _forumDetail = value,
            })
        .catchError((error) {
      print("Error: $error");
    }).whenComplete(() => {_isLoading = false, notifyListeners()});
  }

  Future<void> showModalForNewForum(context, subcategory) async {
    final result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0),
            ),
            contentPadding: const EdgeInsets.all(25),
            content: AddPopUp(
              subcategory: subcategory,
            ));
      },
    );
    if (result == true) {
      if (forumSubCategory != null) {
        forumSubCategory.record_count++;
      }
      getForumCategory(subcategory);
    }
  }

  Future<void> getMore(String subcategory, int page) async {
    _isLoading = true;
    _apiProvider
        .getForumDetail(subcategory, page: page)
        .then((value) => {
              _forumDetail.data.addAll(value.data),
              _forumDetail.page = value.page,
            })
        .catchError((error) {
      print("Error: $error");
    }).whenComplete(() => {_isLoading = false, notifyListeners()});
  }
}
