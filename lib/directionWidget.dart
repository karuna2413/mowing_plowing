import 'package:flutter/material.dart';
import 'package:map_launcher/map_launcher.dart';

class DirectionsWidget extends StatefulWidget {
  final double latitude;
  final double longitude;
  final String address;
  const DirectionsWidget({
   
    required this.latitude,
    required this.longitude,
    required this.address,
  });

  @override
  State<DirectionsWidget> createState() => _DirectionsWidgetState();
}

class _DirectionsWidgetState extends State<DirectionsWidget> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.directions),
      iconSize: 25,
      color: Theme.of(context).primaryColor,
      onPressed: () async {
        final availableMaps = await MapLauncher.installedMaps;
        // print("availableMaps");
        // print(availableMaps);
        await availableMaps.first.showMarker(
          coords: Coords(widget.latitude, widget.latitude),
          title: widget.address,
        );
      },
    );
  }
}
