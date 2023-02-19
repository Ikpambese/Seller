import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mkd_seller_app/global/global.dart';
import 'package:mkd_seller_app/screens/home_screen.dart';
import 'package:mkd_seller_app/widget/progress_bar.dart';
import '../widget/error_dialoge.dart';
import 'package:firebase_storage/firebase_storage.dart' as storageRef;

class MenuUploadScreen extends StatefulWidget {
  const MenuUploadScreen({super.key});

  @override
  State<MenuUploadScreen> createState() => _MenuUploadScreenState();
}

class _MenuUploadScreenState extends State<MenuUploadScreen> {
  XFile? imageXFile;
  final ImagePicker _Picker = ImagePicker();
  bool uploading = false;
  String uniqueIdName = DateTime.now().millisecondsSinceEpoch.toString();
  defaultScreen() {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.cyan,
                Colors.amber,
              ],
              begin: FractionalOffset(0.0, 0.0),
              end: FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            ),
          ),
        ),
        title: const Text(
          'Add New Menu',
          style: TextStyle(fontSize: 30, fontFamily: 'Lobster'),
        ),
        centerTitle: true,
        //automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()));
            },
            icon: const Icon(Icons.arrow_back_ios_new)),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.black,
              Colors.blue,
            ],
            begin: FractionalOffset(0.0, 0.0),
            end: FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          ),
        ),
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.shop_2,
              size: 200.0,
              color: Colors.white,
            ),
            ElevatedButton(
              onPressed: () {
                takeImage(context);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.amber),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              child: const Text('Add New Menu'),
            ),
          ],
        )),
      ),
    );
  }

  takeImage(nContext) {
    return showDialog(
        context: nContext,
        builder: ((context) {
          return SimpleDialog(
            title: const Text(
              'Menu Image',
              style:
                  TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
            ),
            children: [
              SimpleDialogOption(
                onPressed: captureWithCamera,
                child: const Text(
                  'Capture with Camera',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              SimpleDialogOption(
                onPressed: pickImageFromGallery,
                child: const Text(
                  'Gallery',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              SimpleDialogOption(
                child: const Text(
                  'Canel',
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        }));
  }

// Cappture with Camera funtion

  captureWithCamera() async {
    Navigator.pop(context);
    imageXFile = await _Picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 720,
      maxWidth: 1280,
    );
    setState(() {
      imageXFile;
    });
  }

  pickImageFromGallery() async {
    Navigator.pop(context);
    imageXFile = await _Picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 720,
      maxWidth: 1280,
    );
    setState(() {
      imageXFile;
    });
  }

  menusUploadFormScreen() {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.cyan,
                Colors.amber,
              ],
              begin: FractionalOffset(0.0, 0.0),
              end: FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            ),
          ),
        ),
        title: const Text(
          'Uploading New Menu',
          style: TextStyle(fontSize: 20, fontFamily: 'Lobster'),
        ),
        centerTitle: true,
        //automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              clearMenuUploadForm();
            },
            icon: const Icon(Icons.arrow_back_ios_new)),
        actions: [
          TextButton(
            onPressed: uploading ? null : () => validateUploadForm(),
            child: const Text(
              'Add',
              style: TextStyle(
                  color: Colors.cyan,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  fontFamily: 'Lobster',
                  letterSpacing: 3),
            ),
          ),
        ],
      ),
      body: ListView(children: [
        uploading == true ? horizontalProgress() : const Text(''),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: Center(
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: FileImage(
                        File(imageXFile!.path),
                      ),
                      fit: BoxFit.cover),
                ),
              ),
            ),
          ),
        ),
        const Divider(
          thickness: 2,
          color: Colors.blue,
        ),
        ListTile(
          leading: const Icon(
            Icons.perm_device_information,
            color: Colors.cyan,
          ),
          title: SizedBox(
            height: 25,
            child: TextField(
              style: const TextStyle(color: Colors.black),
              controller: shortInfoController,
              decoration: const InputDecoration(
                  hintText: 'Menu Info',
                  hintStyle: TextStyle(
                    color: Colors.grey,
                  ),
                  border: InputBorder.none),
            ),
          ),
        ),
        const Divider(
          thickness: 2,
          color: Colors.blue,
        ),
        ListTile(
          leading: const Icon(
            Icons.title,
            color: Colors.cyan,
          ),
          title: SizedBox(
            height: 25,
            child: TextField(
              style: const TextStyle(color: Colors.black),
              controller: titleController,
              decoration: const InputDecoration(
                  hintText: 'Menu Title',
                  hintStyle: TextStyle(
                    color: Colors.grey,
                  ),
                  border: InputBorder.none),
            ),
          ),
        ),
        const Divider(
          thickness: 2,
          color: Colors.blue,
        ),
      ]),
    );
  }

  final TextEditingController shortInfoController = TextEditingController();
  final TextEditingController titleController = TextEditingController();

  clearMenuUploadForm() {
    setState(() {
      shortInfoController.clear();
      titleController.clear();
      imageXFile = null;
    });
  }

//
  validateUploadForm() async {
    if (imageXFile != null) {
      if (shortInfoController.text.isNotEmpty &&
          titleController.text.isNotEmpty) {
        setState(() {
          uploading = true;
        });
        // DO UPLOADS

        String downloadUrl = await uploadImage(File(imageXFile!.path));
        // SAVE TO FIRE STORE

        saveInfo(downloadUrl);
      } else {
        showDialog(
            context: context,
            builder: (c) {
              return ErroDialog(
                message: 'One or more fields are empty',
              );
            });
      }
    } else {
      showDialog(
          context: context,
          builder: (c) {
            return ErroDialog(
              message: 'Pick an Image',
            );
          });
    }
  }

  uploadImage(mImageFile) async {
    storageRef.Reference reference =
        storageRef.FirebaseStorage.instance.ref().child('menus');
    storageRef.UploadTask uploadTask =
        reference.child(uniqueIdName + '.jpg').putFile(mImageFile);
    storageRef.TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();

    return downloadUrl;
  }

  void saveInfo(String downloadUrl) {
    final ref = FirebaseFirestore.instance
        .collection('sellers')
        //.doc(firebaseAuth.currentUser!.uid); // using shared preferece
        .doc(sharedPreferences!.getString('uid'))
        .collection('menus');
    // using shared preferece

    ref.doc(uniqueIdName).set({
      'menuID': uniqueIdName,
      'sellerUID': sharedPreferences!.getString('uid'),
      'menuInfo': shortInfoController.text.toString(),
      'menuTitle': titleController.text.trim().toString(),
      'publishedDate': DateTime.now(),
      'status': 'available',
      'thumbnailUrl': downloadUrl,
    });

    setState(() {
      clearMenuUploadForm();
      uniqueIdName = DateTime.now().millisecondsSinceEpoch.toString();
      uploading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return imageXFile == null ? defaultScreen() : menusUploadFormScreen();
  }
}
