import 'package:flutter/material.dart';
import 'package:flutter_nearfix/customerNavbar.dart';
import 'package:flutter_nearfix/notifications.dart';
import 'package:flutter_nearfix/service.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/gestures.dart';

class CustomerServices extends StatefulWidget {
  const CustomerServices({super.key});

  @override
  State<CustomerServices> createState() => _CustomerServicesState();
}

class _CustomerServicesState extends State<CustomerServices> {
  late GoogleMapController mapController;
  final LatLng _center = const LatLng(31.9539, 35.9106);
  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  final SupabaseClient supabase = Supabase.instance.client;

  final Color primaryMaroon = Color(0xFF5D1219);
  final Color backgroundCream = Color(0xFFF9F5EB);
  final Color accentSage = Color(0xFF9FB2AC);
  final Color textMaroon = Color(0xFF1A0101);

  late Future<List<Map<String, dynamic>>> _servicesFuture;

  Future<List<Map<String, dynamic>>> _fetchNearbyServices() async {
    final data = await supabase.from('service').select();
    return List<Map<String, dynamic>>.from(data);
  }

  @override
  void initState() {
    super.initState();
    _servicesFuture = _fetchNearbyServices();
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
          'Services',
          style: TextStyle(color: textMaroon, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: onMapCreated,
            initialCameraPosition: CameraPosition(target: _center, zoom: 11.0),
          ),

          ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(
              dragDevices: {
                PointerDeviceKind.touch,
                PointerDeviceKind.mouse,
                PointerDeviceKind.trackpad,
              },
            ),
            child: DraggableScrollableSheet(
              initialChildSize: 0.4,
              minChildSize: 0.15,
              maxChildSize: 0.90,
              snap: true,
              builder: (context, scrollController) {
                return Container(
                  decoration: BoxDecoration(
                    color: backgroundCream,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(30),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: FutureBuilder<List<Map<String, dynamic>>>(
                    future: _fetchNearbyServices(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                          child: Text("No services available right now."),
                        );
                      }

                      final servicesList = snapshot.data!;

                      return ListView.builder(
                        controller: scrollController,

                        padding: const EdgeInsets.all(20),
                        itemCount: servicesList.length + 1,

                        itemBuilder: (context, index) {
                          if (index == 0) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: Container(
                                    width: 50,
                                    height: 5,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[400],
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  "Neaby Services",
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: textMaroon,
                                  ),
                                ),
                                const SizedBox(height: 15),
                              ],
                            );
                          }

                          final item = servicesList[index - 1];
                          final String serviceTitle =
                              item['service_name'] ?? 'Service Name';
                          final String? imageUrl = item['image_url'];
                          final rawCategory = item['List_service_type'];
                          String serviceCategory = 'General';
                          if (rawCategory is List) {
                            serviceCategory = rawCategory.isNotEmpty
                                ? rawCategory.join(', ')
                                : 'General';
                          } else if (rawCategory != null) {
                            serviceCategory = rawCategory.toString();
                          }

                          return Container(
                            margin: const EdgeInsets.only(bottom: 15),
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 25,
                                  backgroundColor: accentSage,
                                  backgroundImage:
                                      imageUrl != null &&
                                          imageUrl.startsWith('http')
                                      ? NetworkImage(imageUrl)
                                      : const AssetImage(
                                              'assets/images/images.png',
                                            )
                                            as ImageProvider,
                                ),
                                SizedBox(width: 15),
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
                                      ),
                                      Text(
                                        serviceCategory,
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 15),
                                IconButton(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                      context,
                                      '/service',
                                      arguments: item,
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.arrow_forward_ios,
                                    size: 18,
                                  ),
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Navbar(currentIndex: 2),
    );
  }
}