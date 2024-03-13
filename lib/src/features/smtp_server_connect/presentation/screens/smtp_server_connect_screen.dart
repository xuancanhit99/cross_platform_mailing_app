import 'package:cross_platform_mailing_app/core/constants/sizes.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';


class SMTPServerConnectScreen extends StatefulWidget {
  const SMTPServerConnectScreen({super.key});

  @override
  State<SMTPServerConnectScreen> createState() => _SMTPServerConnectScreenState();
}

class _SMTPServerConnectScreenState extends State<SMTPServerConnectScreen> {
  final _formKey = GlobalKey<FormState>();



  @override
  Widget build(BuildContext context) {
    return SafeArea(child:
    Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(cDefaultSize),
          child: Form(
            key: _formKey,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: cDefaultSize),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Sender's Email
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.outbox),
                      labelText: 'Senders\'s Email',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter sender\' Email';
                      } else if (!EmailValidator.validate(value, true)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: cDefaultSize),
                  // Sender's Password
                  TextFormField(
                    keyboardType:  TextInputType.visiblePassword,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock_outlined),
                      labelText: 'Password',
                      suffixIcon: IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.visibility_off),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter sender\' password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: cDefaultSize),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          // _sendEmail();
                        }
                      },
                      child: const Text('Connect to SMTP Server'),
                    ),
                  ),
                ],
              ),

            ),
          )
        )
      ),
    ));
  }
}
