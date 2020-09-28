/**********************************************************************
Purpose:

Handle events for EmailMessage Trigger.
======================================================
Test class:

EmailMessageHandlerTest
======================================================
History
-------
DATE        AUTHOR                 	DETAIL
10/30/2020  Fco.Javier Sanz         Initial
10/30/2019  Fco.Javier Sanz         added beforeInsert function
10/30/2019  Fco.Javier Sanz         added assignExistingCaseCreateNewCase function
02/18/2020  Kseniya Hanchuk         MASQ-815: Code refactoring (prev logic all except reopenCase).
02/20/2020  Kseniya Hanchuk         MASQ-815: Case re-open for nutmails
04/07/2020  Kseniya Hanchuk         MASQ-1083: Moved part of logic to QueueableEmailToCase
***********************************************************************/

public with sharing class EmailMessageHandler {

    private final static String CASE_NUTMAIL_ORIGIN = 'Nutmail';
    private final static String CASE_EMAIL_ORIGIN   = 'Email';
    private final static String CASE_OPEN_STATUS    = 'Open';
    private final static String CASE_CLOSED_STATUS  = 'Closed';
    private final static String TASK_PRIORITY       = 'Normal';
    private final static String TASK_SUBTYPE        = 'Email';
    private final static String TASK_STATUS         = 'Completed';
    private final static Id CASE_QUEUE_ID           = Utils.getQueueIdByName(Label.EmailMessage_CaseOwner);
    private final static Map<String, Id> TOADDRESS_TO_QUEUE = new Map<String, Id> {
        'pensionsupport@nutmeg.com' => Utils.getQueueIdByName('Pensions'),
        'a.longton@nutmeg.com' => Utils.getQueueIdByName('HNW')
    };

    private static String taskSubject = 'Email: {0}';

    public static Map<String, Case> conversationIdToCase = new Map<String, Case>();
    public static Map<String, Account> senderUuidToAccount = new Map<String, Account>();

    public static void beforeInsert(List<EmailMessage> triggerNew) {
        Map<String, List<EmailMessage>> conversationIdToEmailsMessages = new Map<String, List<EmailMessage>>();
        Map<String, List<EmailMessage>> conversationIdToNutmails = new Map<String, List<EmailMessage>>();
        Map<String, List<EmailMessage>> conversationIdToEmails = new Map<String, List<EmailMessage>>();
        Set<String> sendersUuid = new Set<String>();

        for (EmailMessage emailItem : triggerNew) {
            if (emailItem.Nutmail_Message__c) {
                System.debug(LoggingLevel.info, 'rodriemailItem.Nutmail_Message__c  ' + emailItem.ConversationID__c);
                if (conversationIdToNutmails.containsKey(emailItem.ConversationID__c)) {
                    conversationIdToNutmails.get(emailItem.ConversationID__c).add(emailItem);
                } else {
                    conversationIdToNutmails.put(emailItem.ConversationID__c, new List<EmailMessage>{ emailItem });
                }
            } else {
                if (conversationIdToEmails.containsKey(emailItem.ConversationID__c)) {
                    conversationIdToEmails.get(emailItem.ConversationID__c).add(emailItem);
                } else {
                    conversationIdToEmails.put(emailItem.ConversationID__c, new List<EmailMessage>{ emailItem });
                }
            }

            if (String.isNotBlank(emailItem.Related_User_UUID__c)) {
                sendersUuid.add(emailItem.Related_User_UUID__c);
            }
        }

        for (Account accItem : [
            SELECT Id, User_UUID__c, PersonContactId
            FROM Account
            WHERE User_UUID__c IN :sendersUuid
        ]) {
            senderUuidToAccount.put(accItem.User_UUID__c, accItem);
        }

        conversationIdToEmailsMessages.putAll(conversationIdToNutmails);
        conversationIdToEmailsMessages.putAll(conversationIdToEmails);

        Set<Id> owners = new Set<Id>();

        for (Case caseItem : [
            SELECT Id, ConversationID__c, Last_Message_ID__c, OwnerId, Status, Re_opened_Case__c
            FROM Case
            WHERE ConversationID__c IN :conversationIdToEmailsMessages.keySet()
        ]) {
            conversationIdToCase.put(caseItem.ConversationID__c, caseItem);
            owners.add(caseItem.OwnerId);
        }

        for (User userItem : [
            SELECT Id, IsActive
            FROM User
            WHERE Profile.Name = 'SC Agent'
            AND Id IN : owners
        ]) {
            if (!userItem.IsActive) {
                owners.remove(userItem.Id);
            }
        }

        linkEmailMessagesToCases(conversationIdToEmailsMessages, conversationIdToCase.values());
        assignNutmailToNewCase(conversationIdToNutmails);
        if(!conversationIdToEmailsMessages.isEmpty()){
            reopenCase(conversationIdToEmailsMessages, owners);

        }

        if (!conversationIdToCase.isEmpty()) {
            List<Case> casesToUpdate = (List<Case>) conversationIdToCase.values();
            upsert casesToUpdate;

            if (!senderUuidToAccount.isEmpty()) {
                insertTasks(conversationIdToNutmails, casesToUpdate);
            }

            linkEmailMessagesToCases(conversationIdToNutmails, casesToUpdate);
        }

        populatePAForSystemMsg(conversationIdToEmailsMessages);

    }

    private static void populatePAForSystemMsg(Map<String, List<EmailMessage>> conversationIdToEmails) {
        for (String conversationId : conversationIdToEmails.keyset()) {
            for (EmailMessage emailItem : conversationIdToEmails.get(conversationId)) {
                Account currentAcc = senderUuidToAccount.get(emailItem.Related_User_UUID__c);

                if (emailItem.Is_Activity__c && currentAcc != null) {
                    emailItem.RelatedToId = currentAcc.Id;
                }
            }
        }
    }

    private static void assignNutmailToNewCase(Map<String, List<EmailMessage>> conversationIdToNutmails) {
        for (String conversationId : conversationIdToNutmails.keySet()) {
            List<EmailMessage> emailMessagesForCurrentCase = conversationIdToNutmails.get(conversationId);

            if (emailMessagesForCurrentCase[0].Is_Activity__c) {
                continue;
            }

            if (!conversationIdToCase.containsKey(conversationId)) {
                conversationIdToCase.put(
                    conversationId,
                    createNewCase(conversationId, emailMessagesForCurrentCase)
                );
            }
        }
    }

    private static Case createNewCase(String conversationId, List<EmailMessage> emailMessagesForCurrentCase) {
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
                }
            }
        }
    }

    private static void insertTasks(Map<String, List<EmailMessage>> conversationIdToEmails, List<Case> cases) {
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

    private static void reopenCase(Map<String, List<EmailMessage>> conversationIdToEmails, Set<Id> activeOwners) {
        for (Case caseItem : conversationIdToCase.values()) {
            if (caseItem.Status != CASE_CLOSED_STATUS) {
                continue;
            }

            List<EmailMessage> emailMessagesForCurrentCase = conversationIdToEmails.get(caseItem.ConversationID__c);
            System.debug(LoggingLevel.info, 'rodri emailMessagesForCurrentCase conversationIdToEmails ' + conversationIdToEmails);
            System.debug(LoggingLevel.info, 'rodri emailMessagesForCurrentCase case ' + emailMessagesForCurrentCase);
            System.debug(LoggingLevel.info, 'rodri emailMessagesForCurrentCase activity ' + emailMessagesForCurrentCase[0].Is_Activity__c);
            
            if (!emailMessagesForCurrentCase.isEmpty() && emailMessagesForCurrentCase[0].Is_Activity__c) {
                continue;
            }

            caseItem.OwnerId = activeOwners.contains(caseItem.OwnerId) ? caseItem.OwnerId : CASE_QUEUE_ID;
            caseItem.Status = CASE_OPEN_STATUS;
            caseItem.Re_opened_Case__c = true;
        }
    }

    public static void afterInsert(Set<id> emailMessagesId) {
        List<SLA_Metrics__c> metrics = new List<SLA_Metrics__c>();
        List<String> toAddressBanned = new List<String>{'pensionops@nutmeg.com','nutmeg@hornbuckle.co.uk','alerts@nutmeg.com','noreply.notifications@trustpilot.com','cma@nutmeg.com'};
        List<String> fromAddressBanned = new List<String>{'no-reply@nutmeg.com','pensionops@nutmeg.com','nutmeg@hornbuckle.co.uk','alerts@nutmeg.com','noreply.notifications@trustpilot.com'};

        set<id> casesId = new set<id>();
        System.debug(LoggingLevel.info,  'Rodri entre metrica' + emailMessagesId);
        List<EmailMessage> emailMessages = [Select id ,parentId , Nutmail_Message__c, Created_At__c  , ToAddress , fromAddress , Incoming, status From EmailMessage where id in:emailMessagesId];
        for(EmailMessage e :emailMessages ){
            System.debug(LoggingLevel.info,  'rodri parentId ' + e.parentId);
            System.debug(LoggingLevel.info,  'rodri status ' + e.status);
            SLA_Metrics__c m = new SLA_Metrics__c();
            if( e.toAddress != null && (e.parentId != null && !toAddressBanned.contains(e.toAddress) && !fromAddressBanned.contains(e.fromAddress)
             && (e.toAddress != 'support@nutmeg.com'  ) &&  !e.toAddress.contains('@nutmeg.com')
             && e.Nutmail_Message__c)){
                m.User__c= Userinfo.getuserid();
                m.Case__c = e.parentId;
                m.Type__c = 'Nutmail';
                if(e.Created_At__c != null ){
                    m.Received_date__c = System.now();
                }else{
                    m.Outbound__c =true;
                    m.Response_date__c = System.now();
                }
                metrics.add(m);

                    System.debug(LoggingLevel.info,  'Rodri metrics' + m );
            }else if(e.toAddress != null && (e.parentId != null && !toAddressBanned.contains(e.toAddress) && !fromAddressBanned.contains(e.fromAddress)
            && (e.toAddress != 'support@nutmeg.com'  ) &&  !e.toAddress.contains('@nutmeg.com') 
            && !e.Nutmail_Message__c && e.Incoming)){
                m.User__c= Userinfo.getuserid();
                m.Case__c = e.parentId;
                m.Type__c = 'Email'; 
                m.Outbound__c =false;
                m.Received_date__c = System.now();
                metrics.add(m);
            }else if( e.toAddress != null && (e.parentId != null && !toAddressBanned.contains(e.toAddress) && !fromAddressBanned.contains(e.fromAddress)
            && (e.toAddress != 'support@nutmeg.com' ) &&  !e.toAddress.contains('@nutmeg.com')
            && !e.Nutmail_Message__c && e.status == '3' && !e.Incoming)){
                m.User__c= Userinfo.getuserid();
                m.Case__c = e.parentId;
                m.Type__c = 'Email'; 
                m.Outbound__c =true;
                m.Response_date__c = System.now();

                metrics.add(m);
            }

        }
        if(!metrics.isEmpty()){
            insert metrics;

        }
        
    }

    public static void afterUpdate(Set<id> emailMessagesId) {
        List<SLA_Metrics__c> metrics = new List<SLA_Metrics__c>();
        List<String> toAddressBanned = new List<String>{'pensionops@nutmeg.com','nutmeg@hornbuckle.co.uk','alerts@nutmeg.com','noreply.notifications@trustpilot.com','cma@nutmeg.com'};
        List<String> fromAddressBanned = new List<String>{'no-reply@nutmeg.com','pensionops@nutmeg.com','nutmeg@hornbuckle.co.uk','alerts@nutmeg.com','noreply.notifications@trustpilot.com'};

        set<id> casesId = new set<id>();
        System.debug(LoggingLevel.info,  'Rodri entre metrica' + emailMessagesId);
        List<EmailMessage> emailMessages = [Select id ,parentId , Nutmail_Message__c, Created_At__c  , ToAddress , fromAddress , Incoming, status From EmailMessage where id in:emailMessagesId];
        for(EmailMessage e :emailMessages ){
            System.debug(LoggingLevel.info,  'rodri parentId ' + e.parentId);
            System.debug(LoggingLevel.info,  'rodri status ' + e.status);
            if( e.toAddress != null && (e.parentId != null && !toAddressBanned.contains(e.toAddress) && !fromAddressBanned.contains(e.fromAddress)
             && (e.toAddress != 'support@nutmeg.com' ) &&  !e.toAddress.contains('@nutmeg.com')
             && !e.Nutmail_Message__c && e.status == '3')){
                    SLA_Metrics__c m = new SLA_Metrics__c();
                m.User__c= Userinfo.getuserid();
                m.Case__c = e.parentId;
                m.Type__c = 'Email'; 
                if(!e.Incoming){ 
                    m.Outbound__c =true;
                    m.Response_date__c = System.now();
                }
                
                 
                metrics.add(m);
                System.debug(LoggingLevel.info,  'Rodri metrics' + m );
            }

        }
        if(!metrics.isEmpty()){
            insert metrics;

        }        
    }
}



            /**
             * 
             * 
             * 
             * Generar SLA metric original cuando se crea el caso. Field nuevo generate_case (true or false), agrego date
             * Solo para casos generados por distintos medios q no sean EMAIL o NUTMAIL ( Chat, Mobile, Call)
             * CUIDADO con auto respuestas de EMAIL (no pasa con nutmail)
             *
             * 
             * ToAddress = support@nutmeg.com y fromaAddress = support@nutmeg.com ???
FromAddress	
                ToAddress = "noreply.notifications@trustpilot.com" y fromaAddress = "noreply.notifications@trustpilot.com" ???

ToAddress = alerts@nutmeg.com o fromaAddress = alerts@nutmeg.com ???
ToAddress = pensionops@nutmeg.com o fromaAddress = pensionops@nutmeg.com ???
ToAddress = nutmeg@hornbuckle.co.uk o fromaAddress = nutmeg@hornbuckle.co.uk ???


fromaAddress = no-reply@nutmeg.com NO cuenta/ Automaticos --> NO hago nada
             *  CHAT TRANSCRIPT EXAMPLE https://nutmegaccount.my.salesforce.com/5704J000001toJC
             * 
             * Para origin CHAT suele no haber segundo contacto, o puede haber un mail, hay q esperar.A veces envian mail manuak con ek trabscript
             * Origin --> Email. Que hago? https://nutmegaccount.my.salesforce.com/5004J00000GutwD
             * 
             * https://nutmegaccount.my.salesforce.com/5004J00000Guvrt
             * 
             * q onda esto? de support a support? genera el caso? https://nutmegaccount.my.salesforce.com/5004J00000Gutw8
             * 
             * Podria aca trackear interacciones con el usuario ( NO USAR EMAIL DE LA EMPRESA)  Pero, desde el trigger de case, generar el primer registro si se esta insertando el caso 
             * y el email es uno de esos tipo support@nutmeg.com to support@nutmeg.com --> SON EMAIL
             * 
             * 
             * caso de error? conversacion entre hornbuckle y nutmeg
             * 
             * Que hacer con este? caso creado a mano y mails al usuario? que trackeamos? como lo hacemos?
             * 
             * Si es support tu suppor en el trigger trigger case, creo el primer registro
             * si es support to support email message no hago nada, logica para no hacer nada
             * si es de no reply, email message no hago nada
             * si es to algun mail interno (alerts@nutmeg.com  ) no hago nada
             * si es desde algun mail interno (alerts@nutmeg.com  ) no hago nada ? 
             * email funciona income
             * nutmail - usar created at, para diferenciar income the outbound
             * 
             */
