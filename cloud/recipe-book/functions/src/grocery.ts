import {onCall, HttpsError} from "firebase-functions/v2/https";
import {logger} from "firebase-functions/v2";
import axios, {AxiosError} from "axios";


export const searchGroceryAutoComplete = onCall(async (request) => {
  if (!request.auth) {
    throw new HttpsError("unauthenticated", "You must be authenticated to use this endpoint");
  }

  const {query} = request.data;
  logger.info("query", query);
  logger.info("process.env.EDAMAM_APP_ID", process.env.EDAMAM_APP_ID);
  logger.info("process.env.EDAMAM_APP_KEY", process.env.EDAMAM_APP_KEY);

  if (!query) {
    throw new HttpsError("invalid-argument", "You must provide a query");
  }
  return axios.get(`
    https://api.edamam.com/auto-complete?q=${query}&app_id=${process.env.EDAMAM_APP_ID}&app_key=${process.env.EDAMAM_APP_KEY}
  `).then((response) => {
    logger.info("response", response.data);
    return response.data as String[];
  }).catch((error: AxiosError) => {
    logger.error("error", error);
    throw new HttpsError("internal", error.toString());
  });
});
