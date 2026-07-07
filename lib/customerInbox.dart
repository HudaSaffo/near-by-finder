import 'package:flutter/material.dart';
import 'package:flutter_nearfix/customerNavbar.dart';
import 'package:flutter_nearfix/customerChat.dart';
import 'package:flutter_nearfix/notifications.dart';
import 'package:flutter_svg/flutter_svg.dart';


final Color primaryMaroon = Color(0xFF5D1219);
final Color backgroundCream = Color(0xFFF9F5EB);
final Color accentSage = Color(0xFF9FB2AC);
final Color textMaroon = Color(0xFF1A0101);

class CustomerInbox extends StatefulWidget {
  const CustomerInbox({super.key});

  @override
  State<CustomerInbox> createState() => _CustomerInboxState();
}

class _CustomerInboxState extends State<CustomerInbox> {
  final supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> getProviders() async {
    final currId = supabase.auth.currentUser!.id;
    List providerIds = [];

    final appointments = await supabase
        .from('appointments')
        .select('provider_id')
        .eq('customer_id', currId);

    for (var appointment in appointments) {
      providerIds.add(appointment['provider_id']);
    }

    final messages = await supabase
        .from('messages')
        .select('receiver_id')
        .eq('sender_id', currId);

    for (var message in messages) {
      providerIds.add(message['receiver_id']);
    }

    providerIds = providerIds.toSet().toList();

    if (providerIds.isEmpty) {
      return [];
    }

    final providers = await supabase
        .from('providers')
        .select()
        .inFilter('id', providerIds);
    return List<Map<String, dynamic>>.from(providers);
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
                            Navigator.pushNamed(context, '/customerchat');
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: ListTile(
                            contentPadding: EdgeInsets.all(10),
                            title: Text(
                              "Service Name",
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
                            Navigator.pushNamed(context, '/customerchat');
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: ListTile(
                            contentPadding: EdgeInsets.all(10),
                            title: Text(
                              "Service Name",
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
                            Navigator.pushNamed(context, '/customerchat');
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: ListTile(
                            contentPadding: EdgeInsets.all(10),
                            title: Text(
                              "Service Name",
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
                            Navigator.pushNamed(context, '/customerchat');
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: ListTile(
                            contentPadding: EdgeInsets.all(10),
                            title: Text(
                              "Service Name",
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

      bottomNavigationBar: Navbar(currentIndex: 3),
    );
  }
}