import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:sportpro/login.dart';
import 'package:sportpro/pages/bottomNavbar.dart';
import 'package:sportpro/pages/drawer.dart';
import 'package:sportpro/pages/grounds.dart';
import 'package:sportpro/pages/liveStream.dart';
import 'package:sportpro/pages/profile.dart';
import 'package:sportpro/pages/store.dart';
import 'package:http/http.dart' as http;
import 'dart:math' as math;


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin{
  bool _isDrawerOpen = false;
  double xOffset = 0;
  double yOffset = 0;
  double scaleFactor = 1;
  double angle = 0;
  int _selectedIndex = 0;

   late AnimationController _animationController;
   late List carouselItems = [];
   List liveMatches = [];
   List  teams = [];
   Timer? _updateTimer;


  Future<void> fetchLiveMatches() async {
    const String apiUrl =
      "https://dapiab.apcqwd.com/api/merge/schedules?d=afr.livesports088.com&_t=1733224972020";
    const Map<String, String> headers = {
       "accept": "application/json, text/plain, */*",
       "accept-language": "en-US,en;q=0.9",
       "priority": "u=1, i",
       "sec-ch-ua": "\"Google Chrome\";v=\"131\", \"Chromium\";v=\"131\", \"Not_A Brand\";v=\"24\"",
       "sec-ch-ua-mobile": "?1",
       "sec-ch-ua-platform": "\"Android\"",
       "sec-fetch-dest": "empty",
       "sec-fetch-mode": "cors",
       "sec-fetch-site": "cross-site"
    };

    try {
      final response = await http.get(Uri.parse(apiUrl), headers: headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        // Detailed logging
        debugPrint('Raw API Response: ${response.body}');

        // Modified parsing for this specific response structure
        if (data is Map<String, dynamic> && data.containsKey('matchList')) {
          setState(() {
            liveMatches = List<Map<String, dynamic>>.from(data['matchList'])
                .where((match) => _isValidMatch(match))
                .toList();
          });

          debugPrint('Parsed Live Matches: ${liveMatches.length}');
        } else {
          debugPrint("No valid match data found in response");
          setState(() {
            liveMatches = [];
          });
        }
      } else {
        debugPrint("HTTP Error: ${response.statusCode}");
        debugPrint("Response Body: ${response.body}");
        setState(() {
          liveMatches = [];
        });
      }
    } catch (e, stackTrace) {
      // More comprehensive error handling
      debugPrint("Error fetching live matches: $e");
      debugPrint("Stack Trace: $stackTrace");
      
      setState(() {
        liveMatches = [];
      });
    }
}
    bool _isValidMatch(Map<String, dynamic> match) {
      return match.containsKey('homeName') && 
            match.containsKey('awayName') && 
            match['homeName'] != null && 
            match['awayName'] != null;
    }
    bool isSearching = false;
    TextEditingController searchController = TextEditingController();
    List<dynamic> filteredMatches = [];

  String _formatMatchTime(int? timestamp) {
    if (timestamp == null) return 'Unknown Time';
    
    DateTime matchTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return DateFormat('EEE, MMM d, HH:mm').format(matchTime);
  }

  bool _isMatchLive(Map<String, dynamic> match) {
    if (match['matchType'] == 1) return true;

    if (match['matchTime_t'] != null) {
      DateTime matchTime = DateTime.fromMillisecondsSinceEpoch(match['matchTime_t']);
      DateTime now = DateTime.now();

      return matchTime.isBefore(now) && 
             now.difference(matchTime).inHours < 2;
    }
    return false;
  }

  String _getMatchTimeStatus(Map<String, dynamic> match) {
    if (match['matchTime_t'] == null) return 'Unknown';

    DateTime matchTime = DateTime.fromMillisecondsSinceEpoch(match['matchTime_t']);
    DateTime now = DateTime.now();

    if (matchTime.isAfter(now)) {
      Duration difference = matchTime.difference(now);
      if (difference.inDays > 0) {
        return '${difference.inDays}d ${difference.inHours % 24}h';
      } else if (difference.inHours > 0) {
        return '${difference.inHours}h ${difference.inMinutes % 60}m';
      } else {
        return '${difference.inMinutes}m';
      }
    } else {
      // Match is in the past or ongoing
      Duration difference = now.difference(matchTime);
      if (difference.inHours < 2) {
        return 'Live';
      } else {
        return 'FT';
      }
    }
  }

  final List<Widget> _pages = [
    const Column(children: []), 
     const Grounds(), 
     const Store(), 
     const Profile(), 
    ];

  //  @override
  // void initState() {
  //   super.initState();
  //   ReadData();
  // }

  void _onItemSelected(int index) {
    setState((){
      _selectedIndex = index;
    });
  }

  void _goToPreviousBottomNavItem (){
    setState(() {
      _selectedIndex --;
    });
  }

  ReadData() async {
    await DefaultAssetBundle.of(context).loadString("json/carouselItems.json").then((s) {
      setState(() {
        carouselItems = json.decode(s);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    fetchLiveMatches();
    ReadData();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _updateTimer = Timer.periodic(const Duration(minutes: 3), (timer) {
      fetchLiveMatches();
    });
  }

  @override
  void dispose () {
    _animationController.dispose();
    _updateTimer?.cancel();
    super.dispose();
  }

  void _toggleDrawer(){
    if (_isDrawerOpen){
      _animationController.reverse();
    } else{
      _animationController.forward();
    }
    setState(() {
      _isDrawerOpen = !_isDrawerOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomDrawer(onClose: _toggleDrawer),
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              double slide = 255 * (_animationController.value);
              double scale = 1 - ((_animationController.value)* 0.15);
              double rotate = (_animationController.value) * 10 * (math.pi / 180);

              return Transform(
                transform: Matrix4.identity()
                  ..translate(slide)
                  ..scale(scale)
                  ..rotateX(rotate),
                alignment: Alignment.center,
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 20,
                        offset: const Offset(0, 10), 
                      ),
                    ],
                  ),
                    child: GestureDetector(
                    onTap: _isDrawerOpen ? _toggleDrawer : null,
                    child: AbsorbPointer(
                    absorbing: _isDrawerOpen,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(_isDrawerOpen ? 20 : 0),
                      child: Scaffold(
                        body: content(),
                        bottomNavigationBar: CustomBottomNavBar(
                          selectedIndex: _selectedIndex,
                          onItemSelected: _onItemSelected,
                        ),
                        ),
                      ),
                    ),
                  ),
                )
              );
            },
          ),
        ],
      ),
    );
  }

  Widget content() {
  return LayoutBuilder(
    builder: (context, Constraints) {
    if (_selectedIndex != 0){
      return _pages[_selectedIndex];
    }
      return SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.35,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
                // image: const DecorationImage(
                //   image: AssetImage("images/img1.png"), 
                //   alignment: Alignment.centerRight,
                //   fit: BoxFit.none,
                //   scale: 1.5,
                //   filterQuality: FilterQuality.high
                // ),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.greenAccent.withOpacity(0.7),
                    Colors.green.withOpacity(0.9),
                  ],
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 40,
                    right: 10,
                    child: Image.asset(
                      "images/img1.png",
                      scale: 1.5,
                      fit: BoxFit.none,
                      filterQuality: FilterQuality.high,
                    )
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    height: 100, 
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(20),
                          bottomLeft: Radius.circular(20),
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.green.shade800.withOpacity(0.9),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SafeArea(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: _toggleDrawer,
                              child: const Padding(
                                padding: EdgeInsets.only(left: 10,),
                              child: Icon(Icons.menu)
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () {},
                                  child: const Icon(Icons.search),
                                ),
                                PopupMenuButton(
                                  itemBuilder: (context) => [
                                    const PopupMenuItem(
                                      value: 0,
                                      child: Text("Feedback"),
                                    ),
                                    const PopupMenuItem(
                                      value: 1,
                                      child: Text("Privacy policy"),
                                    ),
                                    const PopupMenuItem(
                                      value: 2,
                                      child: Text("Terms"),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                         Align(
                          alignment: Alignment.bottomLeft,
                          child: Padding(padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            "Welcome, \n ${UserService.getCurrentUsername()}",
                            semanticsLabel: UserService.getCurrentUsername(),
                            style: const TextStyle(
                              fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 20,
              ),
              child: Column(
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Live Games",
                        style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.5,
                    child: liveMatches.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const CircularProgressIndicator(),
                            const Text('No live matches available'),
                            ElevatedButton(
                              onPressed: fetchLiveMatches,
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      )
                      : ListView.builder(
                        itemCount: liveMatches.length,
                        itemBuilder: (context, index) {
                          final match = liveMatches[index];
                          bool matchIsLive = _isMatchLive(match);
                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
                            decoration: BoxDecoration(
                              // border: Border.all(
                              //   color: matchIsLive ? Colors.green.shade200 : Colors.grey.shade300
                              //   ),
                              borderRadius: BorderRadius.circular(12),
                              color: matchIsLive 
                                ? Colors.green.shade50 
                                : Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 1,
                                  blurRadius: 5
                                )
                              ]
                            ),
                            child: ListTile(
                              leading: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.network(
                                    match['homeLogoUrl'] ?? '',
                                    width: 20,
                                    height: 20,
                                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.sports_soccer),
                                  ),
                                  const SizedBox(width: 10),
                                  Image.network(
                                    match['awayLogoUrl'] ?? '',
                                    width: 20,
                                    height: 20,
                                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.sports_soccer),
                                  ),
                                ],
                              ),
                              title: Text(
                                "${match['homeName'] ?? 'Unknown'} vs ${match['awayName'] ?? 'Unknown'}",
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "League: ${match['leagueEn'] ?? 'Unknown'}",
                                    style: TextStyle(
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                  Text(
                                    "Time: ${_formatMatchTime(match['matchTime_t'])}",
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      if ((_getMatchTimeStatus(match) == 'Live' || 
                                          _getMatchTimeStatus(match) == 'FT') && 
                                          match['homeScore'] != null && 
                                          match['awayScore'] != null)
                                        Row(
                                          children: [
                                            Text(
                                              "${match['homeScore']} - ${match['awayScore']}",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: _getMatchTimeStatus(match) == 'Live' 
                                                  ? Colors.green.shade700
                                                  : Colors.grey.shade700,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: Text(
                                                match['matchTime'] ?? 
                                                (match['statusText'] ?? 
                                                (match['matchMinute'] != null ? "${match['matchMinute']}'" : '')),
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      const SizedBox(width: 10),
                                      Text(
                                        _getMatchTimeStatus(match),
                                        style: TextStyle(
                                          color: _getMatchTimeStatus(match) == 'Live' 
                                            ? Colors.green.shade700 
                                            : Colors.grey.shade600,
                                          fontWeight: _getMatchTimeStatus(match) == 'Live'
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                        )
                                      )
                                    ],
                                  )
                                
                              ],
                            ),
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: _getMatchTimeStatus(match) == 'Live'
                                ? Colors.green.shade100 
                                : Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(20),
                              ),
                            child: Text(
                              _getMatchTimeStatus(match),
                              style: TextStyle(
                                color: _getMatchTimeStatus(match) == 'Live'
                                  ? Colors.green.shade800 
                                  : Colors.grey.shade600,
                                  fontWeight: _getMatchTimeStatus(match) == 'Live'
                                    ? FontWeight.bold 
                                    : FontWeight.normal,
                                ),
                            ),
                          ),
                          onTap: matchIsLive ? () {
                            Navigator.push(
                              context, 
                              MaterialPageRoute(
                                builder: (context) => const LiveStreamScreen(
                                  streamUrl: 'https://dapiab.apcqwd.com/api/merge/schedules?d=afr.livesports088.com&_t=1733224972020',
                                ),
                              )
                            );
                          }: null,
                        ),
                      );
                    },
                  )
                  )
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}
}