@IsTest
public with sharing class Test_BatchUndeleteCasesByDate {

    @TestSetup
    public static void setup() {
        TestDataFactory.startLiveChat();
    }

    @IsTest
    static void testSuccess1() {
        Case c1 = TestDataFactory.createCase(true);

        List<Case> cList1 = [SELECT Id FROM Case];
        System.assertEquals(1, cList1.size());

        delete c1;

        List<Case> cList2 = [SELECT Id FROM Case];
        System.assertEquals(0, cList2.size());

        Test.startTest();
        Database.executeBatch(new BatchUndeleteCasesByDate());
        Test.stopTest();

        List<Case> cList3 = [SELECT Id FROM Case];
        System.assertEquals(1, cList3.size());
    }

    @IsTest
    static void testSuccess2() {
        Case c1 = TestDataFactory.createCase(true);

        List<Case> cList1 = [SELECT Id FROM Case];
        System.assertEquals(1, cList1.size());

        delete c1;

        List<Case> cList2 = [SELECT Id FROM Case];
        System.assertEquals(0, cList2.size());

        Test.startTest();
        Database.executeBatch(new BatchUndeleteCasesByDate(Date.today()));
        Test.stopTest();

        List<Case> cList3 = [SELECT Id FROM Case];
        System.assertEquals(1, cList3.size());
    }

    @IsTest
    static void testFail() {
        Case c1 = TestDataFactory.createCase(true);

        List<Case> cList1 = [SELECT Id FROM Case];
        System.assertEquals(1, cList1.size());

        delete c1;

        List<Case> cList2 = [SELECT Id FROM Case];
        System.assertEquals(0, cList2.size());

        Test.startTest();
        Database.executeBatch(new BatchUndeleteCasesByDate(Date.today().addDays(2)));
        Test.stopTest();

        List<Case> cList3 = [SELECT Id FROM Case];
        System.assertEquals(0, cList3.size());
    }

}