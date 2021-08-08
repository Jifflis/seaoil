import 'package:flutter/cupertino.dart';

abstract class BaseViewModel with ChangeNotifier{
  bool _isLoading = false;
  bool isError = false;
  bool get isLoading => _isLoading;

  set isLoading(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }
}