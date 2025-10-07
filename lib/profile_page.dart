import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'data_repository.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _firstNameController =
        TextEditingController(text: DataRepository.firstName);
    _lastNameController = TextEditingController(text: DataRepository.lastName);
    _phoneController = TextEditingController(text: DataRepository.phoneNumber);
    _emailController = TextEditingController(text: DataRepository.email);

    _firstNameController.addListener(_saveData);
    _lastNameController.addListener(_saveData);
    _phoneController.addListener(_saveData);
    _emailController.addListener(_saveData);
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

  void _launchUrl(String url) async {
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else if (mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Unsupported"),
          content: const Text("This action is not supported on your device."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome Back ${DataRepository.loginName}"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTextField(_firstNameController, "First Name"),
              _buildTextField(_lastNameController, "Last Name"),
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
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: label,
        ),
      ),
    );
  }

  Padding _buildPhoneRow() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Flexible(
            child: TextField(
              controller: _phoneController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Phone Number",
              ),
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () => _launchUrl("tel:${_phoneController.text}"),
            child: const Icon(Icons.call),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () => _launchUrl("sms:${_phoneController.text}"),
            child: const Icon(Icons.message),
          ),
        ],
      ),
    );
  }

  Padding _buildEmailRow() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Flexible(
            child: TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Email Address",
              ),
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () => _launchUrl("mailto:${_emailController.text}"),
            child: const Icon(Icons.mail),
          ),
        ],
      ),
    );
  }
}
