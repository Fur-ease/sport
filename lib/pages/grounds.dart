import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sportpro/details/booking.dart';


class Grounds extends StatefulWidget {
  const Grounds({super.key});

  @override
  State<Grounds> createState() => _GroundsState();
}

class _GroundsState extends State<Grounds> {
  // String _activeText = "grounds"; 
  // String? _hoveredText; 
  // final Color _hoverColor = Colors.blueGrey; 
  // final Color _defaultColor = Colors.black;
  List <String> sport = [];
  Future Getsport() async{
    await FirebaseFirestore.instance.collection('groundsItems').get().then(
      (snapshot) => snapshot.docs.forEach((element) {
        print(element.reference);
        //sport.add(element.get('sport'));
      })
      );
  }

  late List groundsItems = [];
  late List cricketGrounds =[];
  late List rugbyGrounds = [];
  late List tennisGrounds = [];
  late List baseballGrounds = [];
  late List basketballGrounds = [];
  int _selectedConsIndex = 0;

  List consNames = [
    "Cricket",
    "Rugby",
    "Football",
    "Tennis",
    "Baseball",
    "Basketball",
  ];

  List <Icon> cons = [
    const Icon(Icons.sports_cricket, color: Colors.black, size: 30,),
    const Icon(Icons.sports_football, color: Colors.black, size: 30,),
    const Icon(Icons.sports_soccer, color: Colors.black, size: 30,),
    const Icon(Icons.sports_tennis, color: Colors.black, size: 30,),
    const Icon(Icons.sports_baseball, color: Colors.black, size: 30,),
    const Icon(Icons.sports_basketball, color: Colors.black, size: 30,),
  ];

  ReadData1() async{
    await DefaultAssetBundle.of(context).loadString("json/rugbyGrounds.json").then((b){
      setState(() {
        rugbyGrounds = json.decode(b);
      });
    });
  }
  ReadData2() async{
    await DefaultAssetBundle.of(context).loadString("json/cricketGrounds.json").then((a){
      setState(() {
        cricketGrounds = json.decode(a);
      });
    });
  }
  ReadData3() async{
    await DefaultAssetBundle.of(context).loadString("json/baseballGrounds.json").then((d){
      setState(() {
        baseballGrounds = json.decode(d);
      });
    });
  }
  ReadData4() async{
    await DefaultAssetBundle.of(context).loadString("json/basketballGrounds.json").then((c){
      setState(() {
        basketballGrounds = json.decode(c);
      });
    });
  }
  ReadData5() async{
    await DefaultAssetBundle.of(context).loadString("json/tennisGrounds.json").then((e){
      setState(() {
        tennisGrounds = json.decode(e);
      });
    });
  }

  ReadData() async{
    await DefaultAssetBundle.of(context).loadString("json/groundsItems.json").then((s){
      setState(() {
        groundsItems = json.decode(s);
      });
    });
  }
  
