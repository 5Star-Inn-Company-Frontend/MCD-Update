import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:mcd/features/bills/models/cable_tv_model.dart';
import 'package:mcd/features/bills/models/electricity_model.dart';

class MyCDropdown extends StatefulWidget {
  final List<CableModelItem> items;

  const MyCDropdown({super.key, required this.items});

  @override
  State<MyCDropdown> createState() => _MyDropdownState();
}

class _MyDropdownState extends State<MyCDropdown> {
  CableModelItem? _selectedItem;

  @override
  void initState() {
    _selectedItem = widget.items.first;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton2<CableModelItem>(
      value: _selectedItem,
  
      iconStyleData: const IconStyleData(
          icon: Icon(
        Icons.keyboard_arrow_down_rounded,
        size: 30,
      )),
      isExpanded: true, // Optional: Fill available horizontal space
      items: widget.items.map((item) => _buildMenuItem(item)).toList(),
      onChanged: (item) => setState(() => _selectedItem = item),
    );
  }

  DropdownMenuItem<CableModelItem> _buildMenuItem(
      CableModelItem item) {
    return DropdownMenuItem<CableModelItem>(
      value: item,
      child: Row(
        children: [
          // Display image using preferred method (e.g., NetworkImage)
          Image.asset(item.imageUrl, width: 30, height: 30),
          const SizedBox(width: 10),
          Text(item.text),
        ],
      ),
    );
  }
}
