import 'package:capstone_sams/global-widgets/buttons/FormSubmitButton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/theme/pallete.dart';
import '../../constants/theme/sizing.dart';
import '../../global-widgets/text-fields/Textfields.dart';
import '../../providers/AccountProvider.dart';
import '../home/HomeScreen.dart';

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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
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

      Navigator.pushNamed(context, '/home');
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(
      //     builder: (context) => HomeScreen(),
      //   ),
      // );
    } else {
      showFailure(context);
      Future.delayed(
        const Duration(seconds: 2),
        () => setState(() => _isLoading = false),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double elementWidth = MediaQuery.of(context).size.width / 1.5;
    return Scaffold(
      backgroundColor: Pallete.whiteColor,
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
                          child: Image.asset(
                              'assets/images/sams_single_text1.png',
                              height: 180),
                        ),
                        Text(
                          "Smarter. Faster. Healthier. - Digitally",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: Sizing.header6,
                            fontWeight: FontWeight.bold,
                            color: Pallete.greyColor,
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
                        FormSubmitButton(
                          title: 'Login',
                          icon: Icons.login,
                          isLoading: _isLoading,
                          onpressed: _isLoading ? null : _onSubmit,
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
