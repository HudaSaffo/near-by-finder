import 'package:flutter/material.dart';
import 'package:flutter_nearfix/notifications.dart';
import 'package:flutter_nearfix/servicenavbar.dart';
import 'package:flutter_nearfix/serviceChat.dart';
import 'package:flutter_svg/flutter_svg.dart';


final Color primaryMaroon = Color(0xFF5D1219);
final Color backgroundCream = Color(0xFFF9F5EB);
final Color accentSage = Color(0xFF9FB2AC);
final Color textMaroon = Color(0xFF1A0101);

class ServiceInbox extends StatefulWidget {
  const ServiceInbox({super.key});

  @override
  State<ServiceInbox> createState() => _ServiceInboxState();
}

class _ServiceInboxState extends State<ServiceInbox> {
  final supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> getCustomers() async {
    final currId = supabase.auth.currentUser!.id;
    List customerIds = [];
    final appointments = await supabase
        .from('appointments')
        .select('customer_id')
        .eq('provider_id', currId);

    for (var appointment in appointments) {
      customerIds.add(appointment['customer_id']);
    }

    final messages = await supabase
        .from('messages')
        .select('sender_id')
        .eq('receiver_id', currId);

    for (var message in messages) {
      customerIds.add(message['sender_id']);
    }

    customerIds = customerIds.toSet().toList();

    if (customerIds.isEmpty) {
      return [];
    }
    final customers = await supabase
        .from('customers')
        .select()
        .inFilter('id', customerIds);
    return List<Map<String, dynamic>>.from(customers);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF4F1E8),
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
          'Inbox',
          style: TextStyle(color: textMaroon, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        child: Container(
                padding: EdgeInsets.only(left: 40),
                child: Column(
                  children: [
                    SizedBox(
                      height: 100,
                      width: 500,

                      child: Card(
                        elevation: 6,
                        color: backgroundCream,

                        child: InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, '/servicechat');
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: ListTile(
                            contentPadding: EdgeInsets.all(10),
                            title: Text(
                              "Customer",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              "last message",
                              style: TextStyle(color: Colors.grey),
                            ),
                            leading: CircleAvatar(
                              radius: 25,
                              backgroundColor: Colors.grey.withOpacity(0.3),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 100,
                      width: 500,

                      child: Card(
                        elevation: 6,
                        color: backgroundCream,

                        child: InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, '/servicechat');
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: ListTile(
                            contentPadding: EdgeInsets.all(10),
                            title: Text(
                              "Customer",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              "last message",
                              style: TextStyle(color: Colors.grey),
                            ),
                            leading: CircleAvatar(
                              radius: 25,
                              backgroundColor: Colors.grey.withOpacity(0.3),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 100,
                      width: 500,

                      child: Card(
                        elevation: 6,
                        color: backgroundCream,

                        child: InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, '/servicechat');
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: ListTile(
                            contentPadding: EdgeInsets.all(10),
                            title: Text(
                              "Customer",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              "last message",
                              style: TextStyle(color: Colors.grey),
                            ),
                            leading: CircleAvatar(
                              radius: 25,
                              backgroundColor: Colors.grey.withOpacity(0.3),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 100,
                      width: 500,

                      child: Card(
                        elevation: 6,
                        color: backgroundCream,

                        child: InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, '/servicechat');
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: ListTile(
                            contentPadding: EdgeInsets.all(10),
                            title: Text(
                              "Customer",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              "last message",
                              style: TextStyle(color: Colors.grey),
                            ),
                            leading: CircleAvatar(
                              radius: 25,
                              backgroundColor: Colors.grey.withOpacity(0.3),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )

      ),

      bottomNavigationBar: serviceNavbar(currentIndex: 2),
    );
  }
}