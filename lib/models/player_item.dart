class PlayerItem {
  final String nickname;
  final String fullName;
  final String contactNumber;
  final String email;
  final String address;
  final String remarks;
  final String levelStart;
  final String levelEnd;

  const PlayerItem({
    required this.nickname,
    required this.fullName,
    required this.contactNumber,
    required this.email,
    required this.address,
    required this.remarks,
    required this.levelStart,
    required this.levelEnd,
  });

  // Main array to store all players
  static List<PlayerItem> playerList = [
    // Initial dummy data
    const PlayerItem(
      nickname: 'Ace',
      fullName: 'Alice Johnson',
      contactNumber: '123-456-7890',
      email: 'alice@gmail.com',
      address: '123 Main St, Cityville',
      remarks: 'Top player',
      levelStart: 'Beginner',
      levelEnd: 'Intermediate',
    ),
  ];
}
