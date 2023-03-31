import 'dart:async';

import 'package:charity_app/localization/user_data.dart';
import 'package:charity_app/model/base_response.dart';
import 'package:charity_app/model/data.dart';
import 'package:charity_app/model/user/user.dart';
import 'package:charity_app/persistance/api_provider.dart';
import 'package:charity_app/utils/constants.dart';
import 'package:charity_app/utils/device_size_config.dart';
import 'package:charity_app/utils/firebase.dart';
import 'package:charity_app/utils/utils.dart';
import 'package:charity_app/view/components/custom/custom_input_field.dart';
import 'package:charity_app/view/components/no_data.dart';
import 'package:charity_app/view/components/user_image.dart';
import 'package:charity_app/view/theme/app_color.dart';
import 'package:charity_app/view/theme/themes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Messages extends StatefulWidget {
  final UserComment user;

  Messages({Key key, this.user}) : super(key: key);

  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User _user;
  UserData userData = new UserData();
  DataUser _dataUser;
  FirebaseHelper db = FirebaseHelper();
  Stream<DocumentSnapshot<Map<String, dynamic>>> _usersStream;
  ScrollController _scrollController = ScrollController();
  ApiProvider _apiProvider = ApiProvider();

  @override
  void initState() {
    init();
    _user = _auth.currentUser;
    _usersStream = FirebaseFirestore.instance
        .collection('chat')
        .doc(_user.email)
        .snapshots();

    super.initState();
  }

  @override
  setState(fn) {
    if (mounted) {
      super.setState(() {});
    }
  }

  init() async {
    _dataUser = await userData.getAllData();
  }

  _sendMessage(String message) async {
    if (message != '' && _dataUser != null && widget.user != null) {
      db.sendMessage(_dataUser, widget.user, message);
      BaseResponses _push = await _apiProvider.push(widget.user.email);
      Timer(
        Duration(milliseconds: 500),
        () => _scrollController
            .jumpTo(_scrollController.position.maxScrollExtent),
      );
    } else {
      // FocusScope.of(context).unfocus();
    }
  }

  _resetCountUnread() async {
    if (_dataUser != null && widget.user != null) {
      db.resetUnreadCountConversation(_dataUser, widget.user);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: IconButton(
                iconSize: 18.0,
                splashRadius: 20,
                icon: Icon(Icons.arrow_back_ios, color: Colors.black54),
                onPressed: () => navigationChat.currentState.pop(),
              ),
            ),
            Expanded(child: SizedBox()),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 30, bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              UserImage(
                userUrl: widget.user.avatar,
                size: 70,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  widget.user.name,
                  textAlign: TextAlign.start,
                  style: AppThemeStyle.headerPrimaryColor,
                ),
              ),
            ],
          ),
        ),
        Divider(
          thickness: 1,
          color: AppColor.lightGrey.withOpacity(0.4),
        ),
        Expanded(
          child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: _usersStream,
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                    snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CupertinoActivityIndicator());
              }

              if (snapshot.data.data() == null)
                return Center(
                    child: Container(
                        child: EmptyData(
                  text: 'У вас пока что нет начатых чатов',
                )));

              List rooms = snapshot.data.data()['rooms'];

              if (rooms.length == 0)
                return Center(
                    child: Container(
                        child: EmptyData(
                  text: 'У вас пока что нет начатых чатов',
                )));

              List data = [];
              int unread = 0;

              rooms.forEach((element) {
                if (element['email'] == widget.user.email) {
                  data.addAll(element['messages']);
                  unread += element['unread'];
                }
              });

              if (data.length == 0)
                return Center(
                    child: Container(
                        child: EmptyData(
                  text: 'У вас пока сообщений с данным пользователем',
                )));

              /**After load scroll down*/
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (_scrollController != null) {
                  _scrollController
                      .jumpTo(_scrollController.position.maxScrollExtent);
                }
                if (unread > 0) {
                  _resetCountUnread();
                }
              });

              return Padding(
                padding: const EdgeInsets.fromLTRB(25.0, 25.0, 25.0, 10.0),
                child: ListView(
                  controller: _scrollController,
                  shrinkWrap: true,
                  children: data.map((document) {
                    Map<String, dynamic> d = document as Map<String, dynamic>;
                    // print(d, level: 2);
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: MessegeCard(_user.email == d['email'], d),
                    );
                  }).toList(),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: InputMessageField(
            callback: _sendMessage,
            hint: 'enter_you_message',
            avatar: null,
            withavatar: false,
            autofocus: false,
          ),
        ),
        SizedBox(height: SizeConfig.calculateBlockVertical(10)),
      ],
    );
  }
}

class MessegeCard extends StatelessWidget {
  final bool currentUser;
  final Map<String, dynamic> data;

  const MessegeCard(
    this.currentUser,
    this.data, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      textDirection: currentUser ? TextDirection.rtl : TextDirection.ltr,
      children: [
        SizedBox(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 17, horizontal: 12),
            constraints: BoxConstraints(maxWidth: 275),
            child: Text(
              data['message'],
              style: AppThemeStyle.normalText,
            ),
            decoration: BoxDecoration(
              color: currentUser ? AppColor.lightGreen : AppColor.lightBlue,
              borderRadius: const BorderRadius.all(const Radius.circular(25)),
            ),
          ),
        ),
        Expanded(child: SizedBox())
      ],
    );
  }
}
