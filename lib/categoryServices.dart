import 'package:flutter/material.dart';
import 'package:flutter_nearfix/customerNavbar.dart';
import 'package:flutter_nearfix/notifications.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_nearfix/service.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Categoryservices extends StatefulWidget {
  final String category;
  const Categoryservices({super.key, required this.category});

  @override
  State<Categoryservices> createState() => _CategoryservicesState();
}

class _CategoryservicesState extends State<Categoryservices> {
  final SupabaseClient supabase = Supabase.instance.client;

  final Color primaryMaroon = const Color(0xFF5D1219);
  final Color backgroundCream = const Color(0xFFF9F5EB);
  final Color textMaroon = const Color(0xFF1A0101);

  Future<List<Map<String, dynamic>>> _fetchServicesByCategory(
    String categoryName,
  ) async {
    final data = await supabase.from('service').select().contains('category', [
      categoryName,
    ]);
    return List<Map<String, dynamic>>.from(data);
  }

  @override
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
          widget.category,
          style: TextStyle(color: textMaroon, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchServicesByCategory(widget.category.toLowerCase()),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                "No services under ${widget.category} found.",
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            );
          }
          final fileredList = snapshot.data!;

          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: fileredList.length,
            itemBuilder: (context, index) {
              final item = fileredList[index];

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
                        image: imageUrl != null && imageUrl.startsWith('http')
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
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                  style: const TextStyle(color: Colors.grey),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Service(item['id']),
                                ),
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
      bottomNavigationBar: Navbar(currentIndex: -1),
    );
  }
}
