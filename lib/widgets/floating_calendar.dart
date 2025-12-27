import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/preferences_service.dart';

class FloatingCalendar extends StatefulWidget {
  final Function(DateTime) onDaySelected;

  const FloatingCalendar({
    super.key,
    required this.onDaySelected,
  });

  @override
  State<FloatingCalendar> createState() => _FloatingCalendarState();
}


class _FloatingCalendarState extends State<FloatingCalendar> {
  bool isExpanded = true;
  @override
void initState() {
  super.initState();
  _loadPreferences();
}

Future<void> _loadPreferences() async {
  final expanded = await ExpandedPreferences.loadExpanded();
  setState(() {
    isExpanded = expanded;
  });
}

  DateTime currentMonth = DateTime.now();
  int? selectedDay;

  void _nextMonth() {
    setState(() {
      currentMonth =
          DateTime(currentMonth.year, currentMonth.month + 1);
      selectedDay = null;
    });
  }

  void _previousMonth() {
    setState(() {
      currentMonth =
          DateTime(currentMonth.year, currentMonth.month - 1);
      selectedDay = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final daysInMonth = DateUtils.getDaysInMonth(
      currentMonth.year,
      currentMonth.month,
    );

    final firstDayOfMonth =
        DateTime(currentMonth.year, currentMonth.month, 1);

    // En Dart: lunes = 1 ... domingo = 7
    final startWeekday = firstDayOfMonth.weekday % 7;

    final monthName =
        DateFormat('MMMM yyyy', 'es').format(currentMonth);

    final totalCells = startWeekday + daysInMonth;

    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // HEADER MES
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: _previousMonth,
                ),
                Text(
                  monthName.toUpperCase(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: _nextMonth,
                ),
              ],
            ),

            // MINIMIZAR
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: Icon(
                  isExpanded
                      ? Icons.expand_less
                      : Icons.expand_more,
                ),
                onPressed: () {
                 setState(() {
                   isExpanded = !isExpanded;
                 });
                 ExpandedPreferences.saveExpanded(isExpanded);
    },

              ),
            ),

            // CALENDARIO
            if (isExpanded) ...[
              // DÍAS DE LA SEMANA
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  _WeekDay('L'),
                  _WeekDay('M'),
                  _WeekDay('X'),
                  _WeekDay('J'),
                  _WeekDay('V'),
                  _WeekDay('S'),
                  _WeekDay('D'),
                ],
              ),

              const SizedBox(height: 8),

              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: totalCells,
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  mainAxisSpacing: 6,
                  crossAxisSpacing: 6,
                ),
                itemBuilder: (context, index) {
                  if (index < startWeekday) {
                    return const SizedBox();
                  }

                  final day = index - startWeekday + 1;
                  final isSelected = selectedDay == day;

                  final isToday =
                      currentMonth.year == DateTime.now().year &&
                      currentMonth.month == DateTime.now().month &&
                      day == DateTime.now().day;

                  Color? bgColor;
                  Color textColor = Colors.black;

                  if (isSelected) {
                    bgColor = Colors.deepPurple;
                    textColor = Colors.white;
                  } else if (isToday) {
                    bgColor = Colors.blue;
                    textColor = Colors.white;
                  }

                  return GestureDetector(
                    onTap: () {
                      final selectedDate = DateTime(currentMonth.year, currentMonth.month, day);
                      setState(() {
                        selectedDay = day;
                      });

                      widget.onDaySelected(selectedDate);
                    },

                    child: Container(
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '$day',
                        style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _WeekDay extends StatelessWidget {
  final String label;
  const _WeekDay(this.label);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
