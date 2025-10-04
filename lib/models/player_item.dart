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
    const PlayerItem(
      nickname: 'Ace',
      fullName: 'Alice Johnson',
      contactNumber: '123-456-7890',
      email: 'alice@gmail.com',
      address: '123 Main St, Cityville',
      remarks: 'Top player',
      levelStart: 'Beginner (Weak)',
      levelEnd: 'Intermediate (Strong)',
    ),
    const PlayerItem(
      nickname: 'Smash',
      fullName: 'Bob Smith',
      contactNumber: '987-654-3210',
      email: 'bob.smith@email.com',
      address: '456 Elm St, Townsville',
      remarks: 'Aggressive style',
      levelStart: 'Level D (Mid)',
      levelEnd: 'Level C (Strong)',
    ),
    const PlayerItem(
      nickname: 'Drop',
      fullName: 'Carol Lee',
      contactNumber: '555-123-4567',
      email: 'carol.lee@email.com',
      address: '789 Oak Ave, Villagetown',
      remarks: 'Consistent performer',
      levelStart: 'Level F (Weak)',
      levelEnd: 'Level E (Mid)',
    ),
  ];
}
