import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as fs;
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_network_app/services/app_state.dart';
import 'package:dio/dio.dart';
import 'package:social_network_app/services/api/dio.dart';

import 'dart:io';

class DatabaseMethods {
  // ------------------------FIREBASE--------------------------------------

  Future<void> addUserInfo(userData) async {
    FirebaseFirestore.instance
        .collection("users")
        .add(userData)
        .catchError((e) {
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

  Future getChats(String chatRoomId) async {
    return FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy('time')
        .snapshots();
  }

  Future<void> addMessage(String chatRoomId, chatMessageData) async {
    FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .add(chatMessageData)
        .catchError((e) {
      print(e.toString());
    });
  }

  getUserChats(String itIsMyName) async {
    return await FirebaseFirestore.instance
        .collection("chatRoom")
        .where('users', arrayContains: itIsMyName)
        .snapshots();
  }

  Future<String> downloadFile(String bucket, String fileId) async {
    fs.Reference ref =
        fs.FirebaseStorage.instance.ref().child(bucket).child(fileId);

    String downloadURL = await ref.getDownloadURL();
    return downloadURL;
  }

  dynamic downloadFiles(String bucket) async {
    fs.Reference ref =
    fs.FirebaseStorage.instance.ref().child(bucket);

    final urls = await ref.listAll();

    print("URLS");
    print(urls);

    return urls;

  }

  Future<String> uploadFile(String bucket, String fileName, XFile file) async {
    String downloadURL;
    fs.Reference ref =
        fs.FirebaseStorage.instance.ref().child(bucket).child(fileName);

    if (kIsWeb) {
      await ref.putData(await file.readAsBytes());
    } else {
      await ref.putFile(File(file.path));
      // await ref.putFile(html.File(image.path.codeUnits, image.path));
    }

    downloadURL = await ref.getDownloadURL();
    return downloadURL;
  }

  // ------------------------SQL--------------------------------------

  Future<int> updateUserField(String value, String field, String route) async {
    String userId = appState.currentUser.id;

    String jsonData = '{"user_id": "$userId", "$field": "$value"}';

    Response response =
        await dioHttpPost(route: route, jsonData: jsonData, token: true);

    if (response.statusCode == 200) {
      return 0;
    } else {
      throw Exception('Fail to updateField');
    }
  }

  getUserField(String userid, String? fields) async {
    String jsonData;

    if (fields == null) {
      jsonData = '{"id": "$userid"}';
    } else {
      jsonData = '{"id": "$userid", "fields": $fields}';
    }

    Response response = await dioHttpPost(
        route: 'getUserFields', jsonData: jsonData, token: true);

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('an error occured');
    }
  }
}

// -------------------------------------------------------------------------
