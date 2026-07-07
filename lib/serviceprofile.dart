import 'package:flutter/material.dart';
import 'package:flutter_nearfix/notifications.dart';
import 'package:flutter_nearfix/serviceNavbar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ServiceProfile extends StatefulWidget {
  const ServiceProfile({super.key});

  @override
  State<ServiceProfile> createState() => _ServiceProfileState();
}

class _ServiceProfileState extends State<ServiceProfile> {
  static const Color bgColor = Color(0xFFF9F5EB);
  static const Color darkBrown = Color(0xFF1A0101);
  static const Color mainRed = Color(0xFF5D1219);
  final supabase = Supabase.instance.client;
  String fullName = "";
  String email = "";
  String city = "";
  String serviceType = "";
  bool isLoading = true;
  TextEditingController nameC = TextEditingController();
  List<String> op = [
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
  String selectedCity = "";
  List<String> op1 = ["Plumber", "tutor", "cleaner"];
  String selectedService = "";

  Future<void> getProviderData() async {
    final currId = supabase.auth.currentUser!.id;
    final data = await supabase
        .from('providers')
        .select()
        .eq('id', currId)
        .single();
    setState(() {
      fullName = data['full_name'];
      email = data['email'];
      city = data['city'];
      serviceType = data['service_type'];
      nameC.text = fullName;
      selectedCity = data['city'];
      selectedService = data['service_type'];
      isLoading = false;
    });
  }

  Future<void> updateProfile() async {
    final currId = supabase.auth.currentUser!.id;
    await supabase
        .from('providers')
        .update({
      'full_name': nameC.text.trim(),
      'city': selectedCity,
      'service_type': selectedService,
    })
        .eq('id', currId);
    await getProviderData();
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    getProviderData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        actions: [
          SvgPicture.asset('assets/images/logo.svg', width: 35),
          SizedBox(width: 20),
        ],
        backgroundColor: bgColor,
        scrolledUnderElevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NotificationScreen()),
            );
          },
          icon: Icon(Icons.notifications_none, size: 30, color: darkBrown),
        ),
        title: Text(
          'Profile',
          style: TextStyle(color: darkBrown, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 35),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        vertical: 28,
                        horizontal: 20,
                      ),
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.12),
                            blurRadius: 14,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.grey.shade400,
                                width: 2,
                              ),
                            ),
                          ),

                          const SizedBox(height: 28),

                          Text(
                            fullName,
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: darkBrown,
                            ),
                          ),

                          const SizedBox(height: 12),

                          Text(
                            serviceType,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade500,
                            ),
                          ),

                          const SizedBox(height: 12),

                          Text(
                            city,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade500,
                            ),
                          ),

                          const SizedBox(height: 10),

                          Text(
                            email,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade500,
                            ),
                          ),

                          const SizedBox(height: 28),

                          Center(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return StatefulBuilder(
                                      builder: (context, setDialogState) {
                                        return AlertDialog(
                                          title: const Text("Edit Profile"),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              TextField(
                                                controller: nameC,
                                                decoration:
                                                const InputDecoration(
                                                  labelText: "Full Name",
                                                ),
                                              ),
                                              const SizedBox(height: 15),
                                              Text("Select City"),
                                              DropdownButton<String>(
                                                value: selectedCity,
                                                isExpanded: true,
                                                items: op
                                                    .map<
                                                    DropdownMenuItem<String>
                                                >((String c) {
                                                  return DropdownMenuItem(
                                                    value: c,
                                                    child: Text(c),
                                                  );
                                                })
                                                    .toList(),
                                                onChanged: (m) {
                                                  setDialogState(() {
                                                    selectedCity = m!;
                                                  });
                                                },
                                              ),
                                              const SizedBox(height: 15),
                                              Text("Service Type"),
                                              DropdownButton<String>(
                                                value: selectedService,
                                                isExpanded: true,
                                                items: op1
                                                    .map<
                                                    DropdownMenuItem<String>
                                                >((String c) {
                                                  return DropdownMenuItem(
                                                    value: c,
                                                    child: Text(c),
                                                  );
                                                })
                                                    .toList(),
                                                onChanged: (m) {
                                                  setDialogState(() {
                                                    selectedService = m!;
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text("Cancel"),
                                            ),
                                            ElevatedButton(
                                              onPressed: updateProfile,
                                              child: const Text("Save"),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                );
                              },
                              icon: const Icon(
                                Icons.edit_outlined,
                                color: Colors.white,
                              ),
                              label: const Text(
                                "Edit Profile",
                                style: TextStyle(fontSize: 18),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: mainRed,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 28,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(28),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    Container(
                      height: 92,
                      padding: const EdgeInsets.symmetric(horizontal: 26),
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.12),
                            blurRadius: 14,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info, size: 38, color: darkBrown),
                          const SizedBox(width: 22),
                          Text(
                            "Update Service Information",
                            style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: darkBrown,
                            ),
                          ),
                          const Spacer(),

                          IconButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                '/serviceinformation',
                              );
                            },
                            icon: const Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            backgroundColor: bgColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            title: const Center(
                              child: Icon(
                                Icons.logout_rounded,
                                color: Colors.red,
                                size: 50,
                              ),
                            ),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  "Log Out",
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 15),

                                Text(
                                  "Are you sure you want to log out?",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.grey.shade700,
                                    fontSize: 16,
                                  ),
                                ),

                                const SizedBox(height: 25),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.grey.shade300,
                                        foregroundColor: Colors.black,
                                        fixedSize: const Size(110, 45),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadiusGeometry.circular(25),
                                        ),
                                      ),
                                      child: Text("Cancel"),
                                    ),

                                    const SizedBox(width: 15),

                                    ElevatedButton(
                                      onPressed: () async {
                                        Navigator.pop(context);
                                        await supabase.auth.signOut();
                                        Navigator.pushNamedAndRemoveUntil(
                                          context,
                                          '/splashscreen',
                                              (route) => false,
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.grey.shade300,
                                        foregroundColor: Colors.black,
                                        fixedSize: const Size(110, 45),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadiusGeometry.circular(25),
                                        ),
                                      ),
                                      child: Text("Log Out"),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,

                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 28,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                      ),
                      child: Text("Log out", style: TextStyle(fontSize: 18)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: serviceNavbar(currentIndex: 3),
    );
  }
}