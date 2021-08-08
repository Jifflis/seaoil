import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sea_oil/model/exception/location_denied.dart';
import 'package:sea_oil/model/exception/location_denied_forever.dart';
import 'package:sea_oil/model/exception/location_service_disable.dart';
import 'package:sea_oil/model/station.dart';
import 'package:sea_oil/util/location_manager.dart';
import 'package:sea_oil/view/dialog/custom_dialog.dart';
import 'package:sea_oil/viewmodel/base_view_model.dart';

class HomeScreenViewModel extends BaseViewModel {
  double initialSheetChildSize = 0.4;
  double dragScrollSheetExtent = 0;

  double widgetHeight = 0;
  double fabPosition = 0;
  double fabPositionPadding = 10;
  bool _dialogVisible = false;
  bool _isInit = false;

  Station? _selectedStation;

  Station? get selectedStation => _selectedStation;

  set selectedStation(Station? station) {
    _selectedStation = station;
    notifyListeners();
  }

  ///Initialize Location
  ///
  Future<void> init(BuildContext context) async {
    if(_isInit)return;
    _isInit = true;
    try {
      await LocationManager().init();
    } on LocationServiceDisable {
      showProviderDialog(
        context,
        'Please turn on location provider',
        'Provider Disabled!',
      );
    } on LocationDenied {
      await Geolocator.requestPermission();
    } on LocationDeniedForever {
      showPermissionDialog(
        context,
        'Please turn on permission!',
        'Permission Denied!',
      );
    } catch (e) {
      print(e);
    } finally {
      setProviderListener(context);
    }
  }

  /// Set provider listener
  /// It will display a dialog if Location provider is turn off
  ///
  void setProviderListener(BuildContext context) {
    LocationManager().providerStream.onData((ServiceStatus status) {
      if (status == ServiceStatus.disabled) {
        showProviderDialog(
          context,
          'Please turn on location provider',
          'Provider Disabled!',
        );
      }else{
        if(_dialogVisible){
          Navigator.pop(context);
          _dialogVisible=false;
        }
      }
    });
  }

  /// Show Provider Dialog
  ///
  Future<void> showProviderDialog(
      BuildContext context, String description, String title) async {
    _dialogVisible = true;
    showCustomDialog(
        context: context,
        title: title,
        description: description,
        showButton2: false,
        button1Title: 'Goto Settings',
        barrierDismissible: false,
        onButton1Press: () {
          Geolocator.openLocationSettings();
        });
  }

  /// Show Permission Dialog
  ///
  Future<void> showPermissionDialog(
      BuildContext context, String description, String title) async {
    showCustomDialog(
        context: context,
        title: title,
        description: description,
        button1Title: 'Goto Settings',
        button2Title: 'Close',
        barrierDismissible: true,
        onButton2Press: (){
          Navigator.pop(context);
        },
        onButton1Press: () {
          Geolocator.openAppSettings();
        });
  }

  /// Listener for Draggable Scroll
  /// and compute fab position
  ///
  void draggableScrollNotificagionListener(
      BuildContext context, DraggableScrollableNotification notification) {
    widgetHeight = getHeight(context);
    dragScrollSheetExtent = notification.extent;
    // Calculate FAB position based on parent widget height and DraggableScrollable position
    fabPosition = dragScrollSheetExtent * widgetHeight;
    notifyListeners();
  }

  /// Get Screen Size height
  ///
  double getHeight(BuildContext context) {
    double size = (context.size?.height ?? 0) - 100;
    return size;
  }

  /// Reset selected section and compute fab position
  ///
  void resetSelectedStation(BuildContext context) {
    selectedStation = null;
    initialSheetChildSize = 0.4;
    fabPosition = initialSheetChildSize * getHeight(context);
  }

  /// Set selected section and compute fab position
  ///
  void setSelectedStation(BuildContext context, Station station) {
    selectedStation = station;
    initialSheetChildSize = 0.3;
    fabPosition = initialSheetChildSize * getHeight(context);
    DraggableScrollableActuator.reset(context);
  }
}
