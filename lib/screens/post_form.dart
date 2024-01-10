

import 'dart:developer';
import 'dart:io';

import 'package:blog/constant.dart';
import 'package:blog/screens/home.dart';
import 'package:blog/screens/login.dart';
import 'package:blog/screens/post_screen.dart';
import 'package:blog/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/api_response.dart';
import '../models/post.dart';
import '../services/post_service.dart';

class PostForm extends StatefulWidget {


  final Post? post;
  final String? title;

   const PostForm({super.key,
    this.post, this.title
});

  @override
  State<PostForm> createState() => _PostFormState();
}

class _PostFormState extends State<PostForm> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final TextEditingController _txtControllerBody = TextEditingController();
  bool _loading = false;
 /// Déclaration de la variable _imageFile de type File qui peut  être null(?)

  File? _imageFile;
  final _picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);
    if(pickedFile != null){
      setState(() {
        _imageFile = File(pickedFile.path);
        print(_imageFile);
      });
    }
  }

  void _createPost() async {
    String? image = _imageFile == null ? null : getStringImage(_imageFile);
    ApiResponse response = await createPost(_txtControllerBody.text, image);
    if(response.error == null){
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const Home()), (
          route) => false);
    }else if(response.error == unauthorized){
       logout().then((value) =>
       {
         Navigator.of(context).pushAndRemoveUntil(
             MaterialPageRoute(builder: (context) => const Login()), (
             route) => false)
       });
    }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${response.error}')));
      setState(() {
        _loading = !_loading;
      });
    }
  }

  void _editPost(int postId) async {
    ApiResponse response = await editPost(postId, _txtControllerBody.text);
    if(response.error == null){
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const Home()), (
          route) => false);
    }else if(response.error == unauthorized){
       logout().then((value) =>
       {
         Navigator.of(context).pushAndRemoveUntil(
             MaterialPageRoute(builder: (context) => const Login()), (
             route) => false)
       });
    }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${response.error}')));
      setState(() {
        _loading = !_loading;
      });
    }
  }  @override
  void initState() {
    if(widget.post != null){
      _txtControllerBody.text = widget.post!.body ?? '';
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
      appBar: AppBar(
        title:  Text('${widget.title}'),
        centerTitle: true,
        leading: Builder(builder: (BuildContext context) {
          return IconButton(onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const Home()), (route) => false);
          },
          icon: const Icon(Icons.arrow_back));
        },

        )
      ),
      body: _loading ? const Center(child: CircularProgressIndicator(),) : ListView(
        children: [
          widget.post != null ? SizedBox() :
         Container(
           width: MediaQuery.of(context).size.width,
           height: 200,
           decoration: BoxDecoration(
             image: _imageFile == null ? null : DecorationImage(
                 image: FileImage(_imageFile ?? File('')),
                 fit: BoxFit.cover )),

           child: Center(
             child: IconButton(
               icon: const Icon(Icons.image, size: 50, color: Colors.black38,), onPressed: () {
               getImage();
             },
             ),
           ),
         ), 
          Form(
              key: _formkey,
              child: Padding(
            padding: EdgeInsets.all(8),
            child: TextFormField(
              controller: _txtControllerBody,
              keyboardType: TextInputType.multiline,
              maxLines: 9,
              validator: (val) => val!.isEmpty ? 'Post body is required' : null,
              decoration: const InputDecoration(
                hintText: "Post body...",
                border: OutlineInputBorder(borderSide: BorderSide(width: 1, color: Colors.black38))
              ),
            ),
          )), 
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: kTextButton("Post", (){
                /// Vérification d'une validation
                if(_formkey.currentState!.validate()){
                  setState(() {
                    _loading = !_loading;
                  });
                  if(widget.post == null){
                    _createPost();
                  }else{
                    _editPost(widget.post!.id ?? 0);
                  }
                  
                }
              }),
          )
        ],
      ),
    );
  }
}
