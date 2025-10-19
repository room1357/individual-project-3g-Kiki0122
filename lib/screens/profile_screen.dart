import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pemrograman_mobile/screens/login_screen.dart';
import 'package:pemrograman_mobile/widgets/custom_navbar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Uint8List? _imageBytes;
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  /// Jika proyekmu sebelumnya menyimpan 'name' bukan 'username',
  /// kita lakukan migrasi kecil supaya value lama tidak hilang.
  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();

    // migration: if 'username' not set but 'name' exists, move it
    final existingName = prefs.getString('name');
    final existingUsername = prefs.getString('username');
    if ((existingUsername == null || existingUsername.isEmpty) &&
        existingName != null &&
        existingName.isNotEmpty) {
      await prefs.setString('username', existingName);
      // optional: remove old key if you want
      // await prefs.remove('name');
    }

    _usernameController.text = prefs.getString('username') ?? '';
    _passwordController.text = prefs.getString('password') ?? '';

    final imageBase64 = prefs.getString('profileImage');
    if (imageBase64 != null && imageBase64.isNotEmpty) {
      try {
        setState(() {
          _imageBytes = base64Decode(imageBase64);
        });
      } catch (_) {
        // ignore decode errors
      }
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery, maxWidth: 800);
    if (picked != null) {
      final bytes = await picked.readAsBytes();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('profileImage', base64Encode(bytes));
      setState(() => _imageBytes = bytes);
    }
  }

  Future<void> _saveProfile() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', _usernameController.text.trim());
    await prefs.setString('password', _passwordController.text);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profil berhasil disimpan!')),
    );
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey[300],
                backgroundImage: _imageBytes != null ? MemoryImage(_imageBytes!) : null,
                child: _imageBytes == null
                    ? const Icon(Icons.camera_alt, size: 40, color: Colors.white)
                    : null,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _saveProfile,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              ),
              child: const Text('Simpan Perubahan'),
            ),
            const SizedBox(height: 20),
            TextButton.icon(
              onPressed: _logout,
              icon: const Icon(Icons.logout, color: Colors.red),
              label: const Text(
                'Logout',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomNavBar(currentIndex: 3),
    );
  }
}
