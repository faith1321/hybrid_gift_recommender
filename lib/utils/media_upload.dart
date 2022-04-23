import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hybrid_gift/application_state.dart';
import 'package:hybrid_gift/utils/constants.dart';
import 'package:hybrid_gift/utils/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

/// Provides image taking and uploading functionalities.
class MediaUpload extends StatefulWidget {
  final int mediaCount;
  const MediaUpload({required this.mediaCount});

  @override
  _MediaUploadState createState() => _MediaUploadState();
}

class _MediaUploadState extends State<MediaUpload> {
  MediaUpload get widget => super.widget;

  final _firebaseStorage = FirebaseStorage.instance;
  List<String?> imageUrl = [];
  List<String> messages = [];

  void _uploadImage(String input, BuildContext context, int index) async {
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
            .child(
                'images/${context.read<ApplicationState>().getCurrentDisplayName()}/' +
                    index.toString())
            .putFile(file);
        dynamic downloadUrl = await snapshot.ref.getDownloadURL();
        setState(() {
          imageUrl.add(downloadUrl.toString());
        });
      } else {
        // print('No Image Path Received');
      }
    } else {
      // print('Permission not granted. Try Again with permission access');
    }
  }

  /// Retrieve the uploaded images.
  Future<List<Map<String, dynamic>>> _loadImages() async {
    List<Map<String, dynamic>> files = [];

    final ListResult result = await _firebaseStorage
        .ref()
        .child(
            'images/${context.read<ApplicationState>().getCurrentDisplayName()}/')
        .list();
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

  /// Delete the image from Firebase Storage
  ///  and refresh the interface.
  Future<void> _delete(String ref) async {
    await _firebaseStorage.ref(ref).delete();
    // Rebuild the UI
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Future<List<Map<String, dynamic>>> media = _loadImages();

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        mainAxisSpacing: kDefaultPaddin,
        crossAxisSpacing: kDefaultPaddin,
        // childAspectRatio: 0.75,
      ),
      itemCount: widget.mediaCount,
      itemBuilder: (context, index) {
        return FittedBox(
          child: Container(
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
            child: (imageUrl.isNotEmpty &&
                    index == (imageUrl.length - 1) &&
                    media != null)
                ? Image.network(imageUrl[index]!)
                : Column(
                    children: [
                      ElevatedButton.icon(
                        icon: const Icon(Icons.camera_enhance_rounded),
                        label: const Text("Camera"),
                        onPressed: () => _uploadImage("camera", context, index),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blue,
                          onPrimary: Colors.white,
                          elevation: 5.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: const BorderSide(color: Colors.blue),
                          ),
                          padding: const EdgeInsets.fromLTRB(
                            15,
                            15,
                            15,
                            15,
                          ),
                        ),
                      ),
                      const SizedBox(height: kDefaultPaddin),
                      ElevatedButton.icon(
                        onPressed: () =>
                            _uploadImage("gallery", context, index),
                        icon: const Icon(Icons.photo_library_rounded),
                        label: const Text("Gallery"),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.teal,
                          onPrimary: Colors.white,
                          elevation: 5.0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: const BorderSide(color: Colors.blue)),
                          padding: const EdgeInsets.fromLTRB(
                            15,
                            15,
                            15,
                            15,
                          ),
                        ),
                      ),
                      const SizedBox(height: kDefaultPaddin),
                      ElevatedButton.icon(
                        onPressed: () => _insertText(context, index),
                        icon: const Icon(Icons.textsms_rounded),
                        label: const Text("Text"),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.indigo,
                          onPrimary: Colors.white,
                          elevation: 5.0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: const BorderSide(color: Colors.blue)),
                          padding: const EdgeInsets.fromLTRB(
                            15,
                            15,
                            15,
                            15,
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }

  /// Handles adding text in the digital wrapping.
  Future<Widget> _insertText(BuildContext context, int index) async {
    Widget widget;
    List<String> text = [];
    final _formKey = GlobalKey<FormState>(debugLabel: '_insertText');
    final _controller = TextEditingController();
    final _state = context.read<ApplicationState>();

    await FirebaseFirestore.instance
        .doc("text/${_state.getCurrentDisplayName()}")
        .get()
        .then((snapshot) {
      Map<String, dynamic>? data = snapshot.data();
      if (data != null) text.add(data.values.toString());
    });

    setState(() {
      messages = text;
    });

    (messages.isNotEmpty && messages[index] != "")
        ? widget = Text(messages[index])
        : widget = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _formKey,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _controller,
                          decoration: const InputDecoration(
                            hintText: 'Leave a message',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter your message to continue';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      StyledButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            await _state.addMessageToUserBook(_controller.text);
                            _controller.clear();
                          }
                        },
                        child: Row(
                          children: const [
                            Icon(Icons.send),
                            SizedBox(width: 4),
                            Text('SEND'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
    return widget;
  }
}
