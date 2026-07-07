import 'package:flutter/material.dart';
import 'package:flutter_nearfix/login.dart';
import 'package:flutter_nearfix/signup.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF4F1E8),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 70),
            SvgPicture.asset('assets/images/logo2.svg', width: 350),
            SizedBox(height: 30),
            Text(
              "Find it, Fix it.",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF9FB2AC),
                padding: EdgeInsets.symmetric(horizontal: 170, vertical: 30),
              ),
              onPressed: () {
                setState(() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => login_page()),
                  );
                });
              },
              child: Text(
                "Login",
                style: TextStyle(
                  color: Color(0xFFF4F1E8),
                  fontSize: 20,
                  fontFamily: "Product Sans",
                ),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF5D0D18),
                padding: EdgeInsets.symmetric(horizontal: 170, vertical: 30),
              ),
              onPressed: () {
                setState(() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => sign_up()),
                  );
                });
              },
              child: Text(
                "Sign up",
                style: TextStyle(
                  color: Color(0xFFF4F1E8),
                  fontSize: 20,
                  fontFamily: "Product Sans",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
