import 'dart:async';

import 'package:drivers_app/global/globals.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../assistants/assistant_methods.dart';

class HomeTabPage extends StatefulWidget {
  const HomeTabPage({super.key});

  @override
  State<HomeTabPage> createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {
  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController? newGooglemapController;
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  bool isOnline = false;
  Position? driverCurrentLocation;
  var geolocator = Geolocator();
  LocationPermission? _locationPermission;
  StreamSubscription<Position>? streamSubscriptionPosition;

  checkIfPermissionAllowed() async {
    _locationPermission = await Geolocator.requestPermission();

    if (_locationPermission == LocationPermission.denied) {
      _locationPermission = await Geolocator.requestPermission();
    } else {
      locateUserPosition();
    }
  }

  locateUserPosition() async {
    driverCurrentLocation = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    LatLng latLngPosition = LatLng(
        driverCurrentLocation!.latitude, driverCurrentLocation!.longitude);
    CameraPosition cameraPosition =
        CameraPosition(target: latLngPosition, zoom: 14);
    newGooglemapController!
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    print("locate user position");
    String humanReadableAddress =
        await AssistantMethods.searchAddressForGeographicCoordinates(
            driverCurrentLocation!, context);
    print("this is your address$humanReadableAddress");
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    checkIfPermissionAllowed();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            myLocationEnabled: true,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (controller) {
              _controller.complete(controller);
              newGooglemapController = controller;
            },
          ),
          isOnline
              ? Container()
              : Container(
                  height: MediaQuery.of(context).size.height,
                  width: double.infinity,
                  decoration: BoxDecoration(color: Colors.black87),
                ),
          Positioned(
            top: isOnline
                ? MediaQuery.of(context).size.height * 0.12
                : MediaQuery.of(context).size.height * 0.46,
            left: 0,
            right: 0,
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              !isOnline
                  ? ElevatedButton(
                      onPressed: () {
                        setDriverOnline();
                        updateDriverLocationRealtime();
                        setState(() {
                          isOnline = true;
                        });
                      },
                      child: Text("Offline"),
                    )
                  : ElevatedButton(
                      onPressed: () {
                        setDriverOffline();
                        setState(() {
                          isOnline = false;
                        });
                      },
                      child: Icon(Icons.phonelink_ring_rounded),
                    ),
            ]),
          ),
        ],
      ),
    ));
  }

  setDriverOnline() async {
    Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print(currentFirebaseUser!.uid);
    driverCurrentLocation = pos;
    Geofire.initialize('activeDrivers');

    Geofire.setLocation(currentFirebaseUser!.uid,
        driverCurrentLocation!.latitude, driverCurrentLocation!.longitude);

    DatabaseReference ref = FirebaseDatabase.instance
        .ref()
        .child('drivers')
        .child(currentFirebaseUser!.uid)
        .child('newRideStatus');

    ref.set('idle');

    ref.onValue.listen((event) {});
  }

  updateDriverLocationRealtime() {
    streamSubscriptionPosition =
        Geolocator.getPositionStream().listen((Position position) {
      driverCurrentLocation = position;

      if (isOnline) {
        Geofire.setLocation(currentFirebaseUser!.uid,
            driverCurrentLocation!.latitude, driverCurrentLocation!.longitude);
      }

      LatLng latLng = LatLng(
          driverCurrentLocation!.latitude, driverCurrentLocation!.longitude);
      newGooglemapController!.animateCamera(CameraUpdate.newLatLng(latLng));
    });
  }

  setDriverOffline() {
    Geofire.removeLocation(currentFirebaseUser!.uid);
    DatabaseReference? ref = FirebaseDatabase.instance
        .ref()
        .child('drivers')
        .child(currentFirebaseUser!.uid)
        .child('newRideStatus');

    ref.onDisconnect();
    ref.remove();
    ref = null;

    SystemNavigator.pop();
  }
}
