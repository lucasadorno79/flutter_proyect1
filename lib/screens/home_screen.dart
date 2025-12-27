import 'package:flutter/material.dart';
import '../widgets/floating_calendar.dart';
import '../database/app_database.dart';
import '../models/transaction_model.dart';
import '../services/auth_service.dart';
import 'add_transaction_screen.dart';

class HomeScreen extends StatefulWidget {
  final bool isDarkMode;
  final Function(bool) onThemeChanged;

  const HomeScreen({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  
  State<HomeScreen> createState() => _HomeScreenState();
  
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime selectedDate = DateTime.now();


  Future<List<TransactionModel>> loadTransactions(DateTime date) async {
    final dateString = date.toIso8601String().split('T')[0];
    return await AppDatabase.getTransactionsByDate(dateString);
  }

  void onDaySelected(DateTime date) {
    setState(() {
      selectedDate = date;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catmanager'),
        actions: [
          const Icon(Icons.dark_mode),
          Switch(
            value: widget.isDarkMode,
            onChanged: widget.onThemeChanged,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await AuthService.logout();
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, '/');
              }
            },
          ),
        ],
      ),

      // 🐱 BODY CON FONDO
      body: Stack(
        children: [
          // FONDO CON GATO
          Positioned.fill(
            child: Opacity(
              opacity: widget.isDarkMode ? 0.05 : 0.08,
              child: Center(
                child: Image.asset(
                  'assets/images/cat_bg.png',
                  width: 320,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),

          // CONTENIDO NORMAL
          Column(
            children: [
              FloatingCalendar(onDaySelected: onDaySelected),
              const SizedBox(height: 8),
              Expanded(
                child: FutureBuilder<List<TransactionModel>>(
                  future: loadTransactions(selectedDate),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(
                          child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                          child: Text('No hay transacciones'));
                    }

                    final txs = snapshot.data!;

                    return ListView.builder(
                      itemCount: txs.length,
                      itemBuilder: (context, index) {
                        final tx = txs[index];

                        return ListTile(
                          title: Text(tx.description),
                          subtitle: Text(tx.category),
                          trailing: Text(
                            tx.type == 'ingreso'
                                ? '+ ${tx.amount.toStringAsFixed(2)}'
                                : '- ${tx.amount.toStringAsFixed(2)}',
                            style: TextStyle(
                              color: tx.type == 'ingreso'
                                  ? Colors.green
                                  : Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onLongPress: () async {
                            await AppDatabase.deleteTransaction(tx.id!);
                            setState(() {});
                          },
                          onTap: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => AddTransactionScreen(
                                  selectedDate: selectedDate,
                                  transaction: tx,
                                ),
                              ),
                            );

                            if (result == true) {
                              setState(() {});
                            }
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddTransactionScreen(
                selectedDate: selectedDate,
              ),
            ),
          );

          if (result == true) {
            setState(() {});
          }
        },
      ),
      
    );
  }
}
