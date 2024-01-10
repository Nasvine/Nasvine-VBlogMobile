

import 'dart:convert';
import 'package:blog/constant.dart';
import 'package:blog/services/user_service.dart';

import '../models/api_response.dart';
import 'package:http/http.dart' as http;

import '../models/comment.dart';


/// Get comments

Future <ApiResponse> getComments(int postId) async {
  ApiResponse apiResponse = ApiResponse();
  try{
    String token = await getToken();
    final response = await http.get(Uri.parse('$postsURL/$postId/comments'),
        headers: {
          'Accept' : 'application/json',
          'Authorization' : 'Bearer $token'
        });

    switch(response.statusCode){
      case 200:
        // map each comments to comment model
        apiResponse.data = jsonDecode(response.body)['comments'].map((p) => Comment.fromJson(p)).toList();
        apiResponse.data as List <dynamic>;
        break;
      case 403:
        apiResponse.data = jsonDecode(response.body)['message'];
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

/// Create comments

Future <ApiResponse> createComment(int postId, String? comment) async {
  ApiResponse apiResponse = ApiResponse();
  try{
    String token = await getToken();
    final response = await http.post(Uri.parse('$postsURL/$postId/comments'),
        headers: {
          'Accept' : 'application/json',
          'Authorization' : 'Bearer $token'
        },body: {
          'comment': comment,
        });

    ///here if the image is null we just send the body, if not null we send the image too

    switch(response.statusCode){
      case 200:
        apiResponse.data = jsonDecode(response.body);
        break;
      case 403:
        apiResponse.data = jsonDecode(response.body)['message'];
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

/// Delete comments

Future <ApiResponse> deleteComment(int commentId) async {
  ApiResponse apiResponse = ApiResponse();
  try{
    String token = await getToken();
    final response = await http.delete(Uri.parse('$commentsURL/$commentId'),
        headers: {
          'Accept' : 'application/json',
          'Authorization' : 'Bearer $token'
        });

    ///here if the image is null we just send the body, if not null we send the image too

    switch(response.statusCode){
      case 200:
        apiResponse.data = jsonDecode(response.body);
        break;
      case 403:
        apiResponse.data = jsonDecode(response.body)['message'];
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

/// Edit comments

Future <ApiResponse> editComment(int commentId, String? comment) async {
  ApiResponse apiResponse = ApiResponse();
  try{
    String token = await getToken();
    final response = await http.put(Uri.parse('$commentsURL/$commentId'),
        headers: {
          'Accept' : 'application/json',
          'Authorization' : 'Bearer $token'
        },body: {
          'comment': comment,
        });

    ///here if the image is null we just send the body, if not null we send the image too

    switch(response.statusCode){
      case 200:
        apiResponse.data = jsonDecode(response.body);
        break;
      case 403:
        apiResponse.data = jsonDecode(response.body)['message'];
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
