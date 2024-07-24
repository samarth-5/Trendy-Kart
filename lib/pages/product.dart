import 'package:flutter/material.dart';
import 'package:trendy_kart/widgets/support_widget.dart';

class Product extends StatefulWidget {

  String image, name, detail, price;

  Product({super.key, required this.image, required this.name, required this.detail, required this.price});

  @override
  State<Product> createState() => _ProductState();
}

class _ProductState extends State<Product> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFfef5f1),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.only(top: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(left: 20),
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Icon(Icons.arrow_back_ios_new_outlined),
                    ),
                  ),
                  Center(
                    child: Image.network(
                      widget.image,
                      height: 400,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                    ),
                  ),
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.name,
                            style: AppWidget.productTextFieldStyle(),
                          ),
                          Text("Rs.+${widget.price}",
                            style: const TextStyle(
                              color: Color(0xFFFD6F3E),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Details",
                        style: AppWidget.semiBoldTextFieldStyle(),
                      ),
                      Text(widget.detail),
                      const SizedBox(height: 50,),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFD6F3E),
                          borderRadius: BorderRadius.circular(10)
                        ),
                        width: MediaQuery.of(context).size.width,
                        child: const Center(
                          child: Text(
                            "Buy Now",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
