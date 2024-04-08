import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> fetchDataFromAPI(String apiUrl) async {
  try {
    final response = await http.get(Uri.parse(apiUrl));
    final responseData = json.decode(response.body);

    if (responseData['success']) {
      return responseData;
    } else {
      return {
        'success': false,
        'message': 'Failed to fetch data from the API',
      };
    }
  } catch (e) {
    return {
      'success': false,
      'message': 'Failed to fetch data from the API',
    };
  }
}
