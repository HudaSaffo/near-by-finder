import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nearfix/login.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


String role = "Customer";
class sign_up extends StatefulWidget {
  const sign_up({super.key});

  @override
  State<sign_up> createState() => _sign_upState();
}

class _sign_upState extends State<sign_up> {
  @override
  List<String> op = ["Customer", "Service provider"];



  List<String> op2 = [
    "Amman",
    "Irbid",
    "Zarqa",
    "Russeifa",
    "Aqaba",
    "As-Salt",
    "Jerash",
    "Al-Mafraq",
    "Al-Karak",
    "Ajloun",
    "Ma'an",
  ];
  String? city;

  List<String> op3 = ["Plumber", "tutor", "cleaner"];
  String? Service_type;

  final k1 = GlobalKey<FormState>();
  TextEditingController cEmail = TextEditingController();
  TextEditingController cPassword = TextEditingController();
  TextEditingController cFullName = TextEditingController();
  TextEditingController cConfirm = TextEditingController();
  final supa = Supabase.instance.client;
  bool r = true;
  bool r2 = true;
  bool passlen = true;
  bool passlower = true;
  bool passUpper = true;
  bool passSpe = true;
  bool passnum = true;

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
              key: k1,
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 30),

                      child: Text(
                        "Role",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 475,
                      height: 55,

                      child: Container(
                        margin: EdgeInsets.only(left: 45),
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.white,
                        ),
                        child: DropdownButton(
                          value: role,
                          underline: SizedBox(),
                          isExpanded: true,
                          items: op.map<DropdownMenuItem<String>>((String v) {
                            return DropdownMenuItem(value: v, child: Text(v));
                          }).toList(),
                          onChanged: (u) {
                            setState(() {
                              role = u!;
                            });
                          },
                        ),
                      ),
                    ),
                    if (role == "Customer") ...[
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.only(left: 30),
                        child: Text(
                          "Full Name",
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
                          padding: const EdgeInsets.only(left: 45),
                          child: TextFormField(
                            validator: v3,
                            controller: cFullName,
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
                                child: Icon(Icons.person),
                              ),
                              label: Text(
                                "Full Name",
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
                          padding: const EdgeInsets.only(left: 45),
                          child: TextFormField(
                            validator: v1,
                            controller: cEmail,
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
                          padding: const EdgeInsets.only(left: 45),
                          child: TextFormField(
                            validator: v2,
                            controller: cPassword,
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
                      Padding(
                        padding: const EdgeInsets.only(left: 60),
                        child: Column(
                          children: [
                            if (!passlen)
                              Row(
                                children: [
                                  Icon(
                                    Icons.circle,
                                    size: 5,
                                    color: Colors.grey,
                                  ),
                                  Text(
                                    "At least 8 characters",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            if (!passSpe)
                              Row(
                                children: [
                                  Icon(
                                    Icons.circle,
                                    size: 5,
                                    color: Colors.grey,
                                  ),
                                  Text(
                                    "Add a special character",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            if (!passnum)
                              Row(
                                children: [
                                  Icon(
                                    Icons.circle,
                                    size: 5,
                                    color: Colors.grey,
                                  ),
                                  Text(
                                    "Add at least one number",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            if (!passUpper)
                              Row(
                                children: [
                                  Icon(
                                    Icons.circle,
                                    size: 5,
                                    color: Colors.grey,
                                  ),
                                  Text(
                                    "Add at least one uppercase letter",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            if (!passlower)
                              Row(
                                children: [
                                  Icon(
                                    Icons.circle,
                                    size: 5,
                                    color: Colors.grey,
                                  ),
                                  Text(
                                    "Add at least one lowercase letter",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.only(left: 30),
                        child: Text(
                          "Confirm Password",
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
                          padding: const EdgeInsets.only(left: 45),
                          child: TextFormField(
                            validator: v4,
                            controller: cConfirm,
                            obscureText: r2,
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
                                    r2 = !r2;
                                  });
                                },
                                icon: Icon(
                                  r2 ? Icons.visibility_off : Icons.visibility,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.only(left: 30),
                        child: Text(
                          "Location",
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

                        child: Container(
                          margin: EdgeInsets.only(left: 45),
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.white,
                          ),
                          child: DropdownButton(
                            value: city,
                            hint: Text(
                              "Choose City",
                              style: TextStyle(color: Colors.grey),
                            ),
                            underline: SizedBox(),
                            isExpanded: true,
                            items: op2.map<DropdownMenuItem<String>>((
                              String h,
                            ) {
                              return DropdownMenuItem(value: h, child: Text(h));
                            }).toList(),
                            onChanged: (h) {
                              setState(() {
                                city = h!;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                    if (role == "Service provider") ...[
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.only(left: 30),
                        child: Text(
                          "Full Name",
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
                          padding: const EdgeInsets.only(left: 45),
                          child: TextFormField(
                            validator: v3,
                            controller: cFullName,
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
                                child: Icon(Icons.person),
                              ),
                              label: Text(
                                "Full Name",
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
                          padding: const EdgeInsets.only(left: 45),
                          child: TextFormField(
                            validator: v1,
                            controller: cEmail,
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
                          padding: const EdgeInsets.only(left: 45),
                          child: TextFormField(
                            validator: v2,
                            controller: cPassword,
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
                      Padding(
                        padding: const EdgeInsets.only(left: 60),
                        child: Column(
                          children: [
                            if (!passlen)
                              Row(
                                children: [
                                  Icon(
                                    Icons.circle,
                                    size: 5,
                                    color: Colors.grey,
                                  ),
                                  Text(
                                    "At least 8 characters",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            if (!passSpe)
                              Row(
                                children: [
                                  Icon(
                                    Icons.circle,
                                    size: 5,
                                    color: Colors.grey,
                                  ),
                                  Text(
                                    "Add a special character",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            if (!passnum)
                              Row(
                                children: [
                                  Icon(
                                    Icons.circle,
                                    size: 5,
                                    color: Colors.grey,
                                  ),
                                  Text(
                                    "Add at least one number",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            if (!passUpper)
                              Row(
                                children: [
                                  Icon(
                                    Icons.circle,
                                    size: 5,
                                    color: Colors.grey,
                                  ),
                                  Text(
                                    "Add at least one uppercase letter",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            if (!passlower)
                              Row(
                                children: [
                                  Icon(
                                    Icons.circle,
                                    size: 5,
                                    color: Colors.grey,
                                  ),
                                  Text(
                                    "Add at least one lowercase letter",
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),

                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.only(left: 30),
                        child: Text(
                          " Confirm Password",
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
                          padding: const EdgeInsets.only(left: 45),
                          child: TextFormField(
                            validator: v4,
                            controller: cConfirm,
                            obscureText: r2,
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
                                    r2 = !r2;
                                  });
                                },
                                icon: Icon(
                                  r2 ? Icons.visibility_off : Icons.visibility,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.only(left: 30),
                        child: Text(
                          "Location",
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

                        child: Container(
                          margin: EdgeInsets.only(left: 45),
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.white,
                          ),
                          child: DropdownButton(
                            value: city,
                            hint: Text(
                              "Choose City",
                              style: TextStyle(color: Colors.grey),
                            ),
                            underline: SizedBox(),
                            isExpanded: true,
                            items: op2.map<DropdownMenuItem<String>>((
                              String h,
                            ) {
                              return DropdownMenuItem(value: h, child: Text(h));
                            }).toList(),
                            onChanged: (h) {
                              setState(() {
                                city = h!;
                              });
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.only(left: 30),
                        child: Text(
                          "Service Type",
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

                        child: Container(
                          margin: EdgeInsets.only(left: 45),
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.white,
                          ),
                          child: DropdownButton(
                            value: Service_type,
                            hint: Text(
                              "Choose Service",
                              style: TextStyle(color: Colors.grey),
                            ),
                            underline: SizedBox(),
                            isExpanded: true,
                            items: op3.map<DropdownMenuItem<String>>((
                              String o,
                            ) {
                              return DropdownMenuItem(value: o, child: Text(o));
                            }).toList(),
                            onChanged: (o) {
                              setState(() {
                                Service_type = o!;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
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
                  padding: EdgeInsets.symmetric(horizontal: 180, vertical: 20),
                ),
                onPressed: () async{
                  setState(() {
                    passlen = cPassword.text.length >= 8;
                    passlower = cPassword.text.contains(RegExp(r'[a-z]'));
                    passUpper = cPassword.text.contains(RegExp(r'[A-Z]'));
                    passnum = cPassword.text.contains(RegExp(r'[0-9]'));
                    passSpe = cPassword.text.contains(
                      RegExp(r'[!@#\$%^&*(),.?":{}|<>]'),
                    );


                  });

                  if (k1.currentState!.validate()) {

                    try {
                      final response=await supa.auth.signUp(
                          email: cEmail.text,
                          password: cPassword.text);

                      final userId =response.user!.id;

                      if (role == "Customer") {

                        await supa.from('customers').insert({
                          'id': userId,
                          'full_name': cFullName.text,
                          'email':cEmail.text,
                          'city':city,

                        });

                        Navigator.pushNamedAndRemoveUntil(context, '/home',(route) => false);
                      } else if (role == "Service provider") {

                        await supa.from('providers').insert({
                          'id': userId,
                          'full_name': cFullName.text,
                          'email':cEmail.text,
                          'city':city,
                          'service_type':Service_type,

                        });


                        Navigator.pushNamedAndRemoveUntil(context, '/dashboard',(route)=>false);

                      }
                    }catch(e){
                      print(e);

                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text("Sign up failed")));



                    }

                  }
                },
                child: Text(
                  "Sign Up",
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
                  margin: EdgeInsets.only(left: 100, right: 10),
                  child: SizedBox(
                    width: 90,
                    child: Divider(thickness: 2, color: Colors.grey),
                  ),
                ),
                Text("Or continue with"),
                Container(
                  margin: EdgeInsets.only(left: 10, right: 90),
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
                  text: "Already have an account?",
                  style: TextStyle(color: Colors.black),
                  children: [
                    TextSpan(
                      text: " Login",
                      style: TextStyle(color: Colors.grey),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => login_page(),
                            ),
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
    if (n!.length < 8 ||
        !n.contains(RegExp(r'[A-Z]')) ||
        !n.contains(RegExp(r'[a-z]')) ||
        !n.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]')) ||
        !n.contains(RegExp(r'[0-9]'))) {
      return "weak password";
    }

    return null;
  }

  String? v3(String? n) {
    if (n == null || n.isEmpty) {
      return "enter name";
    }
    return null;
  }

  String? v4(String? n) {
    if (n != null && n == cPassword.text) {
      return null;
    } else {
      return "Not-Match";
    }
  }
}
