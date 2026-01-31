
import 'package:flutter/material.dart';

class PlateCalculatorModal extends StatefulWidget {
  final double barbellWeight;

  const PlateCalculatorModal({super.key, this.barbellWeight = 20.0});

  @override
  _PlateCalculatorModalState createState() => _PlateCalculatorModalState();
}

class _PlateCalculatorModalState extends State<PlateCalculatorModal> {
  final TextEditingController _weightController = TextEditingController();
  List<Map<String, dynamic>> _plates = [];

  // Available plates in kg
  final List<double> availablePlates = [25, 20, 15, 10, 5, 2.5, 1.25];

  void _calculatePlates() {
    final targetWeight = double.tryParse(_weightController.text);
    if (targetWeight == null || targetWeight <= widget.barbellWeight) {
      setState(() {
        _plates = [];
      });
      return;
    }

    double weightPerSide = (targetWeight - widget.barbellWeight) / 2.0;
    List<Map<String, dynamic>> platesNeeded = [];

    for (var plate in availablePlates) {
      int count = (weightPerSide / plate).floor();
      if (count > 0) {
        platesNeeded.add({'weight': plate, 'count': count});
        weightPerSide -= count * plate;
      }
    }

    setState(() {
      _plates = platesNeeded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Calculadora de Discos', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 20),
          TextField(
            controller: _weightController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Peso Total Deseado (kg)',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) => _calculatePlates(),
          ),
          const SizedBox(height: 20),
          if (_plates.isNotEmpty)
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: _plates.map((plate) {
                return Chip(
                  label: Text('${plate['count']} x ${plate['weight']}kg'),
                );
              }).toList(),
            )
        ],
      ),
    );
  }
}
