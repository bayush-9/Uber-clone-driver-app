import 'package:drivers_app/global/globals.dart';
import 'package:drivers_app/splash_screen/splash_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class CarInfoScreen extends StatefulWidget {
  const CarInfoScreen({super.key});

  @override
  State<CarInfoScreen> createState() => _CarInfoScreenState();
}

class _CarInfoScreenState extends State<CarInfoScreen> {
  TextEditingController carModelTextEditingController = TextEditingController();
  TextEditingController carNumberTextEditingController =
      TextEditingController();
  TextEditingController carColorTextEditingController = TextEditingController();
  List<String> carTypesList = ['uber-x', 'uber-go', 'bike'];
  String? selectedCarType;
  Widget textField(
    String inputfield,
    TextEditingController fieldEditingController,
    TextInputType inputType,
  ) {
    return TextField(
      controller: fieldEditingController,
      keyboardType: inputType,
      style: const TextStyle(color: Colors.grey),
      obscureText: inputfield == "Password" ? true : false,
      decoration: InputDecoration(
        hintText: inputfield,
        labelText: inputfield,
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 10),
        labelStyle: const TextStyle(color: Colors.grey, fontSize: 20),
      ),
    );
  }

  validateData() {
    // add Required Validation
    saveCarInfo();
  }

  saveCarInfo() {
    Map driverCarInfoMap = {
      "car_color": carColorTextEditingController.text.trim(),
      "car_model": carModelTextEditingController.text.trim(),
      "car_number": carNumberTextEditingController.text.trim(),
      "type": selectedCarType
    };
    DatabaseReference driverRef =
        FirebaseDatabase.instance.ref().child('drivers');
    driverRef.child(currentFirebaseUser!.uid).child('car_details').set(
          driverCarInfoMap,
        );
    Navigator.push(
        context, MaterialPageRoute(builder: (c) => const MySplashScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Image.asset('assets/images/logo1.png'),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "Register as a driver.",
              style: TextStyle(
                  fontSize: 26,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold),
            ),
            textField(
                "Car Model", carModelTextEditingController, TextInputType.text),
            textField("Car Number", carNumberTextEditingController,
                TextInputType.text),
            textField("Car Color", carColorTextEditingController,
                TextInputType.phone),
            const SizedBox(
              height: 20,
            ),
            DropdownButton(
              dropdownColor: Colors.white24,
              hint: const Text(
                "Please select car type",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              items: carTypesList.map((element) {
                return DropdownMenuItem(
                  value: element.toString(),
                  child: Text(
                    element,
                    style: const TextStyle(color: Colors.grey),
                  ),
                );
              }).toList(),
              value: selectedCarType,
              onChanged: (value) {
                setState(() {
                  selectedCarType = value.toString();
                });
              },
            ),
            ElevatedButton(
              onPressed: () {
                validateData();
              },
              style: ElevatedButton.styleFrom(primary: Colors.lightGreenAccent),
              child: const Text(
                "Create Account",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
