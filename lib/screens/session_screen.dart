
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nivel_mamado/models.dart';
import 'package:nivel_mamado/providers/game_logic_provider.dart';
import 'package:nivel_mamado/screens/plate_calculator_modal.dart';
import 'package:nivel_mamado/services/firestore_service.dart';
import 'package:vibration/vibration.dart';

class SessionScreen extends ConsumerStatefulWidget {
  final Routine routine;

  const SessionScreen({super.key, required this.routine});

  @override
  _SessionScreenState createState() => _SessionScreenState();
}

class _SessionScreenState extends ConsumerState<SessionScreen> {
  late List<Exercise> _exercises;

  @override
  void initState() {
    super.initState();
    _exercises = widget.routine.exercises.map((e) => e.copyWith()).toList();
    _loadLastSessions();
  }

  void _loadLastSessions() async {
    final firestoreService = ref.read(firestoreServiceProvider);
    // final uid = ref.read(userProvider).value!.uid;
    const uid = 'mock_user_id';

    for (int i = 0; i < _exercises.length; i++) {
      final lastSession = await firestoreService.getLastExercisePerformance(uid, _exercises[i].name);
      if (lastSession != null) {
        setState(() {
          _exercises[i] = _exercises[i].copyWith(lastSession: lastSession);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.routine.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.check, color: Colors.green),
            onPressed: _finishWorkout,
            tooltip: 'Terminar Jale',
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: _exercises.length,
        itemBuilder: (context, index) {
          return _buildExerciseCard(_exercises[index], index);
        },
      ),
    );
  }

  Widget _buildExerciseCard(Exercise exercise, int exerciseIndex) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(exercise.name, style: Theme.of(context).textTheme.titleLarge),
            if (exercise.lastSession != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                child: Text(
                  'Fantasma: ${exercise.lastSession!.weight}kg x ${exercise.lastSession!.reps} reps',
                  style: TextStyle(color: Theme.of(context).colorScheme.secondary, fontStyle: FontStyle.italic),
                ),
              ),
            const SizedBox(height: 8),
            ...List.generate(exercise.sets.length, (setIndex) {
              return _buildSetRow(exercise, exerciseIndex, setIndex);
            }),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.calculate_outlined),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (_) => PlateCalculatorModal(barbellWeight: 20),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      final newSet = exercise.sets.isNotEmpty ? exercise.sets.last : const ExerciseSet(reps: 8, weight: 50);
                      _exercises[exerciseIndex].sets.add(newSet);
                    });
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSetRow(Exercise exercise, int exerciseIndex, int setIndex) {
    final set = exercise.sets[setIndex];
    final weightController = TextEditingController(text: set.weight.toString());
    final repsController = TextEditingController(text: set.reps.toString());

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Checkbox(
            value: set.isCompleted,
            onChanged: (bool? value) {
              setState(() {
                _exercises[exerciseIndex].sets[setIndex] = set.copyWith(isCompleted: value ?? false);
              });
              if(value ?? false) {
                Vibration.vibrate(duration: 100);
              }
            },
            activeColor: Theme.of(context).colorScheme.primary,
          ),
          Expanded(
            child: _buildTextField(weightController, 'Peso (kg)', (value) {
              _exercises[exerciseIndex].sets[setIndex] = set.copyWith(weight: double.tryParse(value) ?? 0);
            }),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildTextField(repsController, 'Reps', (value) {
              _exercises[exerciseIndex].sets[setIndex] = set.copyWith(reps: int.tryParse(value) ?? 0);
            }),
          ),
          const SizedBox(width: 8),
          Text('1RM: ${_calculate1RM(set.weight, set.reps)}', style: Theme.of(context).textTheme.bodySmall)
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, Function(String) onChanged) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        isDense: true,
      ),
      onChanged: onChanged,
    );
  }

  String _calculate1RM(double weight, int reps) {
    if (reps == 0 || weight == 0) return '0';
    if (reps == 1) return weight.toStringAsFixed(1);
    // Epley formula
    return (weight * (1 + (reps / 30.0))).toStringAsFixed(1);
  }

  void _finishWorkout() async {
    final gameLogic = ref.read(gameLogicProvider);
    final firestoreService = ref.read(firestoreServiceProvider);
    // final uid = ref.read(userProvider).value!.uid;
    const uid = 'mock_user_id';

    double totalVolume = 0;
    List<Exercise> completedExercises = [];

    for (var exercise in _exercises) {
      List<ExerciseSet> completedSets = [];
      for (var set in exercise.sets) {
        if (set.isCompleted) {
          totalVolume += set.weight * set.reps;
          completedSets.add(set);
        }
      }
      if(completedSets.isNotEmpty) {
        completedExercises.add(exercise.copyWith(sets: completedSets));
      }
    }

    if (totalVolume > 0) {
      final xpGained = gameLogic.calculateXp(totalVolume);
      final history = WorkoutHistory(
        date: DateTime.now(),
        routineName: widget.routine.name,
        totalVolume: totalVolume,
        xpGained: xpGained,
        exercises: completedExercises,
      );

      await firestoreService.addHistory(uid, history);
      await gameLogic.updateUserStats(uid, totalVolume);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('¡Jale terminado! Ganaste ${xpGained.toStringAsFixed(2)} XP')));
      Navigator.of(context).popUntil((route) => route.isFirst);
    } else {
       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Completa al menos un set para terminar el jale.')));
    }
  }
}
