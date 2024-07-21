import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:trendy_kart/admin/home_admin.dart';
import 'package:trendy_kart/widgets/support_widget.dart';

class AdminLogin extends StatefulWidget {
  const AdminLogin({super.key});

  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            margin: const EdgeInsets.only(
              left: 20,
              right: 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 5,
                ),
                Image.asset("images/login.png"),
                const SizedBox(height: 15,),
                Center(
                  child: Text(
                    "Admin Panel",
                    style: AppWidget.boldTextFieldStyle(),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  "Username",
                  style: AppWidget.semiBoldTextFieldStyle(),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.only(left: 20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4F5F9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextFormField(
                    controller: usernameController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Username",
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Password",
                  style: AppWidget.semiBoldTextFieldStyle(),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.only(left: 20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4F5F9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextFormField(
                    obscureText: true,
                    controller: passwordController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Password",
                    ),
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width / 2,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        loginAdmin();
                      },
                      child: const Center(
                        child: Text(
                          "LOGIN",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  loginAdmin() {
    FirebaseFirestore.instance.collection("Admin").get().then((snapshot){
      snapshot.docs.forEach((result){
        if(result.data()['username'] != usernameController.text.trim())
        {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              backgroundColor: Colors.red,
              content: Text(
                "Your username is not correct!",
                style: TextStyle(fontSize: 15),
              )));
        }
        else if(result.data()['password'] != passwordController.text.trim())
        {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              backgroundColor: Colors.red,
              content: Text(
                "Your password is not correct!",
                style: TextStyle(fontSize: 15),
              )));
        }
        else
        {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              backgroundColor: Colors.blueAccent,
              content: Text(
                "Logged in as Admin!",
                style: TextStyle(fontSize: 15),
              )));
          Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeAdmin()));
        }
      });
    });
  }
}