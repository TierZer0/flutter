import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:recipe_book/models/user.models.dart';
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

  FormGroup buildCategoryForm() => fb.group(
        <String, Object>{
          'name': FormControl<String>(validators: [Validators.required])
        },
      );

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    final appModel = Provider.of<AppModel>(context);

    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future: userService.getUser,
      builder: (_, snapshot) {
        if (snapshot.hasData) {
          var data = UserFB.fromJson(snapshot.data!.data()!);
          return Scaffold(
            appBar: AppBar(
              title: CustomText(
                text: data.name,
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
                const Center(
                  child: Text("Info"),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.width,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .5,
                          child: ListView(
                            children: data.categories
                                .map(
                                  (e) => ListTile(
                                    title: CustomText(
                                      text: e,
                                      fontSize: 25.0,
                                      fontFamily: "Lato",
                                      color: (theme.textTheme.titleLarge?.color)!,
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                        ReactiveFormBuilder(
                          form: buildCategoryForm,
                          builder: (context, formGroup, child) {
                            return Column(
                              children: [
                                const SizedBox(
                                  height: 25.0,
                                ),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: CustomText(
                                    text: "New Category",
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
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0,
                                  ),
                                  child: CustomReactiveInput(
                                    inputAction: TextInputAction.next,
                                    formName: 'name',
                                    label: 'Name',
                                    textColor: (theme.textTheme.titleLarge?.color)!,
                                  ),
                                ),
                                CustomButton(
                                  buttonColor: formGroup.valid ? primaryColor : Colors.grey,
                                  onTap: formGroup.valid
                                      ? () {
                                          userService.createCategory(
                                            formGroup.control('name').value,
                                          );
                                          formGroup.reset();
                                        }
                                      : null,
                                  label: "Create Category",
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
                const Center(
                  child: Text("Recipe Books"),
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
        return Container(
          padding: const EdgeInsets.only(
            top: 20.0,
          ),
          color: theme.scaffoldBackgroundColor,
          height: MediaQuery.of(context).size.height - 90.0,
          width: MediaQuery.of(context).size.width,
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );

    // return SafeArea(
    //   child: Material(
    //       child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
    //     future: userService.getUser,
    //     builder: (_, snapshot) {
    //       if (snapshot.hasData) {
    //         var data = snapshot.data!.data();
    //         return Container(
    //           padding: const EdgeInsets.only(
    //             top: 20.0,
    //           ),
    //           color: theme.scaffoldBackgroundColor,
    //           height: MediaQuery.of(context).size.height - 90.0,
    //           width: MediaQuery.of(context).size.width,
    //           child: Column(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             mainAxisAlignment: MainAxisAlignment.start,
    //             children: [
    //               CustomText(
    //                 text: data!['name'],
    //                 fontSize: 35.0,
    //                 padding: const EdgeInsets.only(left: 30.0),
    //                 fontFamily: "Lato",
    //                 color: (theme.textTheme.titleLarge?.color)!,
    //               ),
    //               Row(
    //                 children: [
    // CustomText(
    //   text: "Dark Theme",
    //   fontSize: 20.0,
    //   padding: const EdgeInsets.only(left: 30.0),
    //   fontFamily: "Lato",
    //   color: (theme.textTheme.titleLarge?.color)!,
    // ),
    // Switch(
    //   value: appModel.theme,
    //   onChanged: (value) {
    //     userService.setUserTheme(value);
    //     setState(() {
    //       appModel.theme = value;
    //     });
    //   },
    // ),
    //                 ],
    //               ),
    //               CustomButton(
    //                 externalPadding: const EdgeInsets.only(right: 50.0, left: 30.0),
    //                 internalPadding: const EdgeInsets.symmetric(
    //                   vertical: 10.0,
    //                   horizontal: 20.0,
    //                 ),
    //                 label: 'Logout',
    //                 buttonColor: primaryColor,
    //                 onTap: () {
    // appModel.uid = '';
    // appModel.theme = false;
    // appModel.view = 'Home';
    //                   ScaffoldMessenger.of(context).showSnackBar(
    //                     const SnackBar(
    //                       content: Text('Successfully Logged out'),
    //                     ),
    //                   );
    //                 },
    //                 textStyle: const TextStyle(
    //                   fontSize: 20.0,
    //                   color: lightThemeTextColor,
    //                 ),
    //               )
    //             ],
    //           ),
    //         );
    //       }
    // return Container(
    //   padding: const EdgeInsets.only(
    //     top: 20.0,
    //   ),
    //   color: theme.scaffoldBackgroundColor,
    //   height: MediaQuery.of(context).size.height - 90.0,
    //   width: MediaQuery.of(context).size.width,
    //   child: const Center(
    //     child: CircularProgressIndicator(),
    //   ),
    // );
    //     },
    //   )),
    // );
  }
}
