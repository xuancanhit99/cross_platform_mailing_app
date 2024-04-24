import 'dart:io';

import 'package:cross_platform_mailing_app/src/features/smtp_server_connect/presentation/bloc/smtp_event.dart';
import 'package:cross_platform_mailing_app/src/features/smtp_server_connect/presentation/bloc/smtp_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:logger/logger.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

import '../../data/models/smtp_server_info_model.dart';

final logger = Logger();

class SmtpConnectBloc extends Bloc<SmtpConnectEvent, SmtpConnectState> {
  List<SmtpServerInfoModel> smtpServers = [
    const SmtpServerInfoModel(name: 'Gmail', address: 'smtp.gmail.com', port: 465, ssl: true, icon: FontAwesomeIcons.google),
    const SmtpServerInfoModel(name: 'Yandex', address: 'smtp.yandex.com', port: 465, ssl: true, icon: FontAwesomeIcons.yandex),
    const SmtpServerInfoModel(name: 'Mail.ru', address: 'smtp.mail.ru', port: 465, ssl: true, icon: FontAwesomeIcons.at),
  ];

  late SmtpServerInfoModel selectedSmtpServer;

  SmtpConnectBloc() : super(SmtpConnectState.initial) {
    selectedSmtpServer = smtpServers[0];

    on<SmtpConnectSelectServerEvent>((event, emit) {
      selectedSmtpServer = event.server;
      emit(SmtpConnectState.serverSelected);
      print(selectedSmtpServer);
    });

    on<SmtpConnectAddServerEvent>((event, emit) {
      smtpServers.add(event.server);
      emit(SmtpConnectState.serverAdded);
      print(smtpServers);
    });

    on<SmtpConnectLoginEvent>((event, emit) async {
      bool isConnected = await testSmtpConnection(event.email, event.password);
      if (isConnected) {
        emit(SmtpConnectState.success);
        // Trong Flutter, BlocListener chỉ phản hồi đối với mỗi trạng thái mới mà không phản hồi đối với trạng thái hiện tại. Điều này có nghĩa là nếu bạn gửi cùng một sự kiện hai lần liên tiếp và trạng thái không thay đổi, BlocListener sẽ không được kích hoạt lần thứ hai.  Để giải quyết vấn đề này, bạn có thể thêm một trạng thái mới vào enum SmtpConnectState của bạn, ví dụ retrying, và gửi trạng thái này trước khi gửi trạng thái failure một lần nữa. Điều này sẽ đảm bảo rằng mỗi lần bạn gửi sự kiện, trạng thái sẽ thay đổi và BlocListener sẽ được kích hoạt.
        emit(SmtpConnectState
            .retrying); // new state fix snackBar just show 1 time
        logger.i('Connect to SMTP Server successfully');
      } else {
        emit(SmtpConnectState.failure);
        emit(SmtpConnectState
            .retrying); // new state fix snackBar just show 1 time
        logger.e('Connect to SMTP Server failed');
      }
    });

    on<SmtpSendMailEvent>((event, emit) async {
      bool isSent = await sendEmail(event.name, event.recipient, event.subject, event.body, event.email, event.password, event.attachments);
      if (isSent) {
        emit(SmtpConnectState.sendingEmail);
        logger.i('Email sent successfully');
      } else {
        emit(SmtpConnectState.failure);
        logger.e('Email sending failed');
      }
    });
  }

  Future<bool> testSmtpConnection(String email, String password) async {
    print(selectedSmtpServer);
    SmtpServer smtpServer;
    if(selectedSmtpServer.address == 'smtp.gmail.com') {
      smtpServer = gmail(email, password);
    } else if (selectedSmtpServer.address == 'smtp.yandex.com') {
      smtpServer = yandex(email, password);
    } else {
      smtpServer = SmtpServer(selectedSmtpServer.address,
          username: email, password: password, port: 465, ssl: true);
    }
    final message = Message()
      ..from = Address(email)
      ..recipients.add(email)
      ..subject = 'Checking connection'
      ..text =
          'The application has successfully connected to the SMTP server. You can send the email now!';

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
      // return sendReport.sent;
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> sendEmail(String name, String recipient, String subject, String body, String email, String password, List<File> attachments) async {
    SmtpServer smtpServer;
    if(selectedSmtpServer.address == 'smtp.gmail.com') {
      smtpServer = gmail(email, password);
    } else if (selectedSmtpServer.address == 'smtp.yandex.com') {
      smtpServer = yandex(email, password);
    } else {
      smtpServer = SmtpServer(selectedSmtpServer.address,
          username: email, password: password, port: 465, ssl: true);
    }
    final message = Message()
      ..from = Address(email, name)
      ..recipients.add(recipient)
      ..subject = subject
      ..text = body;

    print(attachments);
    for (var file in attachments) {
      message.attachments.add(FileAttachment(file));
    }

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
      return true;
    } catch (e) {
      return false;
    }
  }


}
