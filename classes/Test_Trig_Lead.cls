/**********************************************************************
Purpose:

Test class for trigger Trig_Lead
======================================================
History
-------
Date        AUTHOR                 	DETAIL
10/10/2019  Kseniya Hanchuk         CRM-165: Initial version
15/01/2020  Kseniya Hanchuk         MASQ-841: Avios/KMPG/Deloitte fixes.
11/02/2020  Kseniya Hanchuk         MASQ-901: Added custom metadata type.
***********************************************************************/

@IsTest
public with sharing class Test_Trig_Lead {

    @TestSetup
    static void setup() {
        TestDataFactory.startLiveChat();

    }

    @IsTest
    static void createGuideLeads() {
        Integer count = 10;
        Integer countForWrongLeads = 5;

        List<Lead> newLeadsList = new List<Lead>();
        for (Integer i=0; i < count; i++) {
            Lead newLead = new Lead();
            newLead.Website     = '/testPage-' + i;
            newLead.Email       = 'testLeadTrigger-' + i + '@gmail.com';
            newLead.LastName    = '[not provided]';

            if (i==0) {
                newLead.EmailOptIn__c = true;
            }

            newLeadsList.add(newLead);
        }

        // Wrong leads (without Email)
        for (Integer i=0; i < countForWrongLeads; i++) {
            Lead newLead = new Lead();
            newLead.Website     = '/testPage-' + i;
            newLead.LastName    = '[not provided]';

            newLeadsList.add(newLead);
        }

        // Leads that shouldn't be deleted after inserting
        for (String key : Trig_LeadHandler.GUIDE_KEYS) {
            Lead newLead = new Lead();
            newLead.Website     = key;
            key = key.replace('http://', '');
            newLead.Email       = 'testLeadTrigger-' + (key.length() > 50 ? key.substring(1, 51) : key) + '@gmail.com';
            newLead.LastName    = '[not provided]';

            newLeadsList.add(newLead);
        }

        count += Trig_LeadHandler.GUIDE_KEYS.size();

        Test.startTest();
        System.assertEquals(count + countForWrongLeads, newLeadsList.size());

        insert newLeadsList;

        List<Account> accListWithOptIn      = [SELECT Id FROM Account WHERE Email_Investment_Product__pc = TRUE];
        List<Account> accListWithoutOptIn   = [SELECT Id FROM Account WHERE Email_Investment_Product__pc = FALSE];
        System.assertEquals(1, accListWithOptIn.size());
        System.assertEquals(count - 1, accListWithoutOptIn.size());
        Test.stopTest();

        List<Account> accList   = [SELECT Id FROM Account];
        List<Lead> leadList     = [SELECT Id FROM Lead];

        System.assertEquals(count, accList.size());
        System.assertEquals(Trig_LeadHandler.GUIDE_KEYS.size(), leadList.size());

    }

    @IsTest
    static void createPAAvios() {
        TestDataFactory.websiteKey = '/avios';
        Lead testLead = TestDataFactory.createLead(false);

        RestContext.request = TestDataFactory.getRestRequest('fail.test@testfail.com');
        RestContext.response = new RestResponse();

        Test.startTest();

        insert testLead;

        UpsertAccount.checkAccount();
        System.assertEquals(201, RestContext.response.statusCode);

        List<Account> accounts = getAccounts();
        System.assertEquals(2, accounts.size());

        Test.stopTest();

    }

    @IsTest
    static void createPADeloitte() {
        TestDataFactory.websiteKey = '/deloitte';
        Lead testLead = TestDataFactory.createLead(false);

        Test.startTest();

        insert testLead;

        List<Account> accounts = getAccounts();
        System.assertEquals(1, accounts.size());

        Account acc = accounts[0];
        acc.User_UUID__c = 'testUserUUID';
        acc.Watchlist_Result__pc = 'PASS';
        acc.Identity_Result__pc = 'PASS';
        acc.RecordTypeId = Utils.getRecordType('Account', 'Customer').Id;
        update acc;

        System.debug(System.Limits.getEmailInvocations());

        Test.stopTest();

    }

    @IsTest
    static void createPAKMPG() {
        TestDataFactory.websiteKey = '/kpmg';
        Lead testLead = TestDataFactory.createLead(false);

        Test.startTest();

        insert testLead;

        List<Account> accounts = getAccounts();
        System.assertEquals(1, accounts.size());

        Account acc = accounts[0];
        acc.User_UUID__c = 'testUserUUID';
        acc.Watchlist_Result__pc = 'PASS';
        acc.Identity_Result__pc = 'PASS';
        acc.RecordTypeId = Utils.getRecordType('Account', 'Customer').Id;
        update acc;

        List<Case> newCases = [SELECT Id FROM Case];
        System.assertEquals(1, newCases.size());

        Test.stopTest();

    }

    @IsTest
    static void createPATwoCompletedWebForms() {
        TestDataFactory.websiteKey = '/kpmg';
        Lead testLead = TestDataFactory.createLead(false);

        Test.startTest();

        insert testLead;

        List<Account> accounts = getAccounts();
        System.assertEquals(1, accounts.size());

        System.assertEquals('kpmg', accounts[0].CompletedWebForms__c);

        TestDataFactory.websiteKey = '/avios';
        Lead testLead2 = TestDataFactory.createLead(false);
        insert testLead2;

        List<Account> accounts2 = getAccounts();
        System.assertEquals(1, accounts2.size());
        System.assertEquals('kpmg, avios', accounts2[0].CompletedWebForms__c);

        Test.stopTest();

    }

    @IsTest
    static void createPAPreferenceCenter() {
        TestDataFactory.websiteKey = '/preference-centre';
        Lead testLead = TestDataFactory.createLead(false);
        testLead.EmailOptIn__c = false;

        Test.startTest();

        insert testLead;

        List<Account> accounts = [SELECT Email_Investment_Product__pc FROM Account WHERE PersonEmail = :testLead.Email];
        System.assertEquals(1, accounts.size());

        System.assertEquals(false, accounts[0].Email_Investment_Product__pc);

        Test.stopTest();

    }

    @IsTest
    static void updatePAAvios() {
        TestDataFactory.websiteKey = '/avios';
        Lead testLead = TestDataFactory.createLead(false);
        testLead.EmailOptIn__c = false;
        testLead.AviosMembershipNumber__c = '123';
        Account testAccount = TestDataFactory.createAccount(true);

        System.assert(![SELECT Id FROM Account].isEmpty());

        RestContext.request = TestDataFactory.getRestRequest(testLead.Email);
        RestContext.response = new RestResponse();

        Test.startTest();

        insert testLead;

        UpsertAccount.checkAccount();
        System.assertEquals(200, RestContext.response.statusCode);

        List<Account> accounts = getAccounts();
        System.assertEquals(1, accounts.size());

        Test.stopTest();

    }

    @IsTest
    static void updatePADeloitte() {
        TestDataFactory.websiteKey = '/deloitte';
        Lead testLead = TestDataFactory.createLead(false);
        testLead.EmailOptIn__c = false;
        Account testAccount = TestDataFactory.createAccount(true);

        Test.startTest();

        insert testLead;

        List<Account> accounts = getAccounts();
        System.assertEquals(1, accounts.size());

        Account acc = accounts[0];
        acc.User_UUID__c = 'testUserUUID';
        acc.Watchlist_Result__pc = 'PASS';
        acc.Identity_Result__pc = 'PASS';
        acc.RecordTypeId = Utils.getRecordType('Account', 'Customer').Id;
        update acc;

        System.debug(System.Limits.getEmailInvocations());

        Test.stopTest();

    }

    @IsTest
    static void updatePAKMPG() {
        TestDataFactory.websiteKey = '/kpmg';
        Lead testLead = TestDataFactory.createLead(false);
        testLead.EmailOptIn__c = false;
        Account testAccount = TestDataFactory.createAccount(true);

        System.assert(![SELECT Id FROM Account].isEmpty());

        Test.startTest();

        insert testLead;

        List<Account> accounts = getAccounts();
        Account acc = accounts[0];
        acc.User_UUID__c = 'testUserUUID';
        acc.Watchlist_Result__pc = 'PASS';
        acc.Identity_Result__pc = 'PASS';
        acc.RecordTypeId = Utils.getRecordType('Account', 'Customer').Id;
        update acc;

        List<Case> newCases = [SELECT Id FROM Case];
        System.assertEquals(1, newCases.size());

        Test.stopTest();

    }

    @IsTest
    static void updatePAPreferenceCenter() {
        TestDataFactory.websiteKey = '/preference-centre';
        Lead testLead = TestDataFactory.createLead(false);
        testLead.EmailOptIn__c = false;
        Account testAccount = TestDataFactory.createAccount(true);

        Test.startTest();

        insert testLead;

        List<Account> accounts = [SELECT Email_Investment_Product__pc FROM Account WHERE PersonEmail = :testLead.Email];
        System.assertEquals(1, accounts.size());

        System.assertEquals(false, accounts[0].Email_Investment_Product__pc);

        Test.stopTest();

    }

    @IsTest
    static void createAccountFromLead() {
        Lead testLead = TestDataFactory.createLead(false);

        System.assert([SELECT Id FROM Account WHERE PersonEmail = :testLead.Email].isEmpty());

        Test.startTest();

        insert testLead;

        Test.stopTest();

        System.assert(![SELECT Id FROM Account WHERE PersonEmail = :testLead.Email].isEmpty());

    }

    @IsTest
    static void updateAccountFromLead() {
        Account testAccount = TestDataFactory.createAccount(true);
        Lead testLead = TestDataFactory.createLead(false);

        System.assert(![SELECT Id FROM Account WHERE PersonEmail = :testLead.Email].isEmpty());

        Test.startTest();

        insert testLead;

        Test.stopTest();

        Account updatedAcc = [SELECT Id, LastName FROM Account WHERE PersonEmail = :testLead.Email];
        System.assertNotEquals(testLead.LastName, updatedAcc.LastName);

    }

    @IsTest
    static void deleteLead() {
        Lead testLead = TestDataFactory.createLead(true);

        Test.startTest();

        testLead.Email = Trig_LeadHandler.MC_EMAIL_FOR_DELETE.get(0);
        update testLead;

        Test.stopTest();

        System.assert([SELECT Id FROM Lead WHERE Id = :testLead.Id].isEmpty());

    }


    public static List<Account> getAccounts() {
        List<Account> accounts = [
            SELECT
                Id,
                RecordTypeId,
                Identity_Result__pc,
                Watchlist_Result__pc,
                FormName__pc,
                CompletedWebForms__c
            FROM Account
        ];

        return accounts;

    }

}