abstract class MarineData {
  Future<List<dynamic>> loadUsernames();
  Future<void> changeUsername(int index, String newUsername);
}
