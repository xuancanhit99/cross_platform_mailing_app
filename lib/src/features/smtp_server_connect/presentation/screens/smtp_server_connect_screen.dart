import 'package:cross_platform_mailing_app/core/constants/sizes.dart';
import 'package:cross_platform_mailing_app/src/features/smtp_server_connect/presentation/bloc/smtp_bloc.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../data/models/smtp_server_info_model.dart';
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

  final smtpServerController = TextEditingController(text: 'Gmail');
  IconData currentIcon = FontAwesomeIcons.google;

  late SmtpConnectBloc _smtpConnectBloc;
  bool _isPasswordVisible = false;

  final _dialogFormKey = GlobalKey<FormState>();
  final smtpServerNameController = TextEditingController();
  final smtpServerAddressController = TextEditingController();
  final smtpServerPortController = TextEditingController();
  final smtpServerSSLController = TextEditingController(text: 'true');

  @override
  void initState() {
    super.initState();
    _smtpConnectBloc = SmtpConnectBloc();
    // _smtpConnectBloc.add(const SmtpConnectSelectServerEvent(
    //     'smtp.gmail.com')); // Set default server
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
          appBar: AppBar(
            title: const Text('Check Connection',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ),
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
                          // Server SMTP
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: smtpServerController,
                                  keyboardType: TextInputType.none,
                                  showCursor: false,
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(currentIcon),
                                    labelText: 'Server SMTP',
                                  ),
                                  onTap: () {
                                    showModalBottomSheet(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return Container(
                                            padding: const EdgeInsets.all(20),
                                            child: Wrap(
                                              children: _smtpConnectBloc.smtpServers.map((server) {
                                                return ListTile(
                                                  leading: Icon(server.icon),
                                                  title: Text(server.name),
                                                  trailing: IconButton(
                                                    icon: const Icon(Icons.delete),
                                                    onPressed: () {
                                                      setState(() {
                                                        _smtpConnectBloc.smtpServers.remove(server);
                                                      });
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                  onTap: () {
                                                    smtpServerController.text = server.name;
                                                    _smtpConnectBloc.add(SmtpConnectSelectServerEvent(server));
                                                    setState(() {
                                                      currentIcon = server.icon;
                                                    });
                                                    Navigator.pop(context);
                                                  },
                                                );
                                              }).toList(),
                                            ),
                                          );
                                        });
                                  },
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter server smtp';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(width: cDefaultSize),
                              IconButton(
                                  icon: const Icon(Icons.add_box_outlined),
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title:
                                                const Text('Add SMTP Server'),
                                            content: Form(
                                              key: _dialogFormKey,
                                              child: Column(
                                                children: [
                                                  TextFormField(
                                                    controller:
                                                        smtpServerNameController,
                                                    decoration:
                                                        const InputDecoration(
                                                      labelText:
                                                          'SMTP Server Name',
                                                    ),
                                                    validator: (value) {
                                                      if (value!.isEmpty) {
                                                        return 'Please enter SMTP Server Name';
                                                      }
                                                      return null;
                                                    },
                                                  ),
                                                  const SizedBox(
                                                    height: cDefaultSize,
                                                  ),
                                                  TextFormField(
                                                    controller:
                                                        smtpServerAddressController,
                                                    decoration:
                                                        const InputDecoration(
                                                      labelText:
                                                          'SMTP Server Address',
                                                    ),
                                                    validator: (value) {
                                                      if (value!.isEmpty) {
                                                        return 'Please enter SMTP Server Address';
                                                      }
                                                      return null;
                                                    },
                                                  ),
                                                  const SizedBox(
                                                    height: cDefaultSize,
                                                  ),
                                                  TextFormField(
                                                    controller:
                                                        smtpServerPortController,
                                                    decoration:
                                                        const InputDecoration(
                                                      labelText:
                                                          'SMTP Server Port',
                                                    ),
                                                    validator: (value) {
                                                      if (value!.isEmpty) {
                                                        return 'Please enter SMTP Server Port';
                                                      }
                                                      return null;
                                                    },
                                                  ),
                                                  const SizedBox(
                                                    height: cDefaultSize,
                                                  ),
                                                  DropdownButtonFormField<
                                                      String>(
                                                    decoration:
                                                        const InputDecoration(
                                                      labelText:
                                                          'SMTP Server SSL',
                                                    ),
                                                    value: smtpServerSSLController
                                                            .text.isEmpty
                                                        ? null
                                                        : smtpServerSSLController
                                                            .text,
                                                    items: <String>[
                                                      'true',
                                                      'false'
                                                    ].map<
                                                            DropdownMenuItem<
                                                                String>>(
                                                        (String value) {
                                                      return DropdownMenuItem<
                                                          String>(
                                                        value: value,
                                                        child: Text(value),
                                                      );
                                                    }).toList(),
                                                    onChanged:
                                                        (String? newValue) {
                                                      smtpServerSSLController
                                                          .text = newValue!;
                                                    },
                                                    validator: (value) {
                                                      if (value!.isEmpty) {
                                                        return 'Please enter SMTP Server SSL';
                                                      }
                                                      return null;
                                                    },
                                                  )
                                                ],
                                              ),
                                            ),
                                            actions: [
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text('Cancel')),
                                              TextButton(
                                                  onPressed: () {
                                                    if (_dialogFormKey
                                                        .currentState!
                                                        .validate()) {
                                                      // Create a new SmtpServerInfoModel with the input values
                                                      String name =
                                                          smtpServerNameController
                                                              .text;
                                                      String address =
                                                          smtpServerAddressController
                                                              .text;
                                                      int port = int.parse(
                                                          smtpServerPortController
                                                              .text);
                                                      bool ssl =
                                                          smtpServerSSLController
                                                                  .text ==
                                                              'true';
                                                      SmtpServerInfoModel
                                                          newSmtpServer =
                                                          SmtpServerInfoModel(
                                                              name: name,
                                                              address: address,
                                                              port: port,
                                                              ssl: ssl,
                                                              icon:
                                                                  FontAwesomeIcons
                                                                      .server);

                                                      // Add the new server to the list
                                                      _smtpConnectBloc.add(
                                                          SmtpConnectAddServerEvent(
                                                              newSmtpServer));

                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        const SnackBar(
                                                          content: Text(
                                                              'SMTP Server added successfully'),
                                                          backgroundColor:
                                                              Colors.green,
                                                          duration: Duration(
                                                              seconds: 3),
                                                        ),
                                                      );

                                                      Navigator.pop(context);
                                                    } else {
                                                      // Show error message
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        const SnackBar(
                                                          content: Text(
                                                              'Please fill all fields'),
                                                          backgroundColor:
                                                              Colors.redAccent,
                                                          duration: Duration(
                                                              seconds: 3),
                                                        ),
                                                      );
                                                    }
                                                  },
                                                  child: const Text('Add')),
                                            ],
                                          );
                                        });
                                  }),
                              const SizedBox(width: cDefaultSize),
                            ],
                          ),
                          const SizedBox(height: cDefaultSize),
                          // Sender's Email
                          TextFormField(
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.outbox),
                              labelText: 'SMTP Email',
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
                            obscureText: !_isPasswordVisible,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.lock_outlined),
                              labelText: 'Password',
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible =
                                        !_isPasswordVisible; // toggle password visibility state
                                  });
                                },
                                icon: Icon(
                                  // change the icon based on password visibility state
                                  _isPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
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
                                  _smtpConnectBloc.add(SmtpConnectLoginEvent(
                                      emailController.text,
                                      passwordController.text));
                                }
                              },
                              child: const Text(
                                'Connect to SMTP Server',
                                textAlign: TextAlign.center,
                              ),
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
