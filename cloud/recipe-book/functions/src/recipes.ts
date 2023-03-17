import * as functions from "firebase-functions";

export const setRecipeCreatedDate = functions.firestore
  .document("recipes/{recipeId}")
  .onCreate(
    (snapshot, context) => {
      return snapshot.ref.set({
        created: Date.now(),
      }, {merge: true});
    }
  );

