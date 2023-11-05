import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class TaskListItem extends StatefulWidget {
  final String title;

  const TaskListItem({super.key, required this.title});

  @override
  _TaskListItemState createState() => _TaskListItemState();
}

class _TaskListItemState extends State<TaskListItem> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  late String currentTitle;
  late TextEditingController _titleController;
  late FocusNode _titleFocusNode;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting(); // Necessary for the intl package to initialize formatting.
    currentTitle = widget.title;
    _titleController = TextEditingController(text: currentTitle);
    _titleFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _titleFocusNode.dispose();
    super.dispose();
  }

  String getFormattedDateTime() {
    if (selectedDate != null && selectedTime != null) {
      final DateTime fullDateTime = DateTime(
        selectedDate!.year,
        selectedDate!.month,
        selectedDate!.day,
        selectedTime!.hour,
        selectedTime!.minute,
      );
      return DateFormat('HH:mm dd.MM.yyyy', 'ru_RU').format(fullDateTime);
    } else {
      return 'Выбрать дату и время';
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      locale: const Locale('ru', 'RU'), // Set date picker to Russian locale
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );
    if (pickedTime != null && pickedTime != selectedTime) {
      setState(() {
        selectedTime = pickedTime;
      });
    }
  }

  void updateTitle(String newTitle) {
    setState(() {
      currentTitle =
          newTitle.trim().isNotEmpty ? newTitle.trim() : currentTitle;
    });
  }

  void _showItemDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled:
          true, // Allows the bottom sheet to be shown without being covered by the keyboard
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 1,
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setModalState) {
              return Padding(
                padding: const EdgeInsets.all(24.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextField(
                        controller: _titleController,
                        focusNode: _titleFocusNode,
                        decoration: const InputDecoration(
                          border: InputBorder.none, // Hides the underline
                          hintText: 'Введите название задачи',
                        ),
                        keyboardType: TextInputType.multiline,
                        maxLines: null, // No limit to the number of lines
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                        onChanged: (newValue) {
                          setModalState(() {
                            currentTitle = newValue;
                          });
                          updateTitle(
                              newValue); // Add this line to update the main widget's state
                        },
                        onSubmitted: (newValue) {
                          setModalState(() {
                            currentTitle = newValue.trim().isNotEmpty
                                ? newValue.trim()
                                : currentTitle;
                          });
                          _titleFocusNode.unfocus(); // Remove focus when done
                          updateTitle(newValue); // And also call it here
                        },
                      ),
                      TextButton(
                        onPressed: () async {
                          await _selectDate(context);
                          setModalState(() {}); // Update the modal's state
                        },
                        child: Text(
                          selectedDate != null
                              ? DateFormat('dd.MM.yyyy', 'ru_RU')
                                  .format(selectedDate!)
                              : 'Выбрать дату',
                          style:
                              const TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          await _selectTime(context);
                          setModalState(() {}); // Update the modal's state
                        },
                        child: Text(
                          selectedTime != null
                              ? DateFormat('HH:mm', 'ru_RU').format(DateTime(
                                  0,
                                  0,
                                  0,
                                  selectedTime!.hour,
                                  selectedTime!.minute))
                              : 'Выбрать время',
                          style:
                              const TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      ),
                      // Optionally, add more content here if needed
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(currentTitle),
      subtitle: Text(
        getFormattedDateTime(),
        style: const TextStyle(color: Colors.grey),
      ),
      leading: Checkbox(
        value: false,
        onChanged: (bool? value) {
          // Handle checkbox state changes here
        },
      ),
      onTap: () => _showItemDetails(context),
    );
  }
}
