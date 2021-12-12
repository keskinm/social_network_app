import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as fs;
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_network_app/services/app_state.dart';
import 'package:dio/dio.dart';
import 'package:social_network_app/services/api/dio.dart';

import 'dart:io';


class DatabaseMethods {
  Future<void> addUserInfo(userData) async {
    FirebaseFirestore.instance.collection("users").add(userData).catchError((e) {
      print(e.toString());
    });
  }

  getUserInfo(String email) async {
    return FirebaseFirestore.instance
        .collection("users")
        .where("userEmail", isEqualTo: email)
        .get()
        .catchError((e) {
      print(e.toString());
    });
  }

  searchByName(String searchField) {
    return FirebaseFirestore.instance
        .collection("users")
        .where('userName', isEqualTo: searchField)
        .get();
  }

  Future<void> addChatRoom(chatRoom, chatRoomId) async {
    FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .set(chatRoom)
        .catchError((e) {
      print(e);
    });
  }

  Future getChats(String chatRoomId) async{
    return FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy('time')
        .snapshots();
  }

  Future<void> addMessage(String chatRoomId, chatMessageData) async {

    FirebaseFirestore.instance.collection("chatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .add(chatMessageData).catchError((e){
      print(e.toString());
    });
  }

  getUserChats(String itIsMyName) async {
    return await FirebaseFirestore.instance
        .collection("chatRoom")
        .where('users', arrayContains: itIsMyName)
        .snapshots();
  }

}

// -------------------------------------------------------------------------


getUserField(String userid) async {
  // @todo why doesn't work with fields?
  // String jsonData = '{"id": "$userid", "fields": ["profile_image_id"]}';
  String jsonData = '{"id": "$userid"}';

  Response response =
  await dioHttpPost(route: 'getUserFields', jsonData: jsonData, token: true);

  if (response.statusCode == 200) {
    dynamic jsonResp = response.data[0];
    String? profileImageId = jsonResp['profile_image_id'];
    return profileImageId;
  }
  else {
    throw Exception('an error occured');
  }
}

Future<String> downloadFile() async {
  String bucket = 'profile_images';

  fs.Reference ref;

  String? fileId = await getUserField(appState.currentUser.id);

  if (fileId==null){

    fileId = 'default_profile.png';

    ref = fs.FirebaseStorage.instance
        .ref()
        .child(bucket)
        .child(fileId);
  }

  else {
    ref = fs.FirebaseStorage.instance
        .ref()
        .child(bucket)
        .child(appState.currentUser.username)
        .child(fileId);

  }
  String downloadURL = await ref.getDownloadURL();
  return downloadURL;
}

Future<String> uploadFile(XFile image) async {
  String downloadURL;
  String postId = DateTime.now().millisecondsSinceEpoch.toString();
  fs.Reference ref = fs.FirebaseStorage.instance
      .ref()
      .child("images")
      .child("post_$postId.jpg");

  if (kIsWeb) {
    await ref.putData(await image.readAsBytes());
  } else {
    await ref.putFile(File(image.path));
    // await ref.putFile(html.File(image.path.codeUnits, image.path));
  }

  downloadURL = await ref.getDownloadURL();
  return downloadURL;
}

uploadToFirebase(XFile image) async {
  String url = await uploadFile(image); // this will upload the file and store url in the variable 'url'
  // await users.doc(uid).update({  //use update to update the doc fields.
  //   'url':url
  // });
}
