import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';

import '../models/goal.dart';
import 'auth_user_services.dart';
import 'globals.dart';

class GoalInviteServices {
  static Future<Response> createInvite(String code, Goal goal) async {
    Map data = {
      "code": code,
      "goalId": goal.id,
    };

    var token = await AuthUserServices.getToken();
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
    };
    headers.addAll(header);
    Response response = await post(Uri.parse('$invitesURL/create'),
        headers: headers, body: json.encode(data));

    return response;
  }

  static Future<Response> checkInviteExists(String code) async {
    var token = await AuthUserServices.getToken();
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
    };
    headers.addAll(header);
    Response response =
        await get(Uri.parse('$invitesURL/$code'), headers: headers);

    return response;
  }

  static Future<Response> deleteInvite(int id) async {
    var url = Uri.parse('$invitesURL/$id');
    var token = await AuthUserServices.getToken();
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: 'Bearer $token',
    };
    headers.addAll(header);
    Response response = await delete(url, headers: headers);

    return response;
  }
}
