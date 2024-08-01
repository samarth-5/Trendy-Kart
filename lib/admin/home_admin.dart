import 'package:flutter/material.dart';
import 'package:trendy_kart/admin/allOrders.dart';
import 'package:trendy_kart/pages/add_product.dart';
import 'package:trendy_kart/widgets/support_widget.dart';

class HomeAdmin extends StatefulWidget {
  const HomeAdmin({super.key});

  @override
  State<HomeAdmin> createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff2f2f2),
      appBar: AppBar(
        backgroundColor: const Color(0xfff2f2f2),
        title: Text(
          "Home Admin",
          style: AppWidget.boldTextFieldStyle(),
        ),
      ),
      body: Container(
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>const AddProduct()));
              },
              child: Material(
                elevation: 3,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.add,
                        size: 30,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Text(
                        "Add Product",
                        style: AppWidget.semiBoldTextFieldStyle(),
                      )
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(
              height: 30,
            ),
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>const Allorders()));
              },
              child: Material(
                elevation: 3,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.shopping_bag_outlined,
                        size: 30,
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Text(
                        "All Orders",
                        style: AppWidget.semiBoldTextFieldStyle(),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
