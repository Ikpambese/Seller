// ignore_for_file: depend_on_referenced_packages, use_key_in_widget_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mkd_seller_app/widget/progress_bar.dart';
import 'package:mkd_seller_app/widget/shipment.dart';
import 'package:mkd_seller_app/widget/status_barnner.dart';

import '../models/address.dart';

class OrderDeatilsScreen extends StatefulWidget {
  final String? orderID;
  const OrderDeatilsScreen({this.orderID});

  @override
  State<OrderDeatilsScreen> createState() => _OrderDeatilsScreenState();
}

class _OrderDeatilsScreenState extends State<OrderDeatilsScreen> {
  String orderStatus = '';
  String orderByUser = '';
  String sellerId = '';
  // String userId = '';

  getOrderInfo() {
    FirebaseFirestore.instance
        .collection('orders')
        .doc(widget.orderID)
        .get()
        // ignore: avoid_types_as_parameter_names
        .then((DocumentSnapshot) {
      orderStatus = DocumentSnapshot.data()!['status'].toString();
      orderByUser = DocumentSnapshot.data()!['orderBy'].toString();
      sellerId = DocumentSnapshot.data()!['sellerUID'].toString();
      //userId = DocumentSnapshot.data()!['userId'].toString();
    });
  }

  @override
  void initState() {
    super.initState();
    getOrderInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('orders')
              .doc(widget.orderID)
              .get(),
          builder: (c, snapshot) {
            Map? dataMap;

            if (snapshot.hasData) {
              dataMap = snapshot.data!.data() as Map<String, dynamic>;
              orderStatus = dataMap['status'].toString();
            }
            return snapshot.hasData
                ? Container(
                    child: Container(
                    child: Column(
                      children: [
                        StatusBarnner(
                          status: dataMap!["isSuccess"],
                          orderStatus: orderStatus,
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "€  " + dataMap["totalAmount"].toString(),
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Order Id = " + widget.orderID!,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            // ignore: prefer_interpolation_to_compose_strings
                            "Order at: " +
                                DateFormat("dd MMMM, yyyy - hh:mm aa").format(
                                    DateTime.fromMillisecondsSinceEpoch(
                                        int.parse(dataMap["orderTime"]))),
                            style: const TextStyle(
                                fontSize: 16, color: Colors.grey),
                          ),
                        ),
                        const Divider(
                          thickness: 4,
                        ),
                        orderStatus == "normal"
                            ? Image.asset("images/packing.png")
                            : Image.asset("images/delivered.jpg"),
                        const Divider(
                          thickness: 4,
                        ),
                        FutureBuilder<DocumentSnapshot>(
                          future: FirebaseFirestore.instance
                              .collection("users")
                              .doc(orderByUser)
                              .collection("userAddress")
                              .doc(dataMap["addressID"])
                              .get(),
                          builder: (c, snapshot) {
                            return snapshot.hasData
                                ? ShipmentAddressDesign(
                                    model: Address.fromJson(snapshot.data!
                                        .data()! as Map<String, dynamic>),
                                    orderStatus: orderStatus,
                                    orderId: widget.orderID,
                                    sellerId: sellerId,
                                    orderByUser: orderByUser,
                                  )
                                : Center(
                                    child: circularProgress(),
                                  );
                          },
                        ),
                      ],
                    ),
                  ))
                : Center(
                    child: circularProgress(),
                  );
          },
        ),
      ),
    );
  }
}
