import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:recipe_book/pages/search/shared/expansion-list.shared.dart';
import 'package:recipe_book/providers/firebase/firebase.providers.dart';
import 'package:recipe_book/providers/recipe-books/recipe-books.providers.dart';

class MyRecipeBooksPart extends ConsumerStatefulWidget {
  @override
  MyRecipeBooksPartState createState() => MyRecipeBooksPartState();
}

class MyRecipeBooksPartState extends ConsumerState<MyRecipeBooksPart> {
  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  void refreshMyRecipeBooks() => ref.refresh(getRecipeBooksByUserIdProvider(ref.read(firebaseAuthProvider).currentUser!.uid));

  void _onRefresh() async {
    refreshMyRecipeBooks();
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    final getMyRecipeBooks = ref.watch(getRecipeBooksByUserIdProvider(ref.read(firebaseAuthProvider).currentUser!.uid));

    return SmartRefresher(
      controller: _refreshController,
      onLoading: _onLoading,
      onRefresh: _onRefresh,
      header: WaterDropMaterialHeader(
        backgroundColor: Theme.of(context).colorScheme.primary,
        color: Theme.of(context).colorScheme.onPrimary,
      ),
      child: getMyRecipeBooks.when(
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
        loading: () => Center(
          child: CircularProgressIndicator(),
        ),
        data: (data) {
          if (data.payload.isEmpty) {
            return Center(
              child: Text('No recipe books found'),
            );
          }
          return ListView.builder(
            itemCount: data.payload.length,
            itemBuilder: (context, index) {
              final _recipeBooks = data.payload!;
              final books = _recipeBooks.map((e) {
                return {
                  ...e.toFirestore(),
                  'expanded': false,
                };
              }).toList();

              return SearchExpansionList(
                recipeBooks: books,
              );
            },
          );
        },
      ),
    );
  }
}
