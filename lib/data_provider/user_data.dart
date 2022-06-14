import 'dart:convert';
import 'dart:async';
import 'dart:io';
import '../models/http_exception.dart';
import '../models/user.dart';
import '../util/util.dart';
import 'package:http/http.dart' as http;

class UserDataProvider {
  final http.Client httpClient;

  UserDataProvider({required this.httpClient}) : assert(httpClient != null);

  Util util =  Util();
  Future<List<User>> getUsers() async {
    const uri = 'https://mtodo-api.herokuapp.com/api/v1/users/';
    List<User> users;
    try {
      String token = await util.getUserToken();
      String expiry = await util.getExpiryTime();
      final response = await httpClient.get(Uri.parse(uri), headers: {
        HttpHeaders.contentTypeHeader: "application/json",
        HttpHeaders.authorizationHeader: "Bearer $token",
        'expiry': expiry
      });

      if (response.statusCode == 200) {
        final extractedData = json.decode(response.body) as List<dynamic>;
        // if (extractedData == null) {
        //   return null;
        // }
        users = extractedData.map<User>((json) => User.fromJson(json)).toList();
      } else {
        throw Exception('Error');
      }
    } catch (e) {
      throw e;
    }
    return users;
  }

  Future<User> login(User user) async {
    User user1;
    const urlLogin = 'https://mtodo-api.herokuapp.com/api/v1/auth';
    try {
      final response = await http.post(
        Uri.parse(urlLogin),
        body: json.encode({
          'id': user.id,
          'email': user.email,
          'full_name': user.email,
          'phone': user.phone,
          'password': user.password,
        }),
      );
      print(response.statusCode);
      if (response.statusCode == 422) {
        throw HttpException('Invalid Input');
      } else if (response.statusCode == 404) {
        throw HttpException('Incorrect username or password');
      } else {
        final extractedData =
            json.decode(response.body) as Map<String, dynamic>;
        user1 = User.fromJson(extractedData);
        String token = response.headers['token'].toString();
        String expiry = response.headers['expiry_date'].toString();

        await util.storeUserInformation(user1);
        await util.storeTokenAndExpiration(expiry, token);
      }
    } catch (e) {
      throw e;
    }
    return user1;
  }

  Future<User> signUp(User user) async {
  
    final urlPostUser = 'https://mtodo-api.herokuapp.com/api/v1/users/';
    User user1;
    try {
      
             final response = await httpClient.post(
                Uri.parse(urlPostUser),
                body: json.encode({
                  'id': user.id,
                  'email': user.email,
                  'password': user.password,
                  'full_name': user.fullName,
                  'phone': user.phone,
                }),
                headers: {
                  HttpHeaders.contentTypeHeader: "application/json",
                },
              );

              if (response.statusCode == 200) {
                final extractedData =
                    json.decode(response.body) as Map<String, dynamic>;
                user1 = User.fromJson(extractedData);
                String token = response.headers['Token'].toString();
                String expiry = response.headers['Expiry_date'].toString();
                await util.storeUserInformation(user1);
                await util.storeTokenAndExpiration(expiry, token);
              } else {
                throw HttpException('Error occurred');
              }
    } catch (e) {
      throw e;
    }
    return user1;
  }

  Future<User> updateUser(User user) async {
    User updated;
    final url = 'https://mtodo-api.herokuapp.com/api/v1/users/${user.id}';
    try {
      String token = await util.getUserToken();
      String expiry = await util.getExpiryTime();
      final response = await httpClient.put(
        Uri.parse(url),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: "Bearer $token",
          'expiry': expiry
        },
        body: json.encode({
          'id': user.id,
          'email': user.email,
          'password': user.password,
          'full_name': user.fullName,
          'phone': user.phone,
        }),
      );
      if (response.statusCode == 200) {
        final extractedData = json.decode(response.body);
        updated = User.fromJson(extractedData);
      } else {
        throw HttpException('Error Occurred');
      }
    } catch (e) {
      print(e.toString());
      throw e;
    }
    return updated;
  }

  Future<User> updateUserPassword(User user, String oldPassword) async {
    User updated;
    final url = 'https://mtodo-api.herokuapp.com/api/v1/users/${user.id}';
    final urlCheckPassword = 'https://mtodo-api.herokuapp.com/api/v1/users/${user.id}';
    try {
      String token = await util.getUserToken();
      String expiry = await util.getExpiryTime();
      final response = await httpClient.post(
        Uri.parse(urlCheckPassword),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: "Bearer $token",
          'expiry': expiry
        },
        body: json.encode({
          'id': user.id,
          'email': user.email,
          'password': oldPassword,
          'full_name': user.fullName,
          'phone': user.phone,
        }),
      );
      if (response.statusCode == 200) {
        final response2 = await httpClient.put(
          Uri.parse(url),
          headers: {
            HttpHeaders.contentTypeHeader: "application/json",
            HttpHeaders.authorizationHeader: "Bearer $token",
            'expiry': expiry
          },
          body: json.encode({
            'id': user.id,
            'email': user.email,
            'password': user.password,
            'full_name': user.fullName,
            'phone': user.phone,
          }),
        );
        if (response2.statusCode == 200) {
          final extractedData =
              json.decode(response2.body) as Map<String, dynamic>;
          updated = User.fromJson(extractedData);
        } else {
          throw HttpException('Error Occurred');
        }
      } else if (response.statusCode == 404) {
        throw HttpException('Incorrect Old Password');
      } else {
        throw HttpException('Error Occurred');
      }
    } catch (e) {
      print(e.toString());
      throw e;
    }
    return updated;
  }
}
