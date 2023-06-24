 
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

 

class LoginScreen extends StatefulWidget {
   
  const LoginScreen({Key? key})
      : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
 
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

 
 
 
 

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

 

 

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
                      controller: _emailController,
                      validator: (value) =>
                          value == '' ? 'Please input email' : null,
                      decoration: const InputDecoration(
                        hintText: 'email',
                      ),
                    ),
                    TextFormField(
                      controller: _passwordController,
                      // obscureText: true,
                      validator: (value) =>
                          value == '' ? 'Please input password' : null,
                      decoration: const InputDecoration(
                        hintText: 'password',
                      ),
                    ),
                    TextButton(
                      onPressed: () {
 
                        print('login');
                      },
                      child: const Text(
                        "Login",
                        style: TextStyle(),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
          
                    RichText(
                      text: TextSpan(
                        text: 'no bitches? ',
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
}
