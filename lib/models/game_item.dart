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
  final String gameTitle;
  final String courtName;
  final List<CourtSchedule> schedules;
  final double courtRate;
  final double shuttleCockPrice;
  final bool divideCourtEqually;
  int numberOfPlayers;
  List<String> selectedPlayerNicknames;

  GameItem({
    required this.gameTitle,
    required this.courtName,
    required this.schedules,
    required this.courtRate,
    required this.shuttleCockPrice,
    required this.divideCourtEqually,
    this.numberOfPlayers = 0,
    List<String>? selectedPlayerNicknames,
  }) : selectedPlayerNicknames = selectedPlayerNicknames ?? [];

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
