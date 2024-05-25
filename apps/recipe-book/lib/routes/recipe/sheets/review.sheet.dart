import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:recipe_book/models/models.dart';
import 'package:recipe_book/providers/firebase/firebase.providers.dart';
import 'package:recipe_book/providers/recipes/recipes.providers.dart';

class ReviewRatingValidator extends Validator<dynamic> {
  @override
  Map<String, dynamic>? validate(AbstractControl<dynamic> control) {
    print(control);
    if (control.value < 0 || control.value > 5) {
      return {
        'invalidRating': true,
      };
    }
    return null;
  }
}

class RecipeReviewSheet extends ConsumerWidget {
  final String recipeId;

  const RecipeReviewSheet({
    Key? key,
    required this.recipeId,
  }) : super(key: key);

  FormGroup buildForm() {
    return FormGroup({
      'review': fb.control('', [
        Validators.required,
      ]),
      'stars': fb.control<int>(0, [
        Validators.required,
        ReviewRatingValidator(),
      ]),
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        height: 300,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  'Leave a Review',
                  textScaler: TextScaler.linear(1.5),
                ),
                Gap(20),
                ReactiveFormBuilder(
                  form: () => buildForm(),
                  builder: (context, formGroup, child) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ReactiveTextField(
                          formControlName: 'review',
                          decoration: InputDecoration(
                            filled: true,
                            hintText: 'Review',
                          ),
                        ),
                        Gap(15),
                        ReactiveTextField(
                          formControlName: 'stars',
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            filled: true,
                            hintText: 'Stars',
                          ),
                        ),
                        Gap(15),
                        FilledButton(
                          onPressed: formGroup.valid
                              ? () {
                                  ref.read(
                                    setRecipeReviewProvider(
                                      RecipeReview(
                                        review: Review(
                                          review: formGroup.control('review').value,
                                          stars: formGroup.control('stars').value,
                                          createdBy: ref.read(firebaseAuthProvider).currentUser!.uid,
                                        ),
                                        recipeId: recipeId,
                                      ),
                                    ),
                                  );
                                  ref.invalidate(getRecipeProvider);
                                  Navigator.of(context).pop();
                                }
                              : null,
                          child: Text('Submit'),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
