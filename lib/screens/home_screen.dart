
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nivel_mamado/models.dart';
import 'package:nivel_mamado/screens/routines_screen.dart';

// Mock User Data Provider
final userProvider = FutureProvider<UserData>((ref) async {
  // In a real app, you would get the UID from Firebase Auth
  return const UserData(
    uid: 'mock_user_id',
    name: 'El Mamado',
    level: 15,
    currentXP: 12500,
    totalVolume: 1250000,
    rank: 'D-Rank',
  );
});

// Mock History Data Provider
final historyProvider = StreamProvider<List<WorkoutHistory>>((ref) {
  // Mock stream of workout history
  return Stream.value([
    WorkoutHistory(date: DateTime.now().subtract(const Duration(days: 1)), routineName: 'Pecho/Tricep', totalVolume: 10000, xpGained: 100, exercises: []),
    WorkoutHistory(date: DateTime.now().subtract(const Duration(days: 3)), routineName: 'Espalda/Bicep', totalVolume: 12000, xpGained: 120, exercises: []),
    WorkoutHistory(date: DateTime.now().subtract(const Duration(days: 5)), routineName: 'Pierna', totalVolume: 15000, xpGained: 150, exercises: []),
  ]);
});

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProvider);
    final historyAsync = ref.watch(historyProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nivel: Mamado'),
        actions: [
          IconButton(
            icon: const Icon(FontAwesomeIcons.user),
            onPressed: () { /* Navigate to Profile */ },
          ),
        ],
      ),
      body: userAsync.when(
        data: (user) => SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStatusCard(context, user),
              const SizedBox(height: 24),
              Text('Progreso Semanal', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              historyAsync.when(
                data: (history) => _buildVolumeChart(context, history),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, stack) => Text('Error: $err'),
              ),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const RoutinesScreen()),
          );
        },
        label: const Text('Nuevo Jale'),
        icon: const Icon(FontAwesomeIcons.plus),
      ),
    );
  }

  Widget _buildStatusCard(BuildContext context, UserData user) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(user.name ?? 'Usuario', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Chip(label: Text(user.rank, style: const TextStyle(fontWeight: FontWeight.bold))),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatColumn('Nivel', user.level.toString(), context),
                _buildStatColumn('XP Total', user.currentXP.toStringAsFixed(0), context),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(String label, String value, BuildContext context) {
    return Column(
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
        Text(value, style: Theme.of(context).textTheme.headlineMedium),
      ],
    );
  }

  Widget _buildVolumeChart(BuildContext context, List<WorkoutHistory> history) {
    // This is a simplified chart. A real implementation would aggregate volume by day.
    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          barTouchData: BarTouchData(enabled: false),
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (double value, TitleMeta meta) {
                  // Placeholder for day labels
                  return SideTitleWidget(axisSide: meta.axisSide, child: Text(value.toInt().toString()));
                },
              ),
            ),
          ),
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          barGroups: history.asMap().entries.map((entry) {
            final index = entry.key;
            final workout = entry.value;
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: workout.totalVolume,
                  color: Theme.of(context).primaryColor,
                  width: 16,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4),
                    topRight: Radius.circular(4),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
