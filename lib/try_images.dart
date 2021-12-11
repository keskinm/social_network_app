import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as fs;
import 'package:image_picker/image_picker.dart';
import 'package:social_network_front/services/app_state.dart';


class LoadFirbaseStorageImage extends StatefulWidget {
  @override
  _LoadFirbaseStorageImageState createState() =>
      _LoadFirbaseStorageImageState();
}

class _LoadFirbaseStorageImageState extends State<LoadFirbaseStorageImage> {
  bool inProcess = false;
  late Future<String> profileImage;

  @override
  void initState() {
    super.initState();
    profileImage = downloadFile();
  }


  @override
  Widget build(BuildContext context) {
    return Column(children: [


      FutureBuilder(
          future: profileImage,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              dynamic im = snapshot.data;

              return Container(
                child: Column(
                  children: [
                    Container(
                      child: Image.network(
                        im,
                        fit: BoxFit.fill,
                      ),
                      width: 200,
                      height: 200,
                    ),
                    MaterialButton(
                      onPressed: () => newProfileImage(),
                      child: Text('Changer photo de profile'),
                    )
                  ],
                ),
              );
            } else {
              return Text('doesnt have data');
            }
          })
    ]);
  }

  Future<void> newProfileImage() async {
    File? image = await selectImageFromGallery();

    if (image==null){
      throw Exception('an exception occured');
    }

    print("0");
    await uploadFile(image);
    print("1");
    await uploadToFirebase(image);
    print("2");

  }

  Future<File?> selectImageFromGallery() async {
    File? _image;

    final picker = ImagePicker();

    setState(() {
      inProcess = true;
    });

    final imageFile = await picker.pickImage(source: ImageSource.gallery);

    if (imageFile != null) {
      _image = File(imageFile.path);
    }

    setState(() {
      inProcess = false;
    });

    return _image;

  }

  Future<String> downloadFile() async {
    fs.Reference ref = fs.FirebaseStorage.instance
        .ref()
        .child(appState.currentUser.username)
        .child("tmp.jpg");
    String downloadURL = await ref.getDownloadURL();
    return downloadURL;
  }

  Future<String> uploadFile(File image) async {
    String downloadURL;
    String postId = DateTime.now().millisecondsSinceEpoch.toString();
    fs.Reference ref = fs.FirebaseStorage.instance
        .ref()
        .child("images")
        .child("post_$postId.jpg");
    await ref.putFile(image);
    downloadURL = await ref.getDownloadURL();
    return downloadURL;
  }

  uploadToFirebase(File image) async {
    String url = await uploadFile(image); // this will upload the file and store url in the variable 'url'
    // await users.doc(uid).update({  //use update to update the doc fields.
    //   'url':url
    // });
  }
}


// Widget _buildImageBoxes(dynamic im) {
//   return
//     Column(
//       children: <Widget>[
//         Container(
//           child: Image.network(im),
//         ),
//         Container(
//           padding: EdgeInsets.all(10),
//           child:  Text("Text"),        )
//       ],
//     );
//
// }

// return ListView(
//   children: <Widget>[
//     Container(
//         margin: EdgeInsets.all(20),
//         child: GridView.builder(
//             physics: ScrollPhysics(), // to disable GridView's scrolling
//             shrinkWrap: true,
//             itemCount: 20,
//             gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 2),
//             itemBuilder: (BuildContext context, int index) {
//               return Container(
//                   padding: EdgeInsets.all(5), child: _buildImageBoxes(im));
//             })),
//   ],
// );

// return Scaffold(
//     appBar: AppBar(
//       title: Text('Flutter Image Demo'),
//     ),
//     body: Center(
//         child: Column(
//             children: <Widget>[
//               Image.network(im,
//                   height: 400,
//                   width: 250
//               )])));

// return Wrap(children: [Container(
//   height: 200,
//   width: 200,
//   // decoration: BoxDecoration(image: DecorationImage(image: FileImage(im,),fit: BoxFit.contain)),
//   decoration: BoxDecoration(image: DecorationImage(image: im,fit: BoxFit.contain)),
// ),
//   MaterialButton(onPressed: uploadToFirebase(),
//     child: Text('upload'),)]);
