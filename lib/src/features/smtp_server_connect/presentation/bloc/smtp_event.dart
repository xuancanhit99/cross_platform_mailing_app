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