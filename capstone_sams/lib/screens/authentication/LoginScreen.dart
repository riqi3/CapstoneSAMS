import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/theme/pallete.dart';
import '../../constants/theme/sizing.dart';
import '../../global-widgets/text-fields/Textfields.dart';

import '../home/HomeScreen.dart';

import '../../providers/AccountProvider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  var _isLoading = false; 

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
              color: Pallete.dangerColor,
            ),
          ),
          content: const Text("Failed to login.",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Pallete.dangerColor,
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

  void _onSubmit() async {
    setState(() => _isLoading = true);

    final username = usernameController.text;
    final password = passwordController.text;
    final success =
        await context.read<AccountProvider>().login(username, password);

    if (success) {
      final AccountProvider profile =
          Provider.of<AccountProvider>(context, listen: false);
      profile.isAuthentificated = true;
      usernameController.clear();
      passwordController.clear(); 
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      ); 
    } else {
      showFailure(context);
      Future.delayed(
        const Duration(seconds: 2),
        () => setState(() => _isLoading = false),
      );
    }
    print('login');
  }

  @override
  Widget build(BuildContext context) {
    double elementWidth = MediaQuery.of(context).size.width / 1.5;
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
                width: elementWidth,
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
                        ElevatedButton.icon(
                          onPressed: _isLoading ? null : _onSubmit,
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(elementWidth, elementWidth / 8),
                            backgroundColor: Pallete.whiteColor,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(Sizing.borderRadius),
                            ),
                          ),
                          icon: _isLoading
                              ? Container(
                                  width: 24,
                                  height: 24,
                                  padding: const EdgeInsets.all(4),
                                  child: const CircularProgressIndicator(
                                    color: Pallete.mainColor,
                                    strokeWidth: 3,
                                  ),
                                )
                              : const Icon(
                                  Icons.login,
                                  color: Pallete.mainColor,
                                ),
                          label: const Text(
                            'Login',
                            style: TextStyle(
                              color: Pallete.mainColor,
                            ),
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
 