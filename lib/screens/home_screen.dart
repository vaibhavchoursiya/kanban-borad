import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kanban_board/app_theme.dart';
import 'package:kanban_board/comman_widgets/menu_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppTheme.dark,
      body: Row(
        children: [
          Container(
            width: 80.0,
            color: Colors.white,
            child: const MenuSetting(),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 20,
                top: 20.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // HEADING----------------------------
                  Text(
                    "Welcome to Kanban Board",
                    style: GoogleFonts.aDLaMDisplay(
                      fontSize: 34.0,
                      color: AppTheme.light,
                      shadows: [
                        Shadow(
                            blurRadius: 2.0,
                            color: AppTheme.light,
                            offset: const Offset(2, 1)),
                      ],
                    ),
                  ),
                  Text(
                    "All your collections will show here!",
                    style: GoogleFonts.aDLaMDisplay(
                      color: AppTheme.light.withOpacity(0.6),
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  const HeaderRow(),
                  const SizedBox(
                    height: 20.0,
                  ),

                  // GRID--------------------------------
                  Expanded(
                    child: SizedBox(
                      width: 700.0,
                      child: GridView.builder(
                        itemCount: 10,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisExtent: 210.0,
                          crossAxisSpacing: 10.0,
                          mainAxisSpacing: 10.0,
                        ),
                        itemBuilder: (context, index) {
                          return const CollectionCard(
                              collectionName: "Kandam board app");
                        },
                      ),
                    ),
                  ),

                  // const CollectionCard(
                  //   collectionName: "Kandam board app",
                  // )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HeaderRow extends StatelessWidget {
  const HeaderRow({
    super.key,
  });

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
                      style: GoogleFonts.aDLaMDisplay(
                        color: AppTheme.light,
                      ),
                    ),
                    content: TextField(
                      style: TextStyle(color: AppTheme.light),
                    ),
                    actions: [
                      MaterialButton(
                        textColor: Colors.black,
                        onPressed: () {
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
                        onPressed: () {},
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
        ElevatedButton.icon(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.greenAccent,
            foregroundColor: AppTheme.light,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          icon: Icon(
            Icons.watch,
            color: AppTheme.light,
          ),
          label: Text(
            DateTime.now().toString(),
          ),
        ),
      ],
    );
  }
}

class CollectionCard extends StatelessWidget {
  final String collectionName;

  const CollectionCard({super.key, required this.collectionName});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      // shadowColor: AppTheme.light,
      elevation: 10.0,
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
                        style: GoogleFonts.aDLaMDisplay(
                          color: AppTheme.light,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.more_horiz_outlined,
                        color: AppTheme.light,
                      ),
                    ),
                  ],
                )
              ],
            ),
          )),
        ],
      ),
    );
  }
}
