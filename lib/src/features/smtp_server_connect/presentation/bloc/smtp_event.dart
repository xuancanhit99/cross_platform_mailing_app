class SmtpConnectEvent {
  final String email;
  final String password;

  SmtpConnectEvent.connect(this.email, this.password);
}