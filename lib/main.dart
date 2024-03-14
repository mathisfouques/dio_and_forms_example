import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forms_example/dio_page.dart';

import 'custom_image_form_field.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Forms',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const FormPage(),
    );
  }
}

class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomFormField(
                hintText: 'Name',
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                    RegExp(r"[a-zA-Z]+|\s"),
                  )
                ],
                validator: (val) {
                  if (!val.isValidName) return 'Enter valid name';

                  return null;
                },
              ),
              CustomFormField(
                hintText: 'Email',
                validator: (val) {
                  if (!val.isValidEmail) return 'Enter valid email';
                  return null;
                },
              ),
              CustomFormField(
                hintText: 'Phone',
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                    RegExp(r"[0-9]"),
                  )
                ],
                validator: (val) {
                  if (!val.isValidPhone) return 'Enter valid phone';
                  return null;
                },
              ),
              CustomImageFormField(
                validator: (val) {
                  if (val == null) return 'Pick a picture';
                  return null;
                },
                onChanged: (file) {},
              ),
              CustomFormField(
                hintText: 'Password',
                validator: (val) {
                  if (!val.isValidPassword) return 'Enter valid password';
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Successful Form validation'),
                      ),
                    );

                    // Interaction avec Bloc (ou riverpod, provider, etc.)
                  }
                },
                child: const Text('Submit'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const DioPage()),
                  );
                },
                child: const Text('Go to Dio Page'),
              ),

              // Go to bloc page
              ElevatedButton(
                onPressed: () {},
                child: const Text('Go to Bloc Page'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomFormField extends StatelessWidget {
  const CustomFormField({
    super.key,
    required this.hintText,
    this.inputFormatters,
    this.validator,
  });
  final String hintText;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        inputFormatters: inputFormatters,
        validator: validator,
        decoration: InputDecoration(hintText: hintText),
      ),
    );
  }
}

extension StringValidators on String? {
  bool get isValidEmail {
    if (this == null) return false;

    return RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(this!);
  }

  bool get isValidName {
    if (this == null) return false;

    return RegExp(r"^\s*([A-Za-z]{1,}([\.,] |[-']| ))+[A-Za-z]+\.?\s*$")
        .hasMatch(this!);
  }

  bool get isValidPassword {
    if (this == null) return false;

    return RegExp(
            r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\><*~]).{8,}/pre>')
        .hasMatch(this!);
  }

  bool get isNotNull => this != null;

  bool get isValidPhone {
    if (this == null) return false;

    return RegExp(r"^\+?0[0-9]{10}$").hasMatch(this!);
  }
}
