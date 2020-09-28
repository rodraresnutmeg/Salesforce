public with sharing class AccountService {

    public static LiveChat__c liveChat = LiveChat__c.getOrgDefaults();

    public static Account getAccountByUserUUID(String uuid) {
        if (String.isBlank(uuid)) { return null; }

        List<Account> accList = [
            SELECT
                Id,
                RecordTypeId,
                PersonEmail,
                PersonContactId,
                (
                    SELECT
                        Id
                    FROM Cases
                )
            FROM Account
            WHERE User_UUID__c = :uuid
            ORDER BY CreatedDate DESC
            LIMIT 1
        ];

        return accList.isEmpty() ? null : accList[0];
    }

    public static List<Account> findAccountsWithSameEmailsByEmailsSet(Set<String> emailsList) {
        return [
            SELECT
                Id,
                RecordTypeId,
                PersonEmail,
                PersonContactId,
                (
                    SELECT
                        Id
                    FROM Cases
                )
            FROM Account
            WHERE PersonEmail IN :emailsList
            ORDER BY CreatedDate DESC
            LIMIT 1000
        ];
    }

    public static Account createProspectFromLiveChat(LiveChatTranscript lct) {
        if (lct == null) { return null; }
        Account acc = new Account();

        acc.RecordTypeId    = Utils.getRecordType('Account', 'Prospect').Id;
        acc.PersonEmail     = lct.CaseEmail__c;
        acc.FirstName       = lct.PA_First_Name__c;
        acc.LastName        = lct.PA_Last_Name__c;
        acc.OwnerId         = liveChat.DefaultOwnerForProspectAccount__c;

        insert acc;
        return getAccountByIdForLiveChat(acc.Id);
    }

    public static Account getAccountByIdForLiveChat(Id accId) {
        if (accId == null) { return null; }

        List<Account> accList = [
            SELECT
                Id,
                PersonContactId
            FROM Account
            WHERE Id = :accId
            LIMIT 1
        ];

        return accList.isEmpty()
            ? null
            : accList[0];
    }

    @AuraEnabled
    public static Account getAccountById(Id accId) {
        if (accId == null) { return null; }

        List<Account> accList = [
            SELECT
                Id,
                Phone_Opt_Out__pc
            FROM Account
            WHERE Id = :accId
            LIMIT 1
        ];

        return accList.isEmpty()
            ? null
            : accList[0];
    }

}