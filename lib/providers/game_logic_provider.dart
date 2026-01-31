
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nivel_mamado/services/firestore_service.dart';

final gameLogicProvider = Provider((ref) {
  final firestoreService = ref.watch(firestoreServiceProvider);
  return GameLogic(firestoreService);
});

class GameLogic {
  final FirestoreService _firestoreService;

  GameLogic(this._firestoreService);

  // XP Formula: Volume (kg) * 0.01
  double calculateXp(double totalVolume) {
    return totalVolume * 0.01;
  }

  // Leveling Formula: sqrt(XP / 50) + 1
  int calculateLevel(double totalXP) {
    if (totalXP <= 0) return 1;
    return (sqrt(totalXP / 50) + 1).floor();
  }

  // Rank Calculation
  String getRank(int level) {
    if (level >= 100) return 'S-Rank';
    if (level >= 80) return 'A-Rank';
    if (level >= 60) return 'B-Rank';
    if (level >= 40) return 'C-Rank';
    if (level >= 20) return 'D-Rank';
    return 'E-Rank';
  }

  // Update user stats after a workout
  Future<void> updateUserStats(String uid, double newVolume) async {
    final userData = await _firestoreService.getUser(uid);
    if (userData == null) return;

    final xpGained = calculateXp(newVolume);
    final newTotalVolume = userData.totalVolume + newVolume;
    final newTotalXp = userData.currentXP + xpGained;

    final newLevel = calculateLevel(newTotalXp);
    final newRank = getRank(newLevel);

    final updatedUser = userData.copyWith(
      totalVolume: newTotalVolume,
      currentXP: newTotalXp,
      level: newLevel,
      rank: newRank,
    );

    await _firestoreService.setUser(updatedUser);
  }
}
