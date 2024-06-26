import * as functions from "firebase-functions";
import {DateTime} from "luxon";


export const onRecipeCreateActions = functions.firestore
  .document("recipes/{recipeId}")
  .onCreate(
    (snapshot, context) => {
      const recipe = snapshot.data();
      const recipeIngredients = recipe.ingredients;

      const ingredients = recipeIngredients.map((ingredient: { item: any; }) => ingredient.item);

      const recipeData = {
        ingredientsList: ingredients,
        created: DateTime.now().toISODate(),
      };

      return snapshot.ref.set({
        ...recipeData,
      }, {merge: true});
    }
  );

export const onRecipeDeleteActions = functions.firestore
  .document("recipes/{recipeId}")
  .onDelete((snapshot, context) => {
    // handle cleanup
    // delete from users recipebooks
  });
