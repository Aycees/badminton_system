class CourtSchedule {
  final int courtNumber;
  final DateTime startTime;
  final DateTime endTime;

  CourtSchedule({
    required this.courtNumber,
    required this.startTime,
    required this.endTime,
  });
}

class GameItem {
  String gameTitle;
  String courtName;
  double courtRate;
  double shuttleCockPrice;
  bool divideCourtEqually;
  List<CourtSchedule> schedules;
  int numberOfPlayers;
  List<String> selectedPlayerNicknames;
  bool divideShuttleCockEqually;
  String? shuttleCockPayerNickname;
  List<String> courtPayerNicknames;

  GameItem({
    required this.gameTitle,
    required this.courtName,
    required this.courtRate,
    required this.shuttleCockPrice,
    this.divideCourtEqually = true,
    required this.schedules,
    this.numberOfPlayers = 0,
    this.selectedPlayerNicknames = const [],
    this.divideShuttleCockEqually = true,
    this.shuttleCockPayerNickname,
    this.courtPayerNicknames = const [],
  });

  /// Calculates and returns the total hours across all scheduled court sessions
  double getTotalHours() {
    double totalHours = 0;
    for (var schedule in schedules) {
      final duration = schedule.endTime.difference(schedule.startTime);
      totalHours += duration.inMinutes / 60.0;
    }
    return totalHours;
  }

  /// Calculates and returns the total cost including court rental and shuttle cock expenses
  double getTotalCost() {
    final totalHours = getTotalHours();
    final courtCost = totalHours * courtRate;

    // For now, assume 1 shuttle cock per hour (can be adjusted)
    final shuttleCockCost = totalHours.ceil() * shuttleCockPrice;

    return courtCost + shuttleCockCost;
  }

  // Static list to store all games
  static List<GameItem> gameList = [];
}
