import 'package:cross_platform_mailing_app/src/features/send_email/presentation/screens/send_email_screen.dart';
import 'package:cross_platform_mailing_app/src/features/send_mass_email_via_csv/presentation/send_mass_email_screen.dart';
import 'package:cross_platform_mailing_app/src/features/smtp_server_connect/presentation/screens/smtp_server_connect_screen.dart';
import 'package:cross_platform_mailing_app/src/features/webservice_send_mass_email/presentation/webservice_send_mass_email.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  int _currentIndex = 0;
  final List<Widget> _children = [
    // const SMTPServerConnectScreen(),
    const SendMailScreen(),
    const SendMassMailScreen(),
    const WebserviceSendMassEmail(),
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
            // BottomNavigationBarItem(
            //   icon: Icon(FontAwesomeIcons.connectdevelop),
            //   label: 'Check Connection',
            // ),
            BottomNavigationBarItem(
              icon: Icon(Icons.send),
              label: 'Send Email',
            ),
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.mailBulk),
              label: 'Send Mass Email Via CSV',
            ),
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.server),
              label: 'Web Email Service',
            ),
          ],
        ),
      ),
    );
  }
}
