import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:charity_app/localization/language_constants.dart';
import 'package:charity_app/localization/user_data.dart';
import 'package:charity_app/model/data.dart';
import 'package:charity_app/model/user/user.dart';
import 'package:charity_app/persistance/api_provider.dart';
import 'package:charity_app/utils/firebase.dart';
import 'package:charity_app/utils/toast_utils.dart';
import 'package:charity_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class CommentViewModel extends BaseViewModel {
  List<DataComment> get comment => data.comments;
  int get instanceid => data.id;
  final instaceModel;
  String get type => data.type;
  final Data data;
  bool sendingMessage = false;

  ScrollController mainScrollControlller = ScrollController();

  CommentViewModel(this.instaceModel, this.data);

  UserData _userData = new UserData();
  ApiProvider _apiProvider = new ApiProvider();
  final Map<int, GlobalKey> commentsAndReplyKeys = {};
  final Map<int, bool> showRepliesMap = {};

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  int scrollToComment;

  // int _articleid;
  int _commentid;

  String _username = '';

  String get username => _username;

  String _useravatar;

  String get useravatar => _useravatar;

  bool _writingComment = false;

  bool get writingComment => _writingComment;

  String _hint = 'your_comment';

  String get hint => _hint;

  Function _callbackSend;

  bool loadingNextPage = false;

  int _currentPage = 1;
  final int _pageSize = 10;
  bool haveNextPage = true;

  Future<void> startConversation(
      {String message, UserComment receiver, BuildContext context}) async {
    FirebaseHelper db = FirebaseHelper();
    sendingMessage = true;
    notifyListeners();
    DataUser sender = await _userData.getAllData();
    await db.sendMessage(sender, receiver, message);
    sendingMessage = false;
    setSendCallback(null);
    setWritting(hint: 'your_comment');
    notifyListeners();
    ToastUtils.toastInfoGeneral(
        getTranslated(context, 'message_is_sended'), context);
  }

  setSendCallback(callback) {
    _callbackSend = callback;
  }

  setWritting({String hint}) {
    _writingComment = !_writingComment;
    if (hint != null) {
      _hint = hint;
    }
    notifyListeners();
  }

  write(String message) {
    if (_callbackSend == null) {
      setWritting();
      writeComment(message);
    } else {
      _callbackSend(message);
    }
  }

  void srollTo(int id) async {
    Future.delayed(Duration(milliseconds: 800)).then((value) {
      try {
        final keyContext = commentsAndReplyKeys[id].currentContext;
        Scrollable.ensureVisible(keyContext);
      } catch (e) {
        mainScrollControlller.animateTo(
          mainScrollControlller.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.fastOutSlowIn,
        );
      }
    });
  }

  prepareSending({@required int commentid}) {
    _commentid = commentid;
    // print(commentid, level: 2);
  }

  Future<void> getComment() async {
    _isLoading = true;
    // _comment = comments;
    _username = await _userData.getUsername();
    _useravatar = await _userData.getAvatar();
    if (type == 'article') {
      _apiProvider.articleComment(instanceid, _currentPage).then((value) {
        _attachComments(value);
      }).catchError((error, s) {
        print("Error: $error", level: 1);
      }).whenComplete(() => {_isLoading = false, notifyListeners()});
    } else if (type == 'forum') {
      // print('here');
      _apiProvider.forumComment(instanceid, _currentPage).then((value) {
        _attachComments(value);
      }).catchError((error, s) {
        print("Error: $error", level: 1);
      }).whenComplete(() => {_isLoading = false, notifyListeners()});
    } else {
      _apiProvider.recordComment(instanceid, type, _currentPage).then((value) {
        _attachComments(value);
      }).catchError((error, s) {
        print("Error: $error", level: 1);
      }).whenComplete(() => {_isLoading = false, notifyListeners()});
    }
  }

  void _attachComments(List<DataComment> comments) {
    loadingNextPage = false;
    if (_currentPage == 1) {
      comment.clear();
    }
    comment.addAll(comments);
    if (scrollToComment != null) {
      srollTo(scrollToComment);
    }
    haveNextPage = comments.length >= _pageSize;
  }

  Future<void> getCommentInfo() async {
    // _apiProvider
    //     .articleComment()
    //     .then((value) => {
    //           // _comment = value,
    //         })
    //     .catchError((error) {
    //   //print("Error: $error");
    // }).whenComplete(() => {notifyListeners()});
  }

  Future<void> loadNextPage() {
    if (loadingNextPage) {
      return null;
    }
    loadingNextPage = true;
    _currentPage++;
    return getComment();
  }

  void attachCreatedComment(Map<String, dynamic> commentJson) async {
    final DataComment comment = DataComment.fromJson(commentJson);
    DataUser ownProfile = await UserData().getAllData();
    comment.user = UserComment(
        id: ownProfile.id,
        phone: ownProfile.phone,
        name: ownProfile.name,
        avatar: ownProfile.avatar);
    data.comments.insert(0, comment);
    scrollToComment = comment.id;
    notifyListeners();
  }

  void attachCreatedReply(Map<String, dynamic> replyJson, int commentId) async {
    final DataComment reply = DataComment.fromJson(replyJson);
    DataUser ownProfile = await UserData().getAllData();
    reply.user = UserComment(
        id: ownProfile.id,
        phone: ownProfile.phone,
        name: ownProfile.name,
        avatar: ownProfile.avatar);

    final DataComment comment = findReplyById(data.comments, commentId);
    comment.replies.insert(0, reply);
    scrollToComment = reply.id;
    notifyListeners();
  }

  Future<void> writeComment(String comment) async {
    Map<String, dynamic> data = new Map<String, dynamic>();
    if (_commentid != null) {
      data['comment_id'] = _commentid;
    }
    data['text'] = comment;

    if (type == 'article') {
      data['article_id'] = instanceid;
      _isLoading = true;
      _apiProvider.articleCommentStore(data).then((value) async {
        if (value.error == null) {
          if (value.data != null) {
            if (_commentid != null) {
              attachCreatedReply(value.data, _commentid);
            } else {
              attachCreatedComment(value.data);
            }
          }
        }
      }).catchError((error) {
        print("Error: $error", level: 1);
      }).whenComplete(() => {_isLoading = false, notifyListeners()});
    } else if (type == 'forum') {
      data['forum_id'] = instanceid;
      _isLoading = true;
      _apiProvider.forumCommentStore(data).then((value) async {
        // print(value.error);
        if (value.error == null) {
          if (value.data != null) {
            if (_commentid != null) {
              attachCreatedReply(value.data, _commentid);
            } else {
              attachCreatedComment(value.data);
            }
          }
        }
      }).catchError((error) {
        print("Error: $error", level: 1);
      }).whenComplete(() => {_isLoading = false, notifyListeners()});
    } else {
      data['record_id'] = instanceid;
      data['type'] = type;
      _isLoading = true;
      _apiProvider.otherCommentStore(data).then((value) async {
        if (value.error == null) {
          if (value.data != null) {
            if (_commentid != null) {
              attachCreatedReply(value.data, _commentid);
            } else {
              attachCreatedComment(value.data);
            }
          }
        }
      }).catchError((error) {
        print("Error: $error", level: 1);
      }).whenComplete(() => {_isLoading = false, notifyListeners()});
    }
  }

  Future<void> removeComment(String id) async {
    // _isLoading = true;
    // _userData.getLang().then((value) => {
    //       _apiProvider
    //           .articleComment(value)
    //           .then((value) => {
    //                 _comment = value,
    //               })
    //           .catchError((error) {
    //         //print("Error: $error");
    //       }).whenComplete(() => {_isLoading = false, notifyListeners()}),
    //     });
  }

  DataComment findReplyById(List<DataComment> comments, int targetId) {
    for (var comment in comments) {
      if (comment.id == targetId) {
        return comment;
      }

      var result = findReplyById(comment.replies, targetId);
      if (result != null) {
        return result;
      }
    }

    return null;
  }
}
