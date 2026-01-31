// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserDataImpl _$$UserDataImplFromJson(Map<String, dynamic> json) =>
    _$UserDataImpl(
      uid: json['uid'] as String,
      name: json['name'] as String?,
      level: (json['level'] as num?)?.toInt() ?? 1,
      currentXP: (json['currentXP'] as num?)?.toDouble() ?? 0,
      totalVolume: (json['totalVolume'] as num?)?.toDouble() ?? 0,
      rank: json['rank'] as String? ?? 'E-Rank',
    );

Map<String, dynamic> _$$UserDataImplToJson(_$UserDataImpl instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'name': instance.name,
      'level': instance.level,
      'currentXP': instance.currentXP,
      'totalVolume': instance.totalVolume,
      'rank': instance.rank,
    };

_$WorkoutHistoryImpl _$$WorkoutHistoryImplFromJson(Map<String, dynamic> json) =>
    _$WorkoutHistoryImpl(
      id: json['id'] as String?,
      date: DateTime.parse(json['date'] as String),
      routineName: json['routineName'] as String,
      totalVolume: (json['totalVolume'] as num).toDouble(),
      xpGained: (json['xpGained'] as num).toDouble(),
      exercises: (json['exercises'] as List<dynamic>)
          .map((e) => Exercise.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$WorkoutHistoryImplToJson(
        _$WorkoutHistoryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'date': instance.date.toIso8601String(),
      'routineName': instance.routineName,
      'totalVolume': instance.totalVolume,
      'xpGained': instance.xpGained,
      'exercises': instance.exercises,
    };

_$RoutineImpl _$$RoutineImplFromJson(Map<String, dynamic> json) =>
    _$RoutineImpl(
      id: json['id'] as String?,
      name: json['name'] as String,
      exercises: (json['exercises'] as List<dynamic>)
          .map((e) => Exercise.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$RoutineImplToJson(_$RoutineImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'exercises': instance.exercises,
    };

_$ExerciseImpl _$$ExerciseImplFromJson(Map<String, dynamic> json) =>
    _$ExerciseImpl(
      name: json['name'] as String,
      sets: (json['sets'] as List<dynamic>?)
              ?.map((e) => ExerciseSet.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      lastSession: json['lastSession'] == null
          ? null
          : ExerciseSet.fromJson(json['lastSession'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$ExerciseImplToJson(_$ExerciseImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'sets': instance.sets,
      'lastSession': instance.lastSession,
    };

_$ExerciseSetImpl _$$ExerciseSetImplFromJson(Map<String, dynamic> json) =>
    _$ExerciseSetImpl(
      reps: (json['reps'] as num).toInt(),
      weight: (json['weight'] as num).toDouble(),
      isCompleted: json['isCompleted'] as bool? ?? false,
    );

Map<String, dynamic> _$$ExerciseSetImplToJson(_$ExerciseSetImpl instance) =>
    <String, dynamic>{
      'reps': instance.reps,
      'weight': instance.weight,
      'isCompleted': instance.isCompleted,
    };
