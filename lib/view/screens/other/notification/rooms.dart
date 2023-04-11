import 'package:charity_app/localization/language_constants.dart';
import 'package:charity_app/model/data.dart';
import 'package:charity_app/utils/constants.dart';
import 'package:charity_app/view/components/no_data.dart';
import 'package:charity_app/view/components/notice_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Rooms extends StatefulWidget {
  @override
  _RoomsState createState() => _RoomsState();
}

class _RoomsState extends State<Rooms> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User _user;
  Stream<DocumentSnapshot<Map<String, dynamic>>> _usersStream;

  @override
  void initState() {
    _user = _auth.currentUser;
    _usersStream = FirebaseFirestore.instance
        .collection('chat')
        .doc(_user.email)
        .snapshots();

    super.initState();
  }

  goToConversation(data) {
    UserComment user = UserComment.fromJson({
      'avatar': data['avatar'],
      'email': data['email'],
      'name': data['name']
    });
    navigationChat.currentState
        .pushNamed('/messages', arguments: {'user': user});
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: _usersStream,
      builder: (BuildContext context,
          AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
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
            text: getTranslated(context,"no_messages"),
          )));

        List data = snapshot.data.data()['rooms'];
        data.sort((a, b) {
          final int bValue =
              b['messages'].isNotEmpty ? b['messages'].last['time'] : 1;
          final int aValue =
              a['messages'].isNotEmpty ? a['messages'].last['time'] : 1;
          return bValue.compareTo(aValue);
        });

        if (data.length == 0)
          return Center(
              child: Container(
                  child: EmptyData(
            text: getTranslated(context,"no_messages"),
          )));

        return Padding(
          padding: const EdgeInsets.all(25.0),
          child: ListView(
            shrinkWrap: true,
            children: data.map((document) {
              Map<String, dynamic> d = document as Map<String, dynamic>;
              return GestureDetector(
                onTap: () {
                  goToConversation(d);
                },
                child: NoticeCard(d),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
