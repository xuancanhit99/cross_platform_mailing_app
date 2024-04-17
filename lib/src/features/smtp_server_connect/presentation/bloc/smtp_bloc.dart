import 'package:cross_platform_mailing_app/src/features/smtp_server_connect/presentation/bloc/smtp_event.dart';
import 'package:cross_platform_mailing_app/src/features/smtp_server_connect/presentation/bloc/smtp_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

final logger = Logger();

class SmtpConnectBloc extends Bloc<SmtpConnectEvent, SmtpConnectState> {

  String selectedSmtpServer = '';

  SmtpConnectBloc() : super(SmtpConnectState.initial) {
    on<SmtpConnectSelectServerEvent>((event, emit) {
      selectedSmtpServer = event.server;
      emit(SmtpConnectState.serverSelected);
      print(selectedSmtpServer);
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
  }

  Future<bool> testSmtpConnection(String email, String password) async {
    final smtpServer = SmtpServer(selectedSmtpServer,
        username: email, password: password, port: 465, ssl: true);
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
}
