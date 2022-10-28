import 'package:drivers_app/authentication/car_info_screen.dart';
import 'package:drivers_app/authentication/login_screen.dart';
import 'package:drivers_app/global/globals.dart';
import 'package:drivers_app/widgets/progress_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

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

  validateForm() {
    if (nameTextEditingController.text.length <= 3) {
      Fluttertoast.showToast(msg: "Name must be more than 3 character long");
    } else {
      saveDriverInfo();
    }
  }

  saveDriverInfo() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ProgressDialog(message: "Loading.."),
    );
    final User firebaseUser = (await fauth
            .createUserWithEmailAndPassword(
                email: emailTextEditingController.text.trim(),
                password: passwordTextEditingController.text.trim())
            .catchError(
      (errorMsg) {
        Navigator.pop(context);
        Fluttertoast.showToast(
            msg: "Something went wrong: ${errorMsg.toString()} ");
        debugPrint(errorMsg.toString());
      },
    ))
        .user!;

    if (firebaseUser != Null) {
      Map driverMap = {
        "id": firebaseUser.uid,
        "name": nameTextEditingController.text,
        "phone": phoneTextEditingController.text.trim(),
        "email": emailTextEditingController.text.trim(),
      };

      DatabaseReference driverRef =
          FirebaseDatabase.instance.ref().child('drivers');
      driverRef.child(firebaseUser.uid).set(driverMap);

      currentFirebaseUser = firebaseUser;
      Navigator.push(
          context, MaterialPageRoute(builder: (c) => const CarInfoScreen()));
    } else {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Something went wrong: account not created!");
    }
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
            textField("Name", nameTextEditingController, TextInputType.name),
            textField("Email", emailTextEditingController,
                TextInputType.emailAddress),
            textField("Phone Number", phoneTextEditingController,
                TextInputType.phone),
            textField("Password", passwordTextEditingController,
                TextInputType.visiblePassword),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                validateForm();
              },
              style: ElevatedButton.styleFrom(primary: Colors.lightGreenAccent),
              child: const Text(
                "Create Account",
                style: TextStyle(color: Colors.black),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: ((context) => const LoginScreen())),
              ),
              child: const Text("Login Insted"),
            ),
          ],
        ),
      )),
    );
  }
}
