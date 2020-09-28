@IsTest
public class Test_Trig_Case {

    @TestSetup
    public static void setup() {
        TestDataFactory.startLiveChat();
    }

    @IsTest
    static void testInsertCaseFromEmail_Assign_To_Pension_Queue() {
        Case insertCase = TestDataFactory.createCase(true, new Map<String, String>{
            'Status'            => 'Open',
            'Origin'            => 'Email',
            'FirstName__c'      => 'FirstName',
            'LastName__c'       => 'LastName',
            'SuppliedEmail'     => 'test1@test.com',
            'Subject'           => 'Email Pension transfer test',
            'Your_Question__c'  => 'test question'
        });

        List<Case> caseList = getAllCases();
        System.assertEquals(1, caseList.size());

        Id pensionGroupId = [SELECT Id FROM Group WHERE DeveloperName = 'Pensions' LIMIT 1].Id;
        System.assertEquals(pensionGroupId, caseList[0].OwnerId);
    }

    @IsTest
    static void testInsertCaseFromLiveChat_AgentOnline() {
        LiveChatTranscript lctNew = TestDataFactory.createLiveChatTranscript(true, new Map<String, String>{
            'CaseEmail__c'      => 'test1@test.com',
            'Case_Origin__c'    => 'Chat',
            'CaseQuestion__c'   => 'test question',
            'CaseSubject__c'    => 'test subject',
            'PA_First_Name__c'  => 'testFirstName',
            'PA_Last_Name__c'   => 'testLastName'
        });

        Test.startTest();

        List<Account> accList   = getAllAccounts();
        List<Case> caseList     = getAllCases();

        System.assertEquals(1, accList.size());
        System.assertEquals(1, caseList.size());

        Case c = caseList[0];

        System.assertEquals(c.SuppliedEmail,    'test1@test.com');
        System.assertEquals(c.Status,           'Open');
        System.assertEquals(c.Origin,           'Chat');
        System.assertEquals(c.Subject,          'test subject');
        System.assertEquals(c.Your_Question__c, 'test question');

        LiveChatTranscript lct = getLiveChatTranscript(lctNew.Id);

        System.assertEquals(c.OwnerId, lct.OwnerId);
        System.assertEquals(c.Id, lct.CaseId);

        Test.stopTest();
    }

    @IsTest
    static void testInsertCaseFromLiveChat_AgentOffline_No_PA() {
        Test.startTest();
        Case insertCase = TestDataFactory.createCase(true, new Map<String, String>{
            'Status'            => 'Open',
            'Origin'            => 'Web',
            'FirstName__c'      => 'FirstName',
            'LastName__c'       => 'LastName',
            'SuppliedEmail'     => 'test1@test.com',
            'Subject'           => 'test subject',
            'Your_Question__c'  => 'test question'
        });

        List<Account> accList   = getAllAccounts();
        List<Case> caseList     = getAllCases();

        System.assertEquals(1, accList.size());
        System.assertEquals(1, caseList.size());

        Case c = caseList[0];
        System.assertEquals(c.SuppliedEmail,    'test1@test.com');
        System.assertEquals(c.Status,           'Open');
        System.assertEquals(c.Origin,           'Web');
        System.assertEquals(c.Subject,          'test subject');
        System.assertEquals(c.Your_Question__c, 'test question');

        Account acc = accList[0];
        System.assertEquals(acc.FirstName,  'FirstName');
        System.assertEquals(acc.LastName,   'LastName');

        Test.stopTest();
    }

