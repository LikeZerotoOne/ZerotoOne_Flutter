// storage_util.dart
import 'package:shared_preferences/shared_preferences.dart';

class StorageUtil {
  static Future<void> saveMemberId(int memberId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('memberId', memberId);
  }

  static Future<int> getMemberId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('memberId') ?? 0;
  }
}
