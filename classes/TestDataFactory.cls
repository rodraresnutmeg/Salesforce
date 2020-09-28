/**********************************************************************
History
-------
Date        AUTHOR                 	DETAIL
01/15/2020  Kseniya Hanchuk         Initial version
01/24/2020  Raman Aliakevich        MASQ-883: Added several methods
02/20/2020  Kseniya Hanchuk         MASQ-815: Added methods for EmailMessage
***********************************************************************/
@isTest
public with sharing class TestDataFactory {

    private final static String BASE_PROFILEUUID = '36a7d14d-ea67-4331-82d3-502a01a567';
    private final static String BASE_CONVERSATIONID = 'ID123456789BB';

    public static String websiteKey = '/lisa-guide';

    public static User apUser = [
        SELECT
            Id,
            Name
        FROM User
        WHERE Name = 'Automated Process'
        LIMIT 1
    ];

    public static In_Progress_Contributions__c createContribution(Id accountId, Id potId){
        DateTime flagReconciled = System.today().addDays(-12);
        In_Progress_Contributions__c con = new In_Progress_Contributions__c(
            Status__c = 'succeeded', 
            Account__c =accountId,
            Pot__c =potId,
            Reconciled_date__c = flagReconciled
        );
        insert con;
        return con;
    }

    public static Pot__c createPot(Id accountId){
        Pot__c pot = new Pot__c(
            Person_Account__c =accountId
        );
        insert pot;
        return pot;
    }

    public static Lead createLead(Boolean isInsert) {
        Lead newLead = new Lead(
            LastName = 'TestLead',
            Email = 't.test@test.com',
            Website = websiteKey,
            EmailOptIn__c = true,
            FormName__c = websiteKey.substring(1, websiteKey.length())
        );

        if (isInsert) {
            insert newLead;
        }

        return newLead;
    }

    public static Case createCase(Boolean isInsert) {
        return createCase(isInsert, null);
    }

    public static Case createCase(Boolean isInsert, Map<String, String> fields) {
        Case newCase = new Case();

        if (fields != null) {
            for (String s : fields.keySet()) {
                newCase.put(s, fields.get(s));
            }
        }

        if (isInsert) { insert newCase; }

        return newCase;
    }

    public static LiveChatTranscript createLiveChatTranscript(Boolean isInsert) {
        return createLiveChatTranscript(isInsert, null);
    }

    public static LiveChatTranscript createLiveChatTranscript(Boolean isInsert, Map<String, String> fields) {
        LiveChatVisitor lcv = new LiveChatVisitor();
        insert lcv;

        LiveChatTranscript lct = new LiveChatTranscript(
            LiveChatVisitorId = lcv.Id
        );

        if (fields != null) {
            for (String s : fields.keySet()) {
                lct.put(s, fields.get(s));
            }
        }

        if (isInsert) { insert lct; }

        return lct;
    }

    public static List<Account> createAccounts(Boolean isInsert, Integer numOfRecords) {
        List<Account> newAccs = new List<Account>();

        for (Integer i = 0; i < numOfRecords; i ++) {
            newAccs.add(createAccount(false, new Map<String, String> {
                'LastName' => 'TestAccount' + i,
                'PersonEmail' => i + '.test@test.com',
                'User_UUID__c' => BASE_PROFILEUUID + i
            }));
        }

        if (isInsert)
            insert newAccs;

        return newAccs;

    }

    public static Account createAccount(Boolean isInsert) {
        return createAccount(isInsert, null);
    }

    public static Account createAccount(Boolean isInsert, Map<String, String> fields) {
        Account newAccount = new Account(
            LastName = 'TestAccount',
            PersonEmail = 't.test@test.com',
            Consent_Type__pc = websiteKey,
            RecordTypeId = Trig_LeadHandler.RT_PA_PROSPECT_ID,
            Email_Investment_Product__pc = false,
            Email_Nutmeg_Promos__pc = false
        );

        if (fields != null) {
            for (String s : fields.keySet()) {
                newAccount.put(s, fields.get(s));
            }
        }

        if (isInsert) {
            insert newAccount;
        }

        return newAccount;
    }

    public static RestRequest getRestRequest(String email) {
        RestRequest request = new RestRequest();
        request.requestURI = 'https://nutmegaccount--dev.my.salesforce.com/services/apexrest/v1.0/Account/Profile_UUID__c'; // TODO Why it works on not DEV orgs
        request.httpMethod = 'POST';
        request.requestBody = Blob.valueOf(
            '{"LastName" : "Doe","Profile_UUID__c" : "123testing123",' +
            '"PersonEmail" : "'+ email + '","RecordTypeId" : "' + Utils.getRecordType('Account', 'Customer').Id +'"}'
        );

        return request;
    }

    public static void startLiveChat() {
        Group mainGroup = createLiveChatGroup(true, 'Main group');
        QueueSobject mainQueue = createLiveChatQueue(true, mainGroup.Id);

        createLiveChatCustomSetting(mainGroup.Id);
    }


    private static Group createLiveChatGroup(Boolean isInsert, String groupName) {
        Group lcGroup = new Group(
            Name = groupName,
            Type = 'Queue'
        );

        if (isInsert) {
            insert lcGroup;
        }

        return lcGroup;
    }

    private static QueueSobject createLiveChatQueue(Boolean isInsert, Id groupId) {
        QueueSobject queue = new QueueSobject(
            QueueId = groupId,
            SobjectType = 'Case'
        );

        if (isInsert) {
            insert queue;
        }

        return queue;
    }

    @Future
    private static void createLiveChatCustomSetting(Id mainGroupId) {
        insert new LiveChat__c(
            SetupOwnerId                        = UserInfo.getOrganizationId(),
            OriginsForWebChats__c               = 'Web, Email',
            QueueIdForWebChats__c               = mainGroupId,
            StatusesForWebChats__c              = 'Open',
            OriginsForMobileChats__c            = 'Mobile',
            QueueIdForMobileChats__c            = '',
            StatusesForMobileChats__c           = 'Open',
            StatusesForAssignToWebQueue__c      = 'Open',
            OriginsForAssignToWebQueue__c       = 'Web',
            DefaultOwnerForProspectAccount__c   = apUser.Id
        );
    }

    public static List<EmailMessage> createNutEmailMessages(Boolean isInsert, Integer numOfRecords, String messageId) {
        return createNutEmailMessages(isInsert, numOfRecords, messageId, false, false);

    }

    public static List<EmailMessage> createNutEmailMessages(Boolean isInsert, Integer numOfRecords, String messageId, Boolean isSameUserUUID) {
        return createNutEmailMessages(isInsert, numOfRecords, messageId, isSameUserUUID, false);

    }
    public static void creatEmailMessage(String caseid){
        EmailMessage e = new EmailMessage(
            ParentId = caseid
                
        );
        insert e;

    }
    public static List<EmailMessage> createNutEmailMessages(Boolean isInsert, Integer numOfRecords, String messageId, Boolean isSameUserUUID, Boolean isActivity) {
        List<EmailMessage> newEmails = new List<EmailMessage>();

        for (Integer i = 0; i < numOfRecords; i ++) {
            newEmails.add(new EmailMessage(
                ConversationID__c = (isSameUserUUID ? BASE_CONVERSATIONID + '0' : BASE_CONVERSATIONID + i),
                Related_User_UUID__c = (isSameUserUUID ? BASE_PROFILEUUID + '0' : BASE_PROFILEUUID + i),
                MessageIdentifier = messageId + i,
                Nutmail_Message__c = true,
                Reason__c = 'Reason ' + i,
                Is_Activity__c = isActivity
            ));
        }

        if (isInsert)
            upsert newEmails;

        return newEmails;

    }

}