public with sharing class Trig_CaseHandler {

    public final static String  AUTOMATED_PROCESS_USER_NAME     = 'Automated Process';
    public final static String  SC_AGENT_PROFILE_NAME           = 'SC Agent';
    public final static String  CASE_STATUS_OPEN                = 'Open';
    public final static String  CASE_STATUS_CLOSED              = 'Closed';
    public final static String  CASE_STATUS_IN_PROGRESS         = 'In Progress';
    public final static String  CASE_ORIGIN_WEB                 = 'Web';
    public final static String  OWNER_TYPE_USER                 = 'User';
    public final static String  OWNER_TYPE_GROUP                = 'Group';
    public final static String  TRUST_PILOT_EMAIL               = '@trustpilot.com';
    public final static String  TRUST_PILOT_DEFAULT_TYPE        = 'Query';
    public final static String  TRUST_PILOT_DEFAULT_CATEGORY    = 'Feedback';
    public final static String  TRUST_PILOT_DEFAULT_SUBCATEGORY = 'Trustpilot above 3 stars (no response required)';

    public final static Set<String> CASE_ORIGINS_AUTO_AGENT_ASSIGN = new Set<String> {
        'Web',
        'Email',
        'Nutmail'
    };

    public final static List<String>  TRUST_PILOT_SUBJECTS = new List<String> {
        'a new 4 star',
        'a new 4-star',
        'a new 5 star',
        'a new 5-star'
    }; 

    public static LiveChat__c   liveChat                        = LiveChat__c.getOrgDefaults();

    public static List<String>  originsForWebChats              = Utils.getNormalizedListFromString(liveChat.OriginsForWebChats__c);
    public static List<String>  statusesForWebChats             = Utils.getNormalizedListFromString(liveChat.StatusesForWebChats__c);

    public static List<String>  statusesForAssignToWebQueue     = Utils.getNormalizedListFromString(liveChat.StatusesForAssignToWebQueue__c);
    public static List<String>  originsForAssignToWebQueue      = Utils.getNormalizedListFromString(liveChat.OriginsForAssignToWebQueue__c);
    public static Id            queueIdForWebChats              = liveChat.QueueIdForWebChats__c;

    public static List<String>  originsForMobileChats           = Utils.getNormalizedListFromString(liveChat.OriginsForMobileChats__c);
    public static List<String>  statusesForMobileChats          = Utils.getNormalizedListFromString(liveChat.StatusesForWebChats__c);
    public static Id            queueIdForMobileChats           = liveChat.QueueIdForMobileChats__c;

    public static Id            defaultOwnerForProspectAccount  = liveChat.DefaultOwnerForProspectAccount__c;
    public static Id            automatedProcessUserId          = liveChat.AutomatedProcessUserId__c;

    public static Map<Id, User> csAgentsMap                     = new Map<Id, User>();

    // Map<Queue/User Name, Map<ruleName, Map<fieldName, valueList>
    public static Map<String, Map<String, Map<String, List<String>>>>   assignmentMap   = new Map<String, Map<String, Map<String, List<String>>>>();
    public static Map<String, Id>                                       ownersMap       = new Map<String, Id>();

    public static void beforeInsert(List<Case> newCases) {
        prepareCaseAssignmentMap();
        assignCaseToCustomersAgent(newCases);

        for (Case c : newCases) {
            //Routing cases by Origin and Status
            if (
                queueIdForWebChats != null
                && originsForAssignToWebQueue.contains(c.Origin)
                && statusesForAssignToWebQueue.contains(c.Status)
                && String.isBlank(c.OwnerId)
            ) {
                c.OwnerId = queueIdForWebChats;
            }

            if (
                originsForMobileChats.contains(c.Origin)
                && statusesForMobileChats.contains(c.Status)
            ) {
                c.RecordTypeId = Utils.getRecordType('Case', 'Standard_Case').Id;

                if (queueIdForMobileChats != null) {
                    c.OwnerId = queueIdForMobileChats;
                }
            }

            moveCaseToInProgressStatus(c);
            closeTrustPilotFeedbackCase(c);

            caseAssignment(c);
        }

        assignContact(newCases);
    }

    public static void afterInsert(List<Case> newCases,  set<id> casesIdToMetrics) {
        Set<Id> caseIds = new Set<Id>();

        for (Case c : newCases) {
            if (c.Origin == CASE_ORIGIN_WEB && c.Status == CASE_STATUS_OPEN && c.AccountId != null) {
                caseIds.add(c.Id);
            }
        }

        if (!caseIds.isEmpty()) {
            updateCasesFromWebLiveChat(caseIds);
        }
        processMetrics(casesIdToMetrics);
    }

    /** Metrics Logic */

    public static void processMetrics(Set<id> casesId) {
        List<String> casesOrigin = new List<String>{'Web','Email'};
        List<SLA_Metrics__c> metricsToInser = new List<SLA_Metrics__c>();
        List<SLA_Metrics__c> metricsEmailToInsert = new List<SLA_Metrics__c>();
        List<Case> casesInserted = new List<Case> ();
        Set<Id> emailIds = new Set<Id>();
        casesInserted = [select id, Origin, createdDate  from Case where id in:casesId ];

        // si es email , queriar email message para ver si fue support support? 
        for(Case c :casesInserted ){
            if(casesOrigin.contains(c.origin) ){
                SLA_Metrics__c sla = new SLA_Metrics__c(
                User__c = Userinfo.getuserid(),
                Case__c =  c.id ,
                Type__c = c.origin,
                Received_date__c = System.now(),
                Outbound__c = false);
                metricsToInser.add(sla);
            }else if(c.origin == 'Email'){
                emailIds.add(c.id);
            }
        }
        if(emailIds.size() > 0){
            metricsEmailToInsert = addSLAforEmailSupporToSupport(emailIds);
        }

        if(!metricsEmailToInsert.isEmpty()){
            metricsToInser.addAll(metricsEmailToInsert);
        }
        if(!metricsToInser.isEmpty()){
            insert metricsToInser;
        }
    }
    /**
     * if it is email the origin,  check if the case was created for a support to support email. 
     */
    public static List<SLA_Metrics__c> addSLAforEmailSupporToSupport(Set<id> casesId){
        List<SLA_Metrics__c> toCreate = new List<SLA_Metrics__c>();
        List<EmailMessage>emails = [select id, fromAddress, toAddress From EmailMessage where parentId in: casesId];
        for(EmailMessage e : emails){
            if(e.fromAddress == 'support@nutmeg.com' && e.toAddress == 'support@nutmeg.com'){
                SLA_Metrics__c m = new SLA_Metrics__c();
                m.User__c= Userinfo.getuserid();
                m.Case__c = e.parentId;
                m.Type__c = 'MAIL';
                m.Received_date__c = System.now();
                toCreate.add(m);
            }
        }
        return toCreate;
    }

    public static void beforeUpdate(List<Case> newCases, Map<Id, Case> oldCasesMap) {
        assignCasesToGocardless(newCases);
        assignContact(newCases);
        moveCaseToInProgressStatus(newCases, oldCasesMap);
    }

    public static void afterUpdate(List<Case> newCases ) {
        if (liveChat.OriginsForWebChats__c != null && liveChat.OriginsForMobileChats__c != null) {
            Set<Id> mobileCaseIdSet = new Set<Id>();
            Set<Id> caseIdSet       = new Set<Id>();

            for (Case c : newCases) {
                if (checkStatusOpenMobile(c)) {
                    mobileCaseIdSet.add(c.Id);
                }

                if (checkStatusOpenWeb(c)) {
                    caseIdSet.add(c.Id);
                }
            }

            if (!mobileCaseIdSet.isEmpty()) {
                addEmailToMobileCases(mobileCaseIdSet);
            }

            if (!caseIdSet.isEmpty()) {
                updateCasesFromWebLiveChat(caseIdSet);
            }
        }
    }


    public static void addEmailToMobileCases(Set<Id> mobileCaseIdSet) {
        Map<Id, Case> mobileCasesMap = getAllCasesForUpdateBySetId(mobileCaseIdSet);

        for (Case c : mobileCasesMap.values()) {
            c.ContactId     = c.Account.PersonContactId;
            c.SuppliedEmail = c.Account.PersonEmail;

            if (c.Owner.Name == AUTOMATED_PROCESS_USER_NAME) {
                c.OwnerId = queueIdForWebChats;
            }
        }

        update mobileCasesMap.values();
    }

    public static void updateCasesFromWebLiveChat(Set<Id> caseIdSet) {
        Map<Id, Case>       casesMap        = new Map<Id, Case>();
        Map<Id, Account>    caseIdNewAccMap = new Map<Id, Account>();
        Map<String, Case>   caseEmailsMap   = new Map<String, Case>();

        casesMap = getAllCasesForUpdateBySetId(caseIdSet);

        for (Case c : casesMap.values()) {
            caseEmailsMap.put(c.SuppliedEmail, c);

            if (c.Owner.Name == AUTOMATED_PROCESS_USER_NAME) {
                c.OwnerId = queueIdForWebChats;
            }
        }

        // Cases with exist accounts
        List<Account> relatedAccounts = findAccountsWithSameEmailsByEmailsSet(caseEmailsMap.keySet());

        if (!relatedAccounts.isEmpty()) {
            Map<String, Account> accountsByEmail = new Map<String, Account>();
            Id RT_Acc_Customer = Utils.getRecordType('Account', 'Customer').Id;

            for (Account acc : relatedAccounts) {
                if (accountsByEmail.containsKey(acc.PersonEmail)) {
                    if (acc.RecordTypeId == RT_Acc_Customer) {
                        accountsByEmail.put(acc.PersonEmail, acc);
                    } else if (accountsByEmail.get(acc.PersonEmail).RecordTypeId != RT_Acc_Customer && acc.Id > accountsByEmail.get(acc.PersonEmail).Id) {
                        accountsByEmail.put(acc.PersonEmail, acc);
                    }
                } else {
                    accountsByEmail.put(acc.PersonEmail, acc);
                }
            }

            for (Account acc : accountsByEmail.values()) {
                Case c = casesMap.get(caseEmailsMap.get(acc.PersonEmail).Id);
                c.AccountId = acc.Id;
                c.ContactId = acc.PersonContactId;
                caseIdSet.remove(c.Id);
            }

            if (caseIdSet.isEmpty()) {
                update casesMap.values();
                return;
            }
        }

        // Cases without exist accounts
        Map<Id, Account> accMap = new Map<Id, Account>();
        RecordType recordType = Utils.getRecordType('Account', 'Prospect');
        for (Id caseId : caseIdSet) {
            Case c = casesMap.get(caseId);
            caseIdNewAccMap.put(c.Id, createAccountFromCase(c, recordType.Id));
        }
        insert caseIdNewAccMap.values();

        accMap.putAll(caseIdNewAccMap.values());
        accMap = new Map<Id, Account>([SELECT Id, PersonContactId FROM Account WHERE Id IN :accMap.keySet()]);

        for (Id caseId : caseIdNewAccMap.keySet()) {
            Case c = casesMap.get(caseId);
            Account acc = caseIdNewAccMap.get(caseId);
            c.AccountId = acc.Id;
            c.ContactId = accMap.get(acc.Id).PersonContactId;
        }

        List<LiveChatTranscript> liveChatList = getLiveChatList(casesMap.keySet());
        for (LiveChatTranscript lct : liveChatList) {
            lct.AccountId = casesMap.get(lct.CaseId).AccountId;
        }
        update liveChatList;

        update casesMap.values();
    }

    public static void moveCaseToInProgressStatus(List<Case> newCases, Map<Id, Case> oldCasesMap) {
        for (Case c : newCases) {
            if (
                c.OwnerId != oldCasesMap.get(c.Id).OwnerId
                    && (
                        oldCasesMap.get(c.Id).OwnerId.getSobjectType().getDescribe().getLabel() == OWNER_TYPE_GROUP
                        || oldCasesMap.get(c.Id).OwnerId == automatedProcessUserId
                    )
            ) {
                moveCaseToInProgressStatus(c);
            }
        }
    }

    public static void moveCaseToInProgressStatus(Case c) {
        if (
            c.Status == CASE_STATUS_OPEN
            && String.isNotBlank(c.OwnerId)
            && c.OwnerId.getSobjectType().getDescribe().getLabel() == OWNER_TYPE_USER
        ) {
            if (csAgentsMap.isEmpty()) {
                csAgentsMap = new Map<Id, User>([
                    SELECT Id
                    FROM User
                    WHERE Profile.Name = :SC_AGENT_PROFILE_NAME
                ]);
            }

            if (csAgentsMap.containsKey(c.OwnerId)) {
                c.Status = CASE_STATUS_IN_PROGRESS;
            }
        }
    }

    public static void prepareCaseAssignmentMap() {
        List<Case_Assignment_Setting__mdt> caseAssignmentSettingsList = [
            SELECT
                Label,
                QueueName__c,
                TriggerPhase__c,
                OriginValues__c,
                StatusValues__c,
                SubjectValues__c,
                ErrorCodeValues__c
            FROM Case_Assignment_Setting__mdt
        ];

        if (caseAssignmentSettingsList.isEmpty()) {
            return;
        }

        for (Case_Assignment_Setting__mdt casItem : caseAssignmentSettingsList) {
            Map<String, List<String>> conditionsMap = new Map<String, List<String>>();

            if (casItem.OriginValues__c != null) {
                String fieldName1 = 'Origin';
                List<String> valueList1 = Utils.getNormalizedListFromString(casItem.OriginValues__c);
                conditionsMap.put(fieldName1, valueList1);
            }

            if (casItem.StatusValues__c != null) {
                String fieldName2 = 'Status';
                List<String> valueList2 = Utils.getNormalizedListFromString(casItem.StatusValues__c);
                conditionsMap.put(fieldName2, valueList2);
            }

            if (casItem.SubjectValues__c != null) {
                String fieldName3 = 'Subject';
                List<String> valueList3 = Utils.getNormalizedListFromString(casItem.SubjectValues__c);
                conditionsMap.put(fieldName3, valueList3);
            }

            if (casItem.ErrorCodeValues__c != null) {
                String fieldName4 = 'Error_Code__c';
                List<String> valueList4 = Utils.getNormalizedListFromString(casItem.ErrorCodeValues__c);
                conditionsMap.put(fieldName4, valueList4);
            }

            if (conditionsMap.isEmpty()) {
                return;
            }

            if (assignmentMap.containsKey(casItem.QueueName__c)) {
                assignmentMap.get(casItem.QueueName__c).put(casItem.Label, conditionsMap);
            } else {
                Map<String, Map<String, List<String>>> rulesMap = new Map<String, Map<String, List<String>>>();
                rulesMap.put(casItem.Label, conditionsMap);
                assignmentMap.put(casItem.QueueName__c, rulesMap);
            }
        }

        if (!assignmentMap.isEmpty() && ownersMap.isEmpty()) {
            List<Group> groupList = [
                SELECT
                    Id,
                    DeveloperName
                FROM Group
                WHERE DeveloperName IN :assignmentMap.keySet()
            ];

            for (Group g : groupList) {
                ownersMap.put(g.DeveloperName, g.Id);
            }
        }
    }

    public static void caseAssignment(Case c) {
        if (assignmentMap.isEmpty()) {
            return;
        }

        for (String ownerName : assignmentMap.keySet()) {
            if (checkConditions(c, ownerName)) {
                if (ownersMap.get(ownerName) != null) {
                    c.OwnerId = ownersMap.get(ownerName);
                }
            }
        }
    }

    public static Boolean checkConditions(Case c, String ownerName) {
        for (Map<String, List<String>> conditions : assignmentMap.get(ownerName).values()) {
            Integer countConditionsTrue = 0;

            for (String fieldName : conditions.keySet()) {
                if (c.get(fieldName) == null) {
                    break;
                }

                String fieldValue = c.get(fieldName).toString();

                for (String conditionValue : conditions.get(fieldName)) {
                    if (fieldValue.containsIgnoreCase(conditionValue)) {
                        countConditionsTrue++;
                        break;
                    }
                }
            }

            if (conditions.size() == countConditionsTrue) {
                return true;
            }
        }

        return false;
    }

    
    private static Account createAccountFromCase(Case c, Id recordTypeId) {
        Account newAcc = new Account();

        newAcc.RecordTypeId = recordTypeId;
        newAcc.PersonEmail  = c.SuppliedEmail;
        newAcc.FirstName    = c.FirstName__c;
        newAcc.LastName     = c.LastName__c;

        if (defaultOwnerForProspectAccount != null) {
            newAcc.OwnerId = defaultOwnerForProspectAccount;
        }

        return newAcc;
    }

    private static Map<Id, Case> getAllCasesForUpdateBySetId(Set<Id> itemsIds) {
        return new Map<Id, Case>([
            SELECT
                Id,
                Owner.Name,
                SuppliedEmail,
                FirstName__c,
                LastName__c,
                AccountId,
                Account.PersonEmail,
                Account.PersonContactId
            FROM Case
            WHERE Id IN :itemsIds
        ]);
    }

    private static List<Account> findAccountsWithSameEmailsByEmailsSet(Set<String> emailsList) {
        return [
            SELECT
                Id,
                RecordTypeId,
                CreatedDate,
                PersonEmail,
                PersonContactId
            FROM Account
            WHERE PersonEmail IN :emailsList
        ];
    }

    private static Boolean checkStatusOpenWeb(Case c) {
        return c.AccountId      == null
            && c.SuppliedEmail  != null
            && c.FirstName__c   != null
            && c.LastName__c    != null
            && statusesForWebChats.contains(c.Status)
            && originsForWebChats.contains(c.Origin);
    }

    private static Boolean checkStatusOpenMobile(Case c) {
        return c.AccountId      != null
            && c.SuppliedEmail  == null
            && statusesForMobileChats.contains(c.Status)
            && originsForMobileChats.contains(c.Origin);
    }

    private static List<LiveChatTranscript> getLiveChatList(Set<Id> idList) {
        List<LiveChatTranscript> liveChatList = [
            SELECT
                Id,
                AccountId,
                CaseId
            FROM LiveChatTranscript
            WHERE CaseId IN :idList
        ];

        return liveChatList;
    }

    private static void assignContact(List<Case> newCases) {
        List<Id> accIds = new List<Id>();

        for (Case c : newCases) {
            if (c.AccountId != null) {
                accIds.add(c.AccountId);
            }
        }

        Map<Id, Id> accIdToContId = new Map<Id, Id>();

        for (Contact contItem : [SELECT Id, AccountId FROM Contact WHERE AccountId IN :accIds]) {
            accIdToContId.put(contItem.AccountId, contItem.Id);
        }

        for(Case c : newCases) {
            if (c.AccountId != null) {
                c.ContactId = accIdToContId.get(c.AccountId);
            }
        }
    }

    private static void closeTrustPilotFeedbackCase(Case newCase) {
        Boolean isTrustPilotPositiveFeedback = false;
        
        if (String.isNotBlank(newCase.SuppliedEmail) && newCase.SuppliedEmail.contains(TRUST_PILOT_EMAIL)) {
            for (String tpSubjectItem : TRUST_PILOT_SUBJECTS) {
                if (newCase.Subject.contains(tpSubjectItem)) {
                    isTrustPilotPositiveFeedback = true;
                }
            }
        }

        if (isTrustPilotPositiveFeedback) {
            newCase.Status = CASE_STATUS_CLOSED;

            Boolean isEmptyCategory = (
                String.isBlank(newCase.Type) ||
                String.isBlank(newCase.Category__c) ||
                String.isBlank(newCase.Sub_category__c)
            );

            if (isEmptyCategory) {
                newCase.Type = TRUST_PILOT_DEFAULT_TYPE;
                newCase.Category__c = TRUST_PILOT_DEFAULT_CATEGORY;
                newCase.Sub_category__c = TRUST_PILOT_DEFAULT_SUBCATEGORY;
            }
        }
    }

    private static void assignCaseToCustomersAgent(List<Case> newCases) {
        Map<Id, List<Case>> customerToCases = new Map<Id, List<Case>>();

        for (Case caseItem : newCases) {
            if (CASE_ORIGINS_AUTO_AGENT_ASSIGN.contains(caseItem.Origin)) {
                if (caseItem.AccountId == null) {
                    continue;
                }

                if (customerToCases.containsKey(caseItem.AccountId)) {
                    customerToCases.get(caseItem.AccountId).add(caseItem);
                } else {
                    customerToCases.put(caseItem.AccountId, new List<Case> { caseItem });
                }
            }
        }

        List<AggregateResult> existingCases = [
            SELECT AccountId, Status, OwnerId, MAX(LastModifiedDate)lastDate
            FROM Case
            WHERE AccountId IN :customerToCases.keySet()
            AND Origin IN :CASE_ORIGINS_AUTO_AGENT_ASSIGN
            AND LastModifiedDate >= LAST_N_DAYS:30
            GROUP BY AccountId, Status, OwnerId
        ];

        Map<Id, Id> accToAgent = getAgentsToCustomerCase(existingCases);

        if (!accToAgent.isEmpty()) {
            for (Id accItem : customerToCases.keySet()) {
                for (Case caseItem : customerToCases.get(accItem)) {
                    caseItem.OwnerId = accToAgent.get(accItem);
                }
            }
        }
    }

    private static Map<Id, Id> getAgentsToCustomerCase(List<AggregateResult> existingCases) {
        if (existingCases.isEmpty()) {
            return new Map<Id, Id>();
        }

        Map<Id, AggregateResult> mostRecentOwnerForPA = new Map<Id, AggregateResult>();
        for (AggregateResult arItem : existingCases) {
            if (mostRecentOwnerForPA.containsKey(String.valueOf(arItem.get('AccountId')))) {
                mostRecentOwnerForPA.put(
                    String.valueOf(arItem.get('AccountId')),
                    getMostRecentAgent(arItem, mostRecentOwnerForPA.get(String.valueOf(arItem.get('AccountId'))))
                );
            } else {
                mostRecentOwnerForPA.put(String.valueOf(arItem.get('AccountId')), arItem);
            }
        }

        Map<Id, Id> result = new Map<Id, Id>();
        for (Id accItem : mostRecentOwnerForPA.keySet()) {
            result.put(accItem, String.valueOf(mostRecentOwnerForPA.get(accItem).get('OwnerId')));
        }

        return result;
    }

    private static AggregateResult getMostRecentAgent(AggregateResult checkItem, AggregateResult actualItem) {
        if (Datetime.valueOf(checkItem.get('lastDate')) >= Datetime.valueOf(actualItem.get('lastDate'))) {
            if (checkItem.get('Status') == CASE_STATUS_CLOSED && actualItem.get('Status') <> CASE_STATUS_CLOSED) {
                return actualItem;
            } else {
                return checkItem;
            }
        } else {
            if (checkItem.get('Status') <> CASE_STATUS_CLOSED && actualItem.get('Status') == CASE_STATUS_CLOSED) {
                return checkItem;
            } else {
                return actualItem;
            }
        }
    }

    private static void assignCasesToGocardless(List<Case> newCases) {
        Id queueIdGoCardless = null;

        Folder emailsFolder = [
            SELECT Id
            FROM Folder
            WHERE Name = 'Gocardless failure'
            LIMIT 1
        ];

        List<EmailTemplate> emailTemplates = [
            SELECT Id, DeveloperName, Name
            FROM EmailTemplate
            WHERE FolderId = :emailsFolder.Id
        ];

        List<String> gcErrorCodeList = new List<String>();

        for (EmailTemplate et : emailTemplates) {
            gcErrorCodeList.add(et.Name);
        }

        for (Case c : newCases) {
            if (
                c.Origin == 'Email'
                && c.Status == 'Open'
                && c.Inbox__c == 'support@nutmeg.com'
                && c.Description != null
            ) {
                for (String fieldValue : gcErrorCodeList) {
                    if (c.Description.containsIgnoreCase(fieldValue)) {
                        /*
                        if (queueIdGoCardless == null) {
                            queueIdGoCardless = [
                                SELECT
                                    Id,
                                    DeveloperName
                                FROM Group
                                WHERE DeveloperName = 'GoCardless'
                                LIMIT 1
                            ].Id;
                        }
            */

                        c.Error_Code__c     = fieldValue;
                        //c.OwnerId           = queueIdGoCardless;
                        c.Category__c       = 'Payments';
                        c.Sub_category__c   = 'Failed Direct Debit template';
                    }
                }
            }
        }
    } 
} 