import 'dart:typed_data'; 
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:random_string/random_string.dart';
import 'package:recycle_app/pages/home.dart';
import 'package:recycle_app/services/database.dart';
import 'package:recycle_app/services/shared_pref.dart';
import 'package:recycle_app/services/widget_support.dart';

class UploadItem extends StatefulWidget {
  final String category, id;

  UploadItem({required this.category, required this.id});

  @override
  State<UploadItem> createState() => _UploadItemState();
}

class _UploadItemState extends State<UploadItem> {
  TextEditingController addressController = TextEditingController();
  TextEditingController quantityController = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  File? _imageFile;
  Uint8List? _webImage;
  String? imageUrl;

  String? id, name;

  getTheSharedPref() async {
    id = await SharedPreferenceHelper().getUserId();
    name = await SharedPreferenceHelper().getUserName();
    setState(() {});
  }

  @override
  void initState() {
    getTheSharedPref();
    super.initState();
  }

  Future<void> getImage() async {
    if (kIsWeb) {

      FilePickerResult? result =
      await FilePicker.platform.pickFiles(type: FileType.image);

      if (result != null) {
        _webImage = result.files.first.bytes;


        String fileName =
            "${DateTime.now().millisecondsSinceEpoch}_${result.files.first.name}";
        Reference storageRef =
        FirebaseStorage.instance.ref().child("uploads/$fileName");

        await storageRef.putData(_webImage!);

        String downloadUrl = await storageRef.getDownloadURL();
        setState(() {
          imageUrl = downloadUrl;
        });
      }
    } else {

      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);


        String fileName =
            "${DateTime.now().millisecondsSinceEpoch}_${pickedFile.name}";
        Reference storageRef =
        FirebaseStorage.instance.ref().child("uploads/$fileName");

        await storageRef.putFile(_imageFile!);

        String downloadUrl = await storageRef.getDownloadURL();
        setState(() {
          imageUrl = downloadUrl;
        });
      }
    }
  }

  Future<void> uploadItem() async {
    if (addressController.text.isEmpty ||
        quantityController.text.isEmpty ||
        imageUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text("Please upload image and fill all fields",
              style: AppWidget.whitetextstyle(18.0)),
        ),
      );
      return;
    }

    String itemid = randomAlphaNumeric(10);

    Map<String, dynamic> addItem = {
      "image": imageUrl,
      "Address": addressController.text,
      "Quantity": quantityController.text,
      "UserId": id,
      "Name": name,
      "Status": "pending",
    };

    await DatabaseMethods().addUserUploadItem(addItem, id!, itemid);
    await DatabaseMethods().addAdminItem(addItem, itemid);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        content: Text(
          "Item has been uploaded Successfully!",
          style: AppWidget.whitetextstyle(22.0),
        ),
      ),
    );

    setState(() {
      addressController.clear();
      quantityController.clear();
      _imageFile = null;
      _webImage = null;
      imageUrl = null;
    });

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Home()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 3,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Home()),
            );
          },
        ),
        title: Text("Upload Item", style: AppWidget.healinetextstyle(22.0)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(height: 20.0),
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                color: Color(0xFFececf8),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 30.0),
                    imageUrl != null
                        ? Center(
                      child: Container(
                        height: 180,
                        width: 180,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(imageUrl!,
                              fit: BoxFit.cover),
                        ),
                      ),
                    )
                        : GestureDetector(
                      onTap: getImage,
                      child: Center(
                        child: Container(
                          height: 180,
                          width: 180,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                                color: Colors.black45, width: 2.0),
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Icon(Icons.camera_alt_outlined,
                              size: 30.0),
                        ),
                      ),
                    ),

                    SizedBox(height: 50.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        "Enter your address you want the item to be picked",
                        style: AppWidget.normaltextstyle(18.0),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Material(
                        elevation: 2.0,
                        borderRadius: BorderRadius.circular(10.0),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: TextField(
                            controller: addressController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              prefixIcon:
                              Icon(Icons.location_on, color: Colors.green),
                              hintText: "Enter Address",
                              hintStyle: AppWidget.normaltextstyle(20.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 50.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        "Enter the Quantity of item to be picked",
                        style: AppWidget.normaltextstyle(18.0),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Material(
                        elevation: 2.0,
                        borderRadius: BorderRadius.circular(10.0),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: TextField(
                            controller: quantityController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              prefixIcon:
                              Icon(Icons.inventory, color: Colors.green),
                              hintText: "Enter Quantity",
                              hintStyle: AppWidget.normaltextstyle(20.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 60.0),
                    GestureDetector(
                      onTap: uploadItem,
                      child: Center(
                        child: Material(
                          elevation: 2.0,
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            height: 60,
                            width: MediaQuery.of(context).size.width / 1.5,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: Text(
                                "Upload",
                                style: AppWidget.whitetextstyle(26.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
