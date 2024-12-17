import 'package:flutter/material.dart';
import 'package:kanban_board/services/db_service.dart';

class HomeProvider extends ChangeNotifier {
  bool initialLoader = true;

  updateInitialLoader(value) {
    initialLoader = value;
    notifyListeners();
  }

  final TextEditingController collectionName = TextEditingController();
  List collectionNames = [];

  String? collectionNameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "please enter valid input";
    }

    return null;
  }

  Future<void> createCollectionFunc() async {
    await DbService.addCollectionName(collectionName.text.trim());
    await getAllCollectionNamesFunc();
    collectionName.clear();
    notifyListeners();
  }

  Future<void> deleteCollectionFunc(String collectionName) async {
    await DbService.deleteCollection(collectionName);
    await getAllCollectionNamesFunc();
    notifyListeners();
  }

  Future<void> getAllCollectionNamesFunc() async {
    collectionNames = await DbService.getAllCollectionNames();
  }

  @override
  void dispose() {
    collectionName.dispose();
    super.dispose();
  }
}
