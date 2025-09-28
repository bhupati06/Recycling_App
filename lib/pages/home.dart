import 'package:flutter/material.dart';
import 'package:recycle_app/pages/upload_item.dart';
import 'package:recycle_app/services/shared_pref.dart';
import 'package:recycle_app/services/widget_support.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? id;

  getTheSharedpref() async {
    id = await SharedPreferenceHelper().getUserId();
    if (id == null) {
      await SharedPreferenceHelper().saveUserId("user123");
      id = await SharedPreferenceHelper().getUserId();
    }
    print("Loaded user ID: $id");
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getTheSharedpref();
  }

  Widget categoryCard(String category, String imagePath) {
    return GestureDetector(
      onTap: () {
        if (id == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("User ID not loaded yet. Please wait...")),
          );
          return;
        }
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UploadItem(category: category, id: id!),
          ),
        );
      },
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Color(0xFFececf8),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.black45, width: 2.0),
            ),
            child: Image.asset(imagePath, height: 70, width: 70, fit: BoxFit.cover),
          ),
          SizedBox(height: 5.0),
          Text(category, style: AppWidget.normaltextstyle(20.0)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SizedBox(width: 5.0),
                  Image.asset("images/wave.png", height: 40, width: 40, fit: BoxFit.cover),
                  Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: Text("hello,", style: AppWidget.healinetextstyle(26.0)),
                  ),
                  Text("Bhavesh,", style: AppWidget.greentextstyle(25.0)),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image.asset("images/boy.jpg", height: 60, width: 60, fit: BoxFit.cover),
                    ),
                  )
                ],
              ),
              SizedBox(height: 30.0),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Image.asset("images/home.png"),
                ),
              ),
              SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text("Categories", style: AppWidget.healinetextstyle(22.0)),
              ),
              SizedBox(height: 20.0),
              Container(
                padding: EdgeInsets.only(left: 20.0),
                height: 130,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    categoryCard("Plastic", "images/plastic.png"),
                    SizedBox(width: 30.0),
                    categoryCard("Paper", "images/paper.png"),
                    SizedBox(width: 30.0),
                    categoryCard("Battery", "images/battery.png"),
                    SizedBox(width: 30.0),
                    categoryCard("Glass", "images/glass.png"),
                  ],
                ),
              ),
              SizedBox(height: 10.0),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text("Pending Request", style: AppWidget.healinetextstyle(22.0)),
              ),
              SizedBox(height: 20.0),
              Container(
                margin: EdgeInsets.only(left: 20.0, right: 20.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black45, width: 2.0),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Column(
                  children: [
                    SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.location_on, color: Colors.green, size: 30.0),
                        SizedBox(width: 10),
                        Text("New Market, Bhopal", style: AppWidget.normaltextstyle(20.0)),
                      ],
                    ),
                    Divider(),
                    Image.asset("images/chips.png", height: 150, width: 150, fit: BoxFit.cover),
                    SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.layers, color: Colors.green, size: 30.0),
                        SizedBox(width: 10.0),
                        Text("3", style: AppWidget.normaltextstyle(24.0)),
                      ],
                    ),
                    SizedBox(height: 10.0),
                  ],
                ),
              ),
              SizedBox(height: 30.0),
            ],
          ),
        ),
      ),
    );
  }
}
