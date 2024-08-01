import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:trendy_kart/services/database.dart';
import 'package:trendy_kart/widgets/support_widget.dart';

class Allorders extends StatefulWidget {
  const Allorders({super.key});

  @override
  State<Allorders> createState() => _AllordersState();
}

class _AllordersState extends State<Allorders> {
  Stream? orderStream;

  getOnTheLoad() async {
    orderStream = await DatabaseMethods().allOrders();
    setState(() {});
  }

  @override
  void initState() {
    getOnTheLoad();
    super.initState();
  }

  Widget allOrders() {
    return StreamBuilder(
      stream: orderStream,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data.docs[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    child: Material(
                      elevation: 3,
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: const EdgeInsets.only(
                            left: 20, top: 10, bottom: 10),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.network(
                              ds["ProductImage"],
                              height: 120,
                              width: 120,
                              fit: BoxFit.cover,
                            ),
                            const Spacer(),
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Name : " + ds["Name"],
                                    style: AppWidget.semiBoldTextFieldStyle(),
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width / 2,
                                    child: Text(
                                      "Email : " + ds["Email"],
                                      style:
                                          AppWidget.superLightTextFieldStyle(),
                                    ),
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width / 2,
                                    child: Text(
                                      ds["Product"],
                                      style: AppWidget.semiBoldTextFieldStyle(),
                                    ),
                                  ),
                                  Text(
                                    "Rs." + ds["Price"],
                                    style: const TextStyle(
                                      color: Color(0xFFFD6F3E),
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 6,),
                                  GestureDetector(
                                    onTap: ()async{
                                      await DatabaseMethods().updateStatus(ds.id);
                                      setState(() {
                                        
                                      });
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(vertical: 5),
                                      width: 150,
                                      decoration: BoxDecoration(color: Color(0xFFFD6F3E),borderRadius: BorderRadius.circular(10)),
                                      child: Center(child: Text("Done", style: AppWidget.semiBoldTextFieldStyle(),)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              )
            : Container();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "All Orders",
          style: AppWidget.boldTextFieldStyle(),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          children: [
            Expanded(
              child: allOrders(),
            )
          ],
        ),
      ),
    );
  }
}
