import 'package:cross_platform_mailing_app/src/features/send_email/send_mail_screen.dart';
import 'package:cross_platform_mailing_app/src/features/smtp_server_connect/presentation/screens/smtp_server_connect_screen.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  int _currentIndex = 0;
  final List<Widget> _children = [
    const SMTPServerConnectScreen(),
    const SendMailScreen(), // Replace with your SendMailScreen
  ];


  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _children[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          onTap: onTabTapped,
          currentIndex: _currentIndex,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.email),
              label: 'SMTP Server Connect',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.send),
              label: 'Send Mail',
            ),
          ],
        ),
      ),
    );
  }
}
