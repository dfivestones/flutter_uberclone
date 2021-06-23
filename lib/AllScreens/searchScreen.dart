import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_uber_rider_app/AllScreens/Divider.dart';
import 'package:flutter_uber_rider_app/AllWidgets/progressDialog.dart';
import 'package:flutter_uber_rider_app/Assistants/requestAssistant.dart';
import 'package:flutter_uber_rider_app/DataHandler/appData.dart';
import 'package:flutter_uber_rider_app/Models/address.dart';
import 'package:flutter_uber_rider_app/Models/placePredictions.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  TextEditingController pickUpTextEditingController = TextEditingController();
  TextEditingController dropOffTextEditingController = TextEditingController();
  List<PlacePredictions> placepredictionsList =[];



  @override
  Widget build(BuildContext context) {

    String placeAddress = Provider.of<AppData>(context).pickUpLocation?.placeName ?? "";
    pickUpTextEditingController.text = placeAddress;
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            height:215.0,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 6.0,
                  spreadRadius: 0.5,
                  offset: Offset(0.7,0.7)
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.only(left: 25.0, right:25.0, bottom:20.0),
              child: Column(
                children: <Widget>[
                  SizedBox(height: 5.0),
                  Stack(
                    children: <Widget> [
                      GestureDetector(
                          child: Icon(Icons.arrow_back),onTap: (){
                            Navigator.pop(context);
                      },),
                      Center(
                        child: Text("set drop off", style: TextStyle(fontSize: 18.0, fontFamily: "Brand-Bold"),),
                      )
                    ],
                  ),

                  SizedBox(height: 10.0),
                  Row(
                    children: <Widget> [
                    Image.asset("images/pickicon.png", height:16.0, width:16.0),

                      SizedBox(width:18.0),

                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(5.0),

                          ),
                          child: Padding(
                            padding: EdgeInsets.all(3.0),
                            child: TextField(
                              controller: pickUpTextEditingController,
                              decoration: InputDecoration(
                                hintText: "pickup location",
                                fillColor: Colors.grey[400],
                                filled: true,
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.only(left: 11.0, top: 8.0, bottom: 8.0),
                              ),
                            ),
                          )
                        )
                      )
                  ],



                  ),

                  SizedBox(height: 10.0),
                  Row(
                    children: <Widget> [
                      Image.asset("images/desticon.png", height:16.0, width:16.0),

                      SizedBox(width:18.0),

                      Expanded(
                          child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[400],
                                borderRadius: BorderRadius.circular(5.0),

                              ),
                              child: Padding(
                                padding: EdgeInsets.all(3.0),
                                child: TextField(
                                  onChanged: (val) {

                                    findPlace(val);
                                  },
                                  controller:dropOffTextEditingController,
                                  decoration: InputDecoration(
                                    hintText: "where to",
                                    fillColor: Colors.grey[400],
                                    filled: true,
                                    border: InputBorder.none,
                                    isDense: true,
                                    contentPadding: EdgeInsets.only(left: 11.0, top: 8.0, bottom: 8.0),
                                  ),
                                ),
                              )
                          )
                      )
                    ],



                  ),
                ],
              ),
            )

          ),

          //tile for predictions

          SizedBox(height: 10.0),

          (placepredictionsList.length>0) ? Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: ListView.separated(
              padding: EdgeInsets.all(0.0),
                itemBuilder: (context, index) {
                return PredictionsTile(placePredictions: placepredictionsList[index],);
                },
                separatorBuilder: (BuildContext context, int index) => DividerWidget(),
                itemCount: placepredictionsList.length,
            shrinkWrap: true,
                physics: ClampingScrollPhysics(),)
          ) : Container(),
        ],
      ),
    );
  }

  void findPlace(String placeName) async {

    showDialog(
      context: context,
      builder: (BuildContext context) => ProgressDialog(message: "SETTING DROP OFF, Please wait...",)
    );

  if(placeName.length >1) {
    String autoCompleteUrl = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeName&key=AIzaSyAL8qlx4thzYhBh9tQlDl_6td3eIExrrE8&sessiontoken=1234567890&components=country:kr";  //&components 뒷부분은 country specific 이다.
    var res = await RequestAssistant.getRequest(autoCompleteUrl);

    Navigator.pop(context);

    if(res == 'failed') {
      return;
    }

    if(res["status"] == "OK"){

      var predictions = res["predictions"];

      var placesList = (predictions as List).map((e) => PlacePredictions.fromJson(e)).toList();//from json data to list

      setState(() {
        placepredictionsList=placesList;
      });


    }

  }
  }
}


class PredictionsTile extends StatelessWidget {

  final PlacePredictions placePredictions;

  PredictionsTile({Key? key, required this.placePredictions}) : super(key: key);




  @override
  Widget build(BuildContext context) {
    return FlatButton(
      padding: EdgeInsets.all(0.0),
      onPressed: (){
        getPlaceAddressDetails(placePredictions.place_id, context);


      },
      child: Container(
        child: Column(
          children: <Widget> [
            SizedBox(width:10.0),
            Row(
              children: <Widget>[
                Icon(Icons.add_location),
                SizedBox(width:14.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget> [
                      SizedBox(height: 8.0,),
                      Text(placePredictions.main_text, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 16.0),),
                      SizedBox(height: 2.0,),
                      Text(placePredictions.secondary_text, style: TextStyle(fontSize: 12, color: Colors.grey),),
                      SizedBox(height: 8.0,),
                    ],
                  ),
                )
              ],

            ),

            SizedBox(width:10.0),

          ],



        )
      ),
    );
  }

  void getPlaceAddressDetails(String placeId, context) async {
    String placeDetailsUrl = "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=AIzaSyAL8qlx4thzYhBh9tQlDl_6td3eIExrrE8";

    var res = await RequestAssistant.getRequest(placeDetailsUrl);

    if (res == "failed"){
      return;
    }
if (res["status"] == "OK"){

  Address address = Address();
  address.placeName = res["result"]["name"];
  address.placeId = placeId;
  address.latitude = res["result"]["geometry"]["location"]["lat"];
  address.longtitude = res["result"]["geometry"]["location"]["lng"];//[]순서는 json data 안에 들어있는 정보들 순서대로


  Provider.of<AppData> (context, listen:false).updateDropOffLocationAddress(address);
  print("this is Drop off location::");
  print(address.placeName);

  Navigator.pop(context);


}
  }
}


