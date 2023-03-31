import 'dart:async';

import 'package:charity_app/model/data.dart';
import 'package:charity_app/model/user/user.dart';
import 'package:charity_app/utils/constants.dart';
import 'package:charity_app/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseHelper {
  static FirebaseFirestore firestore =
      Constants.db != null ? Constants.db : FirebaseFirestore.instance;

  static fb() {
    return firestore;
  }

  final String fullName = 'John Doe';
  final String company = 'CocaCola';
  final String roomid = '23462173dsaddfa3234';
  final int age = 12;

  // final FirebaseApp app = FirebaseApp._(name: '[DEFAULT]');
  // final DatabaseReference db = FirebaseDatabase(app: firebaseApp).reference();
  // db.child('your_db_child').once().then((result) => print('result = $result'));

  test() async {
    CollectionReference rooms = firestore.collection('rooms');
    // await addUser();
    // var users = await getUsers();
    // print(users);
    // print(users);
    // print(await rooms.get());
    // addUser();
  }

  Future<void> initNewConversationSender(
      DataUser sender, UserComment reciever, String message) async {
    DocumentReference<Map<String, dynamic>> chatSender =
        firestore.collection('chat').doc(sender.email);
    Map<String, dynamic> dataSender = getSimpleDataForSender(sender, reciever, message);

    return chatSender
        .set(dataSender)
        .then((value) {})
        .catchError((error) => print("Failed to add user: $error", level: 1));
  }

  Future<void> initNewConversationReceiver(
      DataUser sender, UserComment reciever, String message) async {
    DocumentReference<Map<String, dynamic>> chatReceiver =
        firestore.collection('chat').doc(reciever.email);

    Map<String, dynamic> dataReceiver = getSimpleDataForReciever(sender, reciever, message);

    return chatReceiver
        .set(dataReceiver)
        .then((value) {})
        .catchError((error) => print("Failed to add user: $error", level: 1));
  }

  Future<void> addNewMessageForConversationSender(DataUser sender, UserComment reciever,
      String message, DocumentSnapshot<Map<String, dynamic>> data) async {
    DocumentReference<Map<String, dynamic>> chatSender =
        firestore.collection('chat').doc(sender.email);

    List rooms = data.get('rooms') as List;
    int roomid = getRoomId(rooms, reciever.email);
    if (roomid == null) {
      List stub = getSimpleDataForSender(sender, reciever, message)['rooms'] as List;
      rooms.add(stub[0]);
    } else {
      rooms[roomid]["timeupdated"] = DateTime.now().millisecondsSinceEpoch;
      // rooms[roomid]["unread"] = rooms[roomid]["unread"] + 1;
      rooms[roomid]["messages"].add(simpleMessage(sender, message));
    }

    return chatSender.update({"rooms": rooms});
  }

  Future<void> resetUnreadCountConversation(DataUser sender, UserComment reciever) async {
    DocumentReference<Map<String, dynamic>> chatSender =
        firestore.collection('chat').doc(sender.email);

    DocumentSnapshot<Map<String, dynamic>> dataSender = await chatSender.get();
    List rooms = dataSender.get('rooms') as List;

    int roomid = getRoomId(rooms, reciever.email);
    if (roomid != null) {
      rooms[roomid]["unread"] = 0;
      return chatSender.update({"rooms": rooms});
    }
  }

  Future<void> addNewMessageForConversationReceiver(DataUser sender, UserComment reciever,
      String message, DocumentSnapshot<Map<String, dynamic>> data) async {
    DocumentReference<Map<String, dynamic>> chatReceiver =
        firestore.collection('chat').doc(reciever.email);

    List rooms = data.get('rooms') as List;
    int roomid = getRoomId(rooms, sender.email);
    if (roomid == null) {
      List stub = getSimpleDataForReciever(sender, reciever, message)['rooms'] as List;
      rooms.add(stub[0]);
    } else {
      rooms[roomid]["timeupdated"] = DateTime.now().millisecondsSinceEpoch;
      rooms[roomid]["unread"] = rooms[roomid]["unread"] + 1;
      rooms[roomid]["messages"].add(simpleMessage(sender, message));
    }

    return chatReceiver.update({"rooms": rooms});
  }

  int getRoomId(List room, email) {
    int roomid;
    room.asMap().forEach((id, room_item) {
      if (room_item['email'] == email) {
        roomid = id;
      }
    });
    return roomid;
  }

  Map<String, dynamic> getSimpleDataForSender(
      DataUser sender, UserComment reciever, String message) {
    Map<String, dynamic> data = {
      "rooms": [
        {
          "email": reciever.email,
          "name": reciever.name,
          "avatar": reciever.avatar,
          "timecreated": DateTime.now().millisecondsSinceEpoch,
          "timeupdated": DateTime.now().millisecondsSinceEpoch,
          "unread": 0,
          "messages": [simpleMessage(sender, message)],
        },
      ],
    };
    return data;
  }

  Map<String, dynamic> getSimpleDataForReciever(
      DataUser sender, UserComment reciever, String message) {
    Map<String, dynamic> data = {
      "rooms": [
        {
          "email": sender.email,
          "name": sender.name,
          "avatar": sender.avatar,
          "timecreated": DateTime.now().millisecondsSinceEpoch,
          "timeupdated": DateTime.now().millisecondsSinceEpoch,
          "unread": 1,
          "messages": [simpleMessage(sender, message)],
        },
      ],
    };
    return data;
  }

  Map<String, dynamic> simpleMessage(sender, message) {
    return {
      "email": sender.email,
      "avatar": sender.avatar,
      "name": sender.name,
      "time": DateTime.now().millisecondsSinceEpoch,
      "message": message,
    };
  }

  Future<void> sendMessage(DataUser sender, UserComment receiver, String message) async {
    Future toSenderFuture = _sendToSender(sender, receiver, message);
    Future toReceiverFuture = _sendToReceiver(sender, receiver, message);
    await toSenderFuture;
    await toReceiverFuture;
  }

  Future<void> _sendToSender(DataUser sender, UserComment receiver, String message) async {
    DocumentSnapshot<Map<String, dynamic>> dataSender =
        await FirebaseHelper.fb().collection('chat').doc(sender.email).get();
    if (!dataSender.exists) {
      return initNewConversationSender(sender, receiver, message);
    } else {
      return addNewMessageForConversationSender(sender, receiver, message, dataSender);
    }
  }

  Future<void> _sendToReceiver(DataUser sender, UserComment receiver, String message) async {
    DocumentSnapshot<Map<String, dynamic>> dataReceiver =
        await FirebaseHelper.fb().collection('chat').doc(receiver.email).get();
    if (!dataReceiver.exists) {
      await initNewConversationReceiver(sender, receiver, message);
    } else {
      await addNewMessageForConversationReceiver(sender, receiver, message, dataReceiver);
    }
  }

// if (snapshot.hasError) {
//   print('error');
//   return Text("Something went wrong");
// }
//
// if (snapshot.hasData && !snapshot.data.exists) {
//   return Text("Document does not exist");
// }
//
// if (snapshot.connectionState == ConnectionState.done) {
//   Map<String, dynamic> data =
//       snapshot.data.data() as Map<String, dynamic>;
//   print(data);
//   return Text("Full Name: ${data['full_name']} ${data['company']}");
// }
}