  @override
  void initState(){
    super.initState();
    Getsport();
    ReadData();
    ReadData1();
    ReadData2();
    ReadData3();
    ReadData4();
    ReadData5();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: contents(),
    );
  }

  Widget contents() {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushReplacementNamed('/home');
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                 GestureDetector(
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/home');// Widget.Home();
                  },
                  child: const Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(width: 20),
                const Text("book a ground"),
                ],
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: const Icon(
                      Icons.notifications_outlined,
                    )
                  ),
                  const SizedBox(width: 20),
                 GestureDetector(
                  onTap: () {},
                  child: const Icon(
                    Icons.search_outlined,
                    color: Colors.black,
                  ),
                ),
                ],
              ),
            ],
          ),
         ),
         body: SafeArea(
           child: Column(
             children: [
               Container(
                 color: Colors.white,
                 // decoration: BoxDecoration(
                 //   borderRadius: BorderRadius.circular(20)
                 // ),
                 padding: const EdgeInsets.all(20),
                 child: Column(
                   children: [
                     const Positioned(
                       bottom: 10,
                       left: 10,
                       child: Align(
                         alignment: Alignment.topLeft,
                         child: Text(
                           "Sports", 
                           style: TextStyle(
                           fontSize: 20, 
                           fontWeight: FontWeight.bold,
                           ),
                         ),
                       ),
                     ),
                     const SizedBox(height: 20),
                     SizedBox(
                       height: 100,
                       child: ListView.builder(
                         shrinkWrap: true,
                         scrollDirection: Axis.horizontal,
                         itemCount: 6,
                         itemBuilder: (_, index) {
                           return Padding(
                             padding: const EdgeInsets.all(8.0),
                             child: Column(
                               children: [
                                 InkWell(
                                   onTap: () {
                                     setState(() {
                                       _selectedConsIndex = index;
                                     });
                                   },
                                 child: AnimatedContainer(
                                   duration: const Duration(milliseconds: 300),
                                   height: () {
                                     if (_selectedConsIndex == index) {
                                       return 60.0;
                                     } else {
                                       return 50.0;
                                     }
                                   }(),
                                   width: () {
                                     if (_selectedConsIndex == index) {
                                       return 60.0;
                                     } else {
                                       return 50.0;
                                     }
                                   }(),
                                   padding: const EdgeInsets.only(left: 10, right: 10),
                                   decoration: BoxDecoration(
                                     color: () {
                                       if (_selectedConsIndex == index) {
                                         return Colors.grey[400];
                                       } else {
                                         return Colors.grey[300];
                                       }
                                     }(),
                                     shape: BoxShape.circle,
                                     boxShadow: () {
                                       if (_selectedConsIndex == index) {
                                         return [
                                           const BoxShadow(
                                             color: Colors.black26,
                                             offset: Offset(0, 4),
                                             blurRadius: 5.0,
                                           )
                                         ];
                                       } else {
                                         return null;
                                       }
                                     }(),
                                   ),
                                   child: Center(
                                     child: cons[index],
                                   ),
                                 ),
                                 ),
                                 const SizedBox(height: 0,),
                                 Text(
                                   consNames[index], 
                                   style: TextStyle(
                                     fontSize: 16,
                                     color: _selectedConsIndex == index ? Colors.green : Colors.black
                                   ),
                                 )
                               ],
                             ),
                           );
                         }
                       ),
                     ),
                     const SizedBox(height: 10),
                     //Text("data"),
                     // _selectedConsIndex != 1 ? Container(
                     //   padding: EdgeInsets.all(10),
                     //   child: Text(
                     //     "Showing ${consNames[_selectedConsIndex]} grounds",
                     //     style: TextStyle(
                     //       fontSize: 16, 
                     //       fontWeight: FontWeight.bold
                     //     ),
                     //   ),
                     // ):
                     // _selectedConsIndex == 1 ?
                   ]
                 ),
               ),
                 Expanded(
                   child: Container(
                     padding: const EdgeInsets.all(5),
                     child: GridView.builder(
                     physics: const AlwaysScrollableScrollPhysics(),
                     itemCount: _selectedConsIndex == 0 ? cricketGrounds.length :
                          _selectedConsIndex == 1 ? rugbyGrounds.length :
                          _selectedConsIndex == 2 ? groundsItems.length :
                          _selectedConsIndex == 3 ? tennisGrounds.length :
                          _selectedConsIndex == 4 ? baseballGrounds.length :
                          basketballGrounds.length,
                     shrinkWrap: true,
                     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                     crossAxisCount: 2,
                     childAspectRatio: MediaQuery.sizeOf(context).width / 
                             (MediaQuery.sizeOf(context).height * 0.55),
                     crossAxisSpacing: 10,
                     mainAxisSpacing: 10
                     ), 
                       itemBuilder: (context, index){
                          var currentItems = _selectedConsIndex == 0 ? cricketGrounds :
                                  _selectedConsIndex == 1 ? rugbyGrounds :
                                  _selectedConsIndex == 2 ? groundsItems :
                                  _selectedConsIndex == 3 ? tennisGrounds :
                                  _selectedConsIndex == 4 ? baseballGrounds :
                                  basketballGrounds;
                         //if(index < groundsItems.length){
                         if (currentItems.isEmpty) {
                           return const Center(child: CircularProgressIndicator());
                         }
                         return InkWell(
                           onTap: (){
                             showModalBottomSheet(
                               isScrollControlled: true, 
                               backgroundColor: Colors.transparent,
                               context: context, 
                               builder: (context) => const Booking()
                             );
                           },
                           child: Container(
                           decoration: BoxDecoration(
                             color: Colors.grey[300],
                             borderRadius: BorderRadius.circular(10)
                           ),
                           child: Column(
                             crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               Expanded(
                                 child: Container(
                                   decoration: BoxDecoration(
                                     borderRadius: BorderRadius.circular(20),
                                   ),
                                   child: Column(
                                     crossAxisAlignment: CrossAxisAlignment.start,
                                     children: [
                                       Flexible(
                                         flex: 2,
                                         child: Container(
                                           decoration: BoxDecoration(
                                             borderRadius: BorderRadius.circular(10),
                                             image: DecorationImage(
                                               fit: BoxFit.cover,
                                               image: NetworkImage(
                                                 currentItems[index]["image"],
                                               ),
                                             ),
                                           ),
                                         ),
                                       ),
                                       Flexible(
                                         flex: 2,
                                         child: Padding(
                                           padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0.0),
                                           child: Column(
                                             crossAxisAlignment: CrossAxisAlignment.start,
                                             children: [
                                               Text(
                                                 currentItems[index]["title"],
                                                 style: const TextStyle(
                                                   fontSize: 20,
                                                   fontWeight: FontWeight.bold,
                                                 ),
                                               ), 
                                               Row(
                                                 children: [
                                                   const Icon(
                                                     Icons.star,
                                                     color: Colors.amber,
                                                     size: 16,
                                                   ),
                                                   Text(
                                                     "${currentItems[index]["rating"]} (${currentItems[index]["reviews"]} reviews)",
                                                     style: const TextStyle(
                                                       fontSize: 16,
                                                       color: Colors.grey,
                                                     ),
                                                   ),
                                                 ],
                                               ),
                                               Row(
                                                 children: [
                                                   const Icon(
                                                     Icons.location_on_outlined,
                                                     //color: Colors.green,
                                                     size: 16,
                                                   ),
                                                   Text(
                                                     currentItems[index]["location"],
                                                     style: const TextStyle(
                                                       fontSize: 14,
                                                       color: Colors.grey,
                                                     ),
                                                   ),
                                                 ],
                                               ),
                                               Text(
                                                 "\$${currentItems[index]["price"]} per hour",
                                                 style: const TextStyle(
                                                   fontSize: 12,
                                                   fontWeight: FontWeight.bold,
                                                   color: Colors.black,
                                                 ),
                                               ),
                                             ],
                                           ),
                                         ),
                                       ),
                                     ],
                                   ),
                                 ),
                               )
                             ]
                           ),
                         ),
                       );
                       }
                      // return Container();
                     //}
                     ),
                   ),
                 ) //: Container(),
             ],
           ),
         ),
      ),
    );
  }
}