import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sportpro/login.dart';
import 'package:sportpro/pages/EditProfile.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}
class _ProfileState extends State<Profile> {

  String name = '';
  String phone = '';
  String dob = '';

  @override
  void initState() {
    super.initState();
    fetchProfileData();
  }
  
  Future<void> fetchProfileData() async {
    final profileSnapshot = await FirebaseFirestore.instance
        .collection('profile')
        .orderBy('created_at', descending: true)
        .limit(1)
        .get();

    if (profileSnapshot.docs.isNotEmpty) {
      setState(() {
        name = profileSnapshot.docs.first['name'];
        phone = profileSnapshot.docs.first['phone'];
        dob = profileSnapshot.docs.first['dob'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacementNamed(context, '/home');
        return true; 
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 300,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.greenAccent.shade400,
                      Colors.green.shade700,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(50),
                    bottomRight: Radius.circular(50),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.white,
                          child: ClipOval(
                            child: Image.asset(
                              "images/user_profile.png",
                              height: 120,
                              width: 120,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.person,
                                  size: 80,
                                  color: Colors.grey,
                                );
                              },
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 5,
                          right: 10,
                          child: GestureDetector(
                            onTap: () {
                              
                            },
                            child: const CircleAvatar(
                              backgroundColor: Colors.greenAccent,
                              radius: 15,
                              child: Icon(
                                Icons.edit,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                     name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      UserService.getCurrentUsername(),
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              profileInfoCard(
                context,
                icon: Icons.phone,
                title: "Phone Number",
                subtitle: phone,
              ),
              profileInfoCard(
                context,
                icon: Icons.calendar_today,
                title: "Date of Birth",
                subtitle: dob,
              ),
              profileInfoCard(
                context,
                icon: Icons.location_on,
                title: "Location",
                subtitle: "Los Angeles, USA",
              ),
              const SizedBox(height: 20),
      
              Column(
                children: [
                  actionButton(
                    context,
                    title: "Edit Profile",
                    icon: Icons.settings,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Editprofile(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 15),
                  actionButton(
                    context,
                    title: "Logout",
                    icon: Icons.logout,
                    color: Colors.red,
                    onPressed: () {
                      showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Logout'),
                        content: const Text('Are you sure you want to logout?'),
                        actions: <Widget>[
                          TextButton(
                            child: const Text(
                              'Cancel',
                              style: TextStyle(color: Colors.black),
                              ),
                            onPressed: () {
                              Navigator.of(context).pop(); 
                            },
                          ),
                          TextButton(
                            child: 
                            const Text(
                              'Logout',
                              style: TextStyle(color: Colors.greenAccent),
                              ),
                            onPressed: () async {
                              // Perform logout logic here
                              // await AuthService.logout();
                              
                              Navigator.of(context).pop(); 
                              Navigator.of(context).pushReplacementNamed('/login');
                              
                              
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Logged out successfully')),
                              );
                            },
                          ),
                        ],
                      );
                    },
                  );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget profileInfoCard(BuildContext context,
      {required IconData icon, required String title, required String subtitle}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.greenAccent.withOpacity(0.2),
            child: Icon(icon, color: Colors.greenAccent),
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            subtitle,
            style: const TextStyle(color: Colors.grey),
          ),
        ),
      ),
    );
  }

  Widget actionButton(BuildContext context,
      {required String title,
      required IconData icon,
      Color color = Colors.greenAccent,
      required VoidCallback onPressed}) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        minimumSize: const Size(200, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      icon: Icon(icon, size: 20),
      label: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      onPressed: onPressed,
    );
  }
}
