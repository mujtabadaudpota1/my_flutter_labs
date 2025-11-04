import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';

class DataRepository {
  static final EncryptedSharedPreferences _prefs = EncryptedSharedPreferences();

  static String loginName = "";
  static String firstName = "";
  static String lastName = "";
  static String phoneNumber = "";
  static String email = "";

  static Future<void> loadData() async {
    loginName = await _prefs.getString("loginName") ?? "";
    firstName = await _prefs.getString("firstName") ?? "";
    lastName = await _prefs.getString("lastName") ?? "";
    phoneNumber = await _prefs.getString("phoneNumber") ?? "";
    email = await _prefs.getString("email") ?? "";
  }

  static Future<void> saveData() async {
    await _prefs.setString("loginName", loginName);
    await _prefs.setString("firstName", firstName);
    await _prefs.setString("lastName", lastName);
    await _prefs.setString("phoneNumber", phoneNumber);
    await _prefs.setString("email", email);
  }
}
