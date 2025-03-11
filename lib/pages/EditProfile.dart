import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';


class Editprofile extends StatefulWidget {
  const Editprofile({super.key});

  @override
  State<Editprofile> createState() => _EditprofileState();
}

  class UserProfile {
    String name = ""; 
    String email = ""; 
    String phone = ""; 
    String dob = "";
  }
class _EditprofileState extends State<Editprofile> {
  final TextEditingController dateController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController dobController = TextEditingController();

  @override
  void dispose () {
    nameController.dispose();
    locationController.dispose();
    phoneController.dispose();
    dobController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: contents()
    );
  }

  Widget contents() {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Text(
              "Edit Profile",
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
              )
            )
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            child: Row(
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
              ]
            )
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 300,
                  child: TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 300,
                  child: IntlPhoneField(
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                      border: UnderlineInputBorder(),
                    ),
                    initialCountryCode: 'KE', 
                    controller: phoneController,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 300,
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Date of Birth',
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    readOnly: true,
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: const ColorScheme.light(
                                primary: Colors.green,
                                onPrimary: Colors.white,
                                onSurface: Colors.black,
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );
                      
                      if (pickedDate != null) {
                        String formattedDate = "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                        setState(() {
                          dateController.text = formattedDate;
                        });
                      }
                    },
                    controller: dateController, 
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              try {
              final firestore = FirebaseFirestore.instance;

                await firestore.collection('profile').add({
                  'name': nameController.text,
                  'phone': phoneController.text,
                  'location': locationController.text,
                  'dob': dateController.text,
                });
                nameController.clear();
                phoneController.clear();
                locationController.clear();
                dateController.clear();

              await firestore.collection('profile').add({
                'name': nameController.text,
                'phone': phoneController.text,
                'location': locationController.text,
                'dob': dateController.text,
              });
              nameController.clear();
              phoneController.clear();
              locationController.clear();
              dateController.clear();

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Profile added successfully'),
                ),
              );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error adding profile: $e')
                  ),
                );
              }
              //Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'Save Changes',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              )
            ),
          )
        ]
      ),
    );
  }
}
