import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MyMap extends StatefulWidget {
  var lat;
  var lon;
  var name;

  MyMap({this.lat, this.lon, this.name});


  @override
  _MyMapState createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {
  Completer<GoogleMapController> _controller = Completer();


  LatLng _center;
  LatLng _lastMapPosition;

  final Set<Marker> _markers = {};


  MapType _currentMapType = MapType.normal;

  void _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  @override
  void initState() {
    _center = widget.lat == null || widget.lat == null ? LatLng(0.0, 0.0) : LatLng(widget.lat, widget.lon);
    _lastMapPosition = _center;
    setState(() {

      _markers.add(Marker(
        // This marker id can be anything that uniquely identifies each marker.
        markerId: MarkerId(_lastMapPosition.toString()),
        position: _lastMapPosition,
        infoWindow: InfoWindow(
          title: 'Localiação',
          snippet: 'Cliente: ' + widget.name,
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));
    });
    super.initState();
  }

  void _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  void _onMapCreated(GoogleMapController controller) {
    if( _controller == null ) {
      _controller.complete(controller);
    }
  }

//  Future<double> distanceInMeters = Geolocator().distanceBetween(-6.765772,-35.6982307,  -6.785108,-35.8126498);

  @override
  Widget build(BuildContext context) {
//    distanceInMeters.then((v){
//        print(v);
//    });

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(

          body: Stack(
            children: <Widget>[
              GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: _center,
                  zoom: 18.0,
                ),
                mapType: _currentMapType,
                markers: _markers,
                onCameraMove: _onCameraMove,
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
              onPressed: _onMapTypeButtonPressed,
              materialTapTargetSize: MaterialTapTargetSize.padded,
              backgroundColor: Colors.deepOrange,
              child: const Icon(Icons.map, size: 36.0),
            ),

        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
