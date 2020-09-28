public with sharing class CaseService {
    @AuraEnabled(Cacheable=true)
    public static String getCaseIdByChatId(String recordId) {
        if (String.isBlank(recordId)) {
            return '';
        }

        LiveChatTranscript lct = [
            SELECT CaseId
            FROM LiveChatTranscript
            WHERE Id = :recordId
            LIMIT 1
        ];

        return lct.CaseId == null ? '' : lct.CaseId;
    }

    @AuraEnabled(Cacheable=true)
    public static List<Case> getRelatedCasesByChatId(String recordId) {
        if (String.isBlank(recordId)) {
            return null;
        }

        LiveChatTranscript lct = [
            SELECT
                CaseId,
                AccountId
            FROM LiveChatTranscript
            WHERE Id = :recordId
            LIMIT 1
        ];

        if (lct.AccountId == null) {
            return null;
        }

        List<Case> casesList = [
            SELECT
                Id,
                CaseNumber,
                Status,
                Subject
            FROM Case
            WHERE AccountId = : lct.AccountId
            ORDER BY LastModifiedDate DESC
        ];

        return casesList;
    }

    @AuraEnabled
    public static String updateRecordChat(String recordId, String caseId) {
        LiveChatTranscript lct = new LiveChatTranscript();
        lct.Id = recordId;
        lct.CaseId = caseId;

        // TODO add try/catch
        update lct;

        return 'SUCCESS';
    }

    @AuraEnabled
    public static Case createCaseFromLiveChatPage(Id recordId) {
        if (recordId == null) { return null; }
        Case c = new Case();

        try {
            LiveChatTranscript lct = [
                SELECT
                    Id,
                    CaseId,
                    Case_Origin__c,
                    OwnerId,
                    AccountId,
                    ContactId,
                    CaseEmail__c,
                    CaseSubject__c,
                    CaseQuestion__c
                FROM LiveChatTranscript
                WHERE Id = :recordId
                LIMIT 1
            ];

            c = createCaseFromLiveChat(lct);

            lct.CaseId = c.Id;
            update lct;
        } catch (Exception e) {
            System.debug(e.getMessage());
        }

        return c;
    }

    public static Case createCaseFromLiveChat(LiveChatTranscript lct) {
        if (lct == null) {
            return null;
        }

        Case c = new Case();
        c.RecordTypeId      = Utils.getRecordType('Case', 'Standard_Case').Id;
        c.Status            = 'Open';
        c.Origin            = lct.Case_Origin__c;
        c.AccountId         = lct.AccountId;
        c.ContactId         = lct.ContactId;
        c.OwnerId           = UserInfo.getUserId();

        c.SuppliedEmail     = lct.CaseEmail__c;
        c.Subject           = lct.CaseSubject__c;
        c.Your_Question__c  = lct.CaseQuestion__c;

        insert c;
        return c;
    }

}