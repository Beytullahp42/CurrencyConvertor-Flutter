import 'package:beytullah_paytar_quiz/api_key.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<double> getCurrentPrice(String baseCurrency, String targetCurrency) async {
  final url = Uri.parse(
    'https://api.freecurrencyapi.com/v1/latest?apikey=$apiKey&base_currency=$baseCurrency',
  );

  final response = await http.get(url);
  try {
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final double rate = jsonResponse['data'][targetCurrency];
      return rate.toDouble();
    }
  } catch (e) {
    throw Exception("Error in fetching the rate: $e");
  }
  throw Exception("Unknown error in fetching the rate.");
}
