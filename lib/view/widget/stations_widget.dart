import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sea_oil/model/station.dart';
import 'package:sea_oil/view/widget/error_widget.dart';
import 'package:sea_oil/view/widget/loading_widget.dart';
import 'package:sea_oil/viewmodel/widget/stations_viewmodel.dart';

class StationsWidget extends StatelessWidget {
  const StationsWidget({this.controller, this.onclick,});

  final ScrollController? controller;
  final Function? onclick;

  @override
  Widget build(BuildContext context) {
    return Consumer<StationsViewModel>(
      builder: (_, StationsViewModel model, __) {
        Widget widget = Container();
        if (model.isLoading) {
          widget = LoadingWidget();
        } else if (model.isError) {
          widget = CustomErrorWidget();
        } else {
          widget = _buildContent(model);
        }

        return widget;
      },
    );
  }

  Widget _buildContent(StationsViewModel model) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 40),
        controller: controller,
        itemCount: model.filteredStations.length,
        itemBuilder: (context, index) {
          final Station station = model.filteredStations[index];

          return ListTile(
            onTap: () {
              model.radioValue = index;
              if (onclick != null) {
                onclick!(station);
              }
            },
            contentPadding: EdgeInsets.zero,
            title: Text(station.name.toString()),
            subtitle: Text(station.distanceLabel.isEmpty
                ? 'n/a'
                : '${station.distanceLabel} from you'),
            trailing: Radio<int>(
              groupValue: model.radioValue,
              value: index,
              onChanged: (int? value) {
                model.radioValue = value;
                if (onclick != null) {
                  onclick!(station);
                }
              },
            ),
          );
        },
      ),
    );
  }
}
