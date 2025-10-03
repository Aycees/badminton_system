class PlayerItem {
  final String nickname;
  final String fullName;
  final String levelStart;
  final String levelEnd;

  const PlayerItem({
    required this.nickname,
    required this.fullName,
    required this.levelStart,
    required this.levelEnd,
  });

  static List<PlayerItem> dummyPlayers = [
    const PlayerItem(
      nickname: 'Ace',
      fullName: 'John Doe',
      levelStart: 'Level F (Mid)',
      levelEnd: 'Level F (Strong)',
    ),
    const PlayerItem(
      nickname: 'Smash',
      fullName: 'Jane Smith',
      levelStart: 'Level E (Weak)',
      levelEnd: 'Level E (Strong)',
    ),
    const PlayerItem(
      nickname: 'NetMaster',
      fullName: 'Alice Brown',
      levelStart: 'Level D (Mid)',
      levelEnd: 'Level D (Strong)',
    ),
  ];
}
