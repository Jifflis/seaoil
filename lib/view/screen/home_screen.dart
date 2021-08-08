import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sea_oil/constant/custom_colors.dart';
import 'package:sea_oil/constant/routes.dart';
import 'package:sea_oil/model/station.dart';
import 'package:sea_oil/view/widget/loading_widget.dart';
import 'package:sea_oil/view/widget/stations_widget.dart';
import 'package:sea_oil/viewmodel/screen/home_screen_viewmodel.dart';
import 'package:sea_oil/viewmodel/widget/map_viewmodel.dart';
import 'package:sea_oil/viewmodel/widget/stations_viewmodel.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late HomeScreenViewModel model;

  @override
  void initState() {
    super.initState();
    model = Provider.of(context, listen: false);
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      setState(() {
        model.fabPosition =
            model.initialSheetChildSize * model.getHeight(context);
      });
    });
  }

  /// Build Widget Tree
  ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: _buildAppBar(),
      body: FutureBuilder<void>(
        future: model.init(context),
        builder: (_, AsyncSnapshot<void> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadingWidget();
          }
          return Stack(
            children: [
              _buildMap(),
              _buildFloatingButton(),
              _buildNotificationListener(context),
            ],
          );
        },
      ),
    );
  }

  /// Build floating button
  ///
  Widget _buildFloatingButton() {
    return Consumer<HomeScreenViewModel>(
      builder: (_, HomeScreenViewModel model, __) {
        return Positioned(
          bottom: model.fabPosition + model.fabPositionPadding,
          right: model.fabPositionPadding,
          child: FloatingActionButton(
            child: const Icon(
              Icons.my_location,
              color: Colors.black87,
            ),
            backgroundColor: CustomColors.white,
            onPressed: () {
              Provider.of<MapViewModel>(context, listen: false)
                  .navigateToMyLocation();
            },
          ),
        );
      },
    );
  }

  /// Build Map
  ///
  Container _buildMap() {
    return Container(
      child: Consumer<MapViewModel>(
        builder: (_, MapViewModel model, __) {
          return GoogleMap(
            initialCameraPosition: model.initialLocation,
            zoomControlsEnabled: false,
            onMapCreated: (GoogleMapController controller) {
              model.controller.complete(controller);
            },
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            markers: model.markers,
          );
        },
      ),
    );
  }

  /// Build Appbar
  ///
  AppBar _buildAppBar() {
    return AppBar(
      toolbarHeight: 100,
      title: const Text('Search Station'),
      centerTitle: true,
      actions: _buildAppbarActions(),
      bottom: PreferredSize(
        child: Container(
          height: 28,
          child: const Text(
            'Which PriceLOCQ station will you likely visit?',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ),
        preferredSize: const Size.fromHeight(4.0),
      ),
    );
  }

  /// Build Appbar Actions
  ///
  List<Widget> _buildAppbarActions() {
    final HomeScreenViewModel model =
        Provider.of<HomeScreenViewModel>(context, listen: false);
    return <Widget>[
      IconButton(
        onPressed: () {
          Navigator.pushNamed(context, Routes.search_screen).then((value) {
            if (value != null) {
              model.setSelectedStation(context, value as Station);
              Provider.of<MapViewModel>(context, listen: false)
                  .animateLocationAndAddMarker(LatLng(
                model.selectedStation!.lat ?? 0,
                model.selectedStation!.lng ?? 0,
              ));
            } else {
              model.resetSelectedStation(context);
            }
            Provider.of<StationsViewModel>(context, listen: false)
              ..resetFilteredStation(notifyListener: false)
              ..radioValue = null;
          });
        },
        icon: const Icon(Icons.search),
      ),
    ];
  }

  /// Build Notification Listener
  ///
  Widget _buildNotificationListener(BuildContext context) {
    return Consumer<HomeScreenViewModel>(
      builder: (_, HomeScreenViewModel model, __) {
        return Positioned.fill(
          child: NotificationListener<DraggableScrollableNotification>(
            onNotification: (notification) {
              model.draggableScrollNotificagionListener(context, notification);
              return true;
            },
            child: _buildDragabbleScrollSheet(model),
          ),
        );
      },
    );
  }

  /// Build Dragabble Scroll Sheet
  ///
  Widget _buildDragabbleScrollSheet(HomeScreenViewModel model) {
    return DraggableScrollableSheet(
      key: Key(model.initialSheetChildSize.toString()),
      maxChildSize: 0.9,
      minChildSize: 0.3,
      initialChildSize: model.initialSheetChildSize,
      builder: (_, controller) {
        return Material(
          elevation: 10,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(20),
          ),
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDraggableHeader(model),
                _buildDraggableContent(controller, model),
              ],
            ),
          ),
        );
      },
    );
  }

  ///Build Draggable Header
  ///
  Widget _buildDraggableHeader(HomeScreenViewModel model) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: model.selectedStation==null?null:(){
            model.resetSelectedStation(context);
          },
          child: Text(
            model.selectedStation == null ? 'Nearby Stations' : 'Back to list',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: model.selectedStation == null
                    ? Colors.black87
                    : CustomColors.blue400),
          ),
        ),
        TextButton(
          onPressed: model.selectedStation != null
              ? () {
                  model.resetSelectedStation(context);
                }
              : null,
          child: const Text(
            'Done',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  /// Build Draggable Content
  ///
  Widget _buildDraggableContent(
      ScrollController controller, HomeScreenViewModel model) {
    return model.selectedStation == null
        ? _buildDraggableContentList(controller, model)
        : _buildDraggableContentDetails(model);
  }

  /// Build Draggable Content List
  ///
  Expanded _buildDraggableContentList(
      ScrollController controller, HomeScreenViewModel model) {
    Provider.of<MapViewModel>(context, listen: false).navigateToMyLocation();
    Provider.of<StationsViewModel>(context, listen: false).resetRadioValue();
    return Expanded(
      child: StationsWidget(
        controller: controller,
        onclick: (Station station) {
          model.setSelectedStation(context, station);
          Provider.of<StationsViewModel>(context, listen: false).radioValue =
              null;
          Provider.of<MapViewModel>(context, listen: false)
              .animateLocationAndAddMarker(LatLng(
            model.selectedStation!.lat ?? 0,
            model.selectedStation!.lng ?? 0,
          ));
        },
      ),
    );
  }

  /// Build Draggable Content Details
  ///
  Widget _buildDraggableContentDetails(HomeScreenViewModel model) {
    return Consumer<StationsViewModel>(
      builder: (_, __, ___) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              model.selectedStation!.name.toString(),
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            ),
            Text(
              model.selectedStation!.address.toString(),
              style:
                  const TextStyle(fontWeight: FontWeight.normal, fontSize: 12),
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                Row(
                  children: [
                    const Icon(Icons.directions_car_rounded),
                    Text(model.selectedStation!.distanceLabel),
                  ],
                ),
                const SizedBox(width: 30),
                Row(
                  children: const <Widget>[
                    Icon(Icons.access_time_outlined),
                    Text('Open 24 hours'),
                  ],
                ),
              ],
            )
          ],
        );
      },
    );
  }
}
