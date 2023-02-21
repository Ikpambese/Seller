import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences? sharedPreferences;
String previousEarnings = '';
FirebaseAuth firebaseAuth = FirebaseAuth.instance;
