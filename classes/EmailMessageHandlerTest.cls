@IsTest
public class EmailMessageHandlerTest {

    private final static String BASE_MESSAGEID = '12345678910';
    private final static String BASE_MESSAGEID2 = '12345678000';

    @TestSetup
    static void setup() {
        Test_Trig_Case.setup();
    }

    @IsTest
    public static void assignExistingCaseCreateNewCase() {
        List<Account> newAccounts = TestDataFactory.createAccounts(true, 2);

        Integer countCases = Database.countQuery('SELECT count() FROM Case');
        System.assertEquals(0, countCases, 'Case object is not empty.');

        Test.startTest();
        TestDataFactory.createNutEmailMessages(true, 2, BASE_MESSAGEID);
        TestDataFactory.createNutEmailMessages(true, 2, BASE_MESSAGEID2);
        Test.stopTest();

        countCases = Database.countQuery('SELECT count() FROM Case');
        System.assert(countCases > 0, 'Case was not created.');
    }

    @IsTest
    public static void createSingleEmailCaseTest() {
        Account existingAccount = TestDataFactory.createAccounts(true, 1)[0];

        Test.startTest();
        EmailMessage existingNutmail = TestDataFactory.createNutEmailMessages(true, 1, BASE_MESSAGEID)[0];
        Test.stopTest();

        System.assertEquals(1, Database.countQuery('SELECT count() FROM Account'), 'Account was not created.');
        System.assertEquals(1, Database.countQuery('SELECT count() FROM EmailMessage'), 'EmailMessage was not created.');

        EmailMessage newEmail = [
            SELECT Id, RelatedToId
            FROM EmailMessage
            LIMIT 1
        ].get(0);

        List<Case> testCase = [SELECT Id, AccountId, ContactId FROM Case WHERE Id = :newEmail.RelatedToId];
        System.assertEquals(1, testCase.size(), 'Case was not created.');
        System.assertNotEquals(null, testCase[0].AccountId, 'Account was not attached to Case.');
        System.assertNotEquals(null, testCase[0].ContactId, 'Contact was not attached to Case.');

    }

    @IsTest
    public static void createChainEmailCaseTest() {
        Account existingAccount = TestDataFactory.createAccounts(true, 1)[0];

        Test.startTest();
        TestDataFactory.createNutEmailMessages(true, 10, BASE_MESSAGEID, true);
        Test.stopTest();

        List<EmailMessage> newEmail = [
            SELECT Id, RelatedToId, MessageIdentifier
            FROM EmailMessage
        ];

        System.assertEquals(10, newEmail.size(), 'EmailMessage was not created.');

        Case newTestCase = [
            SELECT Id, AccountId, ContactId, Last_Message_ID__c
            FROM Case
            WHERE Id = :newEmail[0].RelatedToId
        ][0];
        System.assertNotEquals(null, newTestCase.AccountId, 'Account was not attached to Case.');
        System.assertNotEquals(null, newTestCase.ContactId, 'Contact was not attached to Case.');
        System.assertEquals(newEmail[newEmail.size() - 1].MessageIdentifier, newTestCase.Last_Message_ID__c, 'Last Message Id was not updated.');

        for (EmailMessage emailItem : newEmail) {
            System.assertEquals(newTestCase.Id, emailItem.RelatedToId, 'Incorrect assigment to Case.');
        }

    }

    @IsTest
    public static void createOrphanEmailMessageandCase() {
        Test.startTest();
        TestDataFactory.createNutEmailMessages(true, 1, BASE_MESSAGEID);
        Test.stopTest();

        List<EmailMessage> testEmail = [SELECT Id, RelatedToId FROM EmailMessage];
        System.assertEquals(1, testEmail.size(), 'EmailMessage was not created.');

        List<Case> testCase = [
            SELECT Id, AccountId, ContactId, Last_Message_ID__c, Unknown_Related_User_UUID__c
            FROM Case
        ];
        System.assertEquals(1, testCase.size(), 'Case was not created.');
        System.assertEquals(testEmail[0].RelatedToId, testCase[0].Id, 'EmailMessage was not attached to correct case');
        System.assertEquals(null, testCase[0].AccountId, 'Account attached to Case record');
        System.assertEquals(null, testCase[0].ContactId, 'Contact attached to Case record');

    }

    @IsTest
    public static void createSystemMessageSingle() {
        Account existingAccount = TestDataFactory.createAccounts(true, 1)[0];

        Test.startTest();
        TestDataFactory.createNutEmailMessages(true, 1, BASE_MESSAGEID, true, true);
        Test.stopTest();

        List<EmailMessage> testEmail = [SELECT Id, RelatedToId FROM EmailMessage];
        System.assertEquals(1, testEmail.size(), 'System email was not created.');
        System.assertEquals(existingAccount.Id, testEmail[0].RelatedToId, 'System email was not attached to correct account');

        List<Case> testCase = [
            SELECT Id, AccountId, ContactId, Last_Message_ID__c, Unknown_Related_User_UUID__c
            FROM Case
        ];
        System.assertEquals(0, testCase.size(), 'Case was created for System message.');

    }

    @IsTest
    public static void createSystemMessageSingleOrphan() {
        Test.startTest();
        TestDataFactory.createNutEmailMessages(true, 1, BASE_MESSAGEID, false, true);
        Test.stopTest();

        List<EmailMessage> testEmail = [SELECT Id, RelatedToId FROM EmailMessage];
        System.assertEquals(1, testEmail.size(), 'System email was not created.');
        System.assertEquals(null, testEmail[0].RelatedToId, 'System email was not attached.');

        List<Case> testCase = [
            SELECT Id, AccountId, ContactId, Last_Message_ID__c, Unknown_Related_User_UUID__c
            FROM Case
        ];
        System.assertEquals(0, testCase.size(), 'Case was created for System message.');

    }

}