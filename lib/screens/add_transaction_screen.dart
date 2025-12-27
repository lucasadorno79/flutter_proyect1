import 'package:flutter/material.dart';
import '../database/app_database.dart';
import '../models/transaction_model.dart';

class AddTransactionScreen extends StatefulWidget {
  final DateTime selectedDate;
  final TransactionModel? transaction; // 👈 null = crear | no null = editar

  const AddTransactionScreen({
    super.key,
    required this.selectedDate,
    this.transaction,
  });

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  late TextEditingController amountController;
  late TextEditingController descriptionController;

  String category = 'Gastos variables';
  String type = 'gasto'; // ingreso | gasto

  final List<String> categories = [
    'Gastos fijos',
    'Gastos variables',
    'Ahorro',
    'Emergencia',
  ];

  @override
  void initState() {
    super.initState();

    amountController = TextEditingController(
      text: widget.transaction?.amount.toString() ?? '',
    );

    descriptionController = TextEditingController(
      text: widget.transaction?.description ?? '',
    );

if (widget.transaction != null) {
  // NORMALIZAR TYPE
  final rawType = widget.transaction!.type.toLowerCase();

  if (rawType == 'ingreso') {
    type = 'ingreso';
  } else {
    type = 'gasto';
  }

  // NORMALIZAR CATEGORY
  if (categories.contains(widget.transaction!.category)) {
    category = widget.transaction!.category;
  } else {
    category = 'Gastos variables';
  }
}

  }

  @override
  void dispose() {
    amountController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.transaction != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Editar transacción' : 'Nueva transacción'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // MONTO
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Monto',
                prefixIcon: Icon(Icons.attach_money),
              ),
            ),

            const SizedBox(height: 12),

            // DESCRIPCIÓN
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Descripción',
                prefixIcon: Icon(Icons.description),
              ),
            ),

            const SizedBox(height: 12),

            // TIPO
            DropdownButtonFormField<String>(
              value: type,
              items: const [
                DropdownMenuItem(value: 'ingreso', child: Text('Ingreso')),
                DropdownMenuItem(value: 'gasto', child: Text('Gasto')),
              ],
              onChanged: (value) {
                setState(() {
                  type = value!;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Tipo',
              ),
            ),

            const SizedBox(height: 12),

            // CATEGORÍA
            DropdownButtonFormField<String>(
              value: category,
              items: categories
                  .map(
                    (c) => DropdownMenuItem(
                      value: c,
                      child: Text(c),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  category = value!;
                });
              },
              decoration: const InputDecoration(
                labelText: 'Categoría',
              ),
            ),

            const SizedBox(height: 20),

            // BOTÓN GUARDAR / ACTUALIZAR
            ElevatedButton(
              onPressed: () async {
                if (amountController.text.isEmpty) return;

                final tx = TransactionModel(
                  id: widget.transaction?.id,
                  amount: double.parse(amountController.text),
                  category: category,
                  type: type,
                  date: widget.selectedDate.toIso8601String().split('T')[0],
                  description: descriptionController.text,
                );

                if (isEdit) {
                  await AppDatabase.updateTransaction(tx);
                } else {
                  await AppDatabase.insertTransaction(tx);
                }

                Navigator.pop(context, true);
              },
              child: Text(isEdit ? 'Actualizar' : 'Guardar'),
            ),

            // BOTÓN ELIMINAR (solo edición)
            if (isEdit)
              TextButton.icon(
                icon: const Icon(Icons.delete, color: Colors.red),
                label: const Text(
                  'Eliminar',
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () async {
                  await AppDatabase.deleteTransaction(
                    widget.transaction!.id!,
                  );
                  Navigator.pop(context, true);
                },
              ),
          ],
        ),
      ),
    );
  }
}
