// import 'dart:convert';

// import 'package:http/http.dart' as http;

// Future<void> fetchLiveMatches() async {
//   const String apiUrl = "https://all-sport-live-stream.p.rapidapi.com/api/v4/br/live-stream-list";
//   const Map<String, String> headers = {
//     "x-rapidapi-host": "all-sport-live-stream.p.rapidapi.com",
//     "x-rapidapi-key": "8d7ffc96bbmsh7fd541cb35fe425p1c4012jsn3ce5d95ea963", // Replace with your key
//     "Content-Type": "application/json",
//   };

//   try {
//     final response = await http.get(Uri.parse(apiUrl), headers: headers);

//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);

//       // Parse data structure based on API's actual response
//       setState(() {
//         liveMatches = data['fixtures'] ?? []; // Ensure 'matches' exists
//       });
//     } else {
//       throw Exception("Failed to load matches. Status code: ${response.statusCode}");
//     }
//   } catch (e) {
//     print("Error fetching live matches: $e");
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';

class Team {
  late final String name;
  late final String teamName;

  Team({
    required this.name,
    required this.teamName
  });
}

class FirebaseServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
Future<void> addProfile(String name, String phone, String dob, String location, String imageUrl) {
  CollectionReference profile = FirebaseFirestore.instance.collection('profile');
  
  return profile.add({
    'name': name,
    'phone': phone,
    'dob': dob,
    'location': location,
    'profile_image': imageUrl,
    'created_at': FieldValue.serverTimestamp(),
  });
}

Stream<String> getCurrentUsername() {
  return _firestore.collection('profile')
  .snapshots()
  .map((snapshot){
    final names = snapshot.docs
    .map((doc) => doc['name'])
    .toList();
    return names.first;
  });
}


}

// void _selectTab (String , int index){
//   if(_buildNavItem == _onItemSelected){

//   }else{

//   }
// }