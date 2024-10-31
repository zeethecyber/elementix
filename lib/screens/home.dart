import 'dart:developer';

import 'package:elementix/screens/sensor.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Get Storage Box
  var box = GetStorage();

  // Loading State
  bool _loading = false;

  // Text Input Controllers
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  // Form Key
  final _formKey = GlobalKey<FormState>();

  // Function to sign in user
  Future<void> _signInUser() async {
    FocusScope.of(context).unfocus();
    setState(() {
      _loading = true;
    });
    log(emailController.text);
    log(passwordController.text);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      box.write('@logged_in', 1);
      Get.off(const Sensor());
      _showSnackbar('User login successful', 'success');
    } catch (e) {
      log(e.toString());
      _showSnackbar(e.toString(), 'danger');
    }
    setState(() {
      _loading = false;
    });
  }

  // Snackbar. type (success | danger);
  _showSnackbar(String text, String type) {
    var snackBar = SnackBar(
      content: Text(
        text,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: type == 'success' ? Colors.green[600] : Colors.red[600],
    );
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome to Elementix',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 50,
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      hintText: 'Enter email address',
                      label: Text('Email'),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a value';
                      }
                      final RegExp emailRegex = RegExp(
                        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                      );
                      if (!emailRegex.hasMatch(value)) {
                        return 'Please enter a valid email';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  TextFormField(
                    controller: passwordController,
                    decoration: const InputDecoration(
                      hintText: 'Enter password',
                      label: Text('Password'),
                    ),
                    validator: (value) {
                      if (value!.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 100,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Get.to(Sensor());
                        if (_formKey.currentState!.validate()) {
                          _signInUser();
                          // _showSnackbar('Testing snackbar', 'danger');
                        }
                      },
                      icon: _loading
                          ? Container(
                              width: 24,
                              height: 24,
                              padding: const EdgeInsets.all(2.0),
                              child: const CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 3,
                              ),
                            )
                          : const Icon(Icons.login),
                      label: const Text('Login'),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