    @IsTest
    static void testInsertCaseFromLiveChat_AgentOffline_One_PA_Without_Cases() {
        Account acc1 = TestDataFactory.createAccount(true, new Map<String, String>{
            'PersonEmail'   => 'test1@test.com',
            'LastName'      => 'testUser1'
        });

        Test.startTest();
        Case insertCase = TestDataFactory.createCase(true, new Map<String, String>{
            'Status'            => 'Open',
            'Origin'            => 'Web',
            'FirstName__c'      => 'FirstName',
            'LastName__c'       => 'LastName',
            'SuppliedEmail'     => 'test1@test.com',
            'Subject'           => 'test subject',
            'Your_Question__c'  => 'test question'
        });

        List<Account> accList   = getAllAccounts();
        List<Case> caseList     = getAllCases();

        System.assertEquals(1, accList.size());
        System.assertEquals(1, caseList.size());

        Case c = caseList[0];
        System.assertEquals(c.SuppliedEmail,    'test1@test.com');
        System.assertEquals(c.Status,           'Open');
        System.assertEquals(c.Origin,           'Web');
        System.assertEquals(c.Subject,          'test subject');
        System.assertEquals(c.Your_Question__c, 'test question');

        Account acc = accList[0];
        System.assertEquals(acc.LastName, 'testUser1');

        Test.stopTest();
    }

    @IsTest
    static void testInsertCaseFromLiveChat_AgentOffline_One_PA_With_Cases() {
        Account acc1 = TestDataFactory.createAccount(true, new Map<String, String>{
            'PersonEmail'   => 'test1@test.com',
            'LastName'      => 'testUser1'
        });

        Case c1 = TestDataFactory.createCase(true, new Map<String, String>{
            'Status'            => 'Open',
            'Origin'            => 'Web',
            'AccountId'         => acc1.Id,
            'FirstName__c'      => 'FirstName',
            'LastName__c'       => 'LastName',
            'SuppliedEmail'     => 'test1@test.com',
            'Subject'           => 'test subject',
            'Your_Question__c'  => 'test question'
        });

        Test.startTest();
        Case insertCase = TestDataFactory.createCase(true, new Map<String, String>{
            'Status'            => 'Open',
            'Origin'            => 'Web',
            'FirstName__c'      => 'FirstName',
            'LastName__c'       => 'LastName',
            'SuppliedEmail'     => 'test1@test.com',
            'Subject'           => 'test subject',
            'Your_Question__c'  => 'test question'
        });

        List<Account> accList   = getAllAccounts();
        List<Case> caseList     = getAllCases();

        System.assertEquals(1, accList.size());
        System.assertEquals(2, caseList.size());

        for (Case c : caseList) {
            System.assertEquals(c.SuppliedEmail,    'test1@test.com');
            System.assertEquals(c.Status,           'Open');
            System.assertEquals(c.Origin,           'Web');
            System.assertEquals(c.Subject,          'test subject');
            System.assertEquals(c.Your_Question__c, 'test question');
        }

        Account acc = accList[0];
        System.assertEquals(acc.LastName, 'testUser1');

        Test.stopTest();
    }

    @IsTest
    static void testInsertCaseFromLiveChat_AgentOffline_Two_Prospect_PA_And_One_Customer_PA_Without_Cases() {
        Account acc1 = TestDataFactory.createAccount(true, new Map<String, String>{
            'PersonEmail'   => 'test1@test.com',
            'LastName'      => 'testUser1'
        });

        Account acc2 = TestDataFactory.createAccount(true, new Map<String, String>{
            'PersonEmail'   => 'test1@test.com',
            'LastName'      => 'testUser2',
            'RecordTypeId'  => Utils.getRecordType('Account', 'Customer').Id,
            'User_UUID__c'  => 'testUserUUID'
        });

        Account acc3 = TestDataFactory.createAccount(true, new Map<String, String>{
            'PersonEmail'   => 'test1@test.com',
            'LastName'      => 'testUser1'
        });

        Test.startTest();
        Case insertCase = TestDataFactory.createCase(true, new Map<String, String>{
            'Status'            => 'Open',
            'Origin'            => 'Web',
            'FirstName__c'      => 'FirstName',
            'LastName__c'       => 'LastName',
            'SuppliedEmail'     => 'test1@test.com',
            'Subject'           => 'test subject',
            'Your_Question__c'  => 'test question'
        });

        List<Account> accList   = getAllAccounts();
        List<Case> caseList     = getAllCases();

        System.assertEquals(3, accList.size());
        System.assertEquals(1, caseList.size());

        Case c = caseList[0];
        System.assertEquals(c.SuppliedEmail,    'test1@test.com');
        System.assertEquals(c.Status,           'Open');
        System.assertEquals(c.Origin,           'Web');
        System.assertEquals(c.Subject,          'test subject');
        System.assertEquals(c.Your_Question__c, 'test question');
        System.assertEquals(c.AccountId,        acc2.Id);

        for (Account acc : accList) {
            System.assertEquals(acc.PersonEmail, 'test1@test.com');
        }

        Test.stopTest();
    }

