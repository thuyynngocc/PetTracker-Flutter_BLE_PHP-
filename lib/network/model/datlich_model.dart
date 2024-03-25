import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const baseUrl = 'http://localhost/medhealth_db/get_datlich.php'; // Thay thế bằng URL của máy chủ của bạn

  static Future<List<Map<String, dynamic>>> getBookedAppointments(int userId) async {
    final response = await http.get('$baseUrl/$userId' as Uri);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load booked appointments');
    }
  }
}