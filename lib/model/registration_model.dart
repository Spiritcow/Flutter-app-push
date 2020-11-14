class RegistrationResponseModel {
  final String success;
  final String error;

  RegistrationResponseModel({this.success, this.error});

  factory RegistrationResponseModel.fromJson(Map<String, dynamic> json) {
    return RegistrationResponseModel(
        success: json["success"] != null ? json["success"] : "",
        error: json["error"] != null ? json["error"] : "");
  }
}

class RegistrationRequestModel {
  String email;
  String username;
  String password;

  RegistrationRequestModel({this.email, this.username, this.password});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'email': email,
      'username': username,
      'password': password,
    };

    return map;
  }
}