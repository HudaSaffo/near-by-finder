import 'package:flutter/material.dart';
import 'package:flutter_nearfix/customerHome.dart';
import 'package:flutter_nearfix/signup.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_nearfix/serviceDashboard.dart';


class login_page extends StatefulWidget {
  const login_page({super.key});

  @override
  State<login_page> createState() => _login_pageState();
}

class _login_pageState extends State<login_page> {
  @override
  final k = GlobalKey<FormState>();
  final supa = Supabase.instance.client;


  TextEditingController c1 = TextEditingController();
  TextEditingController c2 = TextEditingController();
  bool r = true;


  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF4F1E8),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            SizedBox(height: 30),

            IconButton(
              padding: EdgeInsets.all(40),
              onPressed: () {
                setState(() {
                  Navigator.pop(context);
                });
              },
              icon: Icon(Icons.navigate_before, size: 50),
            ),
            SizedBox(height: 20),

            Form(
              key: k,
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 40),
                      child: Text(
                        "Email",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      width: 475,
                      height: 55,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 40),
                        child: TextFormField(
                          validator: v1,
                          controller: c1,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 20,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            prefix: Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Icon(Icons.email),
                            ),
                            label: Text(
                              "Email",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(left: 30),
                      child: Text(
                        "Password",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    SizedBox(
                      width: 475,
                      height: 55,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 40),
                        child: TextFormField(
                          validator: v2,
                          controller: c2,
                          obscureText: r,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 20,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            prefix: Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Icon(Icons.password),
                            ),
                            label: Text(
                              "Password",
                              style: TextStyle(color: Colors.grey),
                            ),
                            suffix: IconButton(
                              onPressed: () {
                                setState(() {
                                  r = !r;
                                });
                              },
                              icon: Icon(
                                r ? Icons.visibility_off : Icons.visibility,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),


                  ],
                ),
              ),
            ),
            SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.only(left: 45),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF9FB2AC),
                  padding: EdgeInsets.symmetric(horizontal: 190, vertical: 20),
                ),
                onPressed: () async {
                  setState(() {



                  });


                  if (k.currentState!.validate()) {

                    try {
                      final data = await supa.auth.signInWithPassword(
                        email: c1.text,
                        password: c2.text,
                      );

                      final user_id=data.user!.id;

                      final customer = await supa.from("customers")
                          .select()
                          .eq('id', user_id)
                          .maybeSingle();



                      if (customer != null) {
                        Navigator.pushNamedAndRemoveUntil(context, '/home',(route) => false);

                      }else{
                        Navigator.pushNamedAndRemoveUntil(context, '/dashboard',(route)=>false);

                      }
                    }catch(e){
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text("Invalid email or password")));

                    }
                  }

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
            ),
            SizedBox(height: 30),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 115, right: 10),
                  child: SizedBox(
                    width: 90,
                    child: Divider(thickness: 2, color: Colors.grey),
                  ),
                ),
                Text("Or continue with"),
                Container(
                  margin: EdgeInsets.only(left: 10, right: 10),
                  child: SizedBox(
                    width: 90,
                    child: Divider(thickness: 2, color: Colors.grey),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 140),
                  child: IconButton(
                    onPressed: () {},
                    icon: SvgPicture.asset(
                      "assets/images/google.svg",
                      width: 40,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 30),
                  child: IconButton(
                    onPressed: () {},
                    icon: SvgPicture.asset("assets/images/x.svg", width: 50),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 30),
                  child: IconButton(
                    onPressed: () {},
                    icon: SvgPicture.asset(
                      "assets/images/facebook.svg",
                      width: 50,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 35),
            Container(
              margin: EdgeInsets.only(left: 170, bottom: 50),
              child: RichText(
                text: TextSpan(
                  text: "Don't have an account?",
                  style: TextStyle(color: Colors.black),
                  children: [
                    TextSpan(
                      text: " Sign Up",
                      style: TextStyle(color: Colors.grey),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => sign_up()),
                          );
                        },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String? v1(String? n) {
    if (n == null || n.isEmpty) {
      return "Please enter your email";
    }
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!regex.hasMatch(n)) {
      return "Please enter a valid email address,ex:you@gmail.com";
    }
    return null;
  }

  String? v2(String? n) {
    if (n == null || n.isEmpty) {
      return "Please enter your password";
    }

    return null;
  }
}
