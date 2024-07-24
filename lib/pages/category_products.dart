import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:trendy_kart/pages/product.dart';
import 'package:trendy_kart/services/database.dart';
import 'package:trendy_kart/widgets/support_widget.dart';

class CategoryProducts extends StatefulWidget {
  String category;
  CategoryProducts({super.key, required this.category});

  @override
  State<CategoryProducts> createState() => _CategoryProductsState();
}

class _CategoryProductsState extends State<CategoryProducts> {
  Stream? CategoryStream;

  getOnTheLoad() async {
    CategoryStream = await DatabaseMethods().getProducts(widget.category);
    setState(() {
      
    });
  }

  @override
  void initState() {
    getOnTheLoad();
    super.initState();
  }

  Widget allProducts() {
    return StreamBuilder(
        stream: CategoryStream,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? GridView.builder(
                  padding: EdgeInsets.zero,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.6,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10),
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data.docs[index];
                    return Container(
                      margin: const EdgeInsets.only(left: 10,right: 10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 10),
                      child: Column(
                        children: [
                          const SizedBox(height: 15,),
                          Image.network(
                            ds["Image"],
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(height: 15,),
                          Text(
                            ds["Name"],
                            style: AppWidget.normalTextFieldStyle(),
                          ),
                          const Spacer(),
                          Row(
                            children: [
                              Text(
                                "Rs."+ds["Price"],
                                style: const TextStyle(
                                  color: Color(0xFFFD6F3E),
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                width: 30,
                              ),
                              GestureDetector(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => Product(image: ds["Image"], name: ds["Name"], detail: ds["Detail"], price: ds["Price"])));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: const Color(0xFFFD6F3E),
                                      borderRadius: BorderRadius.circular(12)),
                                  child: const Icon(
                                    Icons.add,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    );
                  },
                )
              : Container();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff2f2f2),
      appBar: AppBar(
        backgroundColor: const Color(0xfff2f2f2),
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(child: allProducts())
          ], 
        ),
      ),
    );
  }
}
