import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class SmtpServerInfo extends Equatable {
  final String name;
  final String address;
  final int port;
  final bool ssl;
  final IconData icon;

  const SmtpServerInfo({
    required this.name,
    required this.address,
    required this.port,
    required this.ssl,
    required this.icon,
  });

  @override
  List<Object?> get props => [name, address, port, ssl, icon];
}
