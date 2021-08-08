import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:sea_oil/constant/custom_colors.dart';
import 'package:sea_oil/constant/routes.dart';
import 'package:sea_oil/model/auth.dart';
import 'package:sea_oil/model/exception/invalid_credentials.dart';
import 'package:sea_oil/util/db_manager.dart';
import 'package:sea_oil/view/widget/beizer_continer.dart';
import 'package:sea_oil/viewmodel/authenticationViewmodel.dart';
import 'package:sea_oil/viewmodel/screen/login_viewmodel.dart';

class LoginScreen extends StatelessWidget {
  /// Build Widget tree
  ///
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final LoginViewModel model =
        Provider.of<LoginViewModel>(context, listen: false);
    return Scaffold(
      body: Container(
        height: height,
        child: Stack(
          children: <Widget>[
            Positioned(
                top: -height * .15,
                right: -MediaQuery.of(context).size.width * .4,
                child: BezierContainer()),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: height * .25),
                    _buildTitle(),
                    const SizedBox(height: 50),
                    _buildEmailPasswordWidget(model),
                    const SizedBox(height: 20),
                    _buildSubmitButton(context),
                    const SizedBox(height: 30),
                    _buildDivider(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build entry field
  ///
  Widget _buildEntryField(String title, TextEditingController controller,
      {bool isPassword = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
              controller: controller,
              obscureText: isPassword,
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  fillColor: Color(0xfff3f3f4),
                  filled: true))
        ],
      ),
    );
  }

  /// Login
  ///
  Future<void> _login(LoginViewModel model, BuildContext context) async {
    if (model.emailController.text.isEmpty ||
        model.passwordController.text.isEmpty) {
      showToast('All fields are required!');
      return;
    }

    try {
      final Auth auth = await model.login();
      Provider.of<AuthenticationViewmodel>(context, listen: false).auth = auth;
      DbManager.saveAuth(auth);
      Navigator.pushReplacementNamed(context, Routes.main_screen);
    } on InvalidCredentials {
      showToast('Invalid Credentials');
    } catch (e) {
      print(e.toString());
      showToast('An unexpected error occurred!');
    }
  }

  /// Build login button
  ///
  Widget _buildSubmitButton(BuildContext context) {
    return Consumer<LoginViewModel>(
      builder: (_, LoginViewModel model, __) {
        return InkWell(
          onTap: model.isLoading
              ? null
              : () {
                  _login(model, context);
                },
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(vertical: 15),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(5)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Colors.grey.shade200,
                      offset: const Offset(2, 4),
                      blurRadius: 5,
                      spreadRadius: 2)
                ],
                gradient: const LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [CustomColors.purple500, CustomColors.primary])),
            child: model.isLoading
                ? Container(
                    height: 23,
                    width: 23,
                    child: const CircularProgressIndicator(),
                  )
                : const Text(
                    'Login',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
          ),
        );
      },
    );
  }

  /// Build Divider
  ///
  Widget _buildDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: const <Widget>[
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build Title
  ///
  Widget _buildTitle() {
    return RichText(
      textAlign: TextAlign.center,
      text: const TextSpan(text: 'd', children: [
        TextSpan(
          text: 'sea',
          style: TextStyle(color: Colors.black, fontSize: 30),
        ),
        TextSpan(
          text: 'oil',
          style: TextStyle(color: Color(0xffe46b10), fontSize: 30),
        ),
      ]),
    );
  }

  /// Build Email,Password widget
  ///
  Widget _buildEmailPasswordWidget(LoginViewModel model) {
    return Column(
      children: <Widget>[
        _buildEntryField('Email id', model.emailController),
        _buildEntryField('Password', model.passwordController,
            isPassword: true),
      ],
    );
  }
}
