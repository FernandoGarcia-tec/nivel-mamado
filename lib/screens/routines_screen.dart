
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nivel_mamado/models.dart';
import 'package:nivel_mamado/screens/session_screen.dart';

// Mock Routines Provider
final routinesProvider = FutureProvider<List<Routine>>((ref) async {
  return [
    const Routine(name: 'Pecho/Tricep', exercises: [
      Exercise(name: 'Bench Press', sets: [ExerciseSet(reps: 8, weight: 100)]), 
      Exercise(name: 'Tricep Pushdown', sets: [ExerciseSet(reps: 12, weight: 50)])]),
    const Routine(name: 'Espalda/Bicep', exercises: [
      Exercise(name: 'Pull-ups', sets: [ExerciseSet(reps: 10, weight: 0)]), 
      Exercise(name: 'Bicep Curls', sets: [ExerciseSet(reps: 10, weight: 30)])]),
    const Routine(name: 'Pierna', exercises: [
      Exercise(name: 'Squats', sets: [ExerciseSet(reps: 8, weight: 150)]), 
      Exercise(name: 'Leg Press', sets: [ExerciseSet(reps: 12, weight: 250)])]),
  ];
});

class RoutinesScreen extends ConsumerWidget {
  const RoutinesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routinesAsync = ref.watch(routinesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Elige tu Jale'),
      ),
      body: routinesAsync.when(
        data: (routines) => ListView.builder(
          itemCount: routines.length,
          itemBuilder: (context, index) {
            final routine = routines[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                title: Text(routine.name, style: Theme.of(context).textTheme.titleLarge),
                subtitle: Text('${routine.exercises.length} ejercicios'),
                onTap: () {
                   Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SessionScreen(routine: routine)),
                  );
                },
              ),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
