import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'data_repository.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: DataRepository.firstName)
      ..addListener(_saveData);
    _lastNameController = TextEditingController(text: DataRepository.lastName)
      ..addListener(_saveData);
    _phoneController = TextEditingController(text: DataRepository.phoneNumber)
      ..addListener(_saveData);
    _emailController = TextEditingController(text: DataRepository.email)
      ..addListener(_saveData);
  }

  void _saveData() {
    DataRepository.firstName = _firstNameController.text;
    DataRepository.lastName = _lastNameController.text;
    DataRepository.phoneNumber = _phoneController.text;
    DataRepository.email = _emailController.text;
    DataRepository.saveData();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _launchUri(Uri uri) async {
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else if (mounted) {
      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Unsupported'),
          content: const Text('This action is not supported on your device.'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final login = DataRepository.loginName;
    return Scaffold(
      appBar: AppBar(title: Text('Welcome Back $login')),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildTextField(_firstNameController, 'First Name'),
              _buildTextField(_lastNameController, 'Last Name'),
              _buildPhoneRow(),
              _buildEmailRow(),
            ],
          ),
        ),
      ),
    );
  }

  Padding _buildTextField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(border: const OutlineInputBorder(), labelText: label),
      ),
    );
  }

  Padding _buildPhoneRow() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Flexible(
            child: TextField(
              controller: _phoneController,
              decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Phone Number'),
              keyboardType: TextInputType.phone,
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () => _launchUri(Uri(scheme: 'tel', path: _phoneController.text)),
            child: const Icon(Icons.call),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () => _launchUri(Uri(scheme: 'sms', path: _phoneController.text)),
            child: const Icon(Icons.message),
          ),
        ],
      ),
    );
  }

  Padding _buildEmailRow() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Flexible(
            child: TextField(
              controller: _emailController,
              decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Email Address'),
              keyboardType: TextInputType.emailAddress,
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () => _launchUri(Uri(scheme: 'mailto', path: _emailController.text)),
            child: const Icon(Icons.mail),
          ),
        ],
      ),
    );
  }
}
