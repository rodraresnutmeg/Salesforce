/**********************************************************************
Purpose:

Test class for SendNutmailFlowCtrl
======================================================
History
-------
Date        AUTHOR                 	DETAIL
24/01/2020  Kseniya Hanchuk         MASQ-822: Initial version
***********************************************************************/

@IsTest
public with sharing class Test_SendNutmailFlowCtrl {

    @TestSetup
    public static void setup() {
        TestDataFactory.startLiveChat();
    }

    @IsTest
    static void folderIsNotEmpty() {
        Test.startTest();
        String result = SendNutmailFlowCtrl.getEmailTemplates(null);
        Map<String, Object> parsedResult = (Map<String, Object>) JSON.deserializeUntyped(result);

        System.assertEquals('SUCCESS', parsedResult.get('status'));
        System.assertEquals('Default', ((Map<String, Object>) parsedResult.get('defaultTemplate')).get('emailTemplateName'));
        Test.stopTest();
    }

    @IsTest
    static void test_sendNutmailApi() {
        Account existingAccount = TestDataFactory.createAccounts(true, 1)[0];

        insert new Token__c(
            Nutmeg_API_Token__c = 'token'
        );

        Case c = TestDataFactory.createCase(false);
        c.AccountId = existingAccount.Id;
        c.Origin = 'Email';
        c.Status = 'Open';
        insert c;
        TestDataFactory.creatEmailMessage(c.id);
        
        ContentVersion cv = new ContentVersion();
        cv.FirstPublishLocationId = c.Id;
        cv.Title = 'test title';
       // cv.ContentUrl = '/ContentUrl/test';
       cv.PathOnClient =  '/ContentUrl/test';
        cv.versionData = Blob.valueof('test');
        insert cv;

        ContentVersion cv1 = [
            SELECT
                Id,
                ContentDocumentId
            FROM ContentVersion
            WHERE Id = :cv.Id
            LIMIT 1
        ];

        String attachmentId = cv1.ContentDocumentId;
        String subject      = 'Test Subject';
        String textBody     = 'test text';

        Test.setMock(HttpCalloutMock.class, new Mock());
        Test.startTest();

        SendNutmailFlowCtrl.NutmailResponse snfc = SendNutmailFlowCtrl.sendNutmailApi(attachmentId, subject, textBody, c.id);
        System.assertEquals(snfc.statusCode, 200);

        Test.stopTest();
    }


    private class Mock implements HttpCalloutMock {

        public HttpResponse respond(HttpRequest request) {
            HttpResponse response = new HttpResponse();
            response.setStatusCode(200);

            return response;
        }

    }

}