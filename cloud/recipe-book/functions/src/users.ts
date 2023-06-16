// import * as functions from "firebase-functions";
// import * as firebase from "firebase-admin";

// export const onUserCreateActions = functions.firestore
//   .document("users/{userId}")
//   .onCreate(
//     (snapshot, context) => {
//       // build user data
//     }
//   );

// export const onUserDeleteActions = functions.firestore
//   .document("recipes/{recipeId}")
//   .onDelete(
//     (snapshot, context) => {
//       // handle cleanup
//     }
//   );

// export const onUserLikeRecipe = functions.firestore
//   .document("users/{userId}")
//   .onUpdate(
//     (snapshot, context) => {
//       const recipe = firebase.firestore().collection("recipes").doc("recipeId");
//       console.log(recipe);
//       // Get Recipe Document
//       // increment/decrement likes
//     }
//   );
