import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hybrid_gift/application_state.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

class ImageUpload extends StatefulWidget {
  @override
  _ImageUploadState createState() => _ImageUploadState();
}

class _ImageUploadState extends State<ImageUpload> {
  final _firebaseStorage = FirebaseStorage.instance;
  String imageUrl = "";

  void _uploadImage(String input, BuildContext context) async {
    final _imagePicker = ImagePicker();
    XFile? image;

    //Check Permissions
    await Permission.photos.request();
    var permissionStatus = await Permission.photos.status;

    if (permissionStatus.isGranted) {
      //Select Image
      image = (await _imagePicker.pickImage(
          source:
              input == "camera" ? ImageSource.camera : ImageSource.gallery));
      File file = File(image!.path);

      if (image != null) {
        //Upload to Firebase
        var snapshot = await _firebaseStorage
            .ref()
            .child('images/${context.select(
              (ApplicationState _state) => _state.getCurrentDisplayName(),
            )} ')
            .putFile(file);
        dynamic downloadUrl = await snapshot.ref.getDownloadURL();
        setState(() {
          imageUrl = downloadUrl.toString();
        });
      } else {
        // print('No Image Path Received');
      }
    } else {
      // print('Permission not granted. Try Again with permission access');
    }
  }

  // Retriew the uploaded images
  // This function is called when the app launches for the first time or when an image is uploaded or deleted
  Future<List<Map<String, dynamic>>> _loadImages() async {
    List<Map<String, dynamic>> files = [];

    final ListResult result = await _firebaseStorage.ref().list();
    final List<Reference> allFiles = result.items;

    await Future.forEach<Reference>(allFiles, (file) async {
      final String fileUrl = await file.getDownloadURL();
      files.add(<String, dynamic>{
        "url": fileUrl,
        "path": file.fullPath,
      });
    });

    return files;
  }

  // Deletes the selected image.
  // This function is called when a trash icon is pressed.
  Future<void> _delete(String ref) async {
    await _firebaseStorage.ref(ref).delete();
    // Rebuild the UI
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(CupertinoIcons.back),
            color: Colors.white,
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.all(15),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(15),
                  ),
                  border: Border.all(color: Colors.white),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      offset: Offset(2, 2),
                      spreadRadius: 2,
                      blurRadius: 1,
                    ),
                  ],
                ),
                child: Stack(
                  children: <Widget>[
                    const Center(child: Icon(Icons.image)),
                    Center(
                      child: (imageUrl != null)
                          ? Image.network(imageUrl)
                          : Row(
                              children: [
                                ElevatedButton.icon(
                                    icon: const Icon(
                                        Icons.camera_enhance_rounded),
                                    label: const Text("Camera"),
                                    onPressed: () =>
                                        _uploadImage("camera", context),
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.blue,
                                      onPrimary: Colors.white,
                                      elevation: 5.0,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18.0),
                                          side: const BorderSide(
                                              color: Colors.blue)),
                                      padding: const EdgeInsets.fromLTRB(
                                          15, 15, 15, 15),
                                    )),
                                ElevatedButton.icon(
                                  onPressed: () =>
                                      _uploadImage("gallery", context),
                                  icon: const Icon(Icons.photo_library_rounded),
                                  label: const Text("Gallery"),
                                ),
                              ],
                            ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
            ],
          ),
        ));
  }
}
