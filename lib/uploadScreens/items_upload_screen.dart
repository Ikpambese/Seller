import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mkd_seller_app/global/global.dart';
import 'package:mkd_seller_app/models/menu_model.dart';
import 'package:mkd_seller_app/screens/home_screen.dart';
import 'package:mkd_seller_app/widget/progress_bar.dart';
import '../widget/error_dialoge.dart';
import 'package:firebase_storage/firebase_storage.dart' as storageRef;

class ItemsUploadScreen extends StatefulWidget {
  Menus? model;
  ItemsUploadScreen({this.model});

  @override
  State<ItemsUploadScreen> createState() => _ItemsUploadScreenState();
}

class _ItemsUploadScreenState extends State<ItemsUploadScreen> {
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
          'Add New Item',
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
              child: const Text('Add New Item'),
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

  itemsUploadForm() {
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
          'Uploading New Item',
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
                  hintText: 'Info',
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
                  hintText: 'Title',
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
        const Divider(
          thickness: 2,
          color: Colors.blue,
        ),
        ListTile(
          leading: const Icon(
            Icons.description,
            color: Colors.cyan,
          ),
          title: SizedBox(
            height: 25,
            child: TextField(
              style: const TextStyle(color: Colors.black),
              controller: descriptionController,
              decoration: const InputDecoration(
                  hintText: 'Description',
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
        const Divider(
          thickness: 2,
          color: Colors.blue,
        ),
        ListTile(
          leading: const Icon(
            Icons.money,
            color: Colors.cyan,
          ),
          title: SizedBox(
            height: 25,
            child: TextField(
              style: const TextStyle(color: Colors.black),
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                  hintText: 'Price',
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
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  clearMenuUploadForm() {
    setState(() {
      shortInfoController.clear();
      descriptionController.clear();
      titleController.clear();
      priceController.clear();
      titleController.clear();
      imageXFile = null;
    });
  }

//
  validateUploadForm() async {
    if (imageXFile != null) {
      if (shortInfoController.text.isNotEmpty &&
          titleController.text.isNotEmpty &&
          descriptionController.text.isNotEmpty &&
          priceController.text.isNotEmpty) {
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
        storageRef.FirebaseStorage.instance.ref().child('items');
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
        .collection('menus')
        .doc(widget.model!.menuID)
        .collection('items');
    // using shared preferece

    ref.doc(uniqueIdName).set({
      'itemID': uniqueIdName,
      'menuId': widget.model!.menuID,
      'sellerUID': sharedPreferences!.getString('uid'),
      'sellerName': sharedPreferences!.getString('name'),
      'shortInfo': shortInfoController.text.toString(),
      'longDescription': descriptionController.text.toString(),
      'price': int.parse(priceController.text),
      'title': titleController.text.trim().toString(),
      'publishedDate': DateTime.now(),
      'status': 'available',
      'thumbnailUrl': downloadUrl,
    }).then((value) {
      final itemsRef = FirebaseFirestore.instance.collection('items');
      itemsRef.doc(uniqueIdName).set({
        'itemID': uniqueIdName,
        'menuId': widget.model!.menuID,
        'sellerUID': sharedPreferences!.getString('uid'),
        'sellerName': sharedPreferences!.getString('name'),
        'shortInfo': shortInfoController.text.toString(),
        'longDescription': descriptionController.text.toString(),
        'price': int.parse(priceController.text),
        'title': titleController.text.trim().toString(),
        'publishedDate': DateTime.now(),
        'status': 'available',
        'thumbnailUrl': downloadUrl,
      });
    }).then((value) => {
          setState(() {
            clearMenuUploadForm();
            uniqueIdName = DateTime.now().millisecondsSinceEpoch.toString();
            uploading = false;
          })
        });

    // setState(() {
    //   clearMenuUploadForm();
    //   uniqueIdName = DateTime.now().millisecondsSinceEpoch.toString();
    //   uploading = false;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return imageXFile == null ? defaultScreen() : itemsUploadForm();
  }
}
