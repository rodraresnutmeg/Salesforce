public with sharing class Trig_LiveChatTranscriptHandler {

    public static void beforeInsert(List<LiveChatTranscript> newTranscripts) {
        for (LiveChatTranscript lct : newTranscripts) {
            // PA exist and is logged in
            if (String.isNotBlank(lct.User_UUID__c)) {
                Account acc = AccountService.getAccountByUserUUID(lct.User_UUID__c);

                if (acc != null) {
                    lct.CaseEmail__c = acc.PersonEmail;
                    updateLCT(lct, acc, acc.Cases.isEmpty());
                    lct.IsLogged__c = true;
                    continue;
                }
            }

            if (lct.CaseEmail__c == null) { continue; }

            List<Account> accList = AccountService.findAccountsWithSameEmailsByEmailsSet(new Set<String>{lct.CaseEmail__c});

            // PA  NOT exist
            if (accList.isEmpty()) {
                if (String.isNotBlank(lct.PA_Last_Name__c)) {
                    Account acc = AccountService.createProspectFromLiveChat(lct);
                    updateLCT(lct, acc, true);
                }
            }

            // PA exist
            if (!accList.isEmpty()) {
                // 1 PA found
                if (accList.size() == 1) {
                    updateLCT(lct, accList[0], accList[0].Cases.isEmpty());
                }

                // More then 1 PA found
                if (accList.size() > 1) {
                    Account tempAccount = null;
                    Id RT_Acc_Customer = Utils.getRecordType('Account', 'Customer').Id;

                    for (Account acc : accList) {
                        if (acc.RecordTypeId == RT_Acc_Customer) {
                            tempAccount = acc;
                            break;
                        }
                    }

                    if (tempAccount == null) {
                        tempAccount = accList[0];
                    }

                    updateLCT(lct, tempAccount, tempAccount.Cases.isEmpty());
                }
            }
        }
    }

    public static void updateLCT(LiveChatTranscript lct, Account acc, Boolean isCreateCase) {
        lct.AccountId = acc.Id;
        lct.ContactId = acc.PersonContactId;

        if (isCreateCase) {
            Case c = CaseService.createCaseFromLiveChat(lct);
            lct.CaseId = c.Id;
        }
    }

    public static void afterUpdate(Map<id, LiveChatTranscript> oldChat , List<LiveChatTranscript> newTranscripts) {
        for (LiveChatTranscript lct : newTranscripts) {
            if (
                lct.CaseId == null
                || lct.Status != 'InProgress'
                || lct.OwnerId.getSobjectType().getDescribe().getLabel() == Trig_CaseHandler.OWNER_TYPE_GROUP
            ) {
                continue;
            }

            Case c = [SELECT Id, OwnerId FROM Case WHERE Id = :lct.CaseId LIMIT 1];

            if (lct.OwnerId != c.OwnerId) {
                c.OwnerId = lct.OwnerId;
                update c;
            }
        }
        processSlaMetrics(oldChat ,newTranscripts );
    }

    public static void processSlaMetrics(Map<id, LiveChatTranscript> oldChat , List<LiveChatTranscript> newChat) {
        System.debug(LoggingLevel.INFO, 'entre aca CHATRODRI oldChat ');
        List<SLA_Metrics__c> metrics = new List<SLA_Metrics__c> ();
        for(LiveChatTranscript t :newChat ){
            System.debug(LoggingLevel.INFO, 'entre aca CHATRODRI oldChat 2 old ' + oldChat.get(t.id));
            System.debug(LoggingLevel.INFO, 'entre aca CHATRODRI oldChat 2 new ' + t);
            System.debug(LoggingLevel.INFO, 'entre aca CHATRODRI new 2 status ' + t.status);
            System.debug(LoggingLevel.INFO, 'entre aca CHATRODRI new 2 case ' + t.caseId);
            System.debug(LoggingLevel.INFO, 'entre aca CHATRODRI oldChat 2 case id ' + oldChat.get(t.id).caseId);
            System.debug(LoggingLevel.INFO, 'entre aca CHATRODRI oldChat 2 status ' + oldChat.get(t.id).status);
            System.debug(LoggingLevel.INFO, 'entre aca CHATRODRI oldChat 2 owner ' + t.owner.name);

            if(oldChat.get(t.id).caseId != t.caseId  && t.caseId != null && t.status == 'Completed'){
                System.debug(LoggingLevel.INFO, 'entre aca 0');

                    SLA_Metrics__c sla = new SLA_Metrics__c(
                    User__c = t.ownerId,
                    Case__c = t.caseId,
                    Outbound__c =false,
                    Received_date__c = t.createdDate);
                    if(t.case.Origin != null ){
                        sla.Type__c = t.case.Origin;

                    }else{
                        sla.Type__c = 'Chat';
                    }
                    metrics.add(sla);

            }else if(t.caseId != null && t.status == 'Completed' && oldChat.get(t.id).status != 'Completed'){
                System.debug(LoggingLevel.INFO, 'entre aca ');

                SLA_Metrics__c sla = new SLA_Metrics__c(
                    User__c = t.ownerId,
                    Case__c = t.caseId,
                    Outbound__c =false,
                    Received_date__c = t.createdDate);
                    if(t.case.Origin != null ){
                        sla.Type__c = t.case.Origin;

                    }else{
                        sla.Type__c = 'Chat';
                    }
                    metrics.add(sla);
            }
            System.debug(LoggingLevel.INFO, 'entre aca 2  ' + metrics);

        }
        if(!metrics.isEmpty()){
            insert metrics;
        }
                     
    }
                

    public static void afterInsert(Set<id> chatIds) {
        List<LiveChatTranscript> chats = [Select id , CaseID , case.origin, CreatedDate from LiveChatTranscript where id in:chatIds];
        List<SLA_Metrics__c> metricsToInser = new List<SLA_Metrics__c>();
 
 
         // si es email , queriar email message para ver si fue support support? 
        for(LiveChatTranscript t  :chats ){
             // Chequear aca lo de missing
            if( t.CaseID != null && t.status != 'Missed' && t.status != 'Dropped'){
                SLA_Metrics__c sla = new SLA_Metrics__c(
                User__c = Userinfo.getuserid(),
                Case__c = t.case.Origin,
                Type__c = 'Chat',
                Outbound__c =false,
                Received_date__c = t.createdDate);
                metricsToInser.add(sla);
            }
        }
        if(!metricsToInser.isEmpty()){
            insert metricsToInser;
        }
    }
        
         
     
}