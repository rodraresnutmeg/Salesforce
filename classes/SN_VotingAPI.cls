/**********************************************************************
Purpose:

Knowledge Hub API for Mobile team.

Test class:
    Test_SN_VotingAPI
======================================================
History
-------
Date        AUTHOR                  DETAIL
12/13/2019  Kseniya Hanchuk         MASQ-636: Initial version.
***********************************************************************/

@RestResource(urlMapping='/v1.0/voting/*')
global with sharing class SN_VotingAPI {
        
    public enum StatusCode { SUCCESS, CANCELLED, ERROR }

    global static RestRequest req = RestContext.request;
    global static RestResponse res = RestContext.response;

    @HttpGet
    global static void getAll() {
        CResponse cRes = new CResponse();

        try {
            List<SN_Vote_Scoring__c> currentVotes = [
                SELECT Knowledge__c, Vote_Sum__c
                FROM SN_Vote_Scoring__c
                LIMIT 50000
            ];

            if (currentVotes.isEmpty()) {
                cRes.status = StatusCode.CANCELLED;
                cRes.message = 'Have no records';

                response(200, cRes);

                return;
            }

            Map<String, Integer> votesMap = new Map<String, Integer>();
            for (SN_Vote_Scoring__c voteItem : currentVotes) {
                votesMap.put(String.valueOf(voteItem.Knowledge__c), Integer.valueOf(voteItem.Vote_Sum__c));
            }

            cRes.status = StatusCode.SUCCESS;
            cRes.result = (Map<String, Object>) votesMap;

            response(200, cRes);

        } catch(Exception e) {
            cRes.status = StatusCode.ERROR;
            cRes.message = e.getMessage();

            response(400, cRes);

            return;

        }

    }

    @HttpPost
    global static void upsertVotes(Integer vote) {
        vote = vote > 0 ? 1 : -1;

        CResponse cRes = new CResponse();

        String articleId = getArticleId();

        try {
            List<SN_Vote_Scoring__c> currentVotes = [
                SELECT Knowledge__c, Vote_Sum__c
                FROM SN_Vote_Scoring__c
                WHERE Knowledge__c = :articleId
            ];

            if (currentVotes.isEmpty()) {
                SN_Vote_Scoring__c newVoteRec = new SN_Vote_Scoring__c();
                newVoteRec.Knowledge__c = articleId;
                newVoteRec.Vote_Sum__c = vote;

                insert newVoteRec;
            } else {
                currentVotes.get(0).Vote_Sum__c = currentVotes.get(0).Vote_Sum__c + vote;

                update currentVotes.get(0);                
            }

            cRes.status = StatusCode.SUCCESS;
            cRes.message = 'Votes updated';

            response(200, cRes);

        } catch(Exception e) {
            cRes.status = StatusCode.ERROR;
            cRes.message = e.getMessage();

            response(400, cRes);

            return;

        }

    }


    public static String getArticleId() {
        return req.requestURI.substring(req.requestURI.lastIndexOf('/') + 1);

    }

    public static void response(Integer statusCode, CResponse responseData) {
        res.statusCode = statusCode;
        res.responseBody = Blob.valueOf(JSON.serialize(responseData));

    }


    global class CResponse {
        StatusCode status;
        String message;
        Map<String, Object> result;

    }

}