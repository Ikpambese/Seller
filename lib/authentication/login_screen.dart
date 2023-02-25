// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mkd_seller_app/authentication/auth_screen.dart';
import 'package:mkd_seller_app/global/global.dart';
import 'package:mkd_seller_app/screens/home_screen.dart';
import 'package:mkd_seller_app/widget/custom_text_field.dart';
import 'package:mkd_seller_app/widget/error_dialoge.dart';
import 'package:mkd_seller_app/widget/loading_dialog.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // FORM COONTROLLERS

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  formValidation() {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      // Login

      loginNow();
    } else {
      showDialog(
          context: context,
          builder: (c) {
            return ErroDialog(
              message: 'Email or password is empty',
            );
          });
    }
  }

  //LOGIN FUNCTION

  loginNow() async {
    showDialog(
        context: context,
        builder: (c) {
          return LoadingDialog(
            message: 'Checking credentials',
          );
        });

    User? currentUser;

    await firebaseAuth
        .signInWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim())
        .then((auth) {
      currentUser = auth.user;
    }).catchError((error) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (c) {
            return ErroDialog(
              message: error.message.toString(),
            );
          });
    });

    if (currentUser != null) {
      readDataAndSaveLocally(currentUser!);
    }
  }

  Future readDataAndSaveLocally(User currentUser) async {
    await FirebaseFirestore.instance
        .collection('sellers')
        .doc(currentUser.uid)
        .get()
        .then((snapshot) async {
      if (snapshot.exists) {
        if (snapshot.data()!['sellerSatus'] == 'approved') {
          await sharedPreferences!.setString('uid', currentUser.uid);
          await sharedPreferences!
              .setString('email', snapshot.data()!['sellerEmail']);
          await sharedPreferences!
              .setString('name', snapshot.data()!['sellerName']);
          await sharedPreferences!
              .setString('photoUrl', snapshot.data()!['sellerAvatarUrl']);
          Navigator.pop(context);
          Navigator.push(
              context, MaterialPageRoute(builder: (c) => const HomeScreen()));
        } else {
          firebaseAuth.signOut();
          Navigator.pop(context);
          Fluttertoast.showToast(
              msg:
                  'Admin has blocked this account \n\n Mail Here : admin@lunchbox.com');
        }
      } else {
        firebaseAuth.signOut();
        Navigator.pop(context);
        Navigator.push(
            context, MaterialPageRoute(builder: (c) => const AuthScreen()));
        showDialog(
            context: context,
            builder: (c) {
              return ErroDialog(
                message: 'No records found',
              );
            });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Image.asset(
                'images/seller.png',
                height: 270,
              ),
            ),
          ),
          Form(
            key: _formKey,
            child: Column(
              children: [
                CustomTextField(
                  data: Icons.email,
                  controller: emailController,
                  hintText: 'Email',
                  isObscure: false,
                ),
                CustomTextField(
                  data: Icons.lock,
                  controller: passwordController,
                  hintText: 'Password',
                  isObscure: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () => formValidation(),
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 10)),
            child: const Text(
              'Login',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
