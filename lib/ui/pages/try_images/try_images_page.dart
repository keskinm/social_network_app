// import 'dart:html' as html;
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:social_network_app/services/database.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_network_app/services/app_state.dart';

class LoadFirbaseStorageImage extends StatefulWidget {
  @override
  _LoadFirbaseStorageImageState createState() =>
      _LoadFirbaseStorageImageState();
}

class _LoadFirbaseStorageImageState extends State<LoadFirbaseStorageImage> {
  bool inProcess = false;
  late Future<String> profileImage;
  DatabaseMethods dataBaseMethods = DatabaseMethods();

  Future<String> getProfileImage() async {
    String bucket;

    dynamic jsonResp = await dataBaseMethods.getUserField(
        appState.currentUser.id, "[\"profile_image_id\"]");
    String? profileImageId = jsonResp[0]['profile_image_id'];

    if (profileImageId == null) {
      bucket = 'profile_images';
      profileImageId = 'default_profile.png';
    } else {
      String currentUsername = appState.currentUser.username;
      bucket = 'profile_images/$currentUsername';
    }

    return dataBaseMethods.downloadFile(bucket, profileImageId);
  }



  @override
  void initState() {
    super.initState();
    profileImage = getProfileImage();
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
                      child: kIsWeb
                          ? Image.network(
                              im,
                              fit: BoxFit.fill,
                            )
                          : Image.file(
                              File(im),
                              fit: BoxFit.fill,
                            ),
                      width: 200,
                      height: 200,
                    ),
                    ElevatedButton(
                      onPressed: () => addProfileImage(),
                      child: Text('Ajouter photo de profile'),
                    ),
                    ElevatedButton(
                      child: const Text('Changer photo de profile'),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DisplayProfileImages()),
                        );
                      },
                    ),
                  ],
                ),
              );
            } else {
              return Text('doesnt have data');
            }
          })
    ]);
  }

  Future<void> changeProfileImage() async {
    //  DISPLAY ALL IMAGES IN gs://profile_images/<currentUsername>/

    // Use databaseMethods.updateUserFields(profileImageId : chosenImage)
  }

  Future<void> addProfileImage() async {
    XFile? image = await selectImageFromGallery();

    if (image == null) {
      throw Exception('an exception occured');
    } else {
      String postId = DateTime.now().millisecondsSinceEpoch.toString();
      String imageName = "post_$postId.jpg";
      String currentUsername = appState.currentUser.username;
      await dataBaseMethods.uploadFile(
          'profile_images/$currentUsername', imageName, image);
    }
  }

  Future<XFile?> selectImageFromGallery() async {
    final picker = ImagePicker();

    setState(() {
      inProcess = true;
    });

    Future<XFile?> xFile = picker.pickImage(source: ImageSource.gallery);

    setState(() {
      inProcess = false;
    });

    return xFile;
  }
}




// @todo make it StateLess???
class DisplayProfileImages extends StatefulWidget {
  @override
  _DisplayProfileImages createState() =>
      _DisplayProfileImages();

}

class _DisplayProfileImages extends State<DisplayProfileImages>{
  bool inProcess = false;
  late dynamic profileImages;
  DatabaseMethods dataBaseMethods = DatabaseMethods();


    buildImageProfileWraps(dynamic profileImages) async {
    List<Widget> r = [];

    dynamic storageReferences = profileImages.items;
    for (dynamic storageReference in storageReferences) {
      print("print storageReference");
      print(storageReference);

      String link = await storageReference.getDownloadURL();

      print("link");
      print(link);

      Widget w = Container(

        child:

        Wrap(
          children: [

            Image.network(link, fit: BoxFit.fill,),

            MaterialButton(
                onPressed: () => dataBaseMethods.updateTableField(storageReference, "profile_image_id", "updateUserField"),
            )

          ],


        ),

        width: 200,
        height: 200,

      );

      r.add(w);

    }

    return r;
  }



  getProfileImages() async {
    String currentUsername = appState.currentUser.username;
    String bucket = 'profile_images/$currentUsername';
    return dataBaseMethods.downloadFiles(bucket);
  }


  @override
  void initState() {
    super.initState();
    profileImages = getProfileImages();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile Images"),
      ),
      body: Column(children: [


        FutureBuilder(
          future: profileImages,
          builder: (context, AsyncSnapshot snapshot) {

            if (snapshot.hasData) {

              dynamic profileImagesList = snapshot.data;

              return Container(
                  child: Column(children: buildImageProfileWraps(profileImagesList))
              );

            }

            else {
              return Text('Votre album photo est vide');
            }

          },
        ),


        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);},
          child: Text('Go back!'),
        ),


      ],
      ),
    );
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
