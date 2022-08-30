import 'package:flutter/material.dart';

class MyChipList<T> extends StatelessWidget {
  const MyChipList({
    Key? key,
    required this.values,
    required this.chipBuilder,
  }) : super(key: key);

  final List<T> values;
  final Chip Function(T) chipBuilder;

  List<Widget> _buildChipList() {
    final List<Widget> items = [];
    for (T value in values) {
      items.add(chipBuilder(value));
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      children: _buildChipList(),
    );
  }
}
