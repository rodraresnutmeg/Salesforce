@isTest
public with sharing class Test_NutmailToArchiveCtrl {

    private final static String BASE_MESSAGEID = '12345678910';

    @TestSetup
    static void setup() {
        Test_Trig_Case.setup();
    }

    @isTest
    static void test_getEmailMessages() {
        Account existingAccount = TestDataFactory.createAccounts(true, 1)[0];
        EmailMessage existingNutmail = TestDataFactory.createNutEmailMessages(true, 1, BASE_MESSAGEID)[0];

        Test.startTest();
        List<EmailMessage> emList = NutmailToArchiveCtrl.getEmailMessages(existingNutmail.Id);
        System.assert(emList.size() > 0, 'Nutmails not found.');
        Test.stopTest();
    }

    @isTest
    static void test_getEmailMessages_account() {
        Account existingAccount = TestDataFactory.createAccounts(true, 1)[0];
        TestDataFactory.createNutEmailMessages(true, 1, BASE_MESSAGEID, true, true);

        Test.startTest();
        List<EmailMessage> emList = NutmailToArchiveCtrl.getEmailMessages(existingAccount.Id);
        Test.stopTest();

        System.assert(emList.size() > 0, 'Nutmails not found.');
    }

    @isTest
    static void test_hideMessage() {
        Account existingAccount = TestDataFactory.createAccounts(true, 1)[0];
        TestDataFactory.createNutEmailMessages(true, 1, BASE_MESSAGEID);

        Test.setMock(HttpCalloutMock.class, new Mock());
        insert new Token__c(
            Nutmeg_API_Token__c = 'token'
        );
        Test.startTest();
        NutmailToArchiveCtrl.hideMessage(BASE_MESSAGEID + '0');
        Test.stopTest();

        Integer count = Database.countQuery('SELECT count() FROM EmailMessage WHERE MessageID__c = \'' + BASE_MESSAGEID + '0\' AND IsHiden__c = TRUE');
        System.assert(count >= 0, 'Hidden Nutmail was not found');
    }


    private class Mock implements HttpCalloutMock {

        public HTTPResponse respond(HTTPRequest request) {
            HttpResponse response = new HttpResponse();
            response.setStatusCode(200);
            return response;

        }

    }
}