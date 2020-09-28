/**********************************************************************
Purpose:

Test class for UpsertAccount.
======================================================
History
-------
Date        AUTHOR                 	DETAIL
--/--/----  Empaua                  Initial version.
27/12/2019  Kseniya Hanchuk         MASQ-820: Endpoint fixes.
06/01/2019  Raman Aliakevich        JISA tests.
***********************************************************************/

@IsTest
public class UpsertAccountTest {

    private static List<Account> createPAProspects(Boolean isInsert, Integer countProspects) {
        List<Account> newAccs = new List<Account>();

        for (Integer i = 0; i < countProspects; i ++) {
            Account newAcc = new Account(
                FirstName = 'John' + i,
                LastName = 'Doe' + i,
                RecordTypeId = UpsertAccount.PROSPECT_RT,
                Profile_UUID__c = '123123' + i,
                PersonEmail = 'test@test.com',
                Question_1__pc = 'Sample question 1',
                Answer_1__pc = 'Sample answer 1 ' + i
            );

            newAccs.add(newAcc);
        }

        if (isInsert) {
            Database.DMLOptions dml = new Database.DMLOptions();
            dml.DuplicateRuleHeader.allowSave = true;
            dml.DuplicateRuleHeader.runAsCurrentUser = true;
            List<Database.SaveResult> sr = Database.insert(newAccs, dml);
        }

        return newAccs;

    }

    private static Account createPACustomer(Boolean isInsert, Boolean isExistExtId) {
        Account newAcc = new Account(
            FirstName = 'Jonas',
            LastName = 'Yong',
            RecordTypeId = UpsertAccount.CUSTOMER_RT,
            Profile_UUID__c = '123123',
            PersonEmail = 'test@test.com',
            Question_1__pc = 'Sample question 1',
            Answer_1__pc = 'Sample answer 1',
            User_UUID__c = isExistExtId ? '1customer' : 'test1'
        );

        if (isInsert) {
            Database.DMLOptions dml = new Database.DMLOptions();
            dml.DuplicateRuleHeader.allowSave = true;
            dml.DuplicateRuleHeader.runAsCurrentUser = true;
            Database.SaveResult sr = Database.insert(newAcc, dml);
        }

        return newAcc;

    }

    @isTest
    static void incorrectEndpoint() {
        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/v1.0/Account/';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(
            '{"LastName":"Doe","RecordTypeId":"' + UpsertAccount.CUSTOMER_RT +
            '","PersonEmail":"test@test.com","User_UUID__c":"1customer"}'
        );

        RestContext.request = req;
        RestContext.response = new RestResponse();

        Test.startTest();
        UpsertAccount.checkAccount();

