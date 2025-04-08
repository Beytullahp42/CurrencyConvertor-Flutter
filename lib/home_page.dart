import 'package:beytullah_paytar_quiz/api_key.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'currency_convertor.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final controller = CurrencyConverterController();

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
            FutureBuilder(
              future: controller.rate,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  if (apiKey.isEmpty){
                    return Text("Please enter your API key in api_key.dart");
                  }
                  return Text("Error: ${snapshot.error}");
                } else {
                  final newRate = snapshot.data!;
                  if (controller.rateDouble != newRate) {
                    controller.setRate(newRate);
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
          setState(() {
            controller.refresh(controller.selectedFirstUnit, controller.selectedSecondUnit);
          });
        },
        tooltip: 'Refresh',
        child: const Icon(Icons.refresh),
      ),
    );
  }

  Widget body() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Currency Converter',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: DropdownButton<String>(
                    value: controller.selectedFirstUnit,
                    onChanged: (value) {
                      setState(() {
                        controller.selectedFirstUnit = value!;
                        controller.refresh(controller.selectedFirstUnit, controller.selectedSecondUnit);
                      });
                    },
                    items:
                        controller.unitList.map((unit) {
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
                      controller.swapUnits();
                    });
                  },
                ),
                Expanded(
                  child: DropdownButton<String>(
                    value: controller.selectedSecondUnit,
                    onChanged: (value) {
                      setState(() {
                        controller.selectedSecondUnit = value!;
                        controller.refresh(controller.selectedFirstUnit, controller.selectedSecondUnit);
                      });
                    },
                    items:
                        controller.unitList.map((unit) {
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
                    controller: controller.firstToSecondController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    onChanged: controller.convertFirstToSecond,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: controller.secondToFirstController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    onChanged: controller.convertSecondToFirst,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
