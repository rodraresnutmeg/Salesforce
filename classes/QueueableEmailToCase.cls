public with sharing class QueueableEmailToCase implements Queueable {

    public Map<String, List<EmailMessage>> conversationIdToEmails = new Map<String, List<EmailMessage>>();
    public Map<String, Account> senderUuidToAccount = new Map<String, Account>();
    public Boolean isNutmails = false;

    public static Map<String, Case> conversationIdToCase = new Map<String, Case>();

    private final static String CASE_NUTMAIL_ORIGIN = 'Nutmail';
    private final static String CASE_EMAIL_ORIGIN = 'Email';
    private final static String CASE_OPEN_STATUS = 'Open';
    private final static String CASE_CLOSED_STATUS = 'Closed';
    private final static String TASK_PRIORITY = 'Normal';
    private final static String TASK_SUBTYPE = 'Email';
    private final static String TASK_STATUS = 'Completed';
    private final static Id CASE_QUEUE_ID = Utils.getQueueIdByName(Label.EmailMessage_CaseOwner);
    private final static Map<String, Id> TOADDRESS_TO_QUEUE = new Map<String, Id> {
        'pensionsupport@nutmeg.com' => Utils.getQueueIdByName('Pensions'),
        'a.longton@nutmeg.com' => Utils.getQueueIdByName('HNW')
    };

    private static String taskSubject = 'Email: {0}';

    public QueueableEmailToCase(Boolean isNutmails, Map<String, List<EmailMessage>> conversationIdToEmails, Map<String, Account> senderUuidToAccount) {
        this.conversationIdToEmails.putAll(conversationIdToEmails);
        this.senderUuidToAccount.putAll(senderUuidToAccount);
    }

    public void execute(QueueableContext context) {
       for (Case caseItem : [
            SELECT Id, ConversationID__c, Last_Message_ID__c, OwnerId, Status, Re_opened_Case__c
            FROM Case
            WHERE ConversationID__c IN :this.conversationIdToEmails.keySet()
        ]) {
            conversationIdToCase.put(caseItem.ConversationID__c, caseItem);
        }

        assignNutmailToNewCase(this.conversationIdToEmails, this.senderUuidToAccount);

        if (!this.isNutmails) {
            reopenCase(this.conversationIdToEmails);
        }

        if (!conversationIdToCase.isEmpty()) {
            List<Case> casesToUpdate = (List<Case>) conversationIdToCase.values();
            upsert casesToUpdate;

            if (!this.senderUuidToAccount.isEmpty()) {
                insertTasks(this.conversationIdToEmails, casesToUpdate, this.senderUuidToAccount);
            }
        }

        linkEmailMessagesToCases(this.conversationIdToEmails, (List<Case>) conversationIdToCase.values());
    }

    private static void assignNutmailToNewCase(Map<String, List<EmailMessage>> conversationIdToNutmails, Map<String, Account> senderUuidToAccount) {
        for (String conversationId : conversationIdToNutmails.keySet()) {
            List<EmailMessage> emailMessagesForCurrentCase = conversationIdToNutmails.get(conversationId);

            if (emailMessagesForCurrentCase[0].Is_Activity__c) {
                continue;
            }

            if (!conversationIdToCase.containsKey(conversationId)) {
                conversationIdToCase.put(
                    conversationId,
                    createNewCase(conversationId, emailMessagesForCurrentCase, senderUuidToAccount)
                );
            }
        }
    }

    private static Case createNewCase(String conversationId, List<EmailMessage> emailMessagesForCurrentCase, Map<String, Account> senderUuidToAccount) {
        Case newCase = new Case(
            Subject = emailMessagesForCurrentCase[0].Reason__c,
            Description = emailMessagesForCurrentCase[0].HtmlBody,
            Status = CASE_OPEN_STATUS,
            Origin = CASE_NUTMAIL_ORIGIN,
            OwnerId = TOADDRESS_TO_QUEUE.containsKey(emailMessagesForCurrentCase[0].ToAddress) ? TOADDRESS_TO_QUEUE.get(emailMessagesForCurrentCase[0].ToAddress) : CASE_QUEUE_ID,
            ConversationID__c = conversationId,
            Last_Message_ID__c = emailMessagesForCurrentCase[emailMessagesForCurrentCase.size() - 1].MessageIdentifier
        );

        Account currentAcc = senderUuidToAccount.get(emailMessagesForCurrentCase[0].Related_User_UUID__c);

        if (currentAcc != null) {
            newCase.AccountId = currentAcc.Id;
            newCase.ContactId = currentAcc.PersonContactId;
        } else {
            newCase.Unknown_Related_User_UUID__c = emailMessagesForCurrentCase[0].Related_User_UUID__c;
        }

        return newCase;
    }

    private static void linkEmailMessagesToCases(Map<String, List<EmailMessage>> conversationIdToEmails, List<Case> cases) {
        if (conversationIdToEmails.isEmpty()) {
            return;
        }

        for (Case caseItem : cases) {
            List<EmailMessage> emailMessagesForCurrentCase = conversationIdToEmails.get(caseItem.ConversationID__c);
            if (!emailMessagesForCurrentCase.isEmpty()) {
                caseItem.Last_Message_ID__c = emailMessagesForCurrentCase[emailMessagesForCurrentCase.size() - 1].MessageIdentifier;

                for (EmailMessage emailItem : emailMessagesForCurrentCase) {
                    emailItem.RelatedToId = caseItem.Id;
                    emailItem.ParentId = caseItem.Id;
                    emailItem.Status = '3';
                }
            }
        }

        // List<EmailMessage> emailMessagesToUpdate = new List<EmailMessage>();
        // for (List<EmailMessage> emItems : conversationIdToEmails.values()) {
        //     emailMessagesToUpdate.addAll(emItems);
        // }

        // upsert emailMessagesToUpdate;
    }

    private static void insertTasks(Map<String, List<EmailMessage>> conversationIdToEmails, List<Case> cases, Map<String, Account> senderUuidToAccount) {
        List<Task> newTasks = new List<Task>();

        for (Case caseItem : cases) {
            for (EmailMessage emailItem : conversationIdToEmails.get(caseItem.ConversationID__c)) {
                if (emailItem.Is_Activity__c) {
                    continue;
                }
                
                newTasks.add(new Task(
                    Subject = String.format(taskSubject, new List<String>{ emailItem.Reason__c }),
                    Description = emailItem.HtmlBody,
                    TaskSubtype = TASK_SUBTYPE,
                    Status = TASK_STATUS,
                    Priority = TASK_PRIORITY,
                    ActivityDate = System.today(),
                    WhatId = caseItem.Id,
                    WhoId = senderUuidToAccount.get(emailItem.Related_User_UUID__c).PersonContactId
                ));
            }
        }

        if (!newTasks.isEmpty()) {
            insert newTasks;
        }
    }

    private static void reopenCase(Map<String, List<EmailMessage>> conversationIdToEmails) {
        for (Case caseItem : conversationIdToCase.values()) {
            if (caseItem.Status != CASE_CLOSED_STATUS) {
                continue;
            }

            List<EmailMessage> emailMessagesForCurrentCase = conversationIdToEmails.get(caseItem.ConversationID__c);

            if (emailMessagesForCurrentCase[0].Is_Activity__c) {
                continue;
            }

            caseItem.Status = CASE_OPEN_STATUS;
            caseItem.Re_opened_Case__c = true;
        }
    }

}