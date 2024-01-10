import 'package:blog/constant.dart';
import 'package:blog/models/api_response.dart';
import 'package:blog/screens/register.dart';
import 'package:blog/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';
import 'home.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey <FormState> formkey = GlobalKey<FormState> ();
  TextEditingController textEmail = TextEditingController();
  TextEditingController textPassword = TextEditingController();
  bool loading = false;

  void _loginUser() async {
    ApiResponse response = await login(textEmail.text, textPassword.text);

    if(response.error == null){
      _saveAndRedirectToHome(response.data as User);
    }else{
      setState(() {
        loading = false;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${response.error}')));
      });
    }
  }

  void _saveAndRedirectToHome(User user) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString('token', user.token ?? '');
    await preferences.setInt('userId', user.id ?? 0);
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const Home()), (route) => false);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
        centerTitle: true,

      ),
      body: Form(
        key: formkey,
        child: ListView(
          padding: const EdgeInsets.all(32),
          children: [

            // Image(image: AssetImage('assets/image/V-blog.png')),
            Container(
              padding: EdgeInsets.only(bottom: 50),
              width: 300,
              height: 200,
              decoration: BoxDecoration(
                  image: DecorationImage(image: AssetImage('assets/image/V-blog.png')
                      ),

              ),
            ),
            SizedBox(height: 20,),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              controller: textEmail,
              validator: (val) => val!.isEmpty ? 'Invalid email address' : null,
              decoration: kInputDecoration('Email')
            ),
            SizedBox(height: 20,),
            TextFormField(
              controller: textPassword,
              obscureText: true,
              validator: (val) => val!.length < 6  ? 'Required at last 6 chars' : null,
              decoration: kInputDecoration('Password')
            ),
            SizedBox(height: 10,),
            loading? Center(child: CircularProgressIndicator(),)
            :
            kTextButton('Login', (){
              if(formkey.currentState!.validate()){
                setState(() {
                  loading = true;
                  _loginUser();
                });
              }
            }),
            SizedBox(height: 10 ,),

            kloginRegisterHint('Dont have an account ? ','Register', (){
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Register()), (route) => false);
            } )
          ],
        ),
      ),
    );
  }
}
