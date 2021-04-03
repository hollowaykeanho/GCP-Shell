/**
* Copyright 2020 Google Inc. All Rights Reserved.
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*    http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

"use strict";

const functions = require("firebase-functions");
const { WebhookClient } = require("dialogflow-fulfillment");
const { Card, Payload } = require("dialogflow-fulfillment");
const { BigQuery } = require("@google-cloud/bigquery");

const bigquery = new BigQuery({
    projectId: "your-project-id" // ** CHANGE THIS **
});

process.env.DEBUG = "dialogflow:debug";

function welcome(agent) {
    agent.add(`Welcome to my agent!`);
}

function fallback(agent) {
    agent.add(`I didn't understand`);
    agent.add(`I'm sorry, can you try again?`);
}


async function etaPredictionFunction(agent) {
    const issueCategory = agent.getContext('submitticket-email-followup').parameters.category;
    const sqlQuery = `WITH pred_table AS (SELECT 5 as seniority, "3-Advanced" as experience,
    @category as category, "Request" as type)
    SELECT cast(predicted_label as INT64) as predicted_label
    FROM ML.PREDICT(MODEL helpdesk.predict_eta,  TABLE pred_table)`;
    const options = {
        query: sqlQuery,
        location: "US",
        params: {
            category: issueCategory
        }
    };

    const [rows] = await bigquery.query(options);

    return rows;
}

async function ticketCollection(agent) {
    const email = agent.getContext('submitticket-email-followup').parameters.email;
    const issueCategory = agent.getContext('submitticket-email-followup').parameters.category;

    let etaPrediction = await etaPredictionFunction(agent);

    agent.setContext({
        name: "submitticket-collectname-followup",
        lifespan: 2
    });

    agent.add(`Your ticket has been created. Someone will contact you shortly at ${email}.
    The estimated response time is ${etaPrediction[0].predicted_label} days.`);

}

exports.dialogflowFirebaseFulfillment = functions.https.onRequest((request, response) => {
    const agent = new WebhookClient({ request, response });
    console.log('Dialogflow Request headers: ' + JSON.stringify(request.headers));
    console.log('Dialogflow Request body: ' + JSON.stringify(request.body));
    let intentMap = new Map();
    intentMap.set("Default Welcome Intent", welcome);
    intentMap.set("Default Fallback Intent", fallback);
    intentMap.set("Submit Ticket - Issue Category", ticketCollection);
    agent.handleRequest(intentMap);
});
