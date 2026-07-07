import 'package:flutter/material.dart';
import 'package:flutter_nearfix/categoryServices.dart';
import 'package:flutter_nearfix/customerNavbar.dart';
import 'package:flutter_nearfix/notifications.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CustomerHome extends StatefulWidget {
  const CustomerHome({super.key});

  @override
  State<CustomerHome> createState() => _CustomerHomeState();
}

final SupabaseClient supabase = Supabase.instance.client;

class _CustomerHomeState extends State<CustomerHome> {
  final Color primaryMaroon = Color(0xFF5D1219);
  final Color backgroundCream = Color(0xFFF9F5EB);
  final Color accentSage = Color(0xFF9FB2AC);
  final Color textMaroon = Color(0xFF1A0101);

  late Future<List<Map<String, dynamic>>> _servicesFuture;
  List<Map<String, dynamic>> _allServices = [];
  List<Map<String, dynamic>> _filteredServices = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _servicesFuture = _fetchServices();
  }

  Future<List<Map<String, dynamic>>> _fetchServices() async {
    final data = await supabase.from('service').select();
    final list = List<Map<String, dynamic>>.from(data);
    setState(() {
      _allServices = list;
      if (!_isSearching) {
        _filteredServices = list;
      }
    });
    return list;
  }

  void _filterServices(String query) {
    setState(() {
      if (query.isEmpty) {
        _isSearching = false;
        _filteredServices = _allServices;
      } else {
        _isSearching = true;
        _filteredServices = _allServices.where((service) {
          final title = (service['service_name'] ?? '')
              .toString()
              .toLowerCase();
          final description = (service['description'] ?? '')
              .toString()
              .toLowerCase();
          final searchLower = query.toLowerCase();
          return title.contains(searchLower) ||
              description.contains(searchLower);
        }).toList();
      }
    });
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
          'Home',
          style: TextStyle(color: textMaroon, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            TextField(
              onChanged: (value) => _filterServices(value),
              decoration: InputDecoration(
                hintText: "Search a service",
                prefixIcon: Icon(Icons.search_outlined, color: textMaroon),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            if (!_isSearching) ...[
              SizedBox(height: 20),
              Text(
                "Services",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: textMaroon,
                ),
              ),
              SizedBox(height: 15),
              GridView.count(
                shrinkWrap: true,
                physics:
                    const NeverScrollableScrollPhysics(), // Added to prevent scrolling conflicts inside parent single scroll view
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                children: [
                  _buildStaticCategoryCard(
                    "Cleaning",
                    Icons.cleaning_services,
                    primaryMaroon,
                  ),
                  _buildStaticCategoryCard(
                    "Electronics",
                    Icons.electrical_services,
                    accentSage,
                  ),
                  _buildStaticCategoryCard(
                    "Furniture",
                    Icons.bed_outlined,
                    accentSage,
                  ),
                  _buildStaticCategoryCard(
                    "Fixing",
                    Icons.build_outlined,
                    primaryMaroon,
                  ),
                ],
              ),
            ],
            SizedBox(height: 20),
            Text(
              _isSearching ? "Search Results" : "Suggested",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textMaroon,
              ),
            ),
            SizedBox(height: 15),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: _servicesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting &&
                    _allServices.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (_filteredServices.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 30),
                    child: Center(
                      child: Text("No services match your search term."),
                    ),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _filteredServices.length,
                  itemBuilder: (context, index) {
                    final item = _filteredServices[index];

                    final String serviceTitle =
                        item['service_name'] ?? 'Service name';
                    final String serviceDescription =
                        item['description'] ?? 'Lorem ipsum description...';
                    final String? imageUrl = item['image_url'];

                    return Card(
                      margin: const EdgeInsets.only(bottom: 15),
                      child: Column(
                        children: [
                          Container(
                            height: 150,
                            decoration: BoxDecoration(
                              color: Colors.grey[400],
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(15),
                              ),
                              image:
                                  imageUrl != null &&
                                      imageUrl.startsWith('http')
                                  ? DecorationImage(
                                      image: NetworkImage(imageUrl),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        serviceTitle,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: textMaroon,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        serviceDescription,
                                        style: const TextStyle(
                                          color: Colors.grey,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 10),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                      context,
                                      '/service',
                                      arguments: item,
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: primaryMaroon,
                                  ),
                                  child: const Text(
                                    "Book a service",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: Navbar(currentIndex: 0),
    );
  }

  Widget _buildStaticCategoryCard(String title, IconData icon, Color bg) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Categoryservices(category: title),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: bg,
              radius: 25,
              child: Icon(icon, color: Colors.white),
            ),
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, color: textMaroon),
            ),
          ],
        ),
      ),
    );
  }
}
