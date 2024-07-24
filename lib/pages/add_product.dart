import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';
import 'package:trendy_kart/services/database.dart';
import 'package:trendy_kart/widgets/support_widget.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final ImagePicker _picker = ImagePicker();
  File? selectedImage;
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController detailController = TextEditingController();

  Future getImage() async {
    var image = await _picker.pickImage(source: ImageSource.gallery);
    selectedImage = File(image!.path);
    setState(() {});
  }

  uploadItem() async {
    if (selectedImage != null && nameController.text != "") {
      String addId = randomAlphaNumeric(10);
      Reference firebaseStorageRef =
          FirebaseStorage.instance.ref().child("blogImage").child(addId);
      final UploadTask task = firebaseStorageRef.putFile(selectedImage!);
      TaskSnapshot snapshot = await task;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      Map<String, dynamic> addProduct = {
        "Name": nameController.text,
        "Image": downloadUrl,
        "Price": priceController.text,
        "Detail": detailController.text
      };
      await DatabaseMethods().addProduct(addProduct, value!).then((value) {
        selectedImage = null;
        nameController.text = "";
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.blueAccent,
            content: Text(
              "Product has been uploaded Successfully!!",
              style: TextStyle(fontSize: 15),
            ),
          ),
        );
      });
    }
  }

  String? value = "";
  final List<String> categoryItems = [
    'Watch',
    'Laptop',
    'TV',
    'Headphones',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back_ios_new_outlined),
        ),
        title: Text(
          "Add Product",
          style: AppWidget.boldTextFieldStyle(),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin:
              const EdgeInsets.only(left: 20, top: 20, right: 20, bottom: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Upload the Product Image",
                style: AppWidget.lightTextFieldStyle(),
              ),
              const SizedBox(
                height: 20,
              ),
              (selectedImage == null)
                  ? GestureDetector(
                      onTap: () {
                        getImage();
                      },
                      child: Center(
                        child: Container(
                          height: 150,
                          width: 150,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 1.5),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(Icons.camera_alt_outlined),
                        ),
                      ),
                    )
                  : Center(
                      child: Material(
                        elevation: 4.0,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          height: 150,
                          width: 150,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 1.5),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.file(
                                selectedImage!,
                                fit: BoxFit.cover,
                              )),
                        ),
                      ),
                    ),
              const SizedBox(
                height: 20,
              ),
              Text(
                "Product Name",
                style: AppWidget.lightTextFieldStyle(),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: const Color(0xFFececf8),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: TextField(
                  controller: nameController,
                  decoration: const InputDecoration(border: InputBorder.none),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                "Product Price",
                style: AppWidget.lightTextFieldStyle(),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: const Color(0xFFececf8),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: TextField(
                  controller: priceController,
                  decoration: const InputDecoration(border: InputBorder.none),
                ),
              ),
              
              const SizedBox(
                height: 20,
              ),
              Text(
                "Product Category",
                style: AppWidget.lightTextFieldStyle(),
              ),
              // Container(
              //   padding: const EdgeInsets.symmetric(horizontal: 10),
              //   width: MediaQuery.of(context).size.width,
              //   decoration: BoxDecoration(
              //     color: const Color(0xFFececf8),
              //     borderRadius: BorderRadius.circular(15),
              //   ),
              //   child: DropdownButtonHideUnderline(
              //     child: DropdownButton<String>(
              //       items: categoryItems
              //           .map((item) => DropdownMenuItem(
              //                 value: item,
              //                 child: Text(
              //                   item,
              //                   style: AppWidget.normalTextFieldStyle(),
              //                 ),
              //               ))
              //           .toList(),
              //       onChanged: ((value) => setState(() {
              //             this.value = value;
              //           })),
              //       dropdownColor: Colors.white,
              //       hint: const Text("Select category"),
              //       iconSize: 36,
              //       icon: const Icon(
              //         Icons.arrow_drop_down,
              //         color: Colors.black,
              //       ),
              //       value: value,
              //     ),
              //   ),
              // ),
              const SizedBox(
                height: 20,
              ),
              Text(
                "Product Details",
                style: AppWidget.lightTextFieldStyle(),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: const Color(0xFFececf8),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: TextField(
                  maxLines: 6,
                  controller: detailController,
                  decoration: const InputDecoration(border: InputBorder.none),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Center(
                  child: ElevatedButton(
                onPressed: () {
                  uploadItem();
                },
                child: const Text(
                  "Add Product",
                  style: TextStyle(fontSize: 20),
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
