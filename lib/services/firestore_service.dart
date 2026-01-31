
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nivel_mamado/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firestoreServiceProvider = Provider((ref) => FirestoreService());

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // User Methods
  Future<UserData?> getUser(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    return doc.exists ? UserData.fromJson(doc.data()!) : null;
  }

  Future<void> setUser(UserData user) {
    return _db.collection('users').doc(user.uid).set(user.toJson());
  }

  // History Methods
  Stream<List<WorkoutHistory>> getHistory(String uid) {
    return _db
        .collection('users')
        .doc(uid)
        .collection('history')
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => WorkoutHistory.fromJson(doc.data()).copyWith(id: doc.id))
            .toList());
  }

  Future<void> addHistory(String uid, WorkoutHistory history) {
    return _db.collection('users').doc(uid).collection('history').add(history.toJson());
  }

  // Routine Methods
  Stream<List<Routine>> getRoutines(String uid) {
    return _db
        .collection('users')
        .doc(uid)
        .collection('routines')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Routine.fromJson(doc.data()).copyWith(id: doc.id))
            .toList());
  }

  Future<void> setRoutine(String uid, Routine routine) {
    return _db.collection('users').doc(uid).collection('routines').add(routine.toJson());
  }

   // Ghost Value Method
  Future<ExerciseSet?> getLastExercisePerformance(String uid, String exerciseName) async {
    final snapshot = await _db
        .collection('users')
        .doc(uid)
        .collection('history')
        .orderBy('date', descending: true)
        .limit(20) // Search within the last 20 workouts for performance
        .get();

    for (var doc in snapshot.docs) {
      final history = WorkoutHistory.fromJson(doc.data());
      final exercise = history.exercises.firstWhere((e) => e.name == exerciseName, orElse: () => const Exercise(name: 'Not Found'));

      if (exercise.name != 'Not Found' && exercise.sets.isNotEmpty) {
        // Return the last set of that exercise
        return exercise.sets.last;
      }
    }
    return null;
  }
}
