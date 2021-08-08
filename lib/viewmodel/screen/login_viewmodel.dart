import 'package:flutter/cupertino.dart';
import 'package:sea_oil/model/auth.dart';
import 'package:sea_oil/repository/login_repository.dart';
import 'package:sea_oil/viewmodel/base_view_model.dart';

class LoginViewModel extends BaseViewModel {
  LoginViewModel(this._loginRepository);

  LoginRepository _loginRepository;


  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<Auth> login() async {
    isLoading = true;
    Auth auth;
    try{
      auth = await _loginRepository.login({
        'mobile': emailController.text,
        'password': passwordController.text,
      });
    }catch(e){
      rethrow;
    }finally{
      isLoading = false;
    }
    return auth;
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
