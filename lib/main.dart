import 'package:flutter/material.dart';
import 'package:my_cst2322_labs/data_repository.dart';
import 'package:my_cst2322_labs/profile_page.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DataRepository.loadData(); // Load repository data at app start
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 5 Login Page',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'Lab 5 Login Page'),
      routes: {
        '/profile': (context) => const ProfilePage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late TextEditingController _loginController;
  late TextEditingController _passwordController;
  final EncryptedSharedPreferences _prefs = EncryptedSharedPreferences();

  @override
  void initState() {
    super.initState();
    _loginController = TextEditingController();
    _passwordController = TextEditingController();
    _loadSavedCredentials();
  }

  Future<void> _loadSavedCredentials() async {
    String? savedLogin = await _prefs.getString("login");
    String? savedPassword = await _prefs.getString("password");

    if (savedLogin != null && savedPassword != null) {
      _loginController.text = savedLogin;
      _passwordController.text = savedPassword;

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Saved login credentials loaded.")),
        );
      }
    }
  }

  void _onLoginPressed() async {
    if (_passwordController.text == "abcd") {
      DataRepository.loginName = _loginController.text;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Welcome Back ${DataRepository.loginName}")),
      );

      await DataRepository.saveData();
      Navigator.pushNamed(context, "/profile");
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Incorrect password")),
      );
    }
  }

  @override
  void dispose() {
    _loginController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _loginController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Login name",
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Password",
                ),
              ),
            ),
            ElevatedButton(
              onPressed: _onLoginPressed,
              child: const Text("Login"),
            ),
          ],
        ),
      ),
    );
  }
}
