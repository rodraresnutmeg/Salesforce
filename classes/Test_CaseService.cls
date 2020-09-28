@IsTest
private class Test_CaseService {

    @TestSetup
    public static void setup() {
        TestDataFactory.startLiveChat();
    }

    @IsTest
    static void testGetCaseIdByChatId() {
        Case c1 = TestDataFactory.createCase(true);
        LiveChatTranscript lct1 = TestDataFactory.createLiveChatTranscript(false);
        lct1.CaseId = c1.Id;
        insert lct1;

        Test.startTest();

        String caseIdFail = CaseService.getCaseIdByChatId('');
        System.assert(String.isBlank(caseIdFail));

        String caseId = CaseService.getCaseIdByChatId(lct1.Id);
        System.assertEquals(c1.Id, caseId);

        Test.stopTest();
    }

    @IsTest
    static void testGetRelatedCasesByChatId() {
        Account acc1 = TestDataFactory.createAccount(true);

        Case c1 = TestDataFactory.createCase(true, new Map<String, String>{
            'AccountId' => acc1.Id
        });
        Case c2 = TestDataFactory.createCase(true, new Map<String, String>{
            'AccountId' => acc1.Id
        });
        Case c3 = TestDataFactory.createCase(true, new Map<String, String>{
            'AccountId' => acc1.Id
        });

        LiveChatTranscript lct1 = TestDataFactory.createLiveChatTranscript(false);
        lct1.CaseId     = c1.Id;
        insert lct1;

        Test.startTest();

        List<Case> caseList1 = CaseService.getRelatedCasesByChatId('');
        System.assertEquals(null, caseList1);

        List<Case> caseList2 = CaseService.getRelatedCasesByChatId(lct1.Id);
        System.assertEquals(null, caseList2);

        lct1.AccountId  = acc1.Id;
        update lct1;

        List<Case> caseList3 = CaseService.getRelatedCasesByChatId(lct1.Id);
        System.assertEquals(3, caseList3.size());

        Test.stopTest();
    }

    @IsTest
    static void testUpdateRecordChat() {
        Case c1 = TestDataFactory.createCase(true);

        LiveChatTranscript lct1 = TestDataFactory.createLiveChatTranscript(true);

        Test.startTest();

        CaseService.updateRecordChat(lct1.Id, c1.Id);

        lct1 = [
            SELECT Id, CaseId
            FROM LiveChatTranscript
            WHERE Id = :lct1.Id
            LIMIT 1
        ];
        System.assertEquals(c1.Id, lct1.CaseId);

        Test.stopTest();
    }

    @IsTest
    static void testCreateCaseFromLiveChatPage() {
        LiveChatTranscript lct1 = TestDataFactory.createLiveChatTranscript(true, new Map<String, String>{
            'CaseEmail__c'      => 'test-email@test.com',
            'Case_Origin__c'    => 'Open',
            'PA_Last_Name__c'   => 'testLastName',
            'CaseSubject__c'    => 'test subject',
            'CaseQuestion__c'   => 'test question'
        });

        Test.startTest();

        Case c1 = CaseService.createCaseFromLiveChatPage(null);
        System.assertEquals(null, c1);

        Case c2 = CaseService.createCaseFromLiveChatPage(lct1.Id);
        System.debug(c2);
        System.assert(c2 != null);

        Test.stopTest();
    }

}