import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_uber_rider_app/AllScreens/Divider.dart';
import 'package:flutter_uber_rider_app/AllWidgets/progressDialog.dart';
import 'package:flutter_uber_rider_app/DataHandler/appData.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_uber_rider_app/Assistants/assistantMethods.dart';
import 'package:provider/provider.dart';
import 'searchScreen.dart';

class MainScreen extends StatefulWidget {
  static const String idScreen = "MainScreen";

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  late GoogleMapController newGoogleMapController;

  //
  GlobalKey<ScaffoldState> scaffoldkey = GlobalKey<ScaffoldState>();

  List<LatLng> pLineCoordinates =[];
  Set<Polyline> polylineSet ={};

  Position? currentPosition;
  var geoLocator = Geolocator();
  double bottomPaddingOfMap = 0;

  Set<Marker> markersSet ={};
  Set<Circle> circlesSet ={};



  void locatePosition() async // 내 위치 가져오는 객체
  {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;

    LatLng latLatPosition = LatLng(position.latitude, position.longitude);

    CameraPosition cameraPosition =
        CameraPosition(target: latLatPosition, zoom: 14);

    newGoogleMapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    String address =
        await AssistantMethods.searchCoordinateAddress(position, context);
    print("this is your address :: " + address);
  }

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldkey,
        appBar: AppBar(
          title: Text('Main Screen'),
        ),
        drawer: Container(
          color: Colors.white,
          width: 255.0,
          child: Drawer(
            child: ListView(
              children: <Widget>[
                Container(
                  height: 165.0,
                  child: DrawerHeader(
                    decoration: BoxDecoration(color: Colors.white),
                    child: Row(
                      children: <Widget>[
                        Image.asset("images/user_icon.png",
                            height: 65.0, width: 65.0),
                        SizedBox(width: 16.0),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "profile name",
                              style: TextStyle(
                                  fontSize: 16.0, fontFamily: "Brand-Bold"),
                            ),
                            SizedBox(height: 6.0),
                            Text("Visit Profile"),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                DividerWidget(),

                SizedBox(height: 12.0),

                //Drawer body controllers

                ListTile(
                  leading: Icon(Icons.history),
                  title: Text(
                    "History",
                    style: TextStyle(fontSize: 15.0),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text(
                    "Visit Profile",
                    style: TextStyle(fontSize: 15.0),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.info),
                  title: Text(
                    "About",
                    style: TextStyle(fontSize: 15.0),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Stack(
          children: [
            GoogleMap(
              padding: EdgeInsets.only(bottom: bottomPaddingOfMap),
              mapType: MapType.normal,
              myLocationButtonEnabled: true,
              initialCameraPosition: _kGooglePlex,
              myLocationEnabled: true,
              zoomGesturesEnabled: true,
              zoomControlsEnabled: true,
              polylines: polylineSet,
              markers: markersSet,
              circles: circlesSet,
              onMapCreated: (GoogleMapController controller) {
                _controllerGoogleMap.complete(controller);
                newGoogleMapController = controller;

                setState(() {
                  bottomPaddingOfMap = 300.0;
                });

                locatePosition();
              },
            ),

            //HamburgerButton for drawer
            Positioned(
              top: 45.0,
              left: 22.0,
              child: GestureDetector(
                onTap: () {
                  scaffoldkey.currentState!.openDrawer();
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 6.0,
                        spreadRadius: 0.5,
                        offset: Offset(0.7, 0.7),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.menu),
                    radius: 20.0,
                  ),
                ),
              ),
            ),

            Positioned(
              left: 0.0,
              right: 0.0,
              bottom: 0.0,
              child: Container(
                height: 300.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(18.0),
                    topRight: Radius.circular(18.0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 16.0,
                      spreadRadius: 0.5,
                      offset: Offset(0.7, 0.7),
                    )
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 6.0),
                      Text(
                        'Hi there',
                        style: TextStyle(fontSize: 10.0),
                      ),
                      Text(
                        'where to',
                        style: TextStyle(fontSize: 20.0),
                      ),
                      SizedBox(height: 20.0),
                      GestureDetector(
                        onTap: () async {
                          var res = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SearchScreen()));

                          if (res == "obtainDirection") {
                            await getPlaceDirection();
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black54,
                                blurRadius: 6.0,
                                spreadRadius: 0.5,
                                offset: Offset(0.7, 0.7),
                              )
                            ],
                          ),
                          child: Row(
                            children: <Widget>[
                              Icon((Icons.search), color: Colors.yellowAccent),
                              SizedBox(width: 10.0),
                              Text("search drop off"),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 24.0),
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.home,
                            color: Colors.grey,
                          ),
                          SizedBox(width: 12.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(Provider.of<AppData>(context)
                                          .pickUpLocation !=
                                      null
                                  ? Provider.of<AppData>(context)
                                      .pickUpLocation!
                                      .placeName!
                                  : "Add Home"),
                              SizedBox(height: 4.0),
                              Text(
                                "your living home address",
                                style: TextStyle(
                                    color: Colors.grey[300], fontSize: 12.0),
                              ),
                            ],
                          )
                        ],
                      ),
                      SizedBox(height: 10.0),
                      DividerWidget(),
                      SizedBox(height: 16.0),
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.work,
                            color: Colors.grey,
                          ),
                          SizedBox(width: 12.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("add work"),
                              SizedBox(height: 4.0),
                              Text(
                                "your office address",
                                style: TextStyle(
                                    color: Colors.grey[300], fontSize: 12.0),
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  Future<void> getPlaceDirection() async {
    var initialPos =Provider.of<AppData>(context, listen: false).pickUpLocation;
    var finalPos = Provider.of<AppData>(context, listen: false).dropOffLocation;

    var pickUpLatLng = LatLng(initialPos!.latitude, initialPos.longtitude);
    var dropOffLatLng = LatLng(finalPos!.latitude, finalPos.longtitude);

    showDialog(
        context: context,
        builder: (BuildContext context) =>
            ProgressDialog(message: "please wait..."));

    var details = await AssistantMethods.obtainPlaceDirectionDetails(
        pickUpLatLng, dropOffLatLng);

    Navigator.pop(context);

    print(details.encodedPoints);


    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> decodedPolyLinePointsResult = polylinePoints.decodePolyline(details.encodedPoints);



    pLineCoordinates.clear();
    if(decodedPolyLinePointsResult.isNotEmpty){

      decodedPolyLinePointsResult.forEach((PointLatLng pointLatLng){
        pLineCoordinates.add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });

    }


    polylineSet.clear();
  setState(() {
    Polyline polyline = Polyline(
      color: Colors.pink,
      polylineId: PolylineId("PolylineId"),
      jointType: JointType.round,
      points: pLineCoordinates,
      width: 5,
      startCap: Cap.roundCap,
      endCap: Cap.roundCap,
      geodesic: true,
    );

    polylineSet.add(polyline);


  });


  LatLngBounds latLngBounds;
  if(pickUpLatLng.latitude >dropOffLatLng.latitude && pickUpLatLng.longitude> dropOffLatLng.longitude){

    latLngBounds = LatLngBounds(southwest: dropOffLatLng, northeast: pickUpLatLng);
  }
  else if(pickUpLatLng.longitude >dropOffLatLng.longitude){
    latLngBounds = LatLngBounds(southwest: LatLng(pickUpLatLng.latitude, dropOffLatLng.longitude), northeast: LatLng(dropOffLatLng.latitude, pickUpLatLng.longitude));
  }

  else if(pickUpLatLng.latitude >dropOffLatLng.latitude){
    latLngBounds = LatLngBounds(southwest: LatLng(dropOffLatLng.latitude, pickUpLatLng.longitude), northeast: LatLng(pickUpLatLng.latitude, dropOffLatLng.longitude));
  }

  else {

    latLngBounds = LatLngBounds(southwest: pickUpLatLng, northeast: dropOffLatLng);
  }
  
  newGoogleMapController.animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 70));

  Marker pickUpLocMarker = Marker(
    icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    infoWindow: InfoWindow(title: initialPos.placeName, snippet: "my location"),
    position: pickUpLatLng,
    markerId: MarkerId("pickupID"),
  );

    Marker dropOffMarker = Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      infoWindow: InfoWindow(title: finalPos.placeName, snippet: "dropoff location"),
      position: dropOffLatLng,
      markerId: MarkerId("dropOffID"),
    );

    setState(() {
      markersSet.add(pickUpLocMarker);
      markersSet.add(dropOffMarker);
    });


    Circle pickUpLocCircle = Circle (
      fillColor: Colors.blueAccent,
      center: pickUpLatLng,
      radius: 12,
      strokeWidth: 4,
      strokeColor: Colors.blueAccent,
      circleId: CircleId("pickupID"),
    );

    Circle dropOffLocCircle = Circle (
      fillColor: Colors.deepPurple,
      center: dropOffLatLng,
      radius: 12,
      strokeWidth: 4,
      strokeColor: Colors.deepPurple,
      circleId: CircleId("drop off"),
    );

    setState(() {
      circlesSet.add(pickUpLocCircle);
      circlesSet.add(dropOffLocCircle);
    });


  }



}
