/**********************************************************************
Purpose:

Class related to SendNutmail Flow. Provides the
possibility to change Email_Body with Nutmail
Template.
======================================================
Test class:

Test_SendNutmailFlowCtrl
======================================================
History
-------
Date        AUTHOR                  DETAIL
23/01/2020  Kseniya Hanchuk         MASQ-822: Initial version
***********************************************************************/

public with sharing class SendNutmailFlowCtrl {

    public enum StatusCode { SUCCESS, ERROR, FILE_DELETED }
    public static String subject{get;set;}

//    public static final Integer         FILE_SIZE_LIMIT                 = 104857600;
    public static final Integer         FILE_SIZE_LIMIT                 = 102400000;

    public static final String          NUTMAIL_FOLDER_NAME             = 'Nutmail Templates';
    public static final String          NUTMAIL_DEFAULT_TEMPLATE_NAME   = 'Default';
    public static final String
    STATUS_SUCCESS = 'SUCCESS',
    STATUS_ERROR = 'ERROR';
    public static final List<String>    NUTMAIL_TEMPLATES_TYPE          = new List<String> {
        'text'
    };

    public static final Folder NUTMAIL_FOLDER = [
        SELECT
            Id
        FROM Folder
        WHERE Name = :NUTMAIL_FOLDER_NAME
    ];

    @AuraEnabled
    public static String deleteNutmailAttachment(String attachmentId) {
        ContentDocument cd = new ContentDocument();
        cd.Id = attachmentId;

        try {
            delete cd;
        } catch (Exception e) {
            return e.getMessage();
        }

        return 'SUCCESS';
    }

    @AuraEnabled
    public static String getCaseSubject(String caseId) {
        Case c = [ SELECT  Id, subject  FROM Case   WHERE Id = :caseId LIMIT 1  ];
        subject = c.subject;
        System.debug(LoggingLevel.INFO , 'Rodri case Subject ' + c.Subject);
        if(c.subject != null){
            return c.subject;
        }else{
            return 'SUCCESS';
        }

        
    }

    @AuraEnabled
    public static String markAsNutmailAttachment(String attachmentId) {
        ContentDocument cd = [
            SELECT
                Id,
                LatestPublishedVersionId
            FROM ContentDocument
            WHERE Id = :attachmentId
            LIMIT 1
        ];

        ContentVersion cv = new ContentVersion();
        cv.Id = cd.LatestPublishedVersionId;
        cv.Nutmail_Attachment__c = true;

        try {
            update cv;
        } catch (Exception e) {
            delete cd;
            return e.getMessage();
        }

        return 'SUCCESS';
    }

    @AuraEnabled
    public static NutmailResponse sendNutmailApi(String attachmentId, String subject, String emailBody, String caseId) {
        String msgId = '';
        String jsonTosend ='';
        Boolean single = true;
        SendSingleNutmailResponse singleResponse;
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        System.debug(LoggingLevel.info , 'rodri subject ' + subject );

        Boolean isSandbox = [SELECT IsSandbox FROM Organization].IsSandbox;

        Case c = [ SELECT  Id, AccountId ,  Account.User_UUID__c,   Account.Nutmail_Address__pc, ConversationID__c  FROM Case   WHERE Id = :caseId LIMIT 1  ];
        
        if(c.AccountId == null){
            System.debug(LoggingLevel.info , 'rodri entre ' );

            return new NutmailResponse(
                null, 
                StatusCode.ERROR,
                'There is no Account associated to the case. Please add a valid account to the case. '
            );
        }else   if(c.Account.User_UUID__c == null || c.Account.User_UUID__c == ''){
            System.debug(LoggingLevel.info , 'rodri entre ' + c.Account.User_UUID__c);
            return new NutmailResponse(
                null, 
                StatusCode.ERROR,
                'User UuId is mandatory. Please check if there is an account with a valid UuId associated to the case.'
            );
        }

        if(c.Account.User_UUID__c == null || c.Account.User_UUID__c == ''){
            System.debug(LoggingLevel.info , 'rodri entre ' + c.Account.User_UUID__c);
            return new NutmailResponse(
                null, 
                StatusCode.ERROR,
                'User UuId is mandatory. Please check if there is an account with a valid UuId associated to the case.'
            );
        }
        

        if(c.ConversationID__c == null || c.ConversationID__c == ''){
            return new NutmailResponse(
                null, 
                StatusCode.ERROR,
                'Conversation Id is mandatory. Please check if there is a Conversation Id associated to the case.'
            );
        }

        if(subject == null || subject == ''){
            return new NutmailResponse(
                null, 
                StatusCode.ERROR,
                'Subject is mandatory. Please enter a valid value and try again.'
            );
        }

        if(attachmentId != null && attachmentId != ''){
            single =false;
            ContentDocument cd = [
                SELECT
                    Id,
                    ParentId,
                    FileExtension,
                    FileType,
                    Title,
                    ContentSize,
                    LatestPublishedVersion.ContentSize,
                    LatestPublishedVersion.FirstPublishLocationId,
                    LatestPublishedVersionId
                FROM ContentDocument
                WHERE Id = :attachmentId
                LIMIT 1
            ];
            ContentVersion cont = [SELECT Id , versionData from ContentVersion where ContentDocumentId =:cd.id];
           //https://www.biswajeetsamal.com/blog/tag/contentversion/

            // VersionData es lo q tengo q pasar a base 64, y ojala sirva
            System.debug(LoggingLevel.INFO, 'attchment id: ' + attachmentId);
            System.debug(LoggingLevel.INFO, 'versionData id: ' + cont.versionData);
            System.debug(LoggingLevel.INFO, 'ParentId id: ' + cd.id);
            System.debug(LoggingLevel.INFO, 'subject id: ' +subject);

            String fileName = cd.Title;
            fileName = fileName.replaceAll(' ', '-');
           // System.debug(LoggingLevel.INFO, 'fileName id: ' +fileName);

            if (cd.ContentSize > FILE_SIZE_LIMIT) {
                delete cd;

                return new NutmailResponse(
                    null,
                    StatusCode.FILE_DELETED,
                    'Fail is too big and has been deleted'
                );
            }

            if (cd.LatestPublishedVersion.FirstPublishLocationId == null
                || cd.LatestPublishedVersion.FirstPublishLocationId.getSobjectType() != Schema.Case.SObjectType
            ) {
                return new NutmailResponse(null, StatusCode.ERROR, '');
            }
            //System.debug(LoggingLevel.INFO, 'subject id: ' +subject);

            NutmailRequestBody nrb = new NutmailRequestBody();  
            nrb.sendNotification    = 'true';
            nrb.emailMessageType    = 'customMessageType';
            nrb.userUuid            = c.Account.User_UUID__c;
            nrb.subject             = subject;
            nrb.message             = emailBody;
            nrb.fileExt            = cd.FileExtension;
            nrb.fileName            = fileName;
            nrb.conversationId            = c.ConversationID__c;
            nrb.base64EncodedFile = EncodingUtil.base64Encode(cont.versionData);
            //System.debug(LoggingLevel.INFO, 'base64EncodedFile id: ' +  nrb.base64EncodedFile);

            jsonTosend = JSON.serialize(nrb);

            if(isSandbox){
                req.setEndpoint('https://api.dev.nutmeg.co.uk/nutmail-with-file');
    
            }else{
                req.setEndpoint('https://api.nutmeg.com/nutmail-with-file'); 
                
            }
        }else{
            if(isSandbox){
                req.setEndpoint('https://api.dev.nutmeg.co.uk/send-nutmail-with-response');
    
            }else{
                req.setEndpoint('https://api.nutmeg.com/send-nutmail-with-response'); 
                 
            }
            NutmailWithOutAttachmentRequestBody nrb = new NutmailWithOutAttachmentRequestBody();  
            nrb.sendNotification    = 'true';
            nrb.emailMessageType    = 'customMessageType';
            nrb.userUuid            = c.Account.User_UUID__c;
            nrb.subject             = subject;
            nrb.body             = emailBody;
            nrb.conversationId            = c.ConversationID__c;
            jsonTosend = JSON.serialize(nrb);

        } 

        jsonTosend = '{"parameters": '+jsonTosend+'}';
        system.debug(LoggingLevel.INFO , 'info c.ConversationID__c : ' + c.ConversationID__c);
        system.debug(LoggingLevel.INFO , 'info rodri : ' + jsonTosend);

        req.setBody(jsonTosend); 

        Token__c cts = Token__c.getOrgDefaults();

        if (String.isBlank(cts.Nutmeg_API_Token__c)) {
            return new NutmailResponse(
                null, 
                StatusCode.ERROR,
                'Request cannot be processed. The token is empty. Please, contact your system administrator'
            );
        }

        String authorizationHeader = 'Bearer ' + cts.Nutmeg_API_Token__c + cts.Nutmeg_API_Token_Two__c + cts.Nutmeg_API_Token_Three__c ;
       

        req.setHeader('Authorization',  authorizationHeader);
        req.setHeader('Content-Type', 'application/json');

        system.debug(LoggingLevel.INFO , 'header : ' + req.getHeader('Authorization'));

        Http http = new Http();
        HttpResponse res = http.send(req);
        system.debug(LoggingLevel.INFO , 'rta : ' + res.getBody());


        if (res.getStatusCode() != 200) {
            logCalloutResult(req,res,caseId);
            
            return new NutmailResponse(
                null, 
                StatusCode.ERROR,
                'An error occurred while trying to send the email. Try again!'
            );
        }
        if(single){
            singleResponse = (SendSingleNutmailResponse)JSON.deserialize(res.getBody(), SendSingleNutmailResponse.class);
           // System.debug(LoggingLevel.info, 'rodri rta single ' +singleResponse) ;
            msgId = singleResponse.messageId;

       }else{
           if(!Test.isRunningTest()){
            singleResponse = (SendSingleNutmailResponse)JSON.deserialize(res.getBody(), SendSingleNutmailResponse.class);
            msgId = singleResponse.messageId;
           }

       }
            insertEmailMessage(  msgId, c.Account.User_UUID__c,  caseId ,  subject,  emailBody, c.ConversationID__c, c.Account.Nutmail_Address__pc  );
           
            DateTime start = System.Now();

          //  while(System.Now().getTime()< start.getTime()+5000){} 
            return new NutmailResponse(res.getStatusCode(), StatusCode.SUCCESS, 'Email sent!');
            //        logCalloutResult(req,res,caseId);

        
    } 

    private static void insertEmailMessage(String msgId, String userUUId, String caseId , String subject, String body, String converstationId, String toAddress){
        System.debug(LoggingLevel.info, 'rodriemailItem.converstationId  ' + converstationId);


        EmailMessage emailMsg = new EmailMessage(
            Related_User_UUID__c = userUUId,
            FromName = 'nutmail@nutmail.nutmeg.co.uk',
            MessageDate = System.now(),
            RelatedToId =caseId,
            Subject = subject,
            Reason__c =subject,
            TextBody = body,
            ToAddress =toAddress ,
            Nutmail_Message__c = true,
            Message_id__c = msgId,
            ConversationID__c = converstationId,
            State__c = 'sent'
        );

        insert emailMsg;
       

    }
    /**
     * 
     * 
     * 
     *     private static void updateEmailMessage(String msgId, String userUUId, String caseId , String subject, String body, String converstationId, String toAddress){
        DateTime start = System.Now();

        while(System.Now().getTime()< start.getTime()+2500){} 
        EmailMessage emailMsg = [select id, TextBody, subject, MessageID__c, Message_id__c, ConversationID__c, Nutmail_Message__c ,
                                 Incoming , Related_User_UUID__c ,FromAddress, CreatedDate from EmailMessage where ParentId =:caseId order by createddate desc limit 1];

        emailMsg.Related_User_UUID__c = userUUId;
        FromName = 'nutmail@nutmail.nutmeg.co.uk'
        MessageDate = System.now();
        RelatedToId =caseId
        Subject = subject
        TextBody = body
        ToAddress =toAddress 
        emailMsg.Nutmail_Message__c = true;
        emailMsg.Message_id__c = msgId;
        emailMsg.ConversationID__c = converstationId;
        emailMsg.State__c = 'sent';

        update emailMsg;
        system.debug(LoggingLevel.info, 'rodri:  ' + emailMsg.id);
        system.debug(LoggingLevel.info, 'rodri msgId:  ' + msgId);
        system.debug(LoggingLevel.info, 'rodri userUUId:  ' + userUUId);
        system.debug(LoggingLevel.info, 'rodri pareconverstationIdntId:  ' + converstationId);


    }/ */

    public static void logCalloutResult(HttpRequest request, HttpResponse response, Id caseId) {
        system.debug(LoggingLevel.info, 'log error:  '  );

        Service_Log__c serviceLog = new Service_Log__c();
        serviceLog.EndpointURL__c = request.getEndpoint();
        serviceLog.Request__c = request.getBody();
        serviceLog.Response__c = response.getBody();
        serviceLog.Status__c = response.getStatusCode() == 200 ? STATUS_SUCCESS : STATUS_ERROR;
        serviceLog.StatusCode__c = response.getStatusCode();
        serviceLog.StatusMessage__c = response.getStatus();
        serviceLog.Case__c = caseId ;
        system.debug(LoggingLevel.info, 'log error:  ' + serviceLog);

        insert serviceLog;
        
    }
 
    @AuraEnabled 
    public static String getEmailTemplates(String caseId) {
        Response res = new Response();
        res.defaultTemplate = getDefaultEmailTemplate(caseId);

        List<EmailTemplate> emailTmpList = [
            SELECT Id, Name, Subject, Body
            FROM EmailTemplate
            WHERE IsActive = TRUE
                AND FolderId = :NUTMAIL_FOLDER.Id
                AND TemplateType IN :NUTMAIL_TEMPLATES_TYPE
                AND Name != :NUTMAIL_DEFAULT_TEMPLATE_NAME
            ORDER BY Name
            LIMIT 1000
        ];

        if (emailTmpList.isEmpty()) {
            res.status = StatusCode.ERROR;
        } else {
            res.status = StatusCode.SUCCESS;
            res.templates       = new List<EmailTemplateWrapper>();
            res.templatesMap    = new Map<Id, EmailTemplateWrapper>();

            for (EmailTemplate emailTmpItem : emailTmpList) {
                EmailTemplateWrapper newETW = new EmailTemplateWrapper();

                newETW.emailTemplateId      = emailTmpItem.Id;
                newETW.emailTemplateName    = emailTmpItem.Name;
                newETW.emailSubject         = emailTmpItem.Subject;
                newETW.emailBody            = getRenderedBodyString(caseId, emailTmpItem.Body, emailTmpItem.Id);

                res.templates.add(newETW);
                res.templatesMap.put(emailTmpItem.Id, newETW);
            }
        }

        return JSON.serialize(res);

    }

 
    private static EmailTemplateWrapper getDefaultEmailTemplate(String caseId) {
        EmailTemplateWrapper defaultTemplate = new EmailTemplateWrapper();

        EmailTemplate defaultET = [
            SELECT Id, Name, Subject, Body
            FROM EmailTemplate
            WHERE IsActive = TRUE
            AND FolderId = :NUTMAIL_FOLDER.Id
            AND TemplateType IN :NUTMAIL_TEMPLATES_TYPE
            AND Name = :NUTMAIL_DEFAULT_TEMPLATE_NAME
            LIMIT 1
        ];

        if (defaultET != null) {
            defaultTemplate.emailTemplateId = defaultET.Id;
            defaultTemplate.emailTemplateName = defaultET.Name;
            defaultTemplate.emailSubject = defaultET.Subject;
            defaultTemplate.emailBody = getRenderedBodyString(caseId, defaultET.Body, defaultET.Id);
        }

        return defaultTemplate;

    }

    private static String getRenderedBodyString(String caseId, String body, String templateId) {
        try {
            List<Messaging.RenderEmailTemplateBodyResult> renderedTmp =
                Messaging.renderEmailTemplate(null, caseId, new List<String>{ body });
            
            return renderedTmp[0].getMergedBody();
        } catch (Exception e) {
            try {
                Messaging.SingleEmailMessage renderedTmp =
                    Messaging.renderStoredEmailTemplate(templateId, null, caseId);

                return renderedTmp.getPlainTextBody();
            } catch (Exception ex) {
                return null;
            }
        }

    }


    public class NutmailRequestBody {
        public String  sendNotification     { get; set; }
        public String   emailMessageType    { get; set; }
        public String   userUuid            { get; set; }
        public String   subject             { get; set; }
        public String   message             { get; set; }
        public String   fileName            { get; set; }
        public String   fileExt             { get; set; }
        public String base64EncodedFile     { get; set;}
        public String conversationId     { get; set;}
    }
    public class NutmailWithOutAttachmentRequestBody {
        public String   subject             { get; set; }
        public String   userUuid            { get; set; }
        public String   sendNotification    { get; set; }
        public String   body                { get; set; }
        public String   emailMessageType    { get; set; }
        public String conversationId     { get; set;}


    }
    public class SendSingleNutmailResponse{
        public string messageId{get;set;}
    }
    public class Response {
        @AuraEnabled public StatusCode                      status          { get; set; }
        @AuraEnabled public List<EmailTemplateWrapper>      templates       { get; set; }
        @AuraEnabled public Map<Id, EmailTemplateWrapper>   templatesMap    { get; set; }
        @AuraEnabled public EmailTemplateWrapper            defaultTemplate { get; set; }
    }

    public class NutmailResponse {
        @AuraEnabled public Integer     statusCode  { get; set; }
        @AuraEnabled public String      status      { get; set; }
        @AuraEnabled public String      message     { get; set; }

        NutmailResponse(Integer statusCode, StatusCode status, String message) {
            this.statusCode = statusCode;
            this.status     = String.valueOf(status);
            this.message    = message;
        }
    }

    public class EmailTemplateWrapper {
        @AuraEnabled public String emailTemplateId      { get; set; }
        @AuraEnabled public String emailTemplateName    { get; set; }
        @AuraEnabled public String emailSubject         { get; set; }
        @AuraEnabled public String emailBody            { get; set; }

    }

}