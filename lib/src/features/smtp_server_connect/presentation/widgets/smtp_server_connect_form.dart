// import 'package:cross_platform_mailing_app/core/constants/sizes.dart';
// import 'package:cross_platform_mailing_app/src/features/smtp_server_connect/presentation/bloc/smtp_bloc.dart';
// import 'package:email_validator/email_validator.dart';
// import 'package:flutter/material.dart';
//
//
// import '../bloc/smtp_event.dart';
//
//
// class SMTPServerConnectForm extends StatefulWidget {
//   final SmtpConnectBloc smtpConnectBloc;
//
//   const SMTPServerConnectForm({
//     required this.smtpConnectBloc,
//     super.key,
//   });
//
//   @override
//   SMTPServerConnectFormState createState() => SMTPServerConnectFormState();
// }
//
// class SMTPServerConnectFormState extends State<SMTPServerConnectForm> {
//   final _formKey = GlobalKey<FormState>();
//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();
//   bool _isPasswordVisible = false;
//
//   @override
//   Widget build(BuildContext context) {
//     return Form(
//       key: _formKey,
//       child: Container(
//         padding: const EdgeInsets.symmetric(vertical: cDefaultSize),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Sender's Email
//             TextFormField(
//               controller: emailController,
//               keyboardType: TextInputType.emailAddress,
//               decoration: const InputDecoration(
//                 prefixIcon: Icon(Icons.outbox),
//                 labelText: 'SMTP Email',
//               ),
//               validator: (value) {
//                 if (value!.isEmpty) {
//                   return 'Please enter sender\' Email';
//                 } else if (!EmailValidator.validate(value, true)) {
//                   return 'Please enter a valid email';
//                 }
//                 return null;
//               },
//             ),
//             const SizedBox(height: cDefaultSize),
//             // Sender's Password
//             TextFormField(
//               controller: passwordController,
//               keyboardType: TextInputType.visiblePassword,
//               obscureText: !_isPasswordVisible,
//               decoration: InputDecoration(
//                 prefixIcon: const Icon(Icons.lock_outlined),
//                 labelText: 'Password',
//                 suffixIcon: IconButton(
//                   onPressed: () {
//                     setState(() {
//                       _isPasswordVisible = !_isPasswordVisible;
//                     });
//                   },
//                   icon: Icon(
//                     _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
//                   ),
//                 ),
//               ),
//               validator: (value) {
//                 if (value!.isEmpty) {
//                   return 'Please enter sender\' password';
//                 }
//                 return null;
//               },
//             ),
//             const SizedBox(height: cDefaultSize),
//             // Connect to SMTP Server
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: () {
//                   if (_formKey.currentState!.validate()) {
//                     widget.smtpConnectBloc.add(SmtpConnectEvent.connect(
//                         emailController.text, passwordController.text));
//                   }
//                 },
//                 child: const Text('Connect to SMTP Server'),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }