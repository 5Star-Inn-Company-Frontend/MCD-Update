import 'package:flutter/material.dart';

class GridViewBuilder extends StatelessWidget {
  final List<Widget> items;
  final int crossAxisCount;
  final double childAspectRatio;

  const GridViewBuilder({
    super.key,
    required this.items,
    required this.crossAxisCount,
    this.childAspectRatio = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: ((items.length - 1) ~/ crossAxisCount) + 1,
      itemBuilder: (context, index) {
        final start = index * crossAxisCount;
        final end = (start + crossAxisCount) > items.length
            ? items.length
            : start + crossAxisCount;
        final itemsInRow = items.sublist(start, end);

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: itemsInRow
              .map(
                (item) => SizedBox(
                    width: MediaQuery.of(context).size.width / crossAxisCount,
                    height: MediaQuery.of(context).size.width /
                        (crossAxisCount * childAspectRatio),
                    child: item),
              )
              .toList(),
        );
      },
    );
  }
}
