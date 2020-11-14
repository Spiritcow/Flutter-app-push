import 'package:hello_world_flutter/model/login_model.dart';
import 'package:hello_world_flutter/model/registration_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class APIService {
  Future<LoginResponseModel> login(LoginRequestModel requestModel) async {
    Uri url = new Uri.http('10.0.2.2:5000', "/");
    var body = json.encode(requestModel);

    final response = await http.post(url, headers: { "accept": "application/json", "content-type": "application/json" }, body: body);
    if (response.statusCode == 200 || response.statusCode == 400) {
      return LoginResponseModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load Data');
    }
  }

  Future<RegistrationResponseModel> register(RegistrationRequestModel requestModel) async {
    Uri url = new Uri.http('10.0.2.2:5000', "/registration");
    var body = json.encode(requestModel);

    final response = await http.post(url, headers: { "accept": "application/json", "content-type": "application/json" }, body: body);
    if (response.statusCode == 200 || response.statusCode == 400) {
      return RegistrationResponseModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load Data');
    }
  }


}
