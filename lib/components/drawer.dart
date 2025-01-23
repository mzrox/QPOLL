import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:qpoll/Constants/constants.dart';
import 'package:qpoll/Screens/UserAuth/LoginScreen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase/supabase.dart';
import '../Screens/components/PrivateVoting/MyPolls.dart';

class CustomDrawer extends StatefulWidget {
  final String username;
  final bool isLoggedIn;

  const CustomDrawer({
    Key? key,
    required this.username,
    required this.isLoggedIn,
  }) : super(key: key);

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  final ImagePicker _picker = ImagePicker();
  String? _profileImageUrl;
  String? _userId;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  /// Load the user profile image and userId from Firestore
  Future<void> _loadUserProfile() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('username', isEqualTo: widget.username)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        final user = querySnapshot.docs.first;

        setState(() {
          _userId = user.id;
          _profileImageUrl =
          user.data().containsKey('profileImage') ? user['profileImage'] as String? : null;
        });
      } else {
        setState(() {
          _userId = 'N/A';
          _profileImageUrl = null;
        });
      }
    } catch (e) {
      print("Error loading profile image and user ID: $e");
      setState(() {
        _userId = 'Error';
        _profileImageUrl = null;
      });
    }
  }

  /// Upload image to Supabase and save the URL along with userId in Firestore
  Future<void> _uploadImage(XFile imageFile) async {
    try {
      // Initialize Supabase Client
      final client = SupabaseClient(
        'https://yacfqzlgnfdcingcxbxr.supabase.co',
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InlhY2ZxemxnbmZkY2luZ2N4YnhyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzY4NzI5MzIsImV4cCI6MjA1MjQ0ODkzMn0.l0CZm5SHdB9iaGXfPtEPsq_Nk0LkxNrRgqxaaGftd28',
      );

      // Prepare File for Upload
      final fileBytes = await imageFile.readAsBytes();
      final fileName = '${DateTime.now().millisecondsSinceEpoch}_${imageFile.name}';

      // Upload File to Supabase Storage
      final response = await client.storage.from('user_pictures').uploadBinary(fileName, fileBytes);

      if (response.error != null) {
        throw Exception('Upload failed: ${response.error!.message}');
      }

      // Get Public URL of Uploaded File
      final imageUrl = client.storage.from('user_pictures').getPublicUrl(fileName);
      setState(() {
        _profileImageUrl = imageUrl;
      });
      // Update Firestore with Profile Image URL
      if (_userId != null && _userId != 'N/A') {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(_userId)
            .update({'profileImage': imageUrl});

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile image updated successfully.')),
        );
      } else {
        throw Exception("User ID not found in Firestore");
      }
    } catch (e) {
      print('Error uploading image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload profile image.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(
              widget.username.isNotEmpty ? widget.username : "Guest",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            accountEmail: Text(
              _userId != null && _userId != 'N/A' && _userId != 'Error'
                  ? "ID: $_userId"
                  : "No ID available",
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            currentAccountPicture: GestureDetector(
              onTap: () async {
                final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
                if (pickedFile != null) {
                  await _uploadImage(pickedFile);
                }
              },
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    backgroundImage: _profileImageUrl != null
                        ? NetworkImage(_profileImageUrl!)
                        : null,
                    child: _profileImageUrl == null
                        ? Text(
                      widget.username.isNotEmpty
                          ? widget.username[0].toUpperCase()
                          : "G",
                      style: TextStyle(fontSize: 40.0, color: kPrimaryColor),
                    )
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Icon(
                      Icons.edit,
                      color: Colors.blueAccent,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
            decoration: BoxDecoration(color: kPrimaryColor),
          ),
          if (!widget.isLoggedIn)
            ListTile(
              leading: Icon(Icons.login),
              title: Text('Login'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },

            ),
          //i have question ma'am, dekho why are we letting unkwon user in the app, user has to login ni?
          if (widget.isLoggedIn) ...[
            ListTile(
              leading: Icon(Icons.poll),
              title: Text('My Polls'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyPollsPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setBool('isLoggedIn', false);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}

extension on String {
  get error => null;
}
