class PlacePredictions {


  String secondary_text ='b';
  String main_text ='a';
  String place_id = 'c';


  PlacePredictions({required this.secondary_text, required this.main_text, required this.place_id});

  PlacePredictions.fromJson(Map<String, dynamic> json){

    place_id = json["place_id"];
    main_text = json["structured_formatting"]["main_text"];
    place_id = json["structured_formatting"]["place_id"];
  }
}