@IsTest
private class Test_AccountService {

    @TestSetup
    public static void setup() {
        TestDataFactory.startLiveChat();
    }

    @IsTest
    static void testFindAccountsWithSameEmailsByEmailsSet() {
        String acc1Email = 'acc1-test@test.com';
        String acc2Email = 'acc2-test@test.com';
        String acc3Email = 'acc3-test@test.com';

        Account acc1 = TestDataFactory.createAccount(true, new Map<String, String>{'PersonEmail' => acc1Email});
        Account acc2 = TestDataFactory.createAccount(true, new Map<String, String>{'PersonEmail' => acc2Email});
        Account acc3 = TestDataFactory.createAccount(true, new Map<String, String>{'PersonEmail' => acc3Email});

        Case c1 = TestDataFactory.createCase(true, new Map<String, String>{'AccountId' => acc1.Id});
        Case c2 = TestDataFactory.createCase(true, new Map<String, String>{'AccountId' => acc1.Id});
        Case c3 = TestDataFactory.createCase(true, new Map<String, String>{'AccountId' => acc2.Id});

        Test.startTest();

        List<Account> accList = AccountService.findAccountsWithSameEmailsByEmailsSet(new Set<String>{acc1Email, acc2Email});
        System.assertEquals(2, accList.size());

        for (Account acc : accList) {
            if (acc.PersonEmail == acc1Email) {
                System.assertEquals(2, acc.Cases.size());
            }

            if (acc.PersonEmail == acc2Email) {
                System.assertEquals(1, acc.Cases.size());
            }

            if (acc.PersonEmail == acc3Email) {
                System.assertEquals(0, acc.Cases.size());
            }
        }

        Test.stopTest();
    }

    @IsTest
    static void testCreateProspectFromLiveChat() {
        LiveChatTranscript lct1 = TestDataFactory.createLiveChatTranscript(true, new Map<String, String>{
            'CaseEmail__c'      => 'test-email@test.com',
            'Case_Origin__c'    => 'Open',
            'PA_Last_Name__c'   => 'testLastName',
            'CaseSubject__c'    => 'test subject',
            'CaseQuestion__c'   => 'test question'
        });

        Test.startTest();

        Account acc1 = AccountService.createProspectFromLiveChat(null);
        System.assertEquals(null, acc1);

        Account acc2 = AccountService.createProspectFromLiveChat(lct1);
        System.assertNotEquals(null, acc2.PersonContactId);

        Test.stopTest();
    }

}