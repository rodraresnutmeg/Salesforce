@IsTest
public class Test_BatchSendEmailWithAviosCustomers {

    @TestSetup
    static void init() {
        insert new Scheduled_Email_Sending_Configs__c(
            Emails_Avios__c = 'manager@nutmegfortest.com',
            Emails_IPSE__c = 'manager@nutmegfortest.com'
        );
    }

    @isTest
    static void checkEmailSending_avios() {
        Account newAcc = new Account(
            RecordTypeId = Utils.getRecordType('Account', 'Customer').Id,
            PersonEmail = 'test@test.com',
            LastName = 'TestCustomer',
            AviosMembershipNumber__pc = '12313',
            FormName__pc = 'avios',
            Derived_First_Investment_Date__pc = System.Today() - 1
        );
        insert newAcc;

        Test.startTest();
        Database.executeBatch(new BatchSendEmailWithAviosCustomers());
        // System.assertEquals(1, BatchSendEmailWithAviosCustomers.newAviosCustomers.size(), 'No avios customers found');
        Test.stopTest();

    }

    @isTest
    static void checkEmailSending_ipse() {
        Account newAcc = new Account(
            RecordTypeId = Utils.getRecordType('Account', 'Customer').Id,
            PersonEmail = 'test@test.com',
            LastName = 'TestCustomer',
            AviosMembershipNumber__pc = '12313',
            FormName__pc = 'ipse',
            Derived_First_Investment_Date__pc = System.Today() - 1
        );
        insert newAcc;

        Test.startTest();
        Database.executeBatch(new BatchSendEmailWithAviosCustomers());
        // System.assertEquals(1, BatchSendEmailWithAviosCustomers.newAviosCustomers.size(), 'No avios customers found');
        Test.stopTest();

    }

}