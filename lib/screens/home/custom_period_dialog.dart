import 'package:flutter/material.dart';

class CustomPeriodDialog extends StatefulWidget {
  final int initialValue;
  final void Function(int) onApply;
  final VoidCallback onCancel;

  const CustomPeriodDialog({
    super.key,
    required this.initialValue,
    required this.onApply,
    required this.onCancel,
  });

  @override
  State<CustomPeriodDialog> createState() => _CustomPeriodDialogState();
}

class _CustomPeriodDialogState extends State<CustomPeriodDialog> {
  late int n;

  @override
  void initState() {
    super.initState();
    n = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          width: 320,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Ultimele N extrageri',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 16),
              TextField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Număr extrageri',
                  border: OutlineInputBorder(),
                ),
                controller: TextEditingController(text: n.toString()),
                onChanged: (v) =>
                    setState(() => n = int.tryParse(v) ?? widget.initialValue),
              ),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: widget.onCancel,
                    child: const Text('Anulează'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () => widget.onApply(n),
                    child: const Text('Aplică'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
