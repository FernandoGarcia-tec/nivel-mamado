
import 'package:freezed_annotation/freezed_annotation.dart';

part 'models.freezed.dart';
part 'models.g.dart';

@freezed
class UserData with _$UserData {
  const factory UserData({
    required String uid,
    String? name,
    @Default(1) int level,
    @Default(0) double currentXP,
    @Default(0) double totalVolume,
    @Default('E-Rank') String rank,
  }) = _UserData;

  factory UserData.fromJson(Map<String, dynamic> json) => _$UserDataFromJson(json);
}

@freezed
class WorkoutHistory with _$WorkoutHistory {
  const factory WorkoutHistory({
    String? id,
    required DateTime date,
    required String routineName,
    required double totalVolume,
    required double xpGained,
    required List<Exercise> exercises,
  }) = _WorkoutHistory;

  factory WorkoutHistory.fromJson(Map<String, dynamic> json) => _$WorkoutHistoryFromJson(json);
}

@freezed
class Routine with _$Routine {
  const factory Routine({
    String? id,
    required String name,
    required List<Exercise> exercises,
  }) = _Routine;

  factory Routine.fromJson(Map<String, dynamic> json) => _$RoutineFromJson(json);
}

@freezed
class Exercise with _$Exercise {
  const factory Exercise({
    required String name,
    @Default([]) List<ExerciseSet> sets,
    // For the "Ghost" values
    ExerciseSet? lastSession,
  }) = _Exercise;

  factory Exercise.fromJson(Map<String, dynamic> json) => _$ExerciseFromJson(json);
}

@freezed
class ExerciseSet with _$ExerciseSet {
  const factory ExerciseSet({
    required int reps,
    required double weight,
    @Default(false) bool isCompleted,
  }) = _ExerciseSet;

  factory ExerciseSet.fromJson(Map<String, dynamic> json) => _$ExerciseSetFromJson(json);
}