        System.assertEquals(400, RESTContext.response.statusCode);
        Test.stopTest();

    }

    @isTest
    static void incorrectExternalIdField() {
        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/v1.0/Account/FirstName';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(
            '{"LastName":"Doe","RecordTypeId":"' + UpsertAccount.CUSTOMER_RT +
            '","PersonEmail":"test@test.com","User_UUID__c":"1customer"}'
        );

        RestContext.request = req;
        RestContext.response = new RestResponse();

        Test.startTest();
        UpsertAccount.checkAccount();

        System.assertEquals(400, RESTContext.response.statusCode);
        Test.stopTest();

    }

    /*
     * PA-Customer exists && ExternalId does not exist && no PA-Prospects
     */
    @isTest
    static void firstScenario() {
        Account existingAcc = createPACustomer(true, false);

        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/v1.0/Account/User_UUID__c';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(
            '{"LastName":"Doe","RecordTypeId":"' + UpsertAccount.CUSTOMER_RT +
            '","PersonEmail":"' + existingAcc.PersonEmail + '","User_UUID__c":"1customer"}'
        );

        RestContext.request = req;
        RestContext.response = new RestResponse();

        Test.startTest();
        UpsertAccount.checkAccount();

        Integer countPACustomer = Database.countQuery(
            'SELECT COUNT() FROM Account WHERE RecordTypeId = \'' + UpsertAccount.CUSTOMER_RT + '\' AND PersonEmail = \'' + existingAcc.PersonEmail + '\''
        );
        System.assertEquals(2, countPACustomer);
        Test.stopTest();

    }

    /*
     * PA-Customer exists && ExternalId does not exist && 1 PA-Prospects
     */
    @isTest
    static void secondScenario() {
        Account existingAcc = createPACustomer(true, false);
        List<Account> existingProspects = createPAProspects(true, 1);

        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/v1.0/Account/User_UUID__c';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(
            '{"LastName":"Doe","RecordTypeId":"' + UpsertAccount.CUSTOMER_RT +
            '","PersonEmail":"' + existingAcc.PersonEmail + '","User_UUID__c":"1customer"}'
        );

        RestContext.request = req;
        RestContext.response = new RestResponse();

        Test.startTest();
        UpsertAccount.checkAccount();

        Integer countPACustomer = Database.countQuery(
            'SELECT COUNT() FROM Account WHERE RecordTypeId = \'' + UpsertAccount.CUSTOMER_RT + '\' AND PersonEmail = \'' + existingAcc.PersonEmail + '\''
        );
        System.assertEquals(2, countPACustomer);
        Test.stopTest();

    }

    /*
     * PA-Customer exists && ExternalId does not exist && 2 PA-Prospects
     */
    @isTest
    static void thirdScenario() {
        Account existingAcc = createPACustomer(true, false);
        List<Account> existingProspects = createPAProspects(true, 2);

        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/v1.0/Account/User_UUID__c';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(
            '{"LastName":"Doe","RecordTypeId":"' + UpsertAccount.CUSTOMER_RT +
            '","PersonEmail":"' + existingAcc.PersonEmail + '","User_UUID__c":"1customer"}'
        );

        RestContext.request = req;
        RestContext.response = new RestResponse();

        Test.startTest();
        UpsertAccount.checkAccount();

        Integer countPACustomer = Database.countQuery(
            'SELECT COUNT() FROM Account WHERE RecordTypeId = \'' + UpsertAccount.CUSTOMER_RT + '\' AND PersonEmail = \'' + existingAcc.PersonEmail + '\''
        );
        System.assertEquals(2, countPACustomer);
        Test.stopTest();

    }

    /*
     * PA-Customer exists && ExternalId exists && no PA-Prospects
     */
    @isTest
    static void fourthScenario() {
        Account existingAcc = createPACustomer(true, true);

        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/v1.0/Account/User_UUID__c';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(
            '{"LastName":"Doe","RecordTypeId":"' + UpsertAccount.CUSTOMER_RT +
            '","PersonEmail":"' + existingAcc.PersonEmail + '","User_UUID__c":"1customer"}'
        );

        RestContext.request = req;
        RestContext.response = new RestResponse();

        Test.startTest();
        UpsertAccount.checkAccount();

        Integer countPACustomer = Database.countQuery(
            'SELECT COUNT() FROM Account WHERE RecordTypeId = \'' + UpsertAccount.CUSTOMER_RT + '\' AND PersonEmail = \'' + existingAcc.PersonEmail + '\''
        );
        System.assertEquals(1, countPACustomer);
        Test.stopTest();

    }

    /*
     * PA-Customer exists && ExternalId exists && 1 PA-Prospects
     */
    @isTest
    static void fifthScenario() {
        Account existingAcc = createPACustomer(true, true);
        List<Account> existingProspects = createPAProspects(true, 1);

        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/v1.0/Account/User_UUID__c';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(
            '{"LastName":"Doe","RecordTypeId":"' + UpsertAccount.CUSTOMER_RT +
            '","PersonEmail":"' + existingAcc.PersonEmail + '","User_UUID__c":"1customer"}'
        );

        RestContext.request = req;
        RestContext.response = new RestResponse();

        Test.startTest();
        UpsertAccount.checkAccount();

        Integer countPACustomer = Database.countQuery(
            'SELECT COUNT() FROM Account WHERE PersonEmail = \'' + existingAcc.PersonEmail + '\''
        );
        System.assertEquals(1, countPACustomer);
        Test.stopTest();

    }

    /*
     * PA-Customer exists && ExternalId exists && 2 PA-Prospects
     */
    @isTest
    static void sixthScenario() {
        Account existingAcc = createPACustomer(true, true);
        List<Account> existingProspects = createPAProspects(true, 2);

        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/v1.0/Account/User_UUID__c';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(
            '{"LastName":"Doe","RecordTypeId":"' + UpsertAccount.CUSTOMER_RT +
            '","PersonEmail":"' + existingAcc.PersonEmail + '","User_UUID__c":"1customer"}'
        );

        RestContext.request = req;
        RestContext.response = new RestResponse();

        Test.startTest();
        UpsertAccount.checkAccount();

        Integer countPACustomer = Database.countQuery(
            'SELECT COUNT() FROM Account WHERE PersonEmail = \'' + existingAcc.PersonEmail + '\''
        );
        System.assertEquals(3, countPACustomer);
        Test.stopTest();

    }

    /*
     * PA-Customer does not exist && ExternalId does not exist && no PA-Prospects
     */
    @isTest
    static void seventhScenario() {
        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/v1.0/Account/User_UUID__c';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(
            '{"LastName":"Doe","RecordTypeId":"' + UpsertAccount.CUSTOMER_RT +
            '","PersonEmail":"test@test.com","User_UUID__c":"1customer"}'
        );

        RestContext.request = req;
        RestContext.response = new RestResponse();

        Test.startTest();
        UpsertAccount.checkAccount();

        Integer countPACustomer = Database.countQuery(
            'SELECT COUNT() FROM Account WHERE PersonEmail = \'test@test.com\''
        );
        System.assertEquals(1, countPACustomer);
        Test.stopTest();

    }

    /*
     * PA-Customer does not exist && ExternalId does not exist && 1 PA-Prospects
     */
    @isTest
    static void eighthScenario() {
        List<Account> existingProspects = createPAProspects(true, 1);

        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/v1.0/Account/User_UUID__c';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(
            '{"LastName":"Doe","RecordTypeId":"' + UpsertAccount.CUSTOMER_RT +
            '","PersonEmail":"' + existingProspects[0].PersonEmail + '","User_UUID__c":"1customer"}'
        );

        RestContext.request = req;
        RestContext.response = new RestResponse();

        Test.startTest();
        UpsertAccount.checkAccount();

        Integer countPACustomer = Database.countQuery(
            'SELECT COUNT() FROM Account WHERE RecordTypeId = \'' + UpsertAccount.CUSTOMER_RT + '\' AND PersonEmail = \'' + existingProspects[0].PersonEmail + '\''
        );
        System.assertEquals(1, countPACustomer);
        Test.stopTest();

    }

    /*
     * PA-Customer does not exist && ExternalId does not exist && 2 PA-Prospects
     */
    @isTest
    static void ninthScenario() {
        List<Account> existingProspects = createPAProspects(true, 2);

        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/v1.0/Account/User_UUID__c';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(
            '{"LastName":"Doe","RecordTypeId":"' + UpsertAccount.CUSTOMER_RT +
            '","PersonEmail":"' + existingProspects[0].PersonEmail + '","User_UUID__c":"1customer"}'
        );

        RestContext.request = req;
        RestContext.response = new RestResponse();

        Test.startTest();
        UpsertAccount.checkAccount();

        Integer countPACustomer = Database.countQuery(
            'SELECT COUNT() FROM Account WHERE PersonEmail = \'' + existingProspects[0].PersonEmail + '\''
        );
        System.assertEquals(3, countPACustomer);
        Test.stopTest();

    }

    /*
     * JISA_Parent_UUID is not empty && Jisa PA-Customer does not exist && ExternalId does not exist && PA-Parent exist
     * THEN
     * JISA_Parent_UUID is none && Jisa PA-Customer exist && ExternalId exist && PA-Parent exist
     */
    @isTest
    static void JisaScenario1() {
        Account existingParentAcc = createPACustomer(true, false);

        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/v1.0/Account/User_UUID__c';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(
            '{"LastName":"Doe","RecordTypeId":"' + UpsertAccount.CUSTOMER_RT +
            '","PersonEmail":"test1@test.com","User_UUID__c":"1customer","JISA_Parent_UUID":"test1"}'
        );

        RestContext.request = req;
        RestContext.response = new RestResponse();

        Test.startTest();
        UpsertAccount.checkAccount();

        List<Account> jisaAccList = [
            SELECT
                Id,
                JISAParentAccount__c
            FROM Account
            WHERE PersonEmail = 'test1@test.com'
        ];

        System.assertEquals(1, jisaAccList.size());
        System.assertEquals(existingParentAcc.Id, jisaAccList[0].JISAParentAccount__c);

        // Second part
        RestRequest req2 = new RestRequest();
        req2.requestURI = '/services/apexrest/v1.0/Account/User_UUID__c';
        req2.httpMethod = 'POST';
        req2.requestBody = Blob.valueOf(
            '{"LastName":"Doe","RecordTypeId":"' + UpsertAccount.CUSTOMER_RT +
                '","PersonEmail":"test1@test.com","User_UUID__c":"1customer","JISA_Parent_UUID":"none"}'
        );

        RestContext.request = req2;
        RestContext.response = new RestResponse();

        UpsertAccount.checkAccount();

        List<Account> jisaAccList2 = [
            SELECT
                Id,
                JISAParentAccount__c
            FROM Account
            WHERE PersonEmail = 'test1@test.com'
        ];

        System.assertEquals(1, jisaAccList2.size());
        System.assertEquals(null, jisaAccList2[0].JISAParentAccount__c);

        Test.stopTest();

    }

    /*
     * JISA_Parent_UUID not empty && Jisa PA-Customer does not exist && ExternalId does not exist && PA-Parent does not exist
     */
    @isTest
    static void JisaScenario2() {
        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/v1.0/Account/User_UUID__c';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(
            '{"LastName":"Doe","RecordTypeId":"' + UpsertAccount.CUSTOMER_RT +
            '","PersonEmail":"test1@test.com","User_UUID__c":"1customer","JISA_Parent_UUID":"test1"}'
        );

        RestContext.request = req;
        RestContext.response = new RestResponse();

        Test.startTest();
        UpsertAccount.checkAccount();

        List<Account> jisaAccList = [
            SELECT
                Id,
                JISAParentAccount__c
            FROM Account
            WHERE PersonEmail = 'test1@test.com'
        ];

        System.assertEquals(1,      jisaAccList.size());
        System.assertEquals(null,   jisaAccList[0].JISAParentAccount__c);
        Test.stopTest();

    }

    /*
     * JISA_Parent_UUID is blank && Jisa PA-Customer does not exist && ExternalId does not exist && PA-Parent does not exist
     */
    @isTest
    static void JisaScenario3() {
        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/v1.0/Account/User_UUID__c';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(
            '{"LastName":"Doe","RecordTypeId":"' + UpsertAccount.CUSTOMER_RT +
            '","PersonEmail":"test1@test.com","User_UUID__c":"1customer","JISA_Parent_UUID":""}'
        );

        RestContext.request = req;
        RestContext.response = new RestResponse();

        Test.startTest();
        UpsertAccount.checkAccount();

        List<Account> jisaAccList = [
            SELECT
                Id,
                JISAParentAccount__c
            FROM Account
            WHERE PersonEmail = 'test1@test.com'
        ];

        System.assertEquals(1,      jisaAccList.size());
        System.assertEquals(null,   jisaAccList[0].JISAParentAccount__c);
        Test.stopTest();

    }

    /*
     * JISA_Parent_UUID is none && Jisa PA-Customer does not exist && ExternalId does not exist && PA-Parent does not exist
     */
    @isTest
    static void JisaScenario4() {
        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/v1.0/Account/User_UUID__c';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(
            '{"LastName":"Doe","RecordTypeId":"' + UpsertAccount.CUSTOMER_RT +
            '","PersonEmail":"test1@test.com","User_UUID__c":"1customer","JISA_Parent_UUID":"None"}'
        );

        RestContext.request = req;
        RestContext.response = new RestResponse();

        Test.startTest();
        UpsertAccount.checkAccount();

        List<Account> jisaAccList = [
            SELECT
                Id,
                JISAParentAccount__c
            FROM Account
            WHERE PersonEmail = 'test1@test.com'
        ];

        System.assertEquals(1,      jisaAccList.size());
        System.assertEquals(null,   jisaAccList[0].JISAParentAccount__c);
        Test.stopTest();

    }

}