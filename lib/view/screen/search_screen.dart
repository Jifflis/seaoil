import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sea_oil/constant/custom_colors.dart';
import 'package:sea_oil/model/station.dart';
import 'package:sea_oil/view/widget/stations_widget.dart';
import 'package:sea_oil/viewmodel/screen/search_screen_viewmodel.dart';
import 'package:sea_oil/viewmodel/widget/stations_viewmodel.dart';

class SearchScreen extends StatelessWidget {
  final ScrollController controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    final SearchScreenViewmodel searchScreenViewmodel =
        Provider.of<SearchScreenViewmodel>(context, listen: false);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: _buildAppBar(context, searchScreenViewmodel),
      body: StationsWidget(
        onclick: (Station station) {
          searchScreenViewmodel.station = station;
        },
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context, SearchScreenViewmodel model) {
    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: 200,
      title:const  Text('Search Station'),
      centerTitle: true,
      actions: <Widget>[
        IconButton(
          onPressed: () {
            Navigator.pop(context, model.station);
          },
          icon: const Icon(Icons.clear),
        ),
      ],
      bottom: PreferredSize(
        child: Container(
          height: 100,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget> [
              const Text(
                'Which PriceLOCQ station will you likely visit?',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 5),
              _buildSearchWidget(context),
            ],
          ),
        ),
        preferredSize: const Size.fromHeight(4.0),
      ),
    );
  }

  Widget _buildSearchWidget(BuildContext context) {
    final StationsViewModel stationsViewModel =
        Provider.of<StationsViewModel>(context, listen: false);

    return Container(
      width: 310,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
        color: CustomColors.white,
      ),
      child: TextFormField(
        onChanged: stationsViewModel.search,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.all(15),
          prefixIcon: Icon(Icons.search),
          border: InputBorder.none,
          hintText: 'Search',
        ),
      ),
    );
  }
}
