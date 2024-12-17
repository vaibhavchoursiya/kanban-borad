import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kanban_board/app_theme.dart';
import 'package:kanban_board/providers/home_provider.dart';
import 'package:provider/provider.dart';

class CollectionCard extends StatelessWidget {
  final String collectionName;

  const CollectionCard({super.key, required this.collectionName});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.go("/task_panel", extra: {"collectionName": collectionName});
      },
      child: Card(
        elevation: 4.0,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        color: AppTheme.light.withOpacity(0.5),
        shadowColor: AppTheme.primary,
        child: Padding(
          padding: const EdgeInsets.all(1.5),
          child: Column(
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(230, 18, 20, 15),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0),
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.task,
                      color: AppTheme.light,
                      size: 40.0,
                    ),
                  ),
                ),
              ),
              Expanded(
                  child: Container(
                decoration: const BoxDecoration(
                  color: Color.fromARGB(230, 3, 3, 3),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10.0),
                    bottomRight: Radius.circular(10.0),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const SizedBox(
                          width: 10.0,
                        ),
                        Expanded(
                          child: Text(
                            collectionName,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: GoogleFonts.comicNeue(
                              color: AppTheme.light,
                            ),
                          ),
                        ),
                        PopupMenuButton(
                            iconColor: AppTheme.light,
                            onSelected: (String value) async {
                              final homeProvider = context.read<HomeProvider>();
                              if (value == "d") {
                                homeProvider
                                    .deleteCollectionFunc(collectionName);
                              }
                            },
                            itemBuilder: (context) => [
                                  const PopupMenuItem(
                                    value: "d",
                                    child: Text("delete"),
                                  ),
                                ])
                      ],
                    )
                  ],
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
