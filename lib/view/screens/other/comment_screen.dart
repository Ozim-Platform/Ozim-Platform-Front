import 'package:charity_app/custom_icons_icons.dart';
import 'package:charity_app/localization/language_constants.dart';
import 'package:charity_app/model/data.dart';
import 'package:charity_app/model/user/user.dart';
import 'package:charity_app/utils/constants.dart';
import 'package:charity_app/utils/device_size_config.dart';
import 'package:charity_app/utils/formatters.dart';
import 'package:charity_app/view/components/no_data.dart';
import 'package:charity_app/view/components/user_image.dart';
import 'package:charity_app/view/screens/other/comment_viewmodel.dart';
import 'package:charity_app/view/theme/app_color.dart';
import 'package:charity_app/view/theme/themes.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:stacked/stacked.dart';

import 'comment_details_view.dart';

class CommentDetailsModel {
  final String title;
  final String description;
  final DataUser userData;

  CommentDetailsModel({
    @required this.title,
    @required this.description,
    @required this.userData,
  });
}

class CommentScreen extends StatelessWidget {
  CommentScreen(this.instance, this.data, {Key key, @required this.detailsModel}) : super(key: key);

  final instance;
  final Data data;
  final CommentDetailsModel detailsModel;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CommentViewModel>.reactive(
      builder: (context, model, child) {
        _writeNewComment(int index) {
          model.prepareSending(commentid: null);
          model.setWritting();
        }

        return Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: AppColor.sometimes,
          appBar: AppBar(
            toolbarHeight: 82.0,
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            title: Column(
              children: [
                const SizedBox(
                  height: 42.0,
                ),
                Text(
                  getTranslated(context, 'comment'),
                  style: AppThemeStyle.headerWhite,
                ),
                const SizedBox(height: 30.0),
              ],
            ),
            leading: Column(
              children: [
                IconButton(
                  iconSize: 25.0,
                  splashRadius: 20,
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                )
              ],
            ),
          ),
          body: Column(
            children: <Widget>[
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topLeft: const Radius.circular(40), topRight: const Radius.circular(40)),
                  child: Container(
                    width: SizeConfig.screenWidth,
                    color: Color.fromRGBO(244, 244, 244, 1),
                    child: mainUI(model),
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: Column(mainAxisSize: MainAxisSize.min, children: [
            ConvexAppBar(
              elevation: 0.2,
              style: TabStyle.fixedCircle,
              color: Colors.black45,
              height: 35.0,
              activeColor: AppColor.sometimes,
              backgroundColor: Colors.white,
              items: [
                TabItem(
                    icon: Semantics(
                  label: getTranslated(context, 'create_comment'),
                  child: Icon(CustomIcons.sending, size: 25, color: Colors.white),
                )),
              ],
              initialActiveIndex: 0,
              onTap: _writeNewComment,
            ),
            Container(height: 5.0, color: Colors.white),
          ]),
        );
      },
      onModelReady: (model) {
        model.getComment();
      },
      viewModelBuilder: () => CommentViewModel(instance, data),
    );
  }

  Widget mainUI(CommentViewModel viewModel) {
    if (viewModel.isLoading) return Container();
    if (viewModel.comment != null) {
      List<DataComment> comments = viewModel.comment;
      String userAvatar = viewModel.useravatar;
      // print(userAvatar);
      return Column(
        children: [
          Expanded(
              child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: Column(
              children: [
                if (detailsModel != null)
                  CommentDetailsView(
                    detailsModel: detailsModel,
                  ),
                CommentsAndReplyBuilder(
                  articleid: viewModel.instanceid,
                  comments: comments,
                  model: viewModel,
                  parent: true,
                ),
              ],
            ),
          )),
          if (viewModel.writingComment)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.transparent,
              ),
              child: CommentField(
                userAvatar,
                viewModel,
                sending: viewModel.sendingMessage,
              ),
            ),
          // //TODO: ??
          // Container(
          //   color: Colors.transparent,
          //     height: 25,
          //   width: double.infinity,
          // )
        ],
      );
    } else {
      return Container(child: EmptyData());
    }
  }
}

class CommentsAndReplyBuilder extends StatelessWidget {
  CommentsAndReplyBuilder({
    Key key,
    @required this.articleid,
    @required this.comments,
    @required this.model,
    @required this.parent = false,
  }) : super(key: key);

