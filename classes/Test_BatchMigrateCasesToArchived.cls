@isTest
public with sharing class Test_BatchMigrateCasesToArchived {
    @TestSetup
    public static void setup() {
        TestDataFactory.startLiveChat();
    }

    @isTest
    static void moveCasesToArchive() {
        Case testCase = TestDataFactory.createCase(true, new Map<String, String> {
            'Status' => 'Closed',
            'Origin' => 'Nutmail',
            'FirstName__c' => 'FirstName',
            'LastName__c' => 'LastName',
            'SuppliedEmail' => 'test1@test.com',
            'Subject' => 'Pension transfer',
            'Your_Question__c' => 'test question',
            'Type' => 'Other',
            'Category__c' => 'Other (they are removed from reporting)',
            'Sub_category__c' => 'Other',
            'RecordTypeId' => Schema.SObjectType.Case.getRecordTypeInfosByName().get('Serenova Case').getRecordTypeId()
        });

        Test.startTest();
        System.schedule('Test Migration Cases To Archive', '0 0 23 * * ?', new BatchMigrateCasesToArchived());
        Test.stopTest();

    }
}