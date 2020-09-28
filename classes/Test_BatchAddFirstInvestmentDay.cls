@isTest
public class Test_BatchAddFirstInvestmentDay {

    public static final String CUSTOMER_RT_ID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();

    @isTest
    static void addFirstInvestmentDay() {
        Account newAccount = new Account(
            LastName = 'Test',
            RecordTypeId = CUSTOMER_RT_ID,
            User_UUID__c = '124234234-23353dff'
        );
        insert newAccount;

        List<Pot__c> newPots = new List<Pot__c>();
        for (Integer i = 0; i < 3; i ++) {
            newPots.add(new Pot__c(
                Person_Account__c = newAccount.Id,
                Pot_Started_Date__c = System.today() - i
            ));
        }
        insert newPots;

        Test.startTest();
        Database.executeBatch(new BatchAddFirstInvestmentDay());
        Test.stopTest();

        Account acc = [SELECT Id, Derived_First_Investment_Date__pc FROM Account LIMIT 1];
        System.assertEquals(System.today() - 2, acc.Derived_First_Investment_Date__pc, 'Incorrect First Investment Day');

    }

}