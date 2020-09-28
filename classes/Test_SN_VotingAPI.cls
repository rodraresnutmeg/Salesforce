/**********************************************************************
Purpose:

Test class for SN_VotingAPI
======================================================
History
-------
Date        AUTHOR                  DETAIL
12/17/2019  Kseniya Hanchuk         MASQ-636: Initial version.
***********************************************************************/

@isTest
public with sharing class Test_SN_VotingAPI {

    public static Id articleIdForUpdate;

    private static List<Id> getPublishedArticleIds() {
        List<Knowledge__kav> newArticles = new List<Knowledge__kav> {
            new Knowledge__kav(
                Title = 'First Article',
                Description_Rich_Text__c = '<b>First</b> rich text',
                UrlName = 'First-Article'
            ),
            new Knowledge__kav(
                Title = 'Second Article',
                Description_Rich_Text__c = '<b>Second</b> rich text',
                UrlName = 'Second-Article'
            )
        };

        insert newArticles;

        List<Knowledge__kav> articleItems = [SELECT KnowledgeArticleId FROM Knowledge__kav WHERE Id = :newArticles];
        KbManagement.PublishingService.publishArticle(articleItems.get(0).KnowledgeArticleId, true);
        KbManagement.PublishingService.publishArticle(articleItems.get(1).KnowledgeArticleId, true);

        List<Id> result = new List<Id>();
        for (Knowledge__kav item : articleItems) {
            result.add(item.Id);
        }

        return result;

    }

    static void setup() {
        List<Id> articleIds = getPublishedArticleIds();
        articleIdForUpdate = articleIds.get(0);

        List<SN_Vote_Scoring__c> voting = new List<SN_Vote_Scoring__c>{
            new SN_Vote_Scoring__c(
                Knowledge__c = articleIds.get(0),
                Vote_Sum__c = 1
            ),
            new SN_Vote_Scoring__c(
                Knowledge__c = articleIds.get(1),
                Vote_Sum__c = 10
            )
        };

        insert voting;

    }


    @isTest
    static void getAll_empty_test() {
        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/v1.0/voting/getAll';
        req.httpMethod = 'GET';
        RestContext.request = req;

        RestResponse res = new RestResponse();
        RestContext.response = res;

        Test.startTest();
        SN_VotingAPI.getAll();

        System.assertEquals(200, SN_VotingAPI.res.statusCode);

        Map<String, Object> bodyMap = (Map<String, Object>) JSON.deserializeUntyped(SN_VotingAPI.res.responseBody.toString());
        System.assertEquals('CANCELLED', bodyMap.get('status'));
        System.assertEquals('Have no records', bodyMap.get('message'));
        Test.stopTest();

    }

    @isTest
    static void getAll_notEmpty_test() {
        setup();

        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/v1.0/voting/getAll';
        req.httpMethod = 'GET';
        RestContext.request = req;

        RestResponse res = new RestResponse();
        RestContext.response = res;

        Test.startTest();
        SN_VotingAPI.getAll();

        System.assertEquals(200, SN_VotingAPI.res.statusCode);

        Map<String, Object> bodyMap = (Map<String, Object>) JSON.deserializeUntyped(SN_VotingAPI.res.responseBody.toString());
        System.assertEquals('SUCCESS', bodyMap.get('status'));
        System.assertEquals(null, bodyMap.get('message'));
        Test.stopTest();

    }

    @isTest
    static void upsertVotes_empty_test() {
        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/v1.0/voting/upsertVotes/' + articleIdForUpdate;
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof('{"vote":1}');
        RestContext.request = req;

        RestResponse res = new RestResponse();
        RestContext.response = res;

        Test.startTest();
        SN_VotingAPI.upsertVotes(1);

        System.assertEquals(400, SN_VotingAPI.res.statusCode);

        Map<String, Object> bodyMap = (Map<String, Object>) JSON.deserializeUntyped(SN_VotingAPI.res.responseBody.toString());
        System.assertEquals('ERROR', bodyMap.get('status'));
        Test.stopTest();

    }

    @isTest
    static void upsertVotes_notEmpty_test() {
        setup();

        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/v1.0/voting/upsertVotes/' + articleIdForUpdate;
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueof('{"vote":1}');
        RestContext.request = req;

        RestResponse res = new RestResponse();
        RestContext.response = res;

        Test.startTest();
        SN_VotingAPI.upsertVotes(1);

        System.assertEquals(200, SN_VotingAPI.res.statusCode);

        Map<String, Object> bodyMap = (Map<String, Object>) JSON.deserializeUntyped(SN_VotingAPI.res.responseBody.toString());
        System.assertEquals('SUCCESS', bodyMap.get('status'));
        System.assertEquals('Votes updated', bodyMap.get('message'));
        
        Integer countVoteRec = Database.countQuery('SELECT COUNT() FROM SN_Vote_Scoring__c WHERE Knowledge__c = \'' + articleIdForUpdate + '\'');
        System.assert(countVoteRec == 1);
        Test.stopTest();

    }

}