import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kanban_board/app_theme.dart';
import 'package:kanban_board/providers/home_provider.dart';
import 'package:kanban_board/utility/validator_model.dart';
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
                            color: AppTheme.dark,
                            iconColor: AppTheme.light,
                            onSelected: (String value) async {
                              final homeProvider = context.read<HomeProvider>();
                              if (value == "d") {
                                homeProvider
                                    .deleteCollectionFunc(collectionName);
                              } else if (value == "r") {
                                await renameDialogBox(context, collectionName);
                              }
                            },
                            itemBuilder: (context) => [
                                  PopupMenuItem(
                                    value: "d",
                                    child: Text(
                                      "delete",
                                      style: GoogleFonts.comicNeue(
                                          color: AppTheme.light),
                                    ),
                                  ),
                                  PopupMenuItem(
                                    value: "r",
                                    child: Text(
                                      "rename",
                                      style: GoogleFonts.comicNeue(
                                          color: AppTheme.light),
                                    ),
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

  Future renameDialogBox(BuildContext context, String oldCollectionName) {
    final GlobalKey<FormState> renameFormKey = GlobalKey<FormState>();

    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          actions: [
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: AppTheme.light,
              ),
              onPressed: () {
                final homeProvider = context.read<HomeProvider>();
                homeProvider.renameCollectionController.clear();

                context.pop();
              },
              label: Text(
                "cancel",
                style: GoogleFonts.comicNeue(fontWeight: FontWeight.bold),
              ),
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: AppTheme.light,
              ),
              onPressed: () async {
                if (renameFormKey.currentState!.validate()) {
                  final homeProvider = context.read<HomeProvider>();

                  await homeProvider.updateCollectionName(oldCollectionName);
                  if (context.mounted) {
                    context.pop();
                  }
                }
              },
              label: Text(
                "rename",
                style: GoogleFonts.comicNeue(fontWeight: FontWeight.bold),
              ),
            )
          ],
          backgroundColor: AppTheme.dark,
          title: Text(
            "Rename collection",
            style: GoogleFonts.comicNeue(
              color: AppTheme.light,
            ),
          ),
          content: Form(
            key: renameFormKey,
            child: TextFormField(
              controller:
                  context.read<HomeProvider>().renameCollectionController,
              validator: (value) {
                return ValidatorModel.notEmptyValidator(value);
              },
              style: GoogleFonts.comicNeue(color: AppTheme.light),
            ),
          ),
        );
      },
    );
  }
}
