import 'dart:io';

import 'package:blog/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../constant.dart';
import '../models/api_response.dart';
import '../services/user_service.dart';
import 'login.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  User? user;
  bool loading = true;

  File? _imageFile;
  final _picker = ImagePicker();

  TextEditingController textNameController = TextEditingController();
  Future getImage() async {
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);
    if(pickedFile != null){
      setState(() {
        _imageFile = File(pickedFile.path);
        print(_imageFile);
      });
    }
  }

  // get user details

  Future <void> _getUser() async{
    ApiResponse response = await getUser();
    if(response.error == null){
      setState(() {
        user = response.data as User;
         loading = false;
         textNameController.text = user!.name ?? '';

      });
    }else if(response.error == unauthorized){
      logout().then((value) =>
      {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const Login()), (
            route) => false)
      });
    }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }

  
  //update user profile
  
  void updateUserProfile() async {
    ApiResponse response = await updateUser(textNameController.text, getStringImage(_imageFile));
    print(_imageFile?.path);
    setState(() {
      loading = false;
    });
    if(response.error == null){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${response.data}')));

    }else if(response.error == unauthorized){
      logout().then((value) =>
      {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const Login()), (
            route) => false)
      });
    }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }
  @override
  void initState() {
    _getUser();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return loading ? Center(child: CircularProgressIndicator(),) : 
        Padding(
          padding: EdgeInsets.only(top: 40, left: 40, right: 40),
          child: ListView(
            children: [
              Center(
                child: GestureDetector(
                  child: Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(60),
                      image: _imageFile == null ? user!.image != null ?
                      DecorationImage(image: NetworkImage('${user!.image}'), fit: BoxFit.cover) : DecorationImage(image: NetworkImage(
                        'https://cdn.pixabay.com/photo/2018/08/28/12/41/avatar-3637425_1280.png'
                      )) :
                          DecorationImage(
                              image: FileImage(_imageFile ?? File('')),fit: BoxFit.cover),
                      color: Colors.amber
                    )
                    ),
                  onTap: (){
                    getImage();
                  },
                  ),

                ),SizedBox(height: 20,),
              Form(
                key: _formkey,
                child: TextFormField(
                decoration: kInputDecoration('Name'),
                controller: textNameController,
                validator: (val) => val!.isEmpty ? 'Invalid name' : null,
              ),
              ), SizedBox(
                height: 20,
              ),
              kTextButton('Update', (){
                if(_formkey.currentState!.validate()){
                    setState(() {
                      loading = true;
                    });
                    updateUserProfile();
                }
              })
            ],
          ),
        );
  }
}
