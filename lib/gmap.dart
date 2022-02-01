import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';

class Gmap extends StatefulWidget {
  const Gmap({ Key? key }) : super(key: key);

  @override
  _GmapState createState() => _GmapState();
}

class _GmapState extends State<Gmap> {
late GoogleMapController mapController;

  final LatLng _center = const LatLng(47.6062, -122.3321);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('SHO Sample App'),
          backgroundColor: Color.fromRGBO(134,201,210, .9),
        ),
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 13.0,
          ),
        ),
      ),
    );
  }
}