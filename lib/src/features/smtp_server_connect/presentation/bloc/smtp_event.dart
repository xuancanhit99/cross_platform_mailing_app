import 'dart:io';

import 'package:cross_platform_mailing_app/src/features/smtp_server_connect/data/models/smtp_server_info_model.dart';

abstract class SmtpConnectEvent {
  const SmtpConnectEvent();
}

class SmtpConnectLoginEvent extends SmtpConnectEvent {
  final String email;
  final String password;

  const SmtpConnectLoginEvent(this.email, this.password);
}

class SmtpConnectSelectServerEvent extends SmtpConnectEvent {
  final SmtpServerInfoModel server;

  const SmtpConnectSelectServerEvent(this.server);
}

class SmtpConnectAddServerEvent extends SmtpConnectEvent {
  final SmtpServerInfoModel server;

  const SmtpConnectAddServerEvent(this.server);
}

class SmtpSendMailEvent extends SmtpConnectEvent {
  final String name;
  final String email;
  final String password;
  final String recipient;
  final String subject;
  final String body;
  final List<File> attachments;

  const SmtpSendMailEvent({
    required this.name,
    required this.email,
    required this.password,
    required this.recipient,
    required this.subject,
    required this.body,
    required this.attachments,
  });
}

class SmtpSendEmailViaURLPostEvent extends SmtpConnectEvent {
  final String webserviceUrl;
  final String name;
  final String recipient;
  final String subject;
  final String body;
  final String email;
  final String password;
  final List<File> attachments;

  const SmtpSendEmailViaURLPostEvent({
    required this.webserviceUrl,
    required this.name,
    required this.email,
    required this.password,
    required this.recipient,
    required this.subject,
    required this.body,
    required this.attachments,
  });
}