abstract class SmtpConnectEvent {
  const SmtpConnectEvent();
}

class SmtpConnectSelectServerEvent extends SmtpConnectEvent {
  final String server;

  const SmtpConnectSelectServerEvent(this.server);
}


class SmtpConnectLoginEvent extends SmtpConnectEvent {
  final String email;
  final String password;

  const SmtpConnectLoginEvent(this.email, this.password);
}