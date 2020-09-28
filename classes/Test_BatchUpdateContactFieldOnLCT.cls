@IsTest
public class Test_BatchUpdateContactFieldOnLCT {

    @TestSetup
    public static void setup() {
        TestDataFactory.startLiveChat();
    }

    @IsTest
    static void test() {
        LiveChatTranscript lctNew = TestDataFactory.createLiveChatTranscript(true, new Map<String, String>{
            'User_UUID__c'      => 'testUserUUID',
            'Case_Origin__c'    => 'Chat'
        });

        LiveChatTranscript lct = [
            SELECT
                Id,
                CaseId,
                AccountId,
                OwnerId,
                Status
            FROM
                LiveChatTranscript
            WHERE Id = :lctNew.Id
            LIMIT 1
        ];

        System.debug(lct);

        Test.startTest();
        Database.executeBatch(new BatchUpdateContactFieldOnLCT());
        Test.stopTest();
    }
}