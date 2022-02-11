import 'dart:html';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_database/firebase_database.dart';

import 'dart:async';
import 'dart:math';

import 'encampment_pin_form.dart';

FirebaseDatabase database = FirebaseDatabase.instance;

class Camp {
  final int id;

  Camp(this.id);
}

class Gmap extends StatefulWidget {
  const Gmap({ Key? key }) : super(key: key);

  @override
  _GmapState createState() => _GmapState();
}

class _GmapState extends State<Gmap> {

  late GoogleMapController mapController;
  final database = FirebaseDatabase.instance;

  // defines the starting location "center" for when the map initially loads
  final LatLng _center = const LatLng(47.6062, -122.3321);

  // Creates a function to use when map is created by googlemaps
  void _onMapCreated(GoogleMapController controller) async {

    // I believe this sets the controls for the map to standard googlemap control functions
    mapController = controller;

    // var ref = FirebaseDatabase.instance.ref("Camps").once().then((snap) {
    //   // print(snap);
    //   Map<dynamic, dynamic> campMap = snap.snapshot.value as Map <dynamic, dynamic>;
    //   print('BLAHBLAHBLAHBLAH');
    //   campMap.forEach((key, value) {
    //     print('key = $key'); print('value = $value');

    //       markers[markerId] = marker;
    //       });
    //     });
    // });

    // Get the Stream
    Stream<DatabaseEvent> stream = FirebaseDatabase.instance.ref("Camps").onValue;

    // Subscribe to the stream!
    stream.listen((DatabaseEvent event) {

      Map<dynamic, dynamic> campMap =  event.snapshot.value as Map <dynamic, dynamic>;
      print('***************');
      campMap.forEach((key, value) {


        setState(() {

          final MarkerId markerId = MarkerId("${value['markerId']}");

          int campId = value['markerId'];

          var camp = Camp(campId);

          Marker marker = Marker(
              markerId: markerId,
              draggable: false,
              position: LatLng(value['latitude'], value['longitude']), //With this parameter you automatically obtain latitude and longitude
              infoWindow: InfoWindow(
                  title: "Encampment #${value['markerId']}",
                  snippet: 'This looks good',
                  onTap: () {
                    _modalButtonTap(camp);
                  },
              ),
              icon: myIcon,
          );

          markers[markerId] = marker;
        });
      });
    });


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
    
    // Sets the state of the initial map creation by adding marker1 to the hashmap
    setState(() {
      markers[markerId1]=marker1;
      }
    );
  }

  
  void _modalButtonTap (camp) {

    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 311,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[ 
                EncampmentPinForm(camp: camp),
              ],
            ),
          ),
        );
      },
    );
  }
  int idCounter3 = 0;

  Future _addMarkerLongPressed(LatLng latlang) async {
  ///function to add a marker on a long press in map.
  
  // API call to database

    setState(() {

      idCounter3 += 1;

      final _refCamp = FirebaseDatabase.instance.ref("Camps/Camp_$idCounter3");

      final MarkerId markerId = MarkerId("$idCounter3");

      // var camp = Camp(idCounter3);

      // Marker marker = Marker(
      //     markerId: markerId,
      //     draggable: false,
      //     position: latlang, //With this parameter you automatically obtain latitude and longitude
      //     infoWindow: InfoWindow(
      //         title: "Encampment #$idCounter3",
      //         snippet: 'This looks good',
      //         onTap: () {
      //           _modalButtonTap(camp);
      //         },
      //     ),
      //     icon: myIcon,
      // );

      // markers[markerId] = marker;

      _refCamp.set({
        'markerId': idCounter3,
        'latitude': latlang.latitude,
        'longitude': latlang.longitude
      });

    });

  
  // _refCampCounter.set(idCounter);
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
        ImageConfiguration(size: Size(48, 35)), 'assets/images/asset_2.png')
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
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          onMapCreated: _onMapCreated,
          compassEnabled: true,
          tiltGesturesEnabled: false,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 13.0,
          ),
          onLongPress: (latlang) {
            _addMarkerLongPressed(latlang); 
            //we will call this function when pressed on the map to set new marker
        },
          markers: Set<Marker>.of(markers.values),
        ),
      );
  }
}

