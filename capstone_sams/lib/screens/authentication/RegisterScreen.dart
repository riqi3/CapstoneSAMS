 
import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../constants/Env.dart';
import '../../models/Account.dart';
 
 

class RegisterScreen extends StatefulWidget {
  
  const RegisterScreen({Key? key }): super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
 final _formKey = GlobalKey<FormState>();
     TextEditingController usernameController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController firstNameController = TextEditingController();
    TextEditingController lastNameController = TextEditingController();

   Future<void> showFailure(BuildContext context) async {
    return showDialog(
        context: context,
        builder: ((context) {
          return AlertDialog(
            title: const Text(
              "Error",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
                color: Colors.red,
              ),
            ),
            content: const Text("Failed to register.",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple,
                )),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("OK"),
              )
            ],
          );
        }),);
  }

  // @override
  // void dispose() {
  //   _emailController.dispose();
  //   _passwordController.dispose();

  //   super.dispose();
  // }

 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User RegisterScreen'),
      ),
      body: LayoutBuilder(builder: (context, cons) {
        return ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: cons.maxHeight,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                               
                      TextFormField(
                        
                        controller: usernameController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                         
                        decoration: const InputDecoration(
                          hintText: 'username',
                        ),
                      ),
                      TextFormField(
                        
                        controller: firstNameController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                         
                        decoration: const InputDecoration(
                          hintText: 'firstname',
                        ),
                      ),
                      TextFormField(
                        
                        controller: lastNameController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                         
                        decoration: const InputDecoration(
                          hintText: 'lastname',
                        ),
                      ),
                      TextFormField(
                        controller: passwordController,
                        obscureText: false,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) =>
                            value != null && value.length < 6
                            ? 'enter valid password of minimum 6 characters'
                            : null,
                        decoration: const InputDecoration(
                          hintText: 'password',
                        ),
                      ),
                     
                      TextButton(
                        onPressed: () async {
 if (usernameController.text.isNotEmpty &&
                      passwordController.text.isNotEmpty &&
                      firstNameController.text.isNotEmpty &&
                      lastNameController.text.isNotEmpty) {
                    String id = const Uuid().v4();
                    Account newAccount = Account(
                        accountID: id,
                        username: usernameController.text,
                        password: passwordController.text,
                        firstName: firstNameController.text,
                        lastName: lastNameController.text,
                        accountRole: 'User',
                        isActive: true,
                        isStaff: false,
                        isSuperuser: false);
                    Map<String, String> headers = {
                      'Content-type': 'application/json',
                      'Accept': 'application/json',
                    };

                    String url = '${Env.prefix}/register/';

                    http.post(Uri.parse(url),
                        headers: headers,
                        body: jsonEncode(newAccount.toJson()));

                    Navigator.pop(context);
                  } else {
                    showFailure(context);
                  }
                        },
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
          
                    RichText(
                      text: TextSpan(
                        text: 'already have bitches? ',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                        children: [
                           
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Future<dynamic> _showDialog(BuildContext context, registerResponse) {
    return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          alignment: Alignment.center,
          child: Container(
            height: 100,
            width: 200,
            decoration: const BoxDecoration(),
            child: Text(
              registerResponse.toString(),
            ),
          ),
        );
      },
    );
  }
}
