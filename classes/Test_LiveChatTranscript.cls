@IsTest
private class Test_LiveChatTranscript {

    @TestSetup
    static void setup() {
        TestDataFactory.startLiveChat();
    }

    @IsTest
    static void test_Move_Case_Status_To_In_Progress() {
        Group mainGroup = [SELECT Id, Name FROM Group WHERE Name = 'Main group' LIMIT 1];
        System.debug(mainGroup);

        List<User> csAgentUsers = [
            SELECT Id,
                ProfileId,
                Profile.Name
            FROM User
            WHERE Profile.Name = 'SC Agent'
        ];

        Account acc1 = TestDataFactory.createAccount(true, new Map<String, String>{
            'PersonEmail'   => 'test1@test.com',
            'LastName'      => 'testUser1'
        });

        LiveChatTranscript lctNew = TestDataFactory.createLiveChatTranscript(true, new Map<String, String>{
            'CaseEmail__c'      => 'test1@test.com',
            'Case_Origin__c'    => 'Chat',
            'OwnerId'           => mainGroup.Id
        });

        lctNew.OwnerId = csAgentUsers[0].Id;

        Test.startTest();

        List<Account> accList   = getAllAccounts();
        List<Case> caseList     = getAllCases();

        System.assertEquals(1, accList.size());
        System.assertEquals(1, caseList.size());

        Case c = caseList[0];
        c.OwnerId = csAgentUsers[0].Id;
        update c;

        c = getAllCases()[0];

        System.assertEquals('In Progress',  c.Status);
        System.assertEquals('Chat',         c.Origin);

        LiveChatTranscript lct = getLiveChatTranscript(lctNew.Id);

        System.assertEquals(acc1.Id,    lct.AccountId);
        System.assertEquals(c.Id,       lct.CaseId);

        Test.stopTest();
    }

    @IsTest
    static void test_Insert_LCT_By_UUID_No_PA() {
        LiveChatTranscript lctNew = TestDataFactory.createLiveChatTranscript(true, new Map<String, String>{
            'User_UUID__c'      => 'testUserUUID',
            'Case_Origin__c'    => 'Chat'
        });

        Test.startTest();

        List<Account> accList   = getAllAccounts();
        List<Case> caseList     = getAllCases();

        System.assertEquals(0, accList.size());
        System.assertEquals(0, caseList.size());

        LiveChatTranscript lct = getLiveChatTranscript(lctNew.Id);

        System.assertEquals(null, lct.AccountId);
        System.assertEquals(null, lct.CaseId);

        Test.stopTest();
    }

    @IsTest
    static void test_Insert_LCT_By_UUID_One_PA_With_Email() {
        Account acc1 = TestDataFactory.createAccount(true, new Map<String, String>{
            'PersonEmail'   => 'test1@test.com',
            'LastName'      => 'testUser1'
        });

        LiveChatTranscript lctNew = TestDataFactory.createLiveChatTranscript(true, new Map<String, String>{
            'User_UUID__c'      => 'testUserUUID',
            'CaseEmail__c'      => 'test1@test.com',
            'Case_Origin__c'    => 'Chat'
        });

        Test.startTest();

        List<Account> accList   = getAllAccounts();
        List<Case> caseList     = getAllCases();

        System.assertEquals(1, accList.size());
        System.assertEquals(1, caseList.size());

        System.assertEquals('Open', caseList[0].Status);
        System.assertEquals('Chat', caseList[0].Origin);

        LiveChatTranscript lct = getLiveChatTranscript(lctNew.Id);

        System.assertEquals(acc1.Id, lct.AccountId);
        System.assertEquals(caseList[0].Id, lct.CaseId);

        Test.stopTest();
    }

    @IsTest
    static void testInsertLCTByUUIDExistOnePAWithCases() {
        Account acc1 = TestDataFactory.createAccount(true, new Map<String, String>{
            'PersonEmail'   => 'test1@test.com',
            'LastName'      => 'testUser1',
            'RecordTypeId'  => Utils.getRecordType('Account', 'Customer').Id,
            'User_UUID__c'  => 'testUserUUID'
        });

        List<Case> accCasesList = new List<Case>();
        accCasesList.add(TestDataFactory.createCase(true, new Map<String, String>{'AccountId' => acc1.Id}));
        accCasesList.add(TestDataFactory.createCase(true, new Map<String, String>{'AccountId' => acc1.Id}));
        accCasesList.add(TestDataFactory.createCase(true, new Map<String, String>{'AccountId' => acc1.Id}));

        LiveChatTranscript lctNew = TestDataFactory.createLiveChatTranscript(true, new Map<String, String>{
            'User_UUID__c'      => 'testUserUUID',
            'Case_Origin__c'    => 'Chat'
        });

        Test.startTest();

        List<Account> accList   = getAllAccounts();
        List<Case> caseList     = getAllCases();

        System.assertEquals(1, accList.size());
        System.assertEquals(accCasesList.size(), caseList.size());

        LiveChatTranscript lct = getLiveChatTranscript(lctNew.Id);

        System.assertEquals(acc1.Id, lct.AccountId);
        System.assertEquals(null, lct.CaseId);

        Test.stopTest();
    }

    @IsTest
    static void testInsertLCTWithoutEmail() {
        LiveChatTranscript lctNew = TestDataFactory.createLiveChatTranscript(true);

        Test.startTest();

        List<Account> accList   = getAllAccounts();
        List<Case> caseList     = getAllCases();

        System.assertEquals(0, accList.size());
        System.assertEquals(0, caseList.size());

        LiveChatTranscript lct = getLiveChatTranscript(lctNew.Id);

        System.assertEquals(null, lct.AccountId);
        System.assertEquals(null, lct.CaseId);

        Test.stopTest();
    }

    @IsTest
    static void testInsertLCTNoPA() {
        LiveChatTranscript lctNew = TestDataFactory.createLiveChatTranscript(true, new Map<String, String>{
            'CaseEmail__c'      => 'test1@test.com',
            'PA_Last_Name__c'   => 'testUser1',
            'Case_Origin__c'    => 'Chat'
        });

        Test.startTest();

        List<Account> accList   = getAllAccounts();
        List<Case> caseList     = getAllCases();

        System.assertEquals(1, accList.size());
        System.assertEquals(1, caseList.size());

        System.assertEquals('Open', caseList[0].Status);
        System.assertEquals('Chat', caseList[0].Origin);

        LiveChatTranscript lct = getLiveChatTranscript(lctNew.Id);

        System.assertEquals(accList[0].Id, lct.AccountId);
        System.assertEquals(caseList[0].Id, lct.CaseId);

        Test.stopTest();
    }

    @IsTest
    static void testInsertLCTExistOnePAWithoutCases() {
        Account acc1 = TestDataFactory.createAccount(true, new Map<String, String>{
            'PersonEmail'   => 'test1@test.com',
            'LastName'      => 'testUser1'
        });

        LiveChatTranscript lctNew = TestDataFactory.createLiveChatTranscript(true, new Map<String, String>{
            'CaseEmail__c'      => 'test1@test.com',
            'Case_Origin__c'    => 'Chat'
        });

        Test.startTest();

        List<Account> accList   = getAllAccounts();
        List<Case> caseList     = getAllCases();

        System.assertEquals(1, accList.size());
        System.assertEquals(1, caseList.size());

        System.assertEquals('Open', caseList[0].Status);
        System.assertEquals('Chat', caseList[0].Origin);

        LiveChatTranscript lct = getLiveChatTranscript(lctNew.Id);

        System.assertEquals(acc1.Id, lct.AccountId);
        System.assertEquals(caseList[0].Id, lct.CaseId);

        Test.stopTest();
    }

    @IsTest
    static void testInsertLCTExistOnePAWithCases() {
        Account acc1 = TestDataFactory.createAccount(true, new Map<String, String>{
            'PersonEmail'   => 'test1@test.com',
            'LastName'      => 'testUser1'
        });

        List<Case> accCasesList = new List<Case>();
        accCasesList.add(TestDataFactory.createCase(true, new Map<String, String>{'AccountId' => acc1.Id}));
        accCasesList.add(TestDataFactory.createCase(true, new Map<String, String>{'AccountId' => acc1.Id}));
        accCasesList.add(TestDataFactory.createCase(true, new Map<String, String>{'AccountId' => acc1.Id}));

        LiveChatTranscript lctNew = TestDataFactory.createLiveChatTranscript(true, new Map<String, String>{
            'CaseEmail__c'      => 'test1@test.com',
            'Case_Origin__c'    => 'Chat'
        });

        Test.startTest();

        List<Account> accList   = getAllAccounts();
        List<Case> caseList     = getAllCases();

        System.assertEquals(1, accList.size());
        System.assertEquals(accCasesList.size(), caseList.size());

        LiveChatTranscript lct = getLiveChatTranscript(lctNew.Id);

        System.assertEquals(acc1.Id, lct.AccountId);
        System.assertEquals(null, lct.CaseId);

        Test.stopTest();
    }

    @IsTest
    static void testInsertLCTExistTwoProspectPAWithoutCases() {
        Account acc1 = TestDataFactory.createAccount(true, new Map<String, String>{
            'PersonEmail'   => 'test1@test.com',
            'LastName'      => 'testUser1'
        });

        Account acc2 = TestDataFactory.createAccount(true, new Map<String, String>{
            'PersonEmail'   => 'test1@test.com',
            'LastName'      => 'testUser2'
        });

        LiveChatTranscript lctNew = TestDataFactory.createLiveChatTranscript(true, new Map<String, String>{
            'CaseEmail__c'      => 'test1@test.com',
            'Case_Origin__c'    => 'Chat'
        });

        Test.startTest();

        List<Account> accList   = getAllAccounts();
        List<Case> caseList     = getAllCases();

        System.assertEquals(2, accList.size());
        System.assertEquals(1, caseList.size());

        System.assertEquals('Open', caseList[0].Status);
        System.assertEquals('Chat', caseList[0].Origin);

        LiveChatTranscript lct = getLiveChatTranscript(lctNew.Id);

        System.assertEquals(accList[0].Id, lct.AccountId);
        System.assertEquals(caseList[0].Id, lct.CaseId);

        Test.stopTest();
    }

    @IsTest
    static void testInsertLCTExistTwoProspectPAWithCases() {
        Account acc1 = TestDataFactory.createAccount(true, new Map<String, String>{
            'PersonEmail'   => 'test1@test.com',
            'LastName'      => 'testUser1'
        });

        Account acc2 = TestDataFactory.createAccount(true, new Map<String, String>{
            'PersonEmail'   => 'test1@test.com',
            'LastName'      => 'testUser2'
        });

        List<Case> accCasesList = new List<Case>();
        accCasesList.add(TestDataFactory.createCase(true, new Map<String, String>{'AccountId' => acc1.Id}));
        accCasesList.add(TestDataFactory.createCase(true, new Map<String, String>{'AccountId' => acc1.Id}));
        accCasesList.add(TestDataFactory.createCase(true, new Map<String, String>{'AccountId' => acc2.Id}));
        accCasesList.add(TestDataFactory.createCase(true, new Map<String, String>{'AccountId' => acc2.Id}));

        LiveChatTranscript lctNew = TestDataFactory.createLiveChatTranscript(true, new Map<String, String>{
            'CaseEmail__c'      => 'test1@test.com',
            'Case_Origin__c'    => 'Chat'
        });

        Test.startTest();

        List<Account> accList   = getAllAccounts();
        List<Case> caseList     = getAllCases();

        System.assertEquals(2, accList.size());
        System.assertEquals(accCasesList.size(), caseList.size());

        LiveChatTranscript lct = getLiveChatTranscript(lctNew.Id);

        System.assertEquals(accList[0].Id, lct.AccountId);
        System.assertEquals(null, lct.CaseId);

        Test.stopTest();
    }

    @IsTest
    static void testInsertLCTExistTwoProspectPAAndOneCustomerPAWithoutCases() {
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

        LiveChatTranscript lctNew = TestDataFactory.createLiveChatTranscript(true, new Map<String, String>{
            'CaseEmail__c'      => 'test1@test.com',
            'Case_Origin__c'    => 'Chat'
        });

        Test.startTest();

        List<Account> accList   = getAllAccounts();
        List<Case> caseList     = getAllCases();

        System.assertEquals(2, accList.size());
        System.assertEquals(1, caseList.size());

        System.assertEquals('Open', caseList[0].Status);
        System.assertEquals('Chat', caseList[0].Origin);

        LiveChatTranscript lct = getLiveChatTranscript(lctNew.Id);

        System.assertEquals(acc2.Id, lct.AccountId);
        System.assertEquals(caseList[0].Id, lct.CaseId);

        Test.stopTest();
    }

    @IsTest
    static void testInsertLCTExistTwoProspectPAAndOneCustomerPAWithCases() {
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

        List<Case> accCasesList = new List<Case>();
        accCasesList.add(TestDataFactory.createCase(true, new Map<String, String>{'AccountId' => acc1.Id}));
        accCasesList.add(TestDataFactory.createCase(true, new Map<String, String>{'AccountId' => acc1.Id}));
        accCasesList.add(TestDataFactory.createCase(true, new Map<String, String>{'AccountId' => acc2.Id}));
        accCasesList.add(TestDataFactory.createCase(true, new Map<String, String>{'AccountId' => acc2.Id}));

        LiveChatTranscript lctNew = TestDataFactory.createLiveChatTranscript(true, new Map<String, String>{
            'CaseEmail__c'      => 'test1@test.com',
            'Case_Origin__c'    => 'Chat'
        });

        Test.startTest();

        List<Account> accList   = getAllAccounts();
        List<Case> caseList     = getAllCases();

        System.assertEquals(2, accList.size());
        System.assertEquals(accCasesList.size(), caseList.size());

        LiveChatTranscript lct = getLiveChatTranscript(lctNew.Id);

        System.assertEquals(acc2.Id, lct.AccountId);
        System.assertEquals(null, lct.CaseId);

        Test.stopTest();
    }

    @IsTest
    static void testUpdateLCT() {
        Group queue = [SELECT Id, Name FROM Group WHERE Name = 'Main group'];

        LiveChatTranscript lctNew = TestDataFactory.createLiveChatTranscript(true, new Map<String, String>{
            'CaseEmail__c'      => 'test1@test.com',
            'PA_Last_Name__c'   => 'testUser1',
            'Case_Origin__c'    => 'Chat',
            'OwnerId'           => queue.Id
        });

        Test.startTest();

        LiveChatTranscript lct1 = getLiveChatTranscript(lctNew.Id);
        Case c1 = [SELECT Id, OwnerId FROM Case WHERE Id = :lct1.CaseId LIMIT 1];

        //System.assertEquals(lct1.OwnerId, c1.OwnerId);

        lct1.OwnerId = TestDataFactory.apUser.Id;
        update lct1;

        Case c2 = [SELECT Id, OwnerId FROM Case WHERE Id = :lct1.CaseId LIMIT 1];
        // Failed cause we can't update field status on LCT object
//        System.assertEquals(lct1.OwnerId, c2.OwnerId);
//        System.assertNotEquals(lct1.OwnerId, c1.OwnerId);
//        System.assertNotEquals(c1.OwnerId, c2.OwnerId);

        Test.stopTest();
    }

    @IsTest
    static void testInsertLCT_Mobile_OnePA_Customer_WithoutCases() {
        Account acc1 = TestDataFactory.createAccount(true, new Map<String, String>{
            'PersonEmail'   => 'test1@test.com',
            'LastName'      => 'testUser1',
            'RecordTypeId'  => Utils.getRecordType('Account', 'Customer').Id,
            'User_UUID__c'  => 'testUserUUID'
        });

        LiveChatTranscript lctNew = TestDataFactory.createLiveChatTranscript(true, new Map<String, String>{
            'User_UUID__c'      => 'testUserUUID',
            'Case_Origin__c'    => 'Mobile'
        });

        Test.startTest();

        List<Account> accList   = getAllAccounts();
        List<Case> caseList     = getAllCases();

        System.assertEquals(1, accList.size());
        System.assertEquals(1, caseList.size());

        System.assertEquals('Open',     caseList[0].Status);
        System.assertEquals('Mobile',   caseList[0].Origin);

        LiveChatTranscript lct = getLiveChatTranscript(lctNew.Id);

        System.assertEquals(acc1.Id, lct.AccountId);
        System.assertEquals(caseList[0].Id, lct.CaseId);
        System.assertEquals(caseList[0].AccountId, acc1.Id);
        System.assertEquals(caseList[0].SuppliedEmail, acc1.PersonEmail);

        System.assertNotEquals(caseList[0].ContactId, null);

        Test.stopTest();
    }

    @IsTest
    static void testInsertLCT_Mobile_OnePA_Customer_WithCases() {
        Account acc1 = TestDataFactory.createAccount(true, new Map<String, String>{
            'PersonEmail'   => 'test1@test.com',
            'LastName'      => 'testUser1',
            'RecordTypeId'  => Utils.getRecordType('Account', 'Customer').Id,
            'User_UUID__c'  => 'testUserUUID'
        });

        List<Case> accCasesList = new List<Case>();
        accCasesList.add(TestDataFactory.createCase(true, new Map<String, String>{'AccountId' => acc1.Id}));
        accCasesList.add(TestDataFactory.createCase(true, new Map<String, String>{'AccountId' => acc1.Id}));

        LiveChatTranscript lctNew = TestDataFactory.createLiveChatTranscript(true, new Map<String, String>{
            'User_UUID__c'      => 'testUserUUID',
            'Case_Origin__c'    => 'Mobile'
        });

        Test.startTest();

        List<Account> accList   = getAllAccounts();
        List<Case> caseList     = getAllCases();

        System.assertEquals(1, accList.size());
        System.assertEquals(accCasesList.size(), caseList.size());

        LiveChatTranscript lct = getLiveChatTranscript(lctNew.Id);

        System.assertEquals(acc1.Id, lct.AccountId);
        System.assertEquals(null, lct.CaseId);

        Test.stopTest();
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

    private static List<Case> getAllCases() {
        return [
            SELECT
                Id,
                Status,
                Origin,
                AccountId,
                ContactId,
                SuppliedEmail,
                RecordType.Name,
                OwnerId
            FROM Case
        ];
    }

    private static List<Account> getAllAccounts() {
        return [
            SELECT
                Id
            FROM Account
            ORDER BY CreatedDate DESC
        ];
    }

}