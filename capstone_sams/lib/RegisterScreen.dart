 
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
 
 

class RegisterScreen extends StatefulWidget {
  
  const RegisterScreen({Key? key }): super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
 final _formKey = GlobalKey<FormState>();
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
                        
                        controller: _emailController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                         
                        decoration: const InputDecoration(
                          hintText: 'email',
                        ),
                      ),
                      TextFormField(
                        controller: _passwordController,
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
