@IsTest
public class Test_SN_SuggestArticlesAPI {

    static void setup() {
        getPublishedArticleIds();
    }

    private static List<Id> getPublishedArticleIds() {
        List<Knowledge__kav> newArticles = new List<Knowledge__kav> {
            new Knowledge__kav(
                Title                       = 'First Article',
                UrlName                     = 'First-Article',
                Description_Rich_Text__c    = '<b>First</b> rich text'
            ),
            new Knowledge__kav(
                Title                       = 'Second Article',
                UrlName                     = 'Second-Article',
                Description_Rich_Text__c    = '<b>Second</b> rich text'
            )
        };

        insert newArticles;

        List<Knowledge__kav> articleItems = [
            SELECT
                Id,
                KnowledgeArticleId
            FROM Knowledge__kav
            WHERE Id = :newArticles
        ];

        insert new Knowledge__DataCategorySelection(
            ParentId                = articleItems.get(0).Id,
            DataCategoryGroupName   = 'Topics',
            DataCategoryName        = 'ISA_and_General_Accounts_Paying_in'
        );

        KbManagement.PublishingService.publishArticle(articleItems.get(0).KnowledgeArticleId, true);
        KbManagement.PublishingService.publishArticle(articleItems.get(1).KnowledgeArticleId, true);

        List<Id> result = new List<Id>();
        for (Knowledge__kav item : articleItems) {
            result.add(item.Id);
        }

        return result;
    }

    @IsTest
    static void getAll_Empty_test() {
        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/v1.0/suggestArticles';
        req.httpMethod = 'GET';
        req.addParameter('q', 'article');
        RestContext.request = req;

        RestResponse res = new RestResponse();
        RestContext.response = res;

        Test.startTest();
            SN_SuggestArticlesAPI.get();

            System.assertEquals(200, SN_SuggestArticlesAPI.res.statusCode, 'Incorrect status code.');

            Map<String, Object> bodyMap = (Map<String, Object>) JSON.deserializeUntyped(SN_SuggestArticlesAPI.res.responseBody.toString());
            System.assertEquals('SUCCESS',  bodyMap.get('status'), 'Incorrect status.');
            System.assertEquals(null,       bodyMap.get('message'), 'Incorrect message.');
        Test.stopTest();

    }

    @IsTest
    static void getAll_notEmpty_test() {
        setup();

        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/v1.0/suggestArticles';
        req.httpMethod = 'GET';
        req.addParameter('q', 'article');
        RestContext.request = req;

        RestResponse res = new RestResponse();
        RestContext.response = res;

        Test.startTest();
            SN_SuggestArticlesAPI.get();

            System.assertEquals(200, SN_SuggestArticlesAPI.res.statusCode, 'Incorrect status code.');

            Map<String, Object> bodyMap = (Map<String, Object>) JSON.deserializeUntyped(SN_SuggestArticlesAPI.res.responseBody.toString());
            System.assertEquals('SUCCESS',  bodyMap.get('status'), 'Incorrect status.');
            System.assertEquals(null,       bodyMap.get('message'), 'Incorrect message.');
        Test.stopTest();

    }

    @IsTest
    static void getAll_notEmpty_test_fail() {
        setup();

        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/v1.0/suggestArticles';
        req.httpMethod = 'GET';
        RestContext.request = req;

        RestResponse res = new RestResponse();
        RestContext.response = res;

        Test.startTest();
            SN_SuggestArticlesAPI.get();

            System.assertEquals(400, SN_SuggestArticlesAPI.res.statusCode, 'Incorrect status code.');

            Map<String, Object> bodyMap = (Map<String, Object>) JSON.deserializeUntyped(SN_SuggestArticlesAPI.res.responseBody.toString());
            System.assertEquals('ERROR',            bodyMap.get('status'), 'Incorrect status.');
            System.assertEquals('Query is empty',   bodyMap.get('message'), 'Incorrect message.');
        Test.stopTest();

    }
}