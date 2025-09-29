import 'package:favorite_places/models/place.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({
    super.key,
    this.location = const PlaceLocation(
      latitute: 7.0,
      longitude: 38.0,
      address: '',
    ),
    this.isSelecting = true,
  });

  final PlaceLocation location;
  final bool isSelecting;

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late LatLng _mapPosition;

  @override
  void initState() {
    super.initState();
    _mapPosition = LatLng(widget.location.latitute, widget.location.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.isSelecting
            ? Text('Pick your location')
            : Text('Your location'),
        actions: [
          if (widget.isSelecting)
            IconButton(
              onPressed: () {
                widget.isSelecting
                    ? Navigator.of(context).pop(_mapPosition)
                    : Navigator.of(context).pop();
              },
              icon: Icon(Icons.save),
            ),
        ],
      ),

      body: GoogleMap(
        onTap: (position) {
          widget.isSelecting
              ? setState(() {
                  _mapPosition = position;
                })
              : null;
        },
        initialCameraPosition: CameraPosition(target: _mapPosition, zoom: 10),
        markers: {Marker(markerId: MarkerId('m1'), position: _mapPosition)},
      ),
    );
  }
}
