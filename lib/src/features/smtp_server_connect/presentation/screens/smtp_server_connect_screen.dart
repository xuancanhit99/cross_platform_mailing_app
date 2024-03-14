import 'package:cross_platform_mailing_app/core/constants/sizes.dart';
import 'package:cross_platform_mailing_app/src/features/smtp_server_connect/presentation/bloc/smtp_bloc.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/smtp_event.dart';
import '../bloc/smtp_state.dart';



class SMTPServerConnectScreen extends StatefulWidget {
  const SMTPServerConnectScreen({super.key});

  @override
  State<SMTPServerConnectScreen> createState() =>
      _SMTPServerConnectScreenState();
}

class _SMTPServerConnectScreenState extends State<SMTPServerConnectScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  late SmtpConnectBloc _smtpConnectBloc;

  @override
  void initState() {
    super.initState();
    _smtpConnectBloc = SmtpConnectBloc();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _smtpConnectBloc,
      child: BlocListener<SmtpConnectBloc, SmtpConnectState>(
        listener: (context, state) {
          if (state == SmtpConnectState.success) {
            // show success message
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Connect to SMTP Server successfully'),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 3),
              ),
            );
            // print('Connect to SMTP Server successfully');
          } else if (state == SmtpConnectState.failure) {
            // show error message
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Connect to SMTP Server failed'),
                backgroundColor: Colors.redAccent,
                duration: Duration(seconds: 3),
              ),
            );
            // print('Connect to SMTP Server failed');
          }
        },
        child: SafeArea(
            child: Scaffold(
          body: SingleChildScrollView(
              child: Container(
                  padding: const EdgeInsets.all(cDefaultSize),
                  child: Form(
                    key: _formKey,
                    child: Container(
                      padding:
                          const EdgeInsets.symmetric(vertical: cDefaultSize),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Sender's Email
                          TextFormField(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.outbox),
                              labelText: 'Senders\'s Email',
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter sender\' Email';
                              } else if (!EmailValidator.validate(
                                  value, true)) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: cDefaultSize),
                          // Sender's Password
                          TextFormField(
                            controller: passwordController,
                            keyboardType: TextInputType.visiblePassword,
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
                          // Connect to SMTP Server
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  _smtpConnectBloc.add(SmtpConnectEvent.connect(
                                      emailController.text,
                                      passwordController.text));
                                }
                              },
                              child: const Text('Connect to SMTP Server'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ))),
        )),
      ),
    );
  }
}
