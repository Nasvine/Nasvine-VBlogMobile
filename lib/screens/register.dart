import 'package:blog/screens/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:blog/services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constant.dart';
import '../models/api_response.dart';
import '../models/user.dart';
import 'home.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final GlobalKey <FormState> formkey = GlobalKey<FormState> ();
  TextEditingController
    nameController = TextEditingController(),
    emailController = TextEditingController(),
    passwordController = TextEditingController(),
    passwordConfirmController = TextEditingController();
  bool loading = false;

  void _registerUser() async {
    ApiResponse response = await register(nameController.text, emailController.text, passwordController.text);

    if(response.error == null){
      _saveAndRedirectToHome(response.data as User);
    }else{
      setState(() {
        loading = !loading;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${response.error}')));
      });
    }
  }

  void _saveAndRedirectToHome(User user) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString('token', user.token ?? '');
    await preferences.setInt('userId', user.id ?? 0);
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const Home()), (route) => false);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
        centerTitle: true,

      ),
      body: Form(
        key: formkey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 32),
          children: [
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
                keyboardType: TextInputType.text,
                controller: nameController,
                validator: (val) => val!.isEmpty ? 'Invalid name' : null,
                decoration: kInputDecoration('Name')
            ),
            SizedBox(height: 20,),
            TextFormField(
                keyboardType: TextInputType.emailAddress,
                controller: emailController,
                validator: (val) => val!.isEmpty ? 'Invalid email address' : null,
                decoration: kInputDecoration('Email')
            ),
            SizedBox(height: 20,),
            TextFormField(
                controller: passwordController,
                obscureText: true,
                validator: (val) => val!.length < 6  ? 'Required at last 6 chars' : null,
                decoration: kInputDecoration('Password')
            ), SizedBox(height: 20,),
            TextFormField(
                controller: passwordConfirmController,
                obscureText: true,
                validator: (val) => val != passwordController.text  ? 'Confirm password does not match' : null,
                decoration: kInputDecoration('Confirm Password')
            ), SizedBox(height: 20,),

            loading? Center(child: CircularProgressIndicator(),)
                :
            kTextButton('Register', (){
              if(formkey.currentState!.validate()){
                setState(() {
                  loading = !loading;
                   _registerUser();
                });
              }
            }),
            SizedBox(height: 10 ,),

            kloginRegisterHint('Already have an account ? ','Login', (){
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Login()), (route) => false);
            } )
          ],
        ),
      ),
    );
  }
}