  final List<DataComment> comments;
  final int articleid;
  final CommentViewModel model;
  final bool parent;

  @override
  Widget build(BuildContext context) {
    if (parent) {
      return ListView.builder(
          controller: model.mainScrollControlller,
          padding: parent ? EdgeInsets.symmetric(vertical: 20) : EdgeInsets.zero,
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          itemCount: comments.length,
          itemBuilder: (context, i) {
            DataComment dataComment = comments[i];
            if (model.commentsAndReplyKeys[dataComment.id] == null) {
              model.commentsAndReplyKeys[dataComment.id] =
                  GlobalKey<_MainBuilderCommentState>(debugLabel: dataComment.id.toString());
            }
            final Widget comment = MainBuilderComment(
              articleid,
              dataComment,
              model,
              parent: parent,
              key: model.commentsAndReplyKeys[dataComment.id],
              commentsAndReplyKeys: model.commentsAndReplyKeys,
            );
            if (i == comments.length - 1 && model.haveNextPage && parent) {
              model.loadNextPage();
              return Column(
                children: [
                  comment,
                  CupertinoActivityIndicator(),
                ],
              );
            }
            return comment;
          });
    } else {
      return Column(
        children: List<MainBuilderComment>.generate(comments.length, (int i) {
          DataComment dataComment = comments[i];
          if (model.commentsAndReplyKeys[dataComment.id] == null) {
            model.commentsAndReplyKeys[dataComment.id] =
                GlobalKey<_MainBuilderCommentState>(debugLabel: dataComment.id.toString());
          }
          return MainBuilderComment(
            articleid,
            dataComment,
            model,
            parent: parent,
            key: model.commentsAndReplyKeys[dataComment.id],
            commentsAndReplyKeys: model.commentsAndReplyKeys,
          );
        }),
      );
    }
  }
}

class MainBuilderComment extends StatefulWidget {
  final DataComment dataComment;
  final bool parent;
  final CommentViewModel model;
  final int articleid;
  final Map<int, GlobalKey> commentsAndReplyKeys;

  const MainBuilderComment(
    this.articleid,
    this.dataComment,
    this.model, {
    Key key,
    this.parent = false,
    @required this.commentsAndReplyKeys,
  }) : super(key: key);

  @override
  _MainBuilderCommentState createState() => _MainBuilderCommentState();
}

class _MainBuilderCommentState extends State<MainBuilderComment> {
  DataComment get dataComment => widget.dataComment;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool get parent => widget.parent;

  int get articleid => widget.articleid;

  CommentViewModel get model => widget.model;

  UserComment _user;
  List<DataComment> get _replies => dataComment.replies;
  bool get _hasReplies => dataComment.replies.length > 0;
  String get _repliesCount => dataComment.repliesCount.toString();
  int _time;
  bool get _showReplies => model.showRepliesMap[dataComment.id] == true;

  @override
  void initState() {
    init();
    super.initState();
  }

