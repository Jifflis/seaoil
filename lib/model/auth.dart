class Auth {
  Auth({this.token, this.expireDate});

  String? token;
  DateTime? expireDate;

  static Auth fromJson(Map<String,dynamic> map){
    return Auth(
      token: map['accessToken'],
      expireDate: DateTime.tryParse(map['expiresAt']),
    );
  }
}