    @IsTest
    static void testInsertCaseFromLiveChat_AgentOffline_Two_Prospect_PA_And_One_Customer_PA_With_Cases() {
        Account acc1 = TestDataFactory.createAccount(true, new Map<String, String>{
            'PersonEmail'   => 'test1@test.com',
            'LastName'      => 'testUser1'
        });

        Account acc2 = TestDataFactory.createAccount(true, new Map<String, String>{
            'PersonEmail'   => 'test1@test.com',
            'LastName'      => 'testUser2',
            'RecordTypeId'  => Utils.getRecordType('Account', 'Customer').Id,
            'User_UUID__c'  => 'testUserUUID'
        });

        Account acc3 = TestDataFactory.createAccount(true, new Map<String, String>{
            'PersonEmail'   => 'test1@test.com',
            'LastName'      => 'testUser1'
        });

        List<Case> accCasesList = new List<Case>();
        accCasesList.add(TestDataFactory.createCase(true, new Map<String, String>{'AccountId' => acc1.Id}));
        accCasesList.add(TestDataFactory.createCase(true, new Map<String, String>{'AccountId' => acc1.Id}));
        accCasesList.add(TestDataFactory.createCase(true, new Map<String, String>{'AccountId' => acc2.Id}));
        accCasesList.add(TestDataFactory.createCase(true, new Map<String, String>{'AccountId' => acc2.Id}));
        accCasesList.add(TestDataFactory.createCase(true, new Map<String, String>{'AccountId' => acc3.Id}));
        accCasesList.add(TestDataFactory.createCase(true, new Map<String, String>{'AccountId' => acc3.Id}));

        Test.startTest();
        Case insertCase = TestDataFactory.createCase(true, new Map<String, String>{
            'Status'            => 'Open',
            'Origin'            => 'Web',
            'FirstName__c'      => 'FirstName',
            'LastName__c'       => 'LastName',
            'SuppliedEmail'     => 'test1@test.com',
            'Subject'           => 'test subject',
            'Your_Question__c'  => 'test question'
        });

        List<Account> accList   = getAllAccounts();
        List<Case> caseList     = getAllCases();

        System.assertEquals(3, accList.size());
        System.assertEquals(accCasesList.size()+1, caseList.size());

        Case c1;
        for (Case c : caseList) {
            if (c.Id == insertCase.Id) {
                c1 = c;
            }
        }

        System.assertEquals(c1.SuppliedEmail,    'test1@test.com');
        System.assertEquals(c1.Status,           'Open');
        System.assertEquals(c1.Origin,           'Web');
        System.assertEquals(c1.Subject,          'test subject');
        System.assertEquals(c1.Your_Question__c, 'test question');
        System.assertEquals(c1.AccountId,        acc2.Id);

        for (Account acc : accList) {
            System.assertEquals(acc.PersonEmail, 'test1@test.com');
        }

        Test.stopTest();
    }

    @isTest
    static void testCloseTrustPilotFeedbackCase() {
        Case newCase = new Case(
            Status = 'Open',
            Origin = 'Email',
            SuppliedEmail = 'test' + Trig_CaseHandler.TRUST_PILOT_EMAIL,
            Subject = 'You\'ve got a new 4-star review'
        );

        Test.startTest();
        insert newCase;

        Case insertedCase = [SELECT Status, Type, Category__c FROM Case WHERE Id = :newCase.Id];

        System.assertEquals(Trig_CaseHandler.CASE_STATUS_CLOSED, insertedCase.Status, 'Trust Pilot Feedback case was not closed.');
        System.assertEquals(Trig_CaseHandler.TRUST_PILOT_DEFAULT_TYPE, insertedCase.Type, 'Trust Pilot Feedback case was not assigned to default Type.');
        System.assertEquals(Trig_CaseHandler.TRUST_PILOT_DEFAULT_CATEGORY, insertedCase.Category__c, 'Trust Pilot Feedback case was not assigned to default Category.');
        Test.stopTest();
    }

    @isTest
    static void testAssignForMostRecentAgent() {
        Account testAcc = new Account(
            LastName = 'TestAccount',
            PersonEmail = 't.test@test.com',
            RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId()
        );
        insert testAcc;
        Profile agentsProfile = [SELECT Id FROM Profile WHERE Name = 'SC Agent' LIMIT 1];
        User testUser = [SELECT Id, Username FROM User WHERE isActive = true AND ProfileId = :agentsProfile.Id LIMIT 1];

        insert new Case(
            Status = 'Open',
            Origin = 'Nutmail',
            AccountId = testAcc.Id,
            Subject = 'First Test Case',
            SuppliedEmail = testAcc.PersonEmail,
            OwnerId = testUser.Id
        );

        Test.startTest();
        insert new Case(
            Status = 'Open',
            Origin = 'Nutmail',
            AccountId = testAcc.Id,
            Subject = 'Second Test Case'
        );
        Test.stopTest();

        Case lastCase = [SELECT Id, OwnerId FROM Case ORDER BY CreatedDate DESC LIMIT 1];

        System.assertEquals(testUser.Id, lastCase.OwnerId, 'Incorrect owner assigment.');
    }

    @isTest
    static void testAssignCasesToGocardless() {
        Account testAcc = new Account(
            LastName = 'TestAccount',
            PersonEmail = 't.test@test.com',
            RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId(),
            User_UUID__c = 'testUUID-test'
        );
        insert testAcc;

        Case c0 = new Case(
            Status = 'Open',
            Origin = 'Email',
            AccountId = testAcc.Id,
            Subject = 'First Test Case',
            Description = 'ADDACS-0',
            Inbox__c = 'support@nutmeg.com',
            SuppliedEmail = testAcc.PersonEmail
        );
        insert c0;

        Case c01 = new Case(
            Id = c0.Id
        );
        update c01;

        Case c1 = [SELECT Id, Error_Code__c FROM Case LIMIT 1];

        System.assertEquals('ADDACS-0', c1.Error_Code__c);
    }

    private static Case getCase(Id caseId) {
        return [
            SELECT Id, OwnerId
            FROM Case
            WHERE Id = :caseId
            LIMIT 1
        ];
    }

    private static Group getGroup(String groupName) {
        return [
            SELECT Id
            FROM Group
            WHERE Name = :groupName
            LIMIT 1
        ];
    }

    private static List<Case> getAllCases() {
        return [
            SELECT
                Id,
                FirstName__c,
                LastName__c,
                SuppliedEmail,
                Status,
                Origin,
                Subject,
                Your_Question__c,
                RecordType.Name,
                OwnerId,
                AccountId
            FROM Case
        ];
    }

    private static List<Account> getAllAccounts() {
        return [
            SELECT
                Id,
                FirstName,
                LastName,
                PersonEmail
            FROM Account
            ORDER BY CreatedDate DESC
        ];
    }

    private static LiveChatTranscript getLiveChatTranscript(Id id) {
        return [
            SELECT
                Id,
                CaseId,
                AccountId,
                OwnerId,
                Status
            FROM
                LiveChatTranscript
            WHERE Id = :id
            LIMIT 1
        ];
    }

}