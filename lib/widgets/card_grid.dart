import 'package:flutter/material.dart';
import 'package:kanban_board/providers/home_provider.dart';
import 'package:kanban_board/widgets/collection_card.dart';
import 'package:provider/provider.dart';

class CardGrid extends StatelessWidget {
  const CardGrid({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        width: 700.0,
        child: GridView.builder(
          itemCount: context.watch<HomeProvider>().collectionNames.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisExtent: 210.0,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
          ),
          itemBuilder: (context, index) {
            final obj = context.read<HomeProvider>().collectionNames[index];
            return CollectionCard(collectionName: obj["cn"]);
          },
        ),
      ),
    );
  }
}
