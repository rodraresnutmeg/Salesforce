/**********************************************************************
Purpose:

Test class for SN_PopularArticlesAPI
======================================================
History
-------
Date        AUTHOR                  DETAIL
05/05/2020  Kseniya Hanchuk         MASQ-635: Initial version.
***********************************************************************/

@isTest
public with sharing class Test_SN_PopularArticlesAPI {

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

        List<Knowledge__kav> articleItems = [SELECT Id, KnowledgeArticleId FROM Knowledge__kav WHERE Id = :newArticles];
        insert new Knowledge__DataCategorySelection(
            ParentId = articleItems.get(0).Id,
            DataCategoryGroupName = 'Topics',
            DataCategoryName = 'ISA_and_General_Accounts_Paying_in'
        );
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

        insert new SN_Recent_Articles__c(
            Recent_Articles__c = String.join(articleIds, ', ')
        );
    }

    @isTest
    static void getAll_empty_test() {
        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/v1.0/popularArticles/getAll';
        req.httpMethod = 'GET';
        RestContext.request = req;

        RestResponse res = new RestResponse();
        RestContext.response = res;

        Test.startTest();
        SN_PopularArticlesAPI.getAll();

        System.assertEquals(200, SN_PopularArticlesAPI.res.statusCode, 'Incorrect status code.');

        Map<String, Object> bodyMap = (Map<String, Object>) JSON.deserializeUntyped(SN_PopularArticlesAPI.res.responseBody.toString());
        System.assertEquals('CANCELLED', bodyMap.get('status'), 'Incorrect status.');
        System.assertEquals('Have no records', bodyMap.get('message'), 'Incorrect message.');
        Test.stopTest();

    }

    @isTest
    static void getAll_notEmpty_test() {
        setup();

        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/v1.0/popularArticles/getAll';
        req.httpMethod = 'GET';
        RestContext.request = req;

        RestResponse res = new RestResponse();
        RestContext.response = res;

        Test.startTest();
        SN_PopularArticlesAPI.getAll();

        System.assertEquals(200, SN_PopularArticlesAPI.res.statusCode, 'Incorrect status code.');

        Map<String, Object> bodyMap = (Map<String, Object>) JSON.deserializeUntyped(SN_PopularArticlesAPI.res.responseBody.toString());
        System.assertEquals('SUCCESS', bodyMap.get('status'), 'Incorrect status.');
        System.assertEquals(null, bodyMap.get('message'), 'Incorrect message.');
        Test.stopTest();

    }

}