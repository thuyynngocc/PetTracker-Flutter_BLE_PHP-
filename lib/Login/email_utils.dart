import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class EmailUtils {
  static Future<void> sendEmail(String recipient, String subject, String body) async {
    final smtpServer = gmail('nltn0611@gmail.com', 'thuyngoc0611');

    final message = Message()
      ..from = Address('nltn0611@gmail.com', 'Your Name')
      ..recipients.add(recipient)
      ..subject = subject
      ..text = body;

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ${sendReport.mail}');
    } on MailerException catch (e) {
      print('Message not sent. ${e.message}');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }
  }
}
