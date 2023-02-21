import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mkd_seller_app/global/global.dart';
import 'package:mkd_seller_app/splash/splash_screen.dart';

class EraningsScreen extends StatefulWidget {
  @override
  State<EraningsScreen> createState() => _EraningsScreenState();
}

class _EraningsScreenState extends State<EraningsScreen> {
  double sellerTotalEarnings = 0.0;
  sellerEarnings() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(sharedPreferences!.getString('uid'))
        .get()
        .then((snap) {
      setState(() {
        sellerTotalEarnings = double.parse(snap.data()!['earnings'].toString());
      });
    });
  }

  @override
  void initState() {
    super.initState();
    sellerEarnings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
          child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '₦ ' + sellerTotalEarnings.toString(),
              style: const TextStyle(
                  fontSize: 80, color: Colors.white, fontFamily: 'Signatra'),
            ),
            const Text(
              'Total Earnings',
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(
              height: 40,
              width: 200,
              child: Divider(
                thickness: 1.5,
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (c) => const MySplashScreen()));
              },
              child: const Card(
                color: Colors.white54,
                margin: EdgeInsets.symmetric(vertical: 60, horizontal: 110),
                child: ListTile(
                  leading: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                  title: Text('Back',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      )),
                ),
              ),
            )
          ],
        ),
      )),
    );
  }
}
