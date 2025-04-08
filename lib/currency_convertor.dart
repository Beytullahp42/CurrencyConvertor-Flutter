import 'package:flutter/material.dart';

import 'currency_exchange_api_call.dart';

class CurrencyConverterController {
  final firstToSecondController = TextEditingController();
  final secondToFirstController = TextEditingController();

  String selectedFirstUnit = 'USD';
  String selectedSecondUnit = 'EUR';

  double rateDouble = 0.0;
  late Future<double> rate;

  CurrencyConverterController() {
    rate = getCurrentPrice(selectedFirstUnit, selectedSecondUnit);
    firstToSecondController.text = '1';
  }

  void setRate(double newRate) {
    rateDouble = newRate;
    if (firstToSecondController.text.isNotEmpty) {
      convertFirstToSecond(firstToSecondController.text);
    } else if (secondToFirstController.text.isNotEmpty) {
      convertSecondToFirst(secondToFirstController.text);
    }
  }

  void refresh(String first, String second) {
    rate = getCurrentPrice(first, second);
  }

  void convertFirstToSecond(String input) {
    double first = double.tryParse(input) ?? 0;
    double second = first * rateDouble;
    secondToFirstController.text = second.toStringAsFixed(2);
  }

  void convertSecondToFirst(String input) {
    double second = double.tryParse(input) ?? 0;
    double first = second / rateDouble;
    firstToSecondController.text = first.toStringAsFixed(2);
  }

  void swapUnits() {
    final temp = selectedFirstUnit;
    selectedFirstUnit = selectedSecondUnit;
    selectedSecondUnit = temp;

    refresh(selectedFirstUnit, selectedSecondUnit);
  }

  final List<String> unitList = [
    'EUR',
    'USD',
    'JPY',
    'BGN',
    'CZK',
    'DKK',
    'GBP',
    'HUF',
    'PLN',
    'RON',
    'SEK',
    'CHF',
    'ISK',
    'NOK',
    'HRK',
    'RUB',
    'TRY',
    'AUD',
    'BRL',
    'CAD',
    'CNY',
    'HKD',
    'IDR',
    'ILS',
    'INR',
    'KRW',
    'MXN',
    'MYR',
    'NZD',
    'PHP',
    'SGD',
    'THB',
    'ZAR',
  ];
}
