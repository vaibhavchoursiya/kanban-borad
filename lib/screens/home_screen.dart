import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kanban_board/app_theme.dart';
import 'package:kanban_board/comman_widgets/menu_bar.dart';
import 'package:kanban_board/providers/home_provider.dart';
import 'package:kanban_board/widgets/card_grid.dart';
import 'package:kanban_board/widgets/header_row.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await initlizeFunc();
    });
  }

  Future initlizeFunc() async {
    final homeProvider = context.read<HomeProvider>();
    await homeProvider.getAllCollectionNamesFunc();
    homeProvider.updateInitialLoader(false);
  }

  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.of(context).size;
    final initialLoader = context
        .select<HomeProvider, bool>((provider) => provider.initialLoader);

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
                  (!initialLoader)
                      ? CardGrid()
                      : Expanded(
                          child: Center(
                            child: CircularProgressIndicator(
                              color: AppTheme.light,
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
