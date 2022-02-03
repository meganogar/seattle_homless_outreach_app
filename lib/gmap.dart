import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';


class Gmap extends StatefulWidget {
  const Gmap({ Key? key }) : super(key: key);

  @override
  _GmapState createState() => _GmapState();
}

class _GmapState extends State<Gmap> {

  late GoogleMapController mapController;

  // defines the starting location "center" for when the map initially loads
  final LatLng _center = const LatLng(47.6062, -122.3321);

  // Creates a function to use when map is created by googlemaps
  void _onMapCreated(GoogleMapController controller) {

    // I believe this sets the controls for the map to standard googlemap control functions
    mapController = controller;

    // defines markerId1 with a MarkerId of one, done so that I can use this as when I first 
    // create the marker1 marker, and also so that I can add to hash map in state
    MarkerId markerId1 = MarkerId("1");

    // Defines a marker
    Marker marker1 = Marker(
      markerId: markerId1,
      position: LatLng(47.6062, -122.3321),
      icon: myIcon,
      // defines the pop window when you click the icon
      infoWindow: InfoWindow(
        title: "Seattle",
        onTap: (){


        },snippet: "Seattle"
      )
    );
    
    // Sets the state of the initial map creation by adding marker1 to the hasmap
    setState(() {
      markers[markerId1]=marker1;
      }
    );
  }

  // initializes a markers hash table that is made up of a MarkerId
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  // defines myIcon variable as a bitmap Decriptor
  late BitmapDescriptor myIcon;
  
  @override

  // Called when this object is inserted into the tree, overrides the initial, inherited state
  void initState() {
    super.initState();

    // Sets the myIcon bitmapdescriptor as a customized asset image, waits for the image to load
    // then it defines it as an icon
    BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(48, 38)), 'assets/images/asset_2.png')
        .then((onValue) {
          myIcon = onValue;
        }
    );
  }
  
  

  @override

  // Builds the scaffold, defines googleMap as the body
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('SHO Encampment Map'),
        ),
        body: GoogleMap(
          markers: Set<Marker>.of(markers.values),
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 13.0,
            
          ),
        ),
      );
  }
}