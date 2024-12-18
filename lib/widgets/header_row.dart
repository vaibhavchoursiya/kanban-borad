import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kanban_board/app_theme.dart';
import 'package:kanban_board/providers/home_provider.dart';
import 'package:provider/provider.dart';

class HeaderRow extends StatefulWidget {
  const HeaderRow({
    super.key,
  });

  @override
  State<HeaderRow> createState() => _HeaderRowState();
}

class _HeaderRowState extends State<HeaderRow> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ElevatedButton.icon(
          onPressed: () async {
            await showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    backgroundColor: AppTheme.dark,
                    title: Text(
                      'Collection',
                      style: GoogleFonts.comicNeue(
                        color: AppTheme.light,
                      ),
                    ),
                    content: Form(
                      key: formkey,
                      child: TextFormField(
                        validator: (String? value) {
                          return context
                              .read<HomeProvider>()
                              .collectionNameValidator(value);
                        },
                        controller: context.read<HomeProvider>().collectionName,
                        style: TextStyle(color: AppTheme.light),
                      ),
                    ),
                    actions: [
                      MaterialButton(
                        textColor: Colors.black,
                        onPressed: () {
                          final homeProvider = context.read<HomeProvider>();
                          homeProvider.resetControllers();
                          context.pop();
                        },
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            color: Colors.redAccent,
                          ),
                        ),
                      ),
                      MaterialButton(
                        textColor: Colors.black,
                        onPressed: () async {
                          if (formkey.currentState!.validate()) {
                            final homeProvider = context.read<HomeProvider>();
                            await homeProvider.createCollectionFunc();
                            if (context.mounted) {
                              context.pop();
                            }
                          }
                        },
                        child: const Text(
                          'Create',
                          style: TextStyle(
                            color: Colors.green,
                          ),
                        ),
                      ),
                    ],
                  );
                });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primary,
            foregroundColor: AppTheme.light,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          icon: Icon(
            Icons.add,
            color: AppTheme.light,
          ),
          label: const Text(
            "Create a collection",
          ),
        ),
        const SizedBox(
          width: 20.0,
        ),
        // ElevatedButton.icon(
        //   onPressed: () {},
        //   style: ElevatedButton.styleFrom(
        //     backgroundColor: Colors.greenAccent,
        //     foregroundColor: AppTheme.light,
        //     shape: RoundedRectangleBorder(
        //       borderRadius: BorderRadius.circular(10.0),
        //     ),
        //   ),
        //   icon: Icon(
        //     Icons.watch,
        //     color: AppTheme.light,
        //   ),
        //   label: Text(
        //     DateTime.now().toString(),
        //   ),
        // ),
      ],
    );
  }
}
