import 'dart:convert';

import 'package:capstone_sams/AdminScreen.dart';
import 'package:capstone_sams/theme/pallete.dart';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/Env.dart';
import '../../global-widgets/text-fields/Textfields.dart';
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
      backgroundColor: Pallete.mainColor,
      body: LayoutBuilder(builder: (context, cons) {
        return ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: cons.maxHeight,
          ),
          child: SingleChildScrollView(
            child: Center(
              child: Container(
                width: MediaQuery.of(context).size.width / 1.5,
                child: Column(
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.only(top: 150.0, bottom: 20),
                          child: Image.asset('assets/images/logo2.png',
                              height: 180),
                        ),
                        Text(
                          "SAMS",
                          style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 30),
                        ShortTextfield(
                          controller: usernameController,
                          validator: 'Please input username',
                          hintText: 'Username',
                        ),
                        SizedBox(height: 10),
                        PasswordTextfield(
                          controller: passwordController,
                          validator: 'Please input password',
                          hintText: 'Password',
                        ),
                        SizedBox(height: 20),
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
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const HomeScreen(),
                                ),
                              );
                              // switch (context.read<AccountProvider>().role) {
                              //   case 'Physician':
                              //     {
                              //       Navigator.of(context).push(
                              //         MaterialPageRoute(
                              //           builder: (context) => const HomeScreen(),
                              //         ),
                              //       );
                              //     }
                              //     break;
                              //   case 'MedTech':
                              //     {
                              //       Navigator.of(context).push(
                              //         MaterialPageRoute(
                              //           builder: (context) => const HomeScreen(),
                              //         ),
                              //       );
                              //     }
                              //     break;
                              //   case 'Nurse':
                              //     {
                              //       Navigator.of(context).push(
                              //         MaterialPageRoute(
                              //           builder: (context) => const HomeScreen(),
                              //         ),
                              //       );
                              //     }
                              //     break;
                              //   default:
                              //     Navigator.of(context).push(
                              //       MaterialPageRoute(
                              //         builder: (context) => const AdminScreen(),
                              //       ),
                              //     );
                              // }
                            } else {
                              showFailure(context);
                            }
                            print('login');
                          },
                          child: const Text(
                            "Login",
                            style: TextStyle(color: Pallete.mainColor),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Pallete.whiteColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            elevation: 6,
                            minimumSize: Size(100, 30),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

// class ShortTextfield extends StatelessWidget {
//   const ShortTextfield({
//     super.key,
//     required this.usernameController,
//   });

//   final TextEditingController usernameController;

//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       controller: usernameController,
//       validator: (value) =>
//           value == '' ? 'Please input username' : null,
//       decoration: const InputDecoration(
//         hintText: 'username',
//       ),
//     );
//   }
// }
