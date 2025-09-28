import 'package:flutter/material.dart';
import 'package:recycle_app/services/auth.dart';
import 'package:recycle_app/services/widget_support.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: size.height * 0.03),

                // Login Top Image
                Image.asset(
                  "images/login.png",
                  // height: size.height * 0.3,
                  width: size.width,
                  fit: BoxFit.fitWidth,
                ),

                SizedBox(height: size.height * 0.03),

                // Recycle Icon
                Image.asset(
                  "images/recycle1.png",
                  height: size.height * 0.12,
                  width: size.height * 0.12,
                  fit: BoxFit.contain,
                ),

                SizedBox(height: size.height * 0.02),

                // Headline Text
                Text(
                  "Reduce. Reuse. Recycle.",
                  style: AppWidget.healinetextstyle(size.width * 0.055),
                  textAlign: TextAlign.center,
                ),
                Text(
                  "Repeat!",
                  style: AppWidget.greentextstyle(size.width * 0.075),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: size.height * 0.03),

                // Subtext
                Text(
                  "Every item you recycle\nMakes a difference",
                  textAlign: TextAlign.center,
                  style: AppWidget.normaltextstyle(size.width * 0.045),
                ),
                Text(
                  "Get Started!",
                  style: AppWidget.greentextstyle(size.width * 0.055),
                ),

                SizedBox(height: size.height * 0.04),

                // Google Sign-In Button
                GestureDetector(
                  onTap: () {
                    AuthMethods().signInWithGoogle(context);
                  },
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                        vertical: size.height * 0.018, horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(16.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        )
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Image.asset(
                            "images/google.png",
                             height: size.height *0.03,
                            width: size.height * 0.03,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(width: 12),
                        Flexible(
                          child: Text(
                            "Sign in with Google",
                            style: AppWidget.whitetextstyle(size.width * 0.05),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: size.height * 0.03),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
