import 'package:flutter/material.dart';
import 'package:sportpro/login.dart';

class CustomDrawer extends StatelessWidget {
  final Function() onClose;

  const CustomDrawer({super.key, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.white12,
                borderRadius: BorderRadius.only(bottomRight: Radius.circular(20))
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white10,
                    child: Icon(Icons.person, size: 40, color: Colors.blueGrey),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    UserService.getCurrentUsername(),
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                
                onClose();
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {
                
                onClose();
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                
                onClose();
              },
            ),
            ListTile(
              leading: const Icon(Icons.help),
              title: const Text('Help & Support'),
              onTap: () {
                
                onClose();
              },
            ),
            const SizedBox(height: 50,),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.exit_to_app, color: Colors.red),
              title: const Text('Logout', style: TextStyle(color: Colors.red)),
              onTap: () async {
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
      ),
    );
  }
}