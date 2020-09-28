/**********************************************************************
Purpose:

Test class for SN_Controller
======================================================
History
-------
Date        AUTHOR                 	DETAIL
08/22/2019  Kseniya Hanchuk         CRM-247: Initial version
***********************************************************************/

@isTest
public with sharing class Test_SN_Controller {

    @testSetup 
    static void setup() {
        List<Knowledge__kav> articles = new List<Knowledge__kav>();

        for (Integer i = 0; i < 10; i ++) {
            articles.add(new Knowledge__kav(
                Title = 'Test Article' + i,
                Description_Rich_Text__c = '<b>Rich</b> text ' + i,
                UrlName = 'Test-Article' + i
            ));
        }

        insert articles;

	}

    @IsTest
    static void mapRequestUrl_test() {
        Test.startTest();

        PageReference startPage = new PageReference('/hc/en-us');
        SN_URL_Rewriter rewriter = new SN_URL_Rewriter();
        rewriter.mapRequestUrl(startPage);

        startPage = new PageReference('/hc/en-us/categories/');
        rewriter.mapRequestUrl(startPage);

        startPage = new PageReference('/hc/en-us/sections/');
        rewriter.mapRequestUrl(startPage);

        startPage = new PageReference('/hc/en-us/articles/');
        rewriter.mapRequestUrl(startPage);

        startPage = new PageReference('');
        rewriter.mapRequestUrl(startPage);

        Test.stopTest();

    }

    @IsTest
    static void generateUrlFor_test() {
        List<PageReference> mySalesforceUrls = new List<PageReference>();

        PageReference startPage = new PageReference('/');
        mySalesforceUrls.add(startPage);

        startPage = new PageReference('/SN_Layout');
        mySalesforceUrls.add(startPage);

        startPage = new PageReference('/SN_CategoryPage');
        mySalesforceUrls.add(startPage);

        startPage = new PageReference('/SN_SectionPage');
        mySalesforceUrls.add(startPage);

        startPage = new PageReference('/SN_ArticlePage');
        mySalesforceUrls.add(startPage);

        startPage = new PageReference('');
        mySalesforceUrls.add(startPage);

        Test.startTest();

        SN_URL_Rewriter rewriter =new SN_URL_Rewriter();
        rewriter.generateUrlFor(mySalesforceUrls);

        Test.stopTest();

    }

    @IsTest
    static void Homepage_test() {
        Test.startTest();

        Test.setCurrentPage(new PageReference('/hc/en-us'));
        SN_Controller ctrl = new SN_Controller();

        Test.stopTest();

        System.assert(String.isNotBlank(ctrl.pageData));

    }

    @IsTest
    static void CategoriesPage_test() {
        Test.startTest();

        Test.setCurrentPage(new PageReference('/hc/en-us?category=Pension'));
        SN_Controller ctrl = new SN_Controller();

        Test.stopTest();

        System.assert(String.isNotBlank(ctrl.pageData));

    }

    @IsTest
    static void SectionPage_test() {
        Test.startTest();

        Test.setCurrentPage(new PageReference('/hc/en-us?section=ISA_and_General_Accounts_Paying_in&category=ISA_and_General_Accounts'));
        SN_Controller ctrl = new SN_Controller();

        Test.stopTest();

        System.assert(String.isNotBlank(ctrl.pageData));

    }

    @IsTest
    static void ArticlePage_test() {
        String articleUrl = publishArticleGetUrl();

        Test.startTest();

        Test.setCurrentPage(new PageReference('/hc/en-us?article=' + articleUrl));
        SN_Controller ctrl = new SN_Controller();

        Test.stopTest();

        System.assert(String.isNotBlank(ctrl.pageData));

    }

    @IsTest
    static void SearchPage_test() {
        insert new Knowledge__kav(
            Title = 'Knowledge__kav',
            Description_Rich_Text__c = '<b>Rich</b> text', 
            UrlName = 'Test-Article'
        );
 
        Test.startTest();

        Test.setCurrentPage(new PageReference('/hc/en-us?query=Knowledge__kav'));
        SN_Controller ctrl = new SN_Controller();

        Test.stopTest();

        System.assert(String.isNotBlank(ctrl.pageData));

    }

    @IsTest
    static void addRecentlyViewedArticle_test() {
        String articleUrl = publishArticleGetUrl();
        insert new SN_Recent_Articles__c(
            Recent_Articles__c = ''
        );

        Test.startTest();

        Test.setCurrentPage(new PageReference('/hc/en-us?article=' + articleUrl));
        SN_Controller.addRecentlyViewedArticle();

        Test.stopTest();

        SN_Recent_Articles__c cts = SN_Recent_Articles__c.getOrgDefaults();
        System.assert(String.isNotBlank(cts.Recent_Articles__c));

    }

    @IsTest
    static void voteUp_test() {
        Id articleId = publishArticle();

		Test.startTest();

        SN_Controller.voteUp(articleId);
        SN_Controller.voteUp(articleId);

        Test.stopTest();

        List<SN_Vote_Scoring__c> votesForCurrentAtricle = [
            SELECT Knowledge__c, Vote_Sum__c
            FROM SN_Vote_Scoring__c
            WHERE Knowledge__c = :articleId
            LIMIT 1
        ];
        System.assertEquals(2, votesForCurrentAtricle.get(0).Vote_Sum__c);

    }

    @IsTest
    static void voteDown_test() {
        Id articleId = publishArticle();

		Test.startTest();

        SN_Controller.voteDown(articleId);
        SN_Controller.voteDown(articleId);

        Test.stopTest();

        List<SN_Vote_Scoring__c> votesForCurrentAtricle = [
            SELECT Knowledge__c, Vote_Sum__c
            FROM SN_Vote_Scoring__c
            WHERE Knowledge__c = :articleId
            LIMIT 1
        ];
        System.assertEquals(-2, votesForCurrentAtricle.get(0).Vote_Sum__c);

    }

    @IsTest
    static void search_test() {
        Id articleId = publishArticle();

        Test.startTest();
        List<Map<String, String>> searchResult = SN_Controller.search('est');
        Test.stopTest();

        System.assertEquals(1, searchResult.size());

    }

    private static Id publishArticle() {
        Knowledge__kav newArticle = new Knowledge__kav(
            Title = 'Test Article',
            Description_Rich_Text__c = '<b>Rich</b> text',
            UrlName = 'Test-Article'
        );
        insert newArticle;

        Knowledge__kav articleItem = [SELECT KnowledgeArticleId FROM Knowledge__kav WHERE Id = :newArticle.Id LIMIT 1];
        KbManagement.PublishingService.publishArticle(articleItem.KnowledgeArticleId, true);

        return articleItem.Id;

    }

    private static String publishArticleGetUrl() {
        Knowledge__kav newArticle = new Knowledge__kav(
            Title = 'Test Article',
            Description_Rich_Text__c = '<b>Rich</b> text',
            UrlName = 'Test-Article'
        );
        insert newArticle;

        Knowledge__kav articleItem = [SELECT KnowledgeArticleId, UrlName FROM Knowledge__kav WHERE Id = :newArticle.Id LIMIT 1];
        KbManagement.PublishingService.publishArticle(articleItem.KnowledgeArticleId, true);

        return articleItem.UrlName;

    }

    private class Mock implements HttpCalloutMock {

        public HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();

            response.setBody(
                '{"count": 1,"next_page": null,"page": 1,"page_count": 1,"per_page": 30,"previous_page": null,' +
                '"articles": [{"id": 115000351891,"url": "https://nutmeg.zendesk.com/api/v2/help_center/en-us/articles/115000351891-ISA-Settings.json",' +
                '"html_url": "https://support.nutmeg.com/hc/en-us/articles/115000351891-ISA-Settings","author_id": 114212108172,' +
                '"comments_disabled": true,"draft": false,"promoted": false,"position": 0,"vote_sum": 35,"vote_count": 45,"section_id": 115000083572,' +
                '"created_at": "2017-06-15T20:26:52Z","updated_at": "2019-08-07T14:04:32Z","name": "ISA Settings","title": "ISA Settings",' +
                '"source_locale": "en-us","locale": "en-us","outdated": false,"outdated_locales": [],"edited_at": "2017-08-14T22:14:50Z",' +
                '"user_segment_id": null,"permission_group_id": 585352,"label_names": ["Not all money in my ISA","Do I have a ISA","ISA",' +
                '"ISA allowance","ISA settings"],"body": "<p>If you hold an ISA with us you\'ll find you have an additional box marked \'ISA\' on the left</p>"}]}'
            );

            response.setStatusCode(200);
            return response;

        }

    }

}