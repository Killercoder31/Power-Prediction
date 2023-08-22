import 'dart:convert';
import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const Prediction());
}

class Prediction extends StatefulWidget {
  const Prediction({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _Prediction();
}

class _Prediction extends State<Prediction> {
  static const List<String> electrolyteType = <String>["NaOH", "KOH"];
  static const Map<String, int> electrolyteTypeMapper = {
    'NaOH': 0,
    'KOH': 1,
  };

  String endpoint = "";
  String power = "N/A";

  String electrolyte = "";
  String electrolyteConcentration = "";
  String voltage = "";
  String currentDensity = "";

  final fieldText0 = TextEditingController();
  final fieldText1 = TextEditingController();
  final fieldText2 = TextEditingController();
  final fieldText3 = TextEditingController();
  final fieldText4 = TextEditingController();

  void clearText() {
    fieldText1.clear();
    fieldText2.clear();
    fieldText3.clear();
    fieldText4.clear();
  }

  Future<Predict> fetchPrediction() async {
    Predict val;

    // if (electrolyte == "" &&
    //     electrolyteConcentration == "" &&
    //     voltage == "" &&
    //     currentDensity == "") {
    //   val = const Predict(prediction: 0.0);
    //   setState(() {
    //     power = "N/A";
    //   });
    //   return val;
    // } // todo
    int? electrolyteInteger = electrolyteTypeMapper[electrolyte];
    final response = await http.get(Uri.parse(
        "http://$endpoint:5000/predict?electrolyte=$electrolyteInteger&electrolyteConcentration=$electrolyteConcentration&current=$currentDensity&voltage=$voltage"));

    if (response.statusCode == 200) {
      dev.log(response.body);
      val = Predict.fromJson(jsonDecode(response.body));
    } else {
      setState(() {
        power = "N/A";
      });
      throw Exception('Failed to get data');
    }

    setState(() {
      power = val.prediction.toString();

      // electrolyte = "";
      // electrolyteConcentration = "";
      // voltage = "";
      // currentDensity = "";
    });

    return val;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title:
              const Text("Power Prediction", textDirection: TextDirection.ltr),
        ),
        body: ListView(
          padding: const EdgeInsets.only(top: 25),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Material(
                elevation: 10.0,
                shadowColor: Colors.blue,
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  autofocus: false,
                  onChanged: (text) {
                    endpoint = text;
                  },
                  controller: fieldText0,
                  decoration: InputDecoration(
                    icon: const Icon(
                      Icons.computer_rounded,
                      color: Color(0xff224597),
                    ),
                    labelText: "IP Address",
                    fillColor: Colors.white,
                    filled: true,
                    contentPadding:
                        const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                    labelStyle: const TextStyle(color: Colors.grey),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide:
                          const BorderSide(color: Colors.white, width: 3.0),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Material(
                elevation: 10.0,
                shadowColor: Colors.blue,
                child: DropdownButtonFormField(
                  value: electrolyte.isNotEmpty ? electrolyte : null,
                  icon: const Icon(Icons.swipe_down),
                  elevation: 20,
                  focusColor: Colors.blue[300]!,
                  borderRadius: BorderRadius.circular(5.0),
                  decoration: InputDecoration(
                    icon: const Icon(
                      Icons.science_rounded,
                      color: Color(0xff224597),
                    ),
                    labelText: "Electrolyte Type",
                    fillColor: Colors.white,
                    filled: true,
                    contentPadding:
                        const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                    labelStyle: const TextStyle(color: Colors.grey),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide:
                          const BorderSide(color: Colors.white, width: 3.0),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      electrolyte = value!;
                    });
                  },
                  items: electrolyteType.map((item) {
                    return DropdownMenuItem(
                      value: item,
                      child: Text(item),
                    );
                  }).toList(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Material(
                elevation: 10.0,
                shadowColor: Colors.blue,
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  autofocus: false,
                  onChanged: (text) {
                    electrolyteConcentration = text;
                  },
                  controller: fieldText2,
                  decoration: InputDecoration(
                    icon: const Icon(
                      Icons.science_rounded,
                      color: Color(0xff224597),
                    ),
                    labelText: "Electrolyte Concentration (mM)",
                    fillColor: Colors.white,
                    filled: true,
                    contentPadding:
                        const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                    labelStyle: const TextStyle(color: Colors.grey),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide:
                          const BorderSide(color: Colors.white, width: 3.0),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Material(
                elevation: 10.0,
                shadowColor: Colors.blue,
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  autofocus: false,
                  onChanged: (text) {
                    voltage = text;
                  },
                  controller: fieldText3,
                  decoration: InputDecoration(
                    icon: const Icon(
                      Icons.electric_bolt_rounded,
                      color: Color(0xff224597),
                    ),
                    labelText: "Voltage (V)",
                    fillColor: Colors.white,
                    filled: true,
                    contentPadding:
                        const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                    labelStyle: const TextStyle(color: Colors.grey),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide:
                          const BorderSide(color: Colors.white, width: 3.0),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Material(
                elevation: 10.0,
                shadowColor: Colors.blue,
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  autofocus: false,
                  onChanged: (text) {
                    currentDensity = text;
                  },
                  controller: fieldText4,
                  decoration: InputDecoration(
                    icon: const Icon(
                      Icons.electrical_services_rounded,
                      color: Color(0xff224597),
                    ),
                    labelText: "Current Density (mA/cm\u00B2)",
                    fillColor: Colors.white,
                    filled: true,
                    contentPadding:
                        const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                    labelStyle: const TextStyle(color: Colors.grey),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide:
                          const BorderSide(color: Colors.white, width: 3.0),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: ElevatedButton(
                style: ButtonStyle(
                  shadowColor: MaterialStateProperty.all<Color>(Colors.blue),
                  elevation: MaterialStateProperty.all(15),
                  enableFeedback: true,
                ),
                onPressed: () {
                  // setState(() {
                  //   endpoint.isEmpty || intensity.isEmpty
                  //       ? _validate = true
                  //       : _validate = false;
                  // });
                  fetchPrediction();
                  clearText();
                },
                child: const Text("Predict"),
              ),
            ),
            const Center(
              child: Text(
                "Power",
                style: TextStyle(fontSize: 23),
              ),
            ),
            Center(
              child: Text(
                "In mW/cm\u00B2 : $power",
                style: const TextStyle(fontSize: 21),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 45, 25, 0),
              child: Center(
                child: power != "N/A"
                    ? Text(
                        "This is the estimated power based on the inputs Electr"
                        "olyte = $electrolyte, Electrolyte Concentration = "
                        "$electrolyteConcentration mM, Voltage = $voltage V, "
                        "Current Density = $currentDensity mA/cm\u00B2",
                      )
                    : const Text(""),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: Center(
                child: Image.asset('assets/Technion_logo.svg.png', scale: 2,),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Predict {
  final double prediction;

  const Predict({required this.prediction});

  factory Predict.fromJson(Map<String, dynamic> json) {
    return Predict(
      prediction: json["prediction"],
    );
  }
}
