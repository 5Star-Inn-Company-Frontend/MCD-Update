import 'package:mcd/core/import/imports.dart';

class MonthYearPicker extends StatefulWidget {
  final Function(String) onDateSelected;
  final String? initialDate;

  const MonthYearPicker({
    super.key,
    required this.onDateSelected,
    this.initialDate,
  });

  @override
  State<MonthYearPicker> createState() => _MonthYearPickerState();
}

class _MonthYearPickerState extends State<MonthYearPicker> {
  int _selectedTabIndex = 0;
  int? _selectedYear;
  int? _selectedMonth;

  final List<String> _months = [
    'January', 'February', 'March', 'April',
    'May', 'June', 'July', 'August',
    'September', 'October', 'November', 'December'
  ];

  // Generate years from current year back to 10 years
  late final List<int> _years;

  @override
  void initState() {
    super.initState();
    final currentYear = DateTime.now().year;
    _years = List.generate(11, (index) => currentYear - index);

    // Parse initial date if provided
    if (widget.initialDate != null && widget.initialDate!.isNotEmpty) {
      try {
        final parts = widget.initialDate!.split('-');
        if (parts.length == 2) {
          _selectedYear = int.parse(parts[0]);
          _selectedMonth = int.parse(parts[1]);
        }
      } catch (e) {
        // Invalid format, ignore
      }
    }
  }

  String _formatDate() {
    if (_selectedYear != null && _selectedMonth != null) {
      return '$_selectedYear-${_selectedMonth.toString().padLeft(2, '0')}';
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header with tabs
          Row(
            children: [
              Expanded(
                child: TouchableOpacity(
                  onTap: () {
                    setState(() {
                      _selectedTabIndex = 0;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: _selectedTabIndex == 0
                              ? AppColors.primaryColor
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                    ),
                    child: Center(
                      child: TextBold(
                        'Month',
                        fontSize: 16,
                        color: _selectedTabIndex == 0
                            ? AppColors.primaryColor
                            : AppColors.primaryGrey2,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: TouchableOpacity(
                  onTap: () {
                    setState(() {
                      _selectedTabIndex = 1;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: _selectedTabIndex == 1
                              ? AppColors.primaryColor
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                    ),
                    child: Center(
                      child: TextBold(
                        'Year',
                        fontSize: 16,
                        color: _selectedTabIndex == 1
                            ? AppColors.primaryColor
                            : AppColors.primaryGrey2,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Content
          SizedBox(
            height: 300,
            child: _selectedTabIndex == 0 ? _buildMonthView() : _buildYearView(),
          ),

          const SizedBox(height: 20),

          // Action buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: TouchableOpacity(
                  onTap: () {
                    // Clear filter
                    widget.onDateSelected('');
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.primaryGrey2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: TextSemiBold(
                        'Clear',
                        fontSize: 14,
                        color: AppColors.primaryGrey2,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TouchableOpacity(
                  onTap: () {
                    if (_selectedYear != null && _selectedMonth != null) {
                      widget.onDateSelected(_formatDate());
                      Navigator.pop(context);
                    } else {
                      Get.snackbar(
                        'Invalid Selection',
                        'Please select both year and month',
                        backgroundColor: AppColors.errorBgColor,
                        colorText: Colors.white,
                      );
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: TextSemiBold(
                        'Apply',
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMonthView() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 2.5,
      ),
      itemCount: _months.length,
      itemBuilder: (context, index) {
        final monthNumber = index + 1;
        final isSelected = _selectedMonth == monthNumber;
        
        return TouchableOpacity(
          onTap: () {
            setState(() {
              _selectedMonth = monthNumber;
            });
          },
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primaryColor : Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: TextSemiBold(
                _months[index],
                fontSize: 13,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildYearView() {
    return ListView.builder(
      itemCount: _years.length,
      itemBuilder: (context, index) {
        final year = _years[index];
        final isSelected = _selectedYear == year;
        
        return TouchableOpacity(
          onTap: () {
            setState(() {
              _selectedYear = year;
            });
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primaryColor : Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: TextSemiBold(
                year.toString(),
                fontSize: 16,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
          ),
        );
      },
    );
  }
}
