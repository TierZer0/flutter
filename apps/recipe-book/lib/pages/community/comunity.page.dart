import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:recipe_book/pages/community/parts/category.part.dart';
import 'package:recipe_book/pages/community/parts/popular.part.dart';
import 'package:recipe_book/providers/recipes/recipes.providers.dart';
import 'package:recipe_book/providers/resources/resources.providers.dart';
import 'package:ui/layout/responsive-widget.custom.dart';

class CommunityPage extends ConsumerStatefulWidget {
  @override
  CommunityPageState createState() => CommunityPageState();
}

class CommunityPageState extends ConsumerState<CommunityPage> {
  @override
  void initState() {
    super.initState();
  }

  RefreshController _refreshController = RefreshController(initialRefresh: false);
  void _onRefresh() async {
    setState(() {});

    refreshCategories();
    refreshRecipes();
    _refreshController.refreshCompleted();
  }

  void refreshCategories() => ref.refresh(getCategoriesProvider);
  void refreshRecipes() => ref.refresh(getRecipesProvider);

  void _onLoading() async {
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      mobileScreen: buildMobile(context),
    );
  }

  Widget buildMobile(BuildContext context) {
    return SmartRefresher(
      controller: _refreshController,
      onLoading: _onLoading,
      onRefresh: _onRefresh,
      header: WaterDropMaterialHeader(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        color: Theme.of(context).colorScheme.primary,
      ),
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(125.0),
            child: CategoryPart(),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: PopularPart(),
            ),
          ],
        ),
      ),
    );
  }
}
