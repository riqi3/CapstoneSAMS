import 'package:capstone_sams/global-widgets/dialogs/AlertDialogTemplate.dart';
import 'package:flutter/material.dart';

class MultiSelect extends StatefulWidget {
  final List<String> items;
  final String title;
  const MultiSelect({Key? key, required this.items, required this.title})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _MultiSelectState();
}

class _MultiSelectState extends State<MultiSelect> {
  final List<String> _selectedItems = [];
  final String title = '';
  void _itemChange(String itemValue, bool isSelected) {
    setState(() {
      if (isSelected) {
        _selectedItems.add(itemValue);
      } else {
        _selectedItems.remove(itemValue);
      }
    });
  }

  void _cancel() {
    Navigator.pop(context);
  }

  void _submit() {
    Navigator.pop(context, _selectedItems);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Select ${widget.title}'),
      content: SingleChildScrollView(
        child: ListBody(
          children: widget.items
              .map(
                (item) => CheckboxListTile(
                  value: _selectedItems.contains(item),
                  title: Text(item),
                  controlAffinity: ListTileControlAffinity.leading,
                  onChanged: (isChecked) => _itemChange(item, isChecked!),
                ),
              )
              .toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _cancel,
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_selectedItems.contains('N/A') && _selectedItems.length > 1) {
              showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDiaglogTemplate(
                  title: 'Are you sure?',
                  content:
                      "It seems that you've selected N/A and selected an illness.",
                  buttonTitle: "I'll correct it",
                  onpressed: () => Navigator.pop(context),
                ),
              );
            } else {
              _submit();
            }
          },
          child: const Text('Submit'),
        ),
      ],
    );
  }
}
