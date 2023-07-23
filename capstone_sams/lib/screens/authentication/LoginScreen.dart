import 'dart:convert';

import 'package:capstone_sams/AdminScreen.dart';
 
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/Env.dart';
import '../home/HomeScreen.dart';
import '../../models/Account.dart';
import '../../providers/AccountProvider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Future<Account?> _login() async {
  //   final url = Uri.parse('${Env.prefix}/login/');
  //   final response = await http.post(url,
  //       headers: <String, String>{
  //         'Content-Type': 'application/json; charset=UTF-8'
  //       },
  //       body: jsonEncode(<String, String>{
  //         'username': usernameController.text,
  //         'password': passwordController.text
  //       }));
  //   if (response.statusCode == 200) {
  //     final jsonBody = json.decode(response.body);
  //     final account = Account.fromJson(jsonBody);
  //     return account;
  //   } else {
  //     return null;
  //   }
  // }

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
          content: const Text("Failed to login.",
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
      }),
    );
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
        title: const Text('User LoginScreen'),
      ),
      body: LayoutBuilder(builder: (context, cons) {
        return ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: cons.maxHeight,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Column(
                  children: [
                    // TextFormField(
                    //   controller: _nameController,
                    //   validator: (value) =>
                    //       value == '' ? 'Please input username' : null,
                    //   decoration: const InputDecoration(
                    //     hintText: 'user name',
                    //   ),
                    // ),
                    TextFormField(
                      controller: usernameController,
                      validator: (value) =>
                          value == '' ? 'Please input username' : null,
                      decoration: const InputDecoration(
                        hintText: 'username',
                      ),
                    ),
                    TextFormField(
                      controller: passwordController,
                      // obscureText: true,
                      validator: (value) =>
                          value == '' ? 'Please input password' : null,
                      decoration: const InputDecoration(
                        hintText: 'password',
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        final username = usernameController.text;
                        final password = passwordController.text;
                        final success = await context
                            .read<AccountProvider>()
                            .login(username, password);
                        if (success) {
                          usernameController.clear();
                          passwordController.clear();
                          // if (context.read<AccountProvider>().role ==
                          //     'Physician') {
                          //   Navigator.of(context).push(
                          //     MaterialPageRoute(
                          //       builder: (context) => const HomeScreen(),
                          //     ),
                          //   );
                          // } else {
                          //   Navigator.of(context).push(MaterialPageRoute(
                          //       builder: (context) => const AdminScreen()));
                          // }
                          switch (context.read<AccountProvider>().role) {
                            case 'Physician':
                              {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const HomeScreen(),
                                  ),
                                );
                              }
                              break;
                            case 'MedTech':
                              {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const HomeScreen(),
                                  ),
                                );
                              }
                              break;
                            case 'Nurse':
                              {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const HomeScreen(),
                                  ),
                                );
                              }
                              break;
                            default:
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const AdminScreen(),
                                ),
                              );
                          }
                        } else {
                          showFailure(context);
                        }
                        print('login');
                      },
                      child: const Text(
                        "Login",
                        style: TextStyle(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
