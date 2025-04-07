import 'package:flutter/material.dart';

import 'currency_exchange_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Currency Exchange'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //body()
            FutureBuilder(
              future: rate,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text("Error: ${snapshot.error}");
                } else {
                  final newRate = snapshot.data!;
                  if (rateDouble != newRate) {
                    setRate(newRate);
                    if (firstToSecondController.text.isNotEmpty) {
                      convertFirstToSecond(firstToSecondController.text);
                    } else if (secondToFirstController.text.isNotEmpty) {
                      convertSecondToFirst(secondToFirstController.text);
                    }
                  }
                  return body();
                }
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          refresh(selectedFirstUnit, selectedSecondUnit);
        },
        tooltip: 'Refresh',
        child: const Icon(Icons.refresh),
      ),
    );
  }

  late Future<double> rate;

  @override
  void initState() {
    super.initState();
    rate = getCurrentPrice(selectedFirstUnit, selectedSecondUnit);
  }

  double rateDouble = 0.0;

  void setRate(double newRate) {
    rateDouble = newRate;
  }

  void refresh(String first, String second) {
    setState(() {
      rate = getCurrentPrice(first, second);
    });
  }

  TextEditingController secondToFirstController = TextEditingController();
  TextEditingController firstToSecondController = TextEditingController();

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

  String selectedFirstUnit = 'USD';
  String selectedSecondUnit = 'EUR';

  Widget body() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: DropdownButton<String>(
                    value: selectedFirstUnit,
                    onChanged: (value) {
                      setState(() {
                        selectedFirstUnit = value!;
                        refresh(selectedFirstUnit, selectedSecondUnit);
                      });
                    },
                    items:
                        unitList.map((unit) {
                          return DropdownMenuItem(
                            value: unit,
                            child: Text(unit),
                          );
                        }).toList(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.swap_horiz),
                  onPressed: () {
                    setState(() {
                      final temp = selectedFirstUnit;
                      selectedFirstUnit = selectedSecondUnit;
                      selectedSecondUnit = temp;

                      refresh(
                        selectedFirstUnit,
                        selectedSecondUnit,
                      ); //fetch new rate
                    });
                  },
                ),
                Expanded(
                  child: DropdownButton<String>(
                    value: selectedSecondUnit,
                    onChanged: (value) {
                      setState(() {
                        selectedSecondUnit = value!;
                        refresh(selectedFirstUnit, selectedSecondUnit);
                      });
                    },
                    items:
                        unitList.map((unit) {
                          return DropdownMenuItem(
                            value: unit,
                            child: Text(unit),
                          );
                        }).toList(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: firstToSecondController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    onChanged: convertFirstToSecond,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: secondToFirstController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    onChanged: convertSecondToFirst,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<String> unitList = [
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
