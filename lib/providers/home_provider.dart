import 'package:flutter/material.dart';
import 'package:kanban_board/services/db_service.dart';

class HomeProvider extends ChangeNotifier {
  bool initialLoader = true;

  updateInitialLoader(value) {
    initialLoader = value;
    notifyListeners();
  }

  final TextEditingController collectionName = TextEditingController();
  final TextEditingController renameCollectionController =
      TextEditingController();

  resetRenameController() {
    renameCollectionController.clear();
  }

  resetControllers() {
    collectionName.clear();
  }

  List collectionNames = [];

  String? collectionNameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "please enter valid input";
    }

    return null;
  }

  Future<void> createCollectionFunc() async {
    await DbService.addCollectionName(collectionName.text.trim());
    resetControllers();
    await getAllCollectionNamesFunc();
  }

  Future<void> deleteCollectionFunc(String collectionName) async {
    await DbService.deleteCollection(collectionName);
    await getAllCollectionNamesFunc();
  }

  Future<void> getAllCollectionNamesFunc() async {
    collectionNames = await DbService.getAllCollectionNames();
    notifyListeners();
  }

  Future updateCollectionName(String oldCollectionName) async {
    await DbService.updateCollectionName(
        oldCollectionName, renameCollectionController.text.trim());
    renameCollectionController.clear();

    await getAllCollectionNamesFunc();
  }

  resetProvider() {
    initialLoader = true;
    resetControllers();
  }

  @override
  void dispose() {
    collectionName.dispose();
    super.dispose();
  }
}
