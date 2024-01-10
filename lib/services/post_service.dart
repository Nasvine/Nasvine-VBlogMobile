

import 'dart:convert';
import 'package:blog/services/user_service.dart';

import '../constant.dart';
import '../models/api_response.dart';
import '../models/post.dart';
import 'package:http/http.dart' as http;

///get all posts

Future <ApiResponse> getPosts() async {
  ApiResponse apiResponse = ApiResponse();

  try{
    String token = await getToken();
    final response = await http.get(Uri.parse(postsURL),
      headers: {
        'Accept' : 'application/json',
        'Authorization' : 'Bearer $token'
      });

    switch(response.statusCode){
      case 200:
        apiResponse.data = jsonDecode(response.body)['posts'].map((p) => Post.fromJson(p)).toList();
        //we are get list of posts, so we need to map each item to post models
        apiResponse.data as List <dynamic>;
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        apiResponse.error = someThingWentWrong;
    }
  }
  catch(e){
    apiResponse.error = serverError;
  }

  return apiResponse;
}

/// Create posts

Future <ApiResponse> createPost(String body, String? image) async {
  ApiResponse apiResponse = ApiResponse();
  try{
    String token = await getToken();
    print(token);
    final response = await http.post(Uri.parse(postsURL),
      headers: {
        'Accept' : 'application/json',
        'Authorization' : 'Bearer $token'
      },body: image !=null ? {
        'body': body,
        'image' : image
      } : {
      'body': body,
          'image' : 'image.png'
    });

    ///here if the image is null we just send the body, if not null we send the image too

    switch(response.statusCode){
      case 200:
        apiResponse.data = jsonDecode(response.body);
        break;
      case 422:
        final errors = jsonDecode(response.body)['errors'];
        apiResponse.error = errors[errors.keys.elementAt(0)][0];
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        apiResponse.error = someThingWentWrong;
        break;
    }
  }
  catch(e){
    apiResponse.error = serverError;
  }
  return apiResponse;
}


/// Edit posts

Future <ApiResponse> editPost(int postId, String body) async {
  ApiResponse apiResponse = ApiResponse();

  try{
    String token = await getToken();
    final response = await http.put(Uri.parse('$postsURL/$postId'),
        headers: {
          'Accept' : 'application/json',
          'Authorization' : 'Bearer $token'
        },
        body: {
            'body': body,
    });

    switch(response.statusCode){
      case 200:
        apiResponse.data = jsonDecode(response.body)['message'];
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        apiResponse.error = someThingWentWrong;
        break;
    }
  }
  catch(e){
    apiResponse.error = serverError;
  }

  return apiResponse;
}


/// Delete posts

Future <ApiResponse> deletePost(int postId) async {
  ApiResponse apiResponse = ApiResponse();

  try{
    String token = await getToken();
    final response = await http.delete(Uri.parse('$postsURL/$postId'),
        headers: {
          'Accept' : 'application/json',
          'Authorization' : 'Bearer $token'
        });

    switch(response.statusCode){
      case 200:
        apiResponse.data = jsonDecode(response.body)['message'];
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        apiResponse.error = someThingWentWrong;
        break;
    }
  }
  catch(e){
    apiResponse.error = serverError;
  }

  return apiResponse;
}

//like or unlike

Future <ApiResponse> likeUnlikePost(int postId) async {
  ApiResponse apiResponse = ApiResponse();

  try{
    String token = await getToken();
    final response = await http.post(Uri.parse('$postsURL/$postId/likes'),
        headers: {
          'Accept' : 'application/json',
          'Authorization' : 'Bearer $token'
        });

    switch(response.statusCode){
      case 200:
        apiResponse.data = jsonDecode(response.body)['message'];
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        apiResponse.error = someThingWentWrong;
        break;
    }
  }
  catch(e){
    apiResponse.error = serverError;
  }

  return apiResponse;
}
