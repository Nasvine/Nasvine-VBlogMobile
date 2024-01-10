import 'package:blog/main.dart';
import 'package:blog/screens/login.dart';
import 'package:blog/screens/post_form.dart';
import 'package:blog/screens/post_screen.dart';
import 'package:blog/screens/profile.dart';
import 'package:blog/services/user_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Blog App', style: TextStyle(color: Colors.white),), centerTitle: false,
      backgroundColor: Color(0xFF1d0fb3),
      actions: [
        IconButton(icon: Icon(Icons.exit_to_app, color: Colors.white,), onPressed: () {
          logout().then((value) => {
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const Login()), (route) => false)
          });
        },)
      ],
      ),
      body: _currentIndex == 0 ? PostScreen() : Profile(),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(100)),
        ),
        child: FloatingActionButton(
          backgroundColor: Color(0xFF1d0fb3),
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const PostForm(
              title: 'New Post',
            )), (route) => false);
          },
          child: Icon(Icons.add, color: Colors.white,),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar:  BottomAppBar(
        notchMargin: 5,
        elevation: 10,
        color: Colors.white,
        clipBehavior: Clip.antiAlias,
        shape: CircularNotchedRectangle(),
        child: BottomNavigationBar(

          items: [
          BottomNavigationBarItem(

            label: 'Home',
              icon: Icon(Icons.home)),
          BottomNavigationBarItem(
            label: 'Person',
              icon: Icon(Icons.person)),

        ],
        currentIndex: _currentIndex,
        onTap: (val){
            setState(() {
             _currentIndex = val;
            });
        },
        ),

      ),
    );
  }
}
