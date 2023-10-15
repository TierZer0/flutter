import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:recipe_book/app_model.dart';
import 'package:recipe_book/pages/favorites/favorites.page.dart';
import 'package:recipe_book/pages/home.page.dart';
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

class MainViewState extends State<MainView> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

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

  buildSearchSheet(BuildContext context) {
    FormControl searchControl = FormControl<String>(value: context.read<AppModel>().search);
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

  Widget buildMobile(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomInset: true,
      drawer: NavigationDrawer(
        onDestinationSelected: (value) {
          setState(() {
            currentPageIndex = value;
          });
          Navigator.pop(context);
        },
        selectedIndex: currentPageIndex,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(20, 16, 16, 10),
            child: CText(
              'Pages',
              textLevel: EText.title,
            ),
          ),
          Divider(),
          NavigationDrawerDestination(
            icon: Icon(
              Icons.groups_2_outlined,
              size: 35.0,
              color: theme.colorScheme.onSurface,
            ),
            label: CText('Community', textLevel: EText.title),
          ),
          NavigationDrawerDestination(
            icon: Icon(
              Icons.book_outlined,
              size: 35.0,
              color: theme.colorScheme.onSurface,
            ),
            label: CText('My Recipes', textLevel: EText.title),
          ),
          NavigationDrawerDestination(
            icon: Icon(
              Icons.favorite_outline,
              size: 35.0,
              color: theme.colorScheme.onSurface,
            ),
            label: CText('Favorites', textLevel: EText.title),
          ),
          NavigationDrawerDestination(
            icon: Icon(
              Icons.person_outline_outlined,
              size: 35.0,
              color: theme.colorScheme.onSurface,
            ),
            label: CText('Profile', textLevel: EText.title),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.only(
            top: 5.0,
          ),
          child: Wrap(
            spacing: 10.0,
            children: [
              IconButton(
                onPressed: () => {
                  scaffoldKey.currentState!.openDrawer(),
                },
                icon: Icon(
                  Icons.menu_rounded,
                  size: 35.0,
                ),
              ),
              IconButton(
                onPressed: () => buildSearchSheet(context),
                icon: Icon(
                  Icons.search,
                  size: 30.0,
                ),
              ),
            ],
          ),
        ),
      ),
      body: views[currentPageIndex],
      floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/newRecipe'),
        child: const Icon(
          Icons.add_outlined,
          size: 30.0,
        ),
      ),
    );
  }
}
