import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:recipe_book/models/recipe.models.dart';
import 'package:recipe_book/models/user.models.dart';
import 'package:recipe_book/pages/profile/tabs/categories.tab.dart';
import 'package:recipe_book/pages/profile/tabs/info.tab.dart';
import 'package:recipe_book/services/auth.service.dart';
import 'package:recipe_book/services/user.service.dart';
import 'package:recipe_book/styles.dart';
import 'package:ui/ui.dart';

import 'package:recipe_book/app_model.dart';

class ProfilePage extends StatefulWidget {
  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  FormGroup buildRecipeBookForm() => fb.group(
        <String, Object>{
          'name': FormControl<String>(validators: [Validators.required]),
          'category': FormControl<String>()
        },
      );

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    final appModel = Provider.of<AppModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          text: authService.user.displayName,
          fontSize: 35.0,
          fontFamily: "Lato",
          color: (theme.textTheme.titleLarge?.color)!,
        ),
        elevation: 0,
        bottom: TabBar(
          indicatorColor: primaryColor,
          controller: _tabController,
          tabs: const [
            Tab(
              text: 'Info',
              icon: Icon(Icons.info_outline),
            ),
            Tab(
              text: 'Categories',
              icon: Icon(Icons.category_outlined),
            ),
            Tab(
              text: 'Recipe Books',
              icon: Icon(Icons.book_outlined),
            ),
            Tab(
              text: 'Settings',
              icon: Icon(Icons.settings_outlined),
            )
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          InfoTab(),
          CategoriesTab(),
          SizedBox(
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .42,
                    child: StreamBuilder(
                      stream: userService.userBooksStream.cast(),
                      builder: (_, snapshot) {
                        if (snapshot.hasData) {
                          var items = snapshot.data!.docs;
                          List<RecipeBook> books = [];
                          for (var e in items) {
                            books.add(
                              RecipeBook(
                                e.id,
                                e['name'],
                                e['category'],
                                e['recipes'],
                                authService.user.uid,
                                e['likes'],
                              ),
                            );
                          }
                          return ListView(
                            children: books.map((e) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
                                child: ListTile(
                                  tileColor: theme.backgroundColor,
                                  title: CustomText(
                                    text: e.name,
                                    fontSize: 30.0,
                                    fontFamily: "Lato",
                                    color: (theme.textTheme.titleLarge?.color)!,
                                  ),
                                  subtitle: CustomText(
                                    text: e.category,
                                    fontSize: 15.0,
                                    fontFamily: "Lato",
                                    color: (theme.textTheme.titleLarge?.color)!,
                                  ),
                                  trailing: SizedBox(
                                    width: 50.0,
                                    child: Row(
                                      children: [
                                        CustomText(
                                          text: e.likes.toString(),
                                          fontSize: 18.0,
                                          fontFamily: "Lato",
                                          color: (theme.textTheme.titleLarge?.color)!,
                                          padding: const EdgeInsets.only(
                                            right: 10.0,
                                          ),
                                        ),
                                        const Icon(
                                          Icons.favorite,
                                          size: 25.0,
                                          color: tertiaryColor,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                        }
                        return const SizedBox(
                          height: 0,
                        );
                      },
                    ),
                  ),
                  ReactiveFormBuilder(
                    form: buildRecipeBookForm,
                    builder: (context, formGroup, child) {
                      return Column(
                        children: [
                          const SizedBox(
                            height: 25.0,
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: CustomText(
                              text: "New Recipe Book",
                              fontSize: 25.0,
                              fontFamily: "Lato",
                              color: (theme.textTheme.titleLarge?.color)!,
                              padding: const EdgeInsets.only(
                                left: 20.0,
                                bottom: 20.0,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                            child: CustomReactiveInput(
                              inputAction: TextInputAction.next,
                              formName: 'name',
                              label: 'Name',
                              textColor: (theme.textTheme.titleLarge?.color)!,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                            child: CustomReactiveInput(
                              inputAction: TextInputAction.next,
                              formName: 'category',
                              label: 'Category',
                              textColor: (theme.textTheme.titleLarge?.color)!,
                            ),
                          ),
                          CustomButton(
                            buttonColor: formGroup.valid ? primaryColor : Colors.grey,
                            onTap: formGroup.valid
                                ? () {
                                    userService.createRecipeBook(
                                      RecipeBook(
                                          '',
                                          formGroup.control('name').value,
                                          formGroup.control('category').value,
                                          [],
                                          authService.user.uid,
                                          0),
                                    );
                                    formGroup.reset();
                                  }
                                : null,
                            label: "Create Recipe Book",
                            internalPadding: const EdgeInsets.symmetric(
                              horizontal: 20.0,
                              vertical: 15.0,
                            ),
                            externalPadding: const EdgeInsets.symmetric(
                              vertical: 20.0,
                              horizontal: 60.0,
                            ),
                            textStyle: GoogleFonts.lato(
                              color: darkThemeTextColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 20.0,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          Column(
            children: [
              Row(
                children: [
                  CustomText(
                    text: "Dark Theme",
                    fontSize: 20.0,
                    padding: const EdgeInsets.only(left: 30.0),
                    fontFamily: "Lato",
                    color: (theme.textTheme.titleLarge?.color)!,
                  ),
                  Switch(
                    value: appModel.theme,
                    onChanged: (value) {
                      userService.setUserTheme(value);
                      setState(() {
                        appModel.theme = value;
                      });
                    },
                  ),
                ],
              ),
              CustomButton(
                externalPadding: const EdgeInsets.only(right: 50.0, left: 30.0),
                internalPadding: const EdgeInsets.symmetric(
                  vertical: 10.0,
                  horizontal: 20.0,
                ),
                label: 'Logout',
                buttonColor: primaryColor,
                onTap: () {
                  authService.logout().then((value) {
                    appModel.uid = '';
                    appModel.theme = false;
                    appModel.view = 'Home';
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Successfully Logged out'),
                      ),
                    );
                  });
                },
                textStyle: const TextStyle(
                  fontSize: 20.0,
                  color: lightThemeTextColor,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
