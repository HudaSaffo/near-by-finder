import 'package:flutter/material.dart';

class serviceNavbar extends StatelessWidget {
  final int currentIndex;

  static const Color primaryMaroon = Color(0xFF5D1219);
  static const Color backgroundCream = Color(0xFFF9F5EB);
  static const Color accentSage = Color(0xFF9FB2AC);
  static const Color textMaroon = Color(0xFF1A0101);
  const serviceNavbar({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    bool isDisabled;
    if (currentIndex == -1) {
      isDisabled = true;
    } else {
      isDisabled = false;
    }
    return BottomNavigationBar(
      currentIndex: isDisabled ? 0 : currentIndex,
      onTap: (index) {
        if (index == currentIndex) return;
        if (index == 0) {
          Navigator.pushReplacementNamed(context, '/dashboard');
        } else if (index == 1) {
          Navigator.pushReplacementNamed(context, '/servicerequest');
        } else if (index == 2) {
          Navigator.pushReplacementNamed(context, '/serviceinbox');
        } else if (index == 3) {
          Navigator.pushReplacementNamed(context, '/serviceprofile');
        }
      },
      type: BottomNavigationBarType.fixed,
      backgroundColor: backgroundCream,
      selectedItemColor: isDisabled ? Colors.grey : primaryMaroon,
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
        BottomNavigationBarItem(
          icon: Icon(Icons.receipt_long_outlined),
          label: 'Requests',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.all_inbox_outlined),
          label: 'Inbox',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: 'Profile',
        ),
      ],
    );
  }
}
