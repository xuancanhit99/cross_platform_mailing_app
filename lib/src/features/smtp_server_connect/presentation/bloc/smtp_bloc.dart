import 'package:cross_platform_mailing_app/src/features/smtp_server_connect/presentation/bloc/smtp_event.dart';
import 'package:cross_platform_mailing_app/src/features/smtp_server_connect/presentation/bloc/smtp_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';


final logger = Logger();

class SmtpConnectBloc extends Bloc<SmtpConnectEvent, SmtpConnectState> {
  SmtpConnectBloc() : super(SmtpConnectState.initial) {
    on<SmtpConnectEvent>((event, emit) async {
      bool isConnected = await testSmtpConnection(event.email, event.password);
      if (isConnected) {
        emit(SmtpConnectState.success);
        logger.i('Connect to SMTP Server successfully');
      } else {
        emit(SmtpConnectState.failure);
        logger.e('Connect to SMTP Server failed');
      }
    });
  }

  Future<bool> testSmtpConnection(String email, String password) async {
    final smtpServer = SmtpServer('smtp.mail.ru',
        username: email, password: password, port: 465, ssl: true);

    final message = Message()
      ..from = Address(email)
      ..recipients.add(email)
      ..subject = 'Checking connection'
      ..text = 'The application has successfully connected to the SMTP server. You can send the email now!';

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
      // return sendReport.sent;
      return true;
    } catch (e) {
      return false;
    }
  }
}