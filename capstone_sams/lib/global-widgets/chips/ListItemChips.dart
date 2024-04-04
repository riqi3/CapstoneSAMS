import 'package:capstone_sams/constants/theme/sizing.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ListItemChip extends StatefulWidget {
  List<String> list;
  final Function(List<String>) onListChange;
  ListItemChip({
    super.key,
    required this.list,
    required this.onListChange,
  });

  @override
  State<ListItemChip> createState() => _ListItemChipState();
}

class _ListItemChipState extends State<ListItemChip> {
  void removeItemFromList(String item, List<String> list) {
    int index = list.indexOf(item);
    setState(() {
      list.removeAt(index);
      widget.onListChange(list);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: widget.list.map((e) {
        return Padding(
          padding: const EdgeInsets.only(right: Sizing.spacing),
          child: Chip(
            onDeleted: () => removeItemFromList(e, widget.list),
            label: Text(e),
          ),
        );
      }).toList(),
    );
  }
}
