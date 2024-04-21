
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../domain/entities/smtp_server_info.dart';

class SmtpServerInfoModel extends SmtpServerInfo {
  const SmtpServerInfoModel({
    required super.name,
    required super.address,
    required super.port,
    required super.ssl,
    super.icon = FontAwesomeIcons.server,
  });

  factory SmtpServerInfoModel.fromJson(String source) =>
      SmtpServerInfoModel.fromMap(jsonDecode(source) as Map<String, dynamic>);

  factory SmtpServerInfoModel.fromMap(Map<String, dynamic> map) {
    return SmtpServerInfoModel(
      name: map['name'] as String,
      address: map['address'] as String,
      port: map['port'] as int,
      ssl: map['ssl'] as bool,
      icon: map['icon'] as IconData,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'address': address,
      'port': port,
      'ssl': ssl,
      'icon': icon,
    };
  }

  String toJson() => jsonEncode(toMap());

  SmtpServerInfoModel copyWith({
    String? name,
    String? address,
    int? port,
    bool? ssl,
    IconData? icon,
  }) {
    return SmtpServerInfoModel(
      name: name ?? this.name,
      address: address ?? this.address,
      port: port ?? this.port,
      ssl: ssl ?? this.ssl,
      icon: icon ?? this.icon,
    );
  }
}