import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:trendy_kart/services/constants.dart';
import 'package:trendy_kart/services/database.dart';
import 'package:trendy_kart/services/shared_pref.dart';
import 'package:trendy_kart/widgets/support_widget.dart';
import 'package:http/http.dart' as http;

class Product extends StatefulWidget {

  String image, name, detail, price;

  Product({super.key, required this.image, required this.name, required this.detail, required this.price});

  @override
  State<Product> createState() => _ProductState();
}

class _ProductState extends State<Product> {
  
  String? name,email,image;

  getSharedPref() async{
    name=await SharedPreferenceHelper().getUserName();
    email=await SharedPreferenceHelper().getUserEmail();
    image=await SharedPreferenceHelper().getUserImage();
    setState(() {
      
    });
  }

  onTheLoad() async{
    await getSharedPref();
    setState(() {
      
    });
  }

  @override
  void initState() {
    super.initState();
    onTheLoad();
  }

  Map<String, dynamic>? paymentIntent;
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
                          Text("Rs.${widget.price}",
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
                      GestureDetector(
                        onTap: (){
                          makePayment(widget.price);
                        },
                        child: Container(
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

  Future<void> makePayment(String amount) async {
    try {
      paymentIntent = await createPaymentIntent(amount, 'INR');
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  paymentIntentClientSecret: paymentIntent?['client_secret'],
                  style: ThemeMode.dark,
                  merchantDisplayName: 'Samarth'))
          .then((value) {});
      displayPaymentSheet();
    } catch (err, s) {
      print('Exception:$err$s');
    }
  }

  displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) async {
        Map<String, dynamic> orderInfoMap={
          "Product" : widget.name,
          "Price" : widget.price,
          "Name" : name,
          "Email" : email,
          "Image" : image,
          "ProductImage" : widget.image,
          "Status" : "On the Way!"
        };
        await DatabaseMethods().orderDetails(orderInfoMap);

        showDialog(
            context: context,
            builder: (_) => const AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: Colors.green,
                          ),
                          Text("Payment Successfull!!"),
                        ],
                      )
                    ],
                  ),
                ));
        paymentIntent = null;
      }).onError((error, stackTrace) {
        print("Error:$error $stackTrace");
      });
    } 
    on StripeException catch (e) {
      print("Error: $e");
      showDialog(
          context: context,
          builder: (_) => const AlertDialog(
                content: Text("Cancelled!"),
              ));
    } catch (e) {
      print("$e");
    }
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card',
      };

      var response = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          headers: {
            'Authorization': 'Bearer $secretKey',
            'Content-Type': 'application/x-www-form-urlencoded',
          },
          body: body);
      return jsonDecode(response.body);
    } catch (err) {
      print('Error changing user!');
    }
  }

  calculateAmount(String amount) {
    final calculatedAmount = (int.parse(amount) * 100);
    return calculatedAmount.toString();
  }
}