  init() {
    _user = dataComment.user;
    _time = dataComment.created_at;
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  _writePrivateMessage() {
    model.setWritting(hint: 'private_message');
    model.setSendCallback((String message) =>
        model.startConversation(message: message, context: context, receiver: _user));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Column(
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    if (_auth.currentUser.email != _user.email) {
                      _writePrivateMessage();
                    }
                  },
                  child: UserImage(
                    userUrl: _user?.avatar ?? "",
                  ),
                ),
              ],
            ),
            SizedBox(width: 10),
            Expanded(
              child: Container(
                child: Column(
                  children: [
                    Stack(
                      fit: StackFit.passthrough,
                      clipBehavior: Clip.none,
                      alignment: Alignment.topCenter,
                      children: [
                        //if (_hasReplies && !_showReplies) ...buildSubCards(dataComment),
                        buildCard(dataComment, showReplies: _hasReplies && !_showReplies),
                      ],
                    ),
                    if (_hasReplies)
                      GestureDetector(
                        onTap: showReplies,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: Text(
                            !_showReplies
                                ? getTranslated(context, 'show_answers') + ' ($_repliesCount)'
                                : getTranslated(context, 'hide_answers'),
                            style: AppThemeStyle.ligtherText,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
        if (_showReplies)
          Row(
            children: [
              if (parent)
                SizedBox(
                  width: 30,
                ),
              Expanded(
                child: Container(
                  child: CommentsAndReplyBuilder(
                    articleid: articleid,
                    comments: _replies,
                    model: model,
                    parent: false,
                  ),
                ),
              )
            ],
          ),
        // if (_writingComment)
        //   CommentField()
        const SizedBox(height: 15)
      ],
    );
  }

  showReplies() {
    setState(() {
      model.showRepliesMap[dataComment.id] = !_showReplies;
    });
  }

  answerForComment() {
    if (!_showReplies) {
      showReplies();
    }
    model.srollTo(dataComment.id);
    model.prepareSending(commentid: dataComment.id);
    model.setWritting();
  }

  List<Widget> buildSubCards(DataComment dataComment) {
    return [
      Positioned(
        bottom: 0,
        left: 20.0,
        right: 20.0,
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 5,
                  spreadRadius: 0,
                )
              ]),
          height: 40.0,
        ),
      ),
      Positioned(
        bottom: 10,
        left: 10.0,
        right: 10.0,
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 5,
                  spreadRadius: 0,
                )
              ]),
          height: 40.0,
        ),
      ),
    ];
  }

  Widget buildCard(DataComment dataComment, {bool showReplies = false}) {
    return Row(
      children: [
        Expanded(
          child: Card(
            margin: EdgeInsets.only(
              bottom: showReplies ? 20 : 0,
            ),
            child: Container(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                top: 15,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25.0),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 5,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getUserName(dataComment.user),
                    style: AppThemeStyle.subHeader,
                  ),
                  SizedBox(
                    height: SizeConfig.calculateBlockVertical(20),
                    width: double.infinity,
                  ),
                  Text(
                    dataComment.text,
                    style: AppThemeStyle.normalText,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 1,
                    width: double.infinity,
                    child: DecoratedBox(
                      decoration: BoxDecoration(color: Constants.mainTextColor),
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        dateFormatterEng(_time),
                        style: AppThemeStyle.ligtherText,
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      Semantics(
                        focusable: true,
                        label: getTranslated(context, "reply_vo"),
                        button: true,
                        child: InkWell(
                          onTap: answerForComment,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            child: Text(
                              getTranslated(context, "reply_vo"),
                              style: AppThemeStyle.ligtherText,
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
        ),
      ],
    );
  }

  _getUserName(UserComment user) {
    if (user == null) return '';
    if (user.name == null) return '';
    return user.name;
  }
}

class CommentField extends StatelessWidget {
  final String avatar;
  final CommentViewModel model;
  final bool sending;

  const CommentField(
    this.avatar,
    this.model, {
    Key key,
    @required this.sending,
  }) : super(key: key);

  _sendComment(String comment) {
    model.write(comment);
  }

  @override
  Widget build(BuildContext context) {
    return _CommentTextField(
      callback: _sendComment,
      hint: model.hint,
      avatar: avatar,
      sending: sending,
    );
  }
}

class _CommentTextField extends StatelessWidget {
  final ValueChanged<String> callback;
  final String hint;
  final String avatar;
  final bool withavatar;
  final bool autofocus;
  final bool sending;

  _CommentTextField(
      {Key key,
      @required this.sending,
      this.callback,
      this.hint,
      this.avatar,
      this.withavatar = true,
      this.autofocus = true})
      : super(key: key);

  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (withavatar)
          UserImage(
            userUrl: avatar,
          ),
        if (withavatar)
          SizedBox(
            width: 10.0,
          ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25.0),
            ),
            child: TextField(
              keyboardType: TextInputType.multiline,
              minLines: 1,
              maxLines: 4,
              autofocus: autofocus,
              focusNode: FocusNode(),
              controller: _textController,
              textInputAction: TextInputAction.send,
              onSubmitted: callback,
              decoration: InputDecoration(
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                border: InputBorder.none,
                hintText: getTranslated(context, hint),
                hintStyle: AppThemeStyle.normalText,
                hintMaxLines: 1,
                fillColor: Colors.white,
              ),
            ),
          ),
        ),
        SizedBox(
          width: 8.0,
        ),
        if (sending)
          CupertinoActivityIndicator()
        else
          InkWell(
            onTap: () {
              callback(_textController.text);
              _textController.text = '';
            },
            child: Icon(
              Icons.arrow_upward,
              color: AppThemeStyle.primaryColor,
              size: 28,
              semanticLabel: getTranslated(context, "send_message_vo"),
            ),
          )
      ],
    );
  }
}
