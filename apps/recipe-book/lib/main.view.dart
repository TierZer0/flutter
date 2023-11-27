import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:recipe_book/app_model.dart';
import 'package:recipe_book/main.dart';
import 'package:recipe_book/pages/favorites/favorites.page.dart';
import 'package:recipe_book/pages/community/community.page.dart';
import 'package:recipe_book/pages/profile/profile.page.dart';
import 'package:go_router/go_router.dart';
import 'package:recipe_book/pages/recipes/my-recipes.page.dart';
import 'package:ui/general/card.custom.dart';
import 'package:ui/general/text.custom.dart';
import 'package:ui/inputs/reactive-input.custom.dart';
import 'package:ui/layout/responsive-widget.custom.dart';

class MainView extends StatefulWidget {
  @override
  MainViewState createState() => MainViewState();
}

class MainViewState extends State<MainView> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  var views = [
    HomePage(),
    RecipesView(),
    FavoritesPage(),
    ProfileView(),
  ];

  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      desktopScreen: buildDesktop(context),
      mobileScreen: buildMobile(context),
    );
  }

  double bottomSheetHeight = 200;

  buildSearchSheet(BuildContext context) {
    FormControl searchControl =
        FormControl<String>(value: context.read<AppModel>().search);
    final theme = Theme.of(context);

    return showModalBottomSheet(
      showDragHandle: true,
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: ReactiveForm(
            formGroup: FormGroup({
              'search': searchControl,
            }),
            child: Container(
              height: 250,
              padding: EdgeInsets.all(20.0),
              child: Wrap(
                runSpacing: 20,
                children: [
                  CText(
                    'Search Recipes',
                    textLevel: EText.title,
                  ),
                  CustomReactiveInput(
                    inputAction: TextInputAction.done,
                    formName: 'search',
                    label: 'Search',
                    textColor: theme.colorScheme.onSurface,
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: FilledButton(
                      onPressed: () {
                        context.read<AppModel>().search = searchControl.value;
                        context.pop();
                      },
                      child: CText('Search'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildDesktop(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        notificationPredicate: (notification) {
          return notification.depth != 0;
        },
        title: CText(
          'Recipe Book',
          textLevel: EText.title2,
        ),
      ),
      body: Row(
        children: [
          NavigationRail(
            labelType: NavigationRailLabelType.none,
            onDestinationSelected: (int index) {
              setState(() {
                currentPageIndex = index;
              });
            },
            trailing: Expanded(
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 20.0,
                    ),
                    child: FloatingActionButton.extended(
                      onPressed: () => context.push('/newRecipe'),
                      icon: const Icon(
                        Icons.add_outlined,
                        size: 30.0,
                      ),
                      label: CText(
                        'New Recipe',
                        textLevel: EText.button,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            groupAlignment: -1.0,
            extended: true,
            selectedLabelTextStyle: TextStyle(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
            destinations: <NavigationRailDestination>[
              NavigationRailDestination(
                icon: Icon(
                  Icons.groups_2_outlined,
                  size: 35.0,
                  color: theme.colorScheme.onSurface,
                ),
                selectedIcon: Icon(
                  Icons.groups_2,
                  size: 35.0,
                  color: theme.colorScheme.onSurface,
                ),
                label: CText(
                  'Community',
                  textLevel: EText.title,
                ),
              ),
              NavigationRailDestination(
                icon: Icon(
                  Icons.book_outlined,
                  size: 35.0,
                  color: theme.colorScheme.onSurface,
                ),
                selectedIcon: Icon(
                  Icons.book,
                  size: 35.0,
                  color: theme.colorScheme.onSurface,
                ),
                label: CText(
                  'My Recipes',
                  textLevel: EText.title,
                ),
              ),
              NavigationRailDestination(
                icon: Icon(
                  Icons.favorite_outline,
                  size: 35.0,
                  color: theme.colorScheme.onSurface,
                ),
                selectedIcon: Icon(
                  Icons.favorite,
                  size: 35.0,
                  color: theme.colorScheme.onSurface,
                ),
                label: CText(
                  'Favorites',
                  textLevel: EText.title,
                ),
              ),
              NavigationRailDestination(
                icon: Icon(
                  Icons.person_outline_outlined,
                  size: 35.0,
                  color: theme.colorScheme.onSurface,
                ),
                selectedIcon: Icon(
                  Icons.person,
                  size: 35.0,
                  color: theme.colorScheme.onSurface,
                ),
                label: CText(
                  'Profile',
                  textLevel: EText.title,
                ),
              ),
            ],
            selectedIndex: currentPageIndex,
          ),
          Expanded(
            child: views[currentPageIndex],
          )
        ],
      ),
    );
  }

  _handleNav(int index) {
    setState(() {
      currentPageIndex = index;
    });
    context.pop();
  }

  Widget buildMobile(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomInset: true,
      drawer: SizedBox(
        width: 250,
        child: CustomCard(
          card: ECard.elevated,
          color: theme.colorScheme.surfaceVariant,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ListTile(
                style: ListTileStyle.drawer,
                leading: Icon(
                  Icons.groups_2_outlined,
                  size: 35.0,
                  color: theme.colorScheme.onSurface,
                ),
                title: CText('Community', textLevel: EText.title),
                onTap: () => _handleNav(0),
              ),
              ListTile(
                style: ListTileStyle.drawer,
                leading: Icon(
                  Icons.book_outlined,
                  size: 35.0,
                  color: theme.colorScheme.onSurface,
                ),
                title: CText('My Recipes', textLevel: EText.title),
                onTap: () => _handleNav(1),
              ),
              ListTile(
                style: ListTileStyle.drawer,
                leading: Icon(
                  Icons.favorite_outline,
                  size: 35.0,
                  color: theme.colorScheme.onSurface,
                ),
                title: CText('Favorites', textLevel: EText.title),
                onTap: () => _handleNav(2),
              ),
              ListTile(
                style: ListTileStyle.drawer,
                leading: Icon(
                  Icons.person_outline_outlined,
                  size: 35.0,
                  color: theme.colorScheme.onSurface,
                ),
                title: CText('Profile', textLevel: EText.title),
                onTap: () => _handleNav(3),
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          views[currentPageIndex],
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              height: 500,
              width: double.maxFinite,
              child: DraggableScrollableSheet(
                initialChildSize: 0.15,
                minChildSize: 0.15,
                maxChildSize: 0.8,
                builder:
                    (BuildContext context, ScrollController scrollController) {
                  return Container(
                    decoration: BoxDecoration(
                      color: seed,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: theme.colorScheme.shadow.withOpacity(0.3),
                          spreadRadius: 1,
                          blurRadius: 20,
                        ),
                      ],
                    ),
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton.filledTonal(
                                  onPressed: () =>
                                      scaffoldKey.currentState!.openDrawer(),
                                  icon: Icon(
                                    Icons.menu,
                                    size: 35,
                                  ),
                                ),
                                CText(
                                  'Recipe Book',
                                  textLevel: EText.custom,
                                  textStyle: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: theme.colorScheme.onPrimary,
                                  ),
                                ),
                                IconButton.filledTonal(
                                  onPressed: () => context.push('/newRecipe'),
                                  icon: Icon(
                                    Icons.add,
                                    size: 40,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Material(
                            color: Colors.transparent,
                            child: ListTile(
                              title: CText(
                                'Create Recipe Book',
                                textLevel: EText.custom,
                                textStyle: TextStyle(
                                  fontSize: 22,
                                  color: theme.colorScheme.onPrimary,
                                ),
                              ),
                              onTap: () => {},
                            ),
                          ),
                          Material(
                            color: Colors.transparent,
                            child: ListTile(
                              title: CText(
                                'Create Recipe Ingredient',
                                textLevel: EText.custom,
                                textStyle: TextStyle(
                                  fontSize: 22,
                                  color: theme.colorScheme.onPrimary,
                                ),
                              ),
                              onTap: () => {},
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          )
        ],
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () => context.push('/newRecipe'),
      //   child: const Icon(
      //     Icons.add_outlined,
      //     size: 30.0,
      //   ),
      // ),
      // bottomSheet:
    );
  }
}
