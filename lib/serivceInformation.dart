import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nearfix/notifications.dart';
import 'package:flutter_nearfix/servicenavbar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Serivceinformation extends StatefulWidget {
  const Serivceinformation({super.key});

  @override
  State<Serivceinformation> createState() => _SerivceinformationState();
}

class _SerivceinformationState extends State<Serivceinformation> {
  final SupabaseClient supabase = Supabase.instance.client;
  String? _imageExtenstion;
  Uint8List? _webImage;

  final Color backgroundCream = const Color(0xFFF9F5EB);
  final Color textMaroon = const Color(0xFF1A0101);
  final Color primaryMaroon = const Color(0xFF5D1219);
  final Color accentSage = const Color(0xFF9FB2AC);

  final List<String> locations = [
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
  String? selectedLocation;

  final List<String> categories = [
    "Cleaning",
    "Furniture",
    "Fixing",
    "Electronics",
  ];
  String? selectedCategory;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadExistingServiceData();
  }

  Future pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final Uint8List imageBytes = await image.readAsBytes();
      setState(() {
        _webImage = imageBytes;
        _imageExtenstion = image.name.split('.').last;
      });
    }
  }

  Future uploadImage() async {
    if (_webImage == null) return;
    final ext = _imageExtenstion ?? 'jpg';
    final fileName = '${DateTime.now().millisecondsSinceEpoch}.$ext';
    final path = 'uploads/$fileName';

    await supabase.storage.from('images').uploadBinary(path, _webImage!);
    final String publicUrl = supabase.storage.from('images').getPublicUrl(path);
    return publicUrl;
  }

  Future<void> _loadExistingServiceData() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    final data = await supabase
        .from('service')
        .select()
        .eq('user_id', user.id)
        .maybeSingle();

    if (data != null) {
      setState(() {
        nameController.text = data['service_name'] ?? '';
        descriptionController.text = data['description'] ?? '';
        selectedLocation = data['location'];
        if (data['List_service_type'] is List &&
            data['List_service_type'].isNotEmpty) {
          selectedCategory = data['List_service_type'][0];
        } else {
          selectedCategory = data['List_service_type'];
        }
      });
    }
  }

  Future<void> _updateServiceInformation() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;
    String? finalImageUrl = await uploadImage();

    final Map<String, dynamic> updatePayload = {
      'user_id': user.id,
      'service_name': nameController.text.trim(),
      'description': descriptionController.text.trim(),
      'location': selectedLocation,
      'List_service_type': selectedCategory != null ? [selectedCategory] : null,
    };
    if (finalImageUrl != null) {
      updatePayload['image_url'] = finalImageUrl;
    }
    await supabase.from('service').upsert(updatePayload);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundCream,
      appBar: AppBar(
        actions: [
          SvgPicture.asset('assets/images/logo.svg', width: 35),
          SizedBox(width: 20),
        ],
        backgroundColor: backgroundCream,
        scrolledUnderElevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NotificationScreen()),
            );
          },
          icon: Icon(Icons.notifications_none, size: 30, color: textMaroon),
        ),
        title: Text(
          'Service Information',
          style: TextStyle(color: textMaroon, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Form(
              key: formKey,

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 30),
                    child: Text(
                      "Category",
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
                        hint: Text("Category"),
                        value: selectedCategory,
                        underline: SizedBox(),
                        isExpanded: true,
                        items: categories.map<DropdownMenuItem<String>>((
                          String v,
                        ) {
                          return DropdownMenuItem(value: v, child: Text(v));
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            selectedCategory = newValue!;
                          });
                        },
                      ),
                    ),
                  ),

                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(left: 30),
                    child: Text(
                      "Service Name",
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
                        controller: nameController,
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
                            "Service Name",
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
                      "Description",
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
                        validator: v4,
                        controller: descriptionController,
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
                            "Description",
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
                      "Service Image",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(left: 45),
                    child: GestureDetector(
                      onTap: pickImage,
                      child: Container(
                        width: 420,
                        height: 150,
                        decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.grey),

                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: _webImage != null
                            ? Image.memory(_webImage!)
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.drive_folder_upload,
                                    size: 40,
                                    color: Colors.grey[400],
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    "upload Image",
                                    style: TextStyle(
                                      color: Colors.grey[400],
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(left: 30),
                    child: Text(
                      "Service Location",
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
                        value: selectedLocation,
                        hint: Text(
                          "Service Location",
                          style: TextStyle(color: Colors.grey),
                        ),
                        underline: SizedBox(),
                        isExpanded: true,
                        items: locations.map<DropdownMenuItem<String>>((
                          String h,
                        ) {
                          return DropdownMenuItem(value: h, child: Text(h));
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            selectedLocation = newValue!;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.only(left: 40),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF9FB2AC),
                  padding: EdgeInsets.symmetric(horizontal: 130, vertical: 20),
                ),
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    await _updateServiceInformation();
                    if (!mounted) return;
                    Navigator.pushNamed(context, '/serviceprofile');
                  }
                },
                child: Text(
                  "Update Information",
                  style: TextStyle(
                    color: Color(0xFFF4F1E8),
                    fontSize: 20,
                    fontFamily: "Product Sans",
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: serviceNavbar(currentIndex: -1),
    );
  }

  String? v3(String? n) {
    if (n == null || n.isEmpty) {
      return "enter Service name";
    }
    return null;
  }

  String? v4(String? n) {
    if (n == null || n.isEmpty) {
      return "enter Service Description";
    }
    return null;
  }
}
