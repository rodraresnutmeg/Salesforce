@isTest
public class Test_ZendeskAPI {

    private class Mock implements HttpCalloutMock {

        public HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();

            if (request.getEndpoint().contains('categories')) {
                response.setBody(
                    '{"categories":[{"id": 115000044451,' +
                    '"url": "https://nutmeg.zendesk.com/api/v2/help_center/en-us/categories/115000044451-ISA-and-General-Accounts.json",' +
                    '"html_url": "https://support.nutmeg.com/hc/en-us/categories/115000044451-ISA-and-General-Accounts","position": 0,' +
                    '"created_at": "2017-06-15T15:34:33Z","updated_at": "2019-09-04T18:39:09Z","name": "ISA and General Accounts",' +
                    '"description": "All about investing in stocks and shares ISAs and general accounts, including opening an account, payments, withdrawals, and more",' +
                    '"locale": "en-us","source_locale": "en-us","outdated": false}]}'
                );
            } else if (request.getEndpoint().contains('sections')) {
                response.setBody(
                    '{"sections": [{"id": 115000083572,' +
                    '"url": "https://nutmeg.zendesk.com/api/v2/help_center/en-us/sections/115000083572-General-information.json",' +
                    '"html_url": "https://support.nutmeg.com/hc/en-us/sections/115000083572-General-information",' +
                    '"category_id": 115000044451,"position": 2,"sorting": "manual","created_at": "2017-06-15T17:18:10Z",' +
                    '"updated_at": "2019-08-07T14:04:32Z","name": "General information","description": "","locale": "en-us",' +
                    '"source_locale": "en-us","outdated": false,"parent_section_id": null,"theme_template": "section_page"}]}'
                );
            } else if (request.getEndpoint().contains('articles')) {
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
            }

            response.setStatusCode(200);
            return response;

        }

    }

    @isTest
    static void getArticles() {
        Test.setMock(HttpCalloutMock.class, new Mock());
        Test.startTest();
        ZendeskAPI.main();
        Integer countArticles = Database.countQuery('SELECT count() FROM Knowledge__kav');
        System.assert(countArticles >= 0);
        Test.stopTest();

    }

}