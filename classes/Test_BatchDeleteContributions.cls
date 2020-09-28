@IsTest
private class Test_BatchDeleteContributions {

    @IsTest
    static void test() {
        Test.startTest();

        Account a = TestDataFactory.createAccount(true, null);
        Pot__c p = TestDataFactory.createPot(a.id);
        In_Progress_Contributions__c con = TestDataFactory.createContribution(a.id,p.id);
        System.debug(LoggingLevel.INFO, 'rodri ' + con);
        Integer conCount = [select count() from In_Progress_Contributions__c];
        System.assertEquals(conCount, 1);

        BatchDeleteContributions.startBatch();


        Test.stopTest();

        Integer conCountAfter = [select count() from In_Progress_Contributions__c];
        System.debug(LoggingLevel.INFO, 'rodri 4' + conCountAfter);
    }

}