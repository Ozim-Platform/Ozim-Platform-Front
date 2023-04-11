import 'dart:developer';

import 'package:charity_app/data/db/readed_notifications.dart';
import 'package:charity_app/localization/language_constants.dart';
import 'package:charity_app/model/data.dart';
import 'package:charity_app/persistance/api_provider.dart';
import 'package:charity_app/utils/constants.dart';
import 'package:charity_app/utils/navigation.dart';
import 'package:charity_app/utils/utils.dart';
import 'package:charity_app/view/components/custom/custom_badge.dart';
import 'package:charity_app/view/components/notice_card.dart';
import 'package:charity_app/view/components/search_field_ui.dart';
import 'package:charity_app/view/components/user_image.dart';
import 'package:charity_app/view/screens/common/bottom_bar_detail.dart';
import 'package:charity_app/view/screens/home/forum/forum_detail.dart';
import 'package:charity_app/view/screens/home/profile/profile_screen.dart';
import 'package:charity_app/view/screens/other/notification/notification_view_model.dart';
import 'package:charity_app/view/screens/other/notification/rooms.dart';
import 'package:charity_app/view/theme/app_color.dart';
import 'package:charity_app/view/theme/themes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stacked/stacked.dart';

GlobalKey _noticeScafold = GlobalKey<State>();

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreen createState() => _NotificationScreen();

  static _NotificationScreen of(BuildContext context) =>
      context.findAncestorStateOfType();
}

class _NotificationScreen extends State<NotificationScreen> {
  var _currentIndex = 0;
  bool _hideBottomBar = false;
  TextEditingController search = new TextEditingController();
  ApiProvider _apiProvider = ApiProvider();
  List<DataComment> _comments = [];
  List<DataComment> _forums = [];
  List<int> readedComments;
  List<int> readedForum;
  AppBar appBar;
  Stream<DocumentSnapshot<Map<String, dynamic>>> _usersStream;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User _user;

  int _countPrivate = 0;
  int _countComment = 0;
  int _countForum = 0;
  bool _showSearchMessages = false;
  final _scrollController = ScrollController();

  @override
  initState() {
    _user = _auth.currentUser;
    _usersStream = FirebaseFirestore.instance
        .collection('chat')
        .doc(_user.email)
        .snapshots();
    profileScreenAppBar(context, true).then(
      (value) => (setState(
        () {
          appBar = value;
        },
      )),
    );
    _usersStream.forEach(
      (element) {
        Map<String, dynamic> data = element.data();
        if (data != null) {
          if (data['rooms'] != null) {
            List rooms = data['rooms'];
            rooms.forEach((element) {
              if (element['unread'] != null) {
                _countPrivate += toInt(element['unread']);
              }
            });
          }
        }
      },
    );
    super.initState();

    _scrollController.addListener(_onScroll);
    getComments();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      log("scroll");

      setState(
        () {
          _showSearchMessages = true;
        },
      );
    } else {
      log("scroll");
      setState(
        () {
          _showSearchMessages = true;
        },
      );
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  hideBottomBar() {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      setState(() {
        _hideBottomBar = true;
      });
    });
  }

  showBottomBar() {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      setState(() {
        _hideBottomBar = false;
      });
    });
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
  }

  updateWidget() {
    setState(() {});
  }

  getComments() async {
    List<int> readedF =
        await ReadedNotifications().getReaded(type: ReadedNotification.Forum);
    List<int> readedC = await ReadedNotifications()
        .getReaded(type: ReadedNotification.Comments);
    _comments = await _apiProvider.myComment();
    if (readedC == null && _comments.length > 1) {
      final Iterator<DataComment> commentIterator = _comments.iterator;
      readedC = [];
      while (commentIterator.moveNext()) {
        int id = commentIterator.current.id;
        readedC.add(id);
        await ReadedNotifications()
            .putReaded(type: ReadedNotification.Comments, id: id);
      }
    } else if (readedC == null) {
      readedC = [-1];
      await ReadedNotifications()
          .putReaded(type: ReadedNotification.Comments, id: -1);
    }
    readedComments = readedC;
    int _currentCountComment = await getCommentsCount();
    if (_comments.length > _currentCountComment) {
      _countComment = _comments.length - _currentCountComment;
    }
    _forums = await _apiProvider.myForumComment();

    if (readedF == null && _forums.length > 1) {
      final Iterator<DataComment> forumsIterator = _forums.iterator;
      readedF = [];
      while (forumsIterator.moveNext()) {
        int id = forumsIterator.current.id;
        readedF.add(id);
        await ReadedNotifications()
            .putReaded(type: ReadedNotification.Forum, id: id);
      }
    } else if (readedF == null) {
      readedF = [-1];
      await ReadedNotifications()
          .putReaded(type: ReadedNotification.Forum, id: -1);
    }
    readedForum = readedF;

    int _currentCountForum = await getForumCount();
    if (_forums.length > _currentCountForum) {
      _countForum = _forums.length - _currentCountForum;
    }

    setState(() {});
  }

  _onPopUp() {
    if (navigationChat.currentState.canPop()) {
      navigationChat.currentState.pop('/');
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<NotificationViewModel>.reactive(
      builder: (context, model, child) {
        return Scaffold(
          appBar: appBar,
          key: _noticeScafold,
          resizeToAvoidBottomInset: true,
          body: SafeArea(
            child: WillPopScope(
              onWillPop: () {
                // return _onPopUp();
              },
              child: NavigationChat(buildModel, context, model),
            ),
          ),
          bottomNavigationBar: _hideBottomBar
              ? null
              : BottomNavigationBar(
                  selectedLabelStyle: AppThemeStyle.normalTextNoColor,
                  selectedItemColor: AppColor.primary,
                  onTap: onTabTapped,
                  currentIndex: _currentIndex,
                  items: [
                    BottomNavigationBarItem(
                      icon: SizedBox(
                        height: 26,
                        width: 50,
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            SvgPicture.asset(
                              'assets/svg/icons/email.svg',
                              width: 26,
                              height: 18,
                              color: _currentIndex == 0
                                  ? AppColor.primary
                                  : AppColor.lightGrey,
                            ),
                            Positioned(
                              right: -1,
                              top: 0,
                              child: StreamBuilder<
                                      DocumentSnapshot<Map<String, dynamic>>>(
                                  stream: _usersStream,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasError) {
                                      return SizedBox();
                                    }
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return SizedBox();
                                    }
                                    if (snapshot.data.data() == null)
                                      return SizedBox();
                                    List data = snapshot.data.data()['rooms'];

                                    if (data.length == 0) return SizedBox();
                                    int _count = 0;
                                    data.forEach((element) {
                                      if (element['unread'] != null) {
                                        // print('${element['unread']}');
                                        _count += toInt(element['unread']);
                                      }
                                    });
                                    _countPrivate = _count;
                                    return BadgeMessagesNotice(
                                      _countPrivate,
                                      shape: BadgeMessagesNotice.ellipsis,
                                    );
                                  }),
                            )
                          ],
                        ),
                      ),
                      label: getTranslated(context, "private"),
                    ),
                    BottomNavigationBarItem(
                      icon: SizedBox(
                        width: 50,
                        height: 27,
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            SvgPicture.asset(
                              'assets/svg/icons/sending.svg',
                              width: 23,
                              height: 23,
                              color: _currentIndex == 1
                                  ? AppColor.primary
                                  : AppColor.lightGrey,
                            ),
                            Positioned(
                              right: -1,
                              top: 0,
                              child: BadgeMessagesNotice(
                                _countComment,
                                shape: BadgeMessagesNotice.ellipsis,
                              ),
                            )
                          ],
                        ),
                      ),
                      label: getTranslated(context, 'comment'),
                    ),
                    BottomNavigationBarItem(
                      icon: SizedBox(
                        width: 50,
                        height: 26,
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            SvgPicture.asset(
                              'assets/svg/icons/forum_icon.svg',
                              width: 32,
                              height: 20,
                              color: _currentIndex == 2
                                  ? AppColor.primary
                                  : AppColor.lightGrey,
                            ),
                            /*Icon(
                                Icons.people_outline,
                                size: 26,
                              ),*/
                            Positioned(
                              right: -1,
                              top: 0,
                              child: BadgeMessagesNotice(
                                _countForum,
                                shape: BadgeMessagesNotice.ellipsis,
                              ),
                            )
                          ],
                        ),
                      ),
                      label: getTranslated(context, 'forum'),
                    )
                  ],
                ),
        );
      },
      onViewModelReady: (model) {
        model.init();
      },
      viewModelBuilder: () => NotificationViewModel(),
    );
  }

  Widget buildModel(BuildContext context, NotificationViewModel model) {
    if (model.isLoading) {
      return Center(child: CupertinoActivityIndicator());
    }
    return SingleChildScrollView(
      controller: _scrollController,
      child: Column(
        children: <Widget>[
          if (_showSearchMessages) SearchMessagesWidget(search: search),
          mainUI(_currentIndex),
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    if (navigationChat.currentState != null &&
        navigationChat.currentState.canPop()) {
      navigationChat.currentState.pop();
    }
  }

  _resetCountComments() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setCommentsCount(_comments.length);
      _countComment = 0;
      setState(() {});
    });
  }

  _resetCountForum() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setForumCount(_forums.length);
      _countForum = 0;
      setState(() {});
    });
  }

  Widget mainUI(int index) {
    switch (index) {
      case 0:
        {
          return private();
        }
        break;
      case 1:
        {
          _resetCountComments();
          return comment();
        }
        break;
      case 2:
        {
          _resetCountForum();
          return forum();
        }
        break;
      default:
        {
          return private();
        }
        break;
    }
  }

  Widget private() {
    return Rooms();
  }

  Widget forum() {
    return CustomList(
      comments: _forums,
      readed: readedForum,
      hasRedirect: true,
    );
  }

  Widget comment() {
    return CustomList(
      comments: _comments,
      readed: readedComments,
      hasRedirect: true,
    );
  }
}

class SearchMessagesWidget extends StatelessWidget {
  const SearchMessagesWidget({
    Key key,
    @required this.search,
  }) : super(key: key);

  final TextEditingController search;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30, top: 20, bottom: 0),
      child: SearchFieldUI(
        controller: search,
        text: '',
        inputAction: TextInputAction.done,
        hintText: getTranslated(context, 'search_msg'),
        suffixIcon: IconButton(
          splashRadius: 25,
          onPressed: () {},
          icon: Icon(Icons.search),
        ),
      ),
    );
  }
}

class CustomList extends StatelessWidget {
  const CustomList({
    Key key,
    @required List<DataComment> comments,
    @required this.readed,
    this.hasRedirect = false,
  })  : _comments = comments,
        super(key: key);
  final List<DataComment> _comments;
  final bool hasRedirect;
  final List<int> readed;

  @override
  Widget build(BuildContext context) {
    if (_comments.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 15),
          child: Text(
            getTranslated(context, 'no_comment'),
            style: AppThemeStyle.normalText,
          ),
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.all(25.0),
        child: NoticeCardList(
          comments: _comments,
          hasRedirect: hasRedirect,
          readed: readed,
        ),
      );
    }
  }
}

class NoticeCardList extends StatelessWidget {
  NoticeCardList({
    Key key,
    @required List<DataComment> comments,
    @required this.readed,
    this.hasRedirect,
  })  : _comments = comments,
        super(key: key);

  final ApiProvider _apiProvider = ApiProvider();
  final List<DataComment> _comments;
  final bool hasRedirect;
  final List<int> readed;

  _goToInstance(BuildContext context, DataComment dataComment) async {
    _showBottomBar() {
      if (NotificationScreen.of(context) != null) {
        NotificationScreen.of(context).showBottomBar();
      }
    }

    _hideBottomBar() {
      if (NotificationScreen.of(context) != null) {
        NotificationScreen.of(context).hideBottomBar();
      }
    }

    // print(dataComment.instance);
    // print(dataComment.instance_id);
    // print(dataComment.instance_rus);
    if (dataComment.instance != null && dataComment.instance_id != null) {
      var model;
      switch (dataComment.instance) {
        case 'forum':
          _hideBottomBar();
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ForumDetailScreen(
                    title: dataComment.instance_rus,
                    subcategory: dataComment.instance_id,
                    disposeCallback: _showBottomBar,
                  )));
          break;
        case 'article':
          model = await _apiProvider.getArticle(
              category: null, id: toInt(dataComment.instance_id));
          break;
        default:
          break;
      }

      if (model != null && model.data != null && model.data.length > 0) {
        _hideBottomBar();
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => BottomBarDetail(
                data: model.data[0],
                needTabBars: false,
                type: dataComment.instance,
                disposeCallback: _showBottomBar),
          ),
        );
      }
    } else {
      return showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
          title: Text('Статья была удалена'),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text(getTranslated(context, 'ok')),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        ),
      );
    }
  }

  int getUnreadCounter(int id) {
    try {
      readed.firstWhere((element) => id == element);
      return 0;
    } catch (e) {
      return 1;
    }
  }

  void markReaded(DataComment comment) async {
    if (getUnreadCounter(comment.id) == 0) {
      return;
    }
    readed.add(comment.id);
    ReadedNotification type = comment.instance == 'article'
        ? ReadedNotification.Comments
        : ReadedNotification.Forum;
    ReadedNotifications().putReaded(type: type, id: comment.id);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _comments.length,
      itemBuilder: (context, i) {
        DataComment dataComment = _comments[i];
        Map<String, dynamic> data = {
          'avatar': dataComment.user.avatar,
          'name': dataComment.user.name,
          'email': dataComment.user.email,
          'messages': [
            {'message': dataComment.text}
          ],
          'timecreated': dataComment.created_at * 1000,
          'unread': getUnreadCounter(dataComment.id),
        };

        return GestureDetector(
          onTap: () {
            if (hasRedirect) {
              _goToInstance(context, dataComment);
            }
            markReaded(dataComment);
          },
          child: NoticeCard(
            data,
            needNotice: true,
          ),
        );
      },
    );
  }
}
