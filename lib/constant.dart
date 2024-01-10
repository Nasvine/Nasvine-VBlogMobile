
// -------  STRING  -------
import 'package:flutter/material.dart';

const baseURL = 'http://192.168.6.161:8000/api';
const loginURL = '$baseURL/login';
const registerURL = '$baseURL/register';
const logoutURL = '$baseURL/logout';
const userURL = '$baseURL/user';
const postsURL = '$baseURL/posts';
const commentsURL = '$baseURL/comments';

// -------  Error  -------
const serverError = 'Server error';
const unauthorized = 'Unauthorized';
const someThingWentWrong = 'SomeThing Went Wrong';

// ----- input decoration

InputDecoration kInputDecoration (String label){
  return InputDecoration(
      labelText: label,
      contentPadding: EdgeInsets.all(10),
      border: OutlineInputBorder(borderSide: BorderSide(width: 1, color: Colors.deepPurple))
  );
}

// ----- Button

TextButton kTextButton(String label, Function onPressed){
  return TextButton(
    onPressed: () => onPressed(),

    style: ButtonStyle(
         backgroundColor: MaterialStateColor.resolveWith((states) => Colors.indigo),
        padding: MaterialStateProperty.resolveWith((states) => EdgeInsets.symmetric(vertical: 10))
    ),
    child: Text(label , style: TextStyle(color: Colors.white),),
  );
}

//login Register Hint

Row kloginRegisterHint(String text, String label, Function onTap){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(text),
        GestureDetector(
          child: Text(label, style: const TextStyle(color: Colors.deepPurpleAccent),),
          onTap: () => onTap(),
        )
      ],
    );
}

//likes and comments

Expanded KlikeAndComment(int value, IconData icon, Color color, Function onTap){
  return Expanded(
      child: Material(
        child: InkWell(
          onTap: () => onTap(),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 16,color: color,),
                SizedBox(width: 4,),
                Text('$value')
              ],
            ),
          ),
        ),
      )
  );
}
