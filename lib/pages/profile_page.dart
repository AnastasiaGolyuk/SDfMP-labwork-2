import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lab2/account/auth_helper.dart';
import 'package:lab2/consts/consts.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';

import 'main_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  LatLng currentLatLng = new LatLng(50, -350);
  late GoogleMapController _controller;
  Set<Marker> _markers = new Set();
  MapType _currentMapType = MapType.normal;
  var _connected = false;

  void _mapTypeChange() {
    setState(() {
      _currentMapType == MapType.normal
          ? _currentMapType = MapType.hybrid
          : _currentMapType = MapType.normal;
    });
  }

  Future<bool> isNetworkConnected() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } on SocketException catch (_) {
      return false;
    }
  }

  void initConnect() {
    isNetworkConnected().then((value) {
      setState(() {
        _connected = value;
      });
    });
  }

  @override
  void initState() {
    initConnect();
      Geolocator.getCurrentPosition().then((currLocation) {
        setState(() {
          currentLatLng =
              new LatLng(currLocation.latitude, currLocation.longitude);
          _markers.add(Marker(
              markerId: MarkerId('Me'),
              position: LatLng(currLocation.latitude, currLocation.longitude)));
          CameraUpdate cameraUpdate = CameraUpdate.newCameraPosition(
              CameraPosition(target: currentLatLng, zoom: 12));
          _controller.animateCamera(cameraUpdate);
        });
      });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_connected) {
      final _user = FirebaseAuth.instance.currentUser;
      return SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Theme.of(context).iconTheme.color,
                fixedSize: Size.fromWidth(Consts.getWidth(context)),
                textStyle: TextStyle(
                    fontSize: 20, color: Theme.of(context).primaryColor),
              ),
              onPressed: () {
                final provider =
                    Provider.of<AuthHelper>(context, listen: false);
                provider.signOut();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MainPage(
                              title: "Labwork 1",
                              index: 2,
                            )),
                    (ret) => false);
              },
              child: Text(
                'Sign out',
                style: TextStyle(color: Theme.of(context).primaryColor),
              )),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                child: CircleAvatar(
                  backgroundColor: Theme.of(context).iconTheme.color,
                  backgroundImage: NetworkImage(_user?.photoURL ?? ''),
                  radius: 50,
                ),
              ),
              Column(children: [
                SizedBox(
                  width: 250,
                  child: Text(
                    _user?.displayName ?? 'no name',
                    style: TextStyle(
                        fontSize: 25,
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                        fontFamily: Consts.titleFont),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  width: 250,
                  child: Text(
                    _user?.email ?? 'no email',
                    style: TextStyle(
                        fontSize: 20, color: Theme.of(context).primaryColor),
                    textAlign: TextAlign.center,
                  ),
                ),
              ])
            ],
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
          ),
          Stack(children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 15),
              height: 300,
              width: MediaQuery.of(context).size.width - 10,
              child: GoogleMap(
                      mapType: _currentMapType,
                      initialCameraPosition:
                          CameraPosition(target: currentLatLng),
                      onMapCreated: (GoogleMapController controller) {
                        _controller = controller;
                      },
                      markers: _markers,
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(25),
              child: Align(
                alignment: Alignment.topRight,
                child: FloatingActionButton(
                  backgroundColor:
                      Theme.of(context).appBarTheme.backgroundColor,
                  onPressed: _mapTypeChange,
                  child: Icon(CupertinoIcons.map,
                      color: Theme.of(context).iconTheme.color),
                ),
              ),
            )
          ]),
        ],
      ));
    } else {
      return Center(child: Text("No internet connection."));
    }
  }
}
