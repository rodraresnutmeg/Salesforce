@isTest
public class Test_BatchCloseCasesReopenedByAPI {
    
    @TestSetup
    public static void setup() {
        TestDataFactory.startLiveChat();
    }

    @isTest
    static void test() {
        Case testCase = TestDataFactory.createCase(true, new Map<String, String>{
            'Status' => 'Open',
            'Origin' => 'Nutmail',
            'FirstName__c' => 'FirstName',
            'LastName__c' => 'LastName',
            'SuppliedEmail' => 'test1@test.com',
            'Subject' => 'Pension transfer',
            'Your_Question__c' => 'test question',
            'Type' => 'Other',
            'Category__c' => 'Other (they are removed from reporting)',
            'Sub_category__c' => 'Other'
        });
        testCase.Status = 'Closed';
        update testCase;

        User apiUser = [SELECT Id FROM User WHERE LastName = 'API USER' LIMIT 1];
        System.runAs(apiUser) {
            testCase.Status = 'Open';
            update testCase;
        }            

        Test.startTest();
        Database.executeBatch(new BatchCloseCasesReopenedByAPI());
        Test.stopTest();
    }
    
}