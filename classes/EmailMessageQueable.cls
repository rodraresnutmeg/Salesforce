public with sharing class EmailMessageQueable implements Queueable{
    String msgId;
    String userUUId; 
    String caseId ;
    String subject; 
    String body;
    String converstationId;
    public EmailMessageQueable (String msgId, String userUUId, String caseId , String subject, String body, String converstationId) {
        this.msgId = msgId;
        this.userUUId = userUUId;
        this.caseId = caseId;
        this.subject = subject;
        this.body = body;
        this.converstationId = converstationId;
    }
    
    public void execute(QueueableContext context) {
        DateTime start = System.Now();

        while(System.Now().getTime()< start.getTime()+2000){} 
            EmailMessage emailMsg = [select id, TextBody, subject, MessageID__c, Message_id__c, ConversationID__c, Nutmail_Message__c ,
                                     Incoming , Related_User_UUID__c , CreatedDate from EmailMessage where ParentId =:caseId order by createddate desc limit 1];
    
            emailMsg.Related_User_UUID__c = userUUId;
            emailMsg.Nutmail_Message__c = true;
            emailMsg.Message_id__c = msgId;
            emailMsg.ConversationID__c = converstationId;
            emailMsg.State__c = 'sent';
    
            //update emailMsg;
            system.debug(LoggingLevel.info, 'rodri:  ' + emailMsg.id);
            system.debug(LoggingLevel.info, 'rodri msgId:  ' + msgId);
            system.debug(LoggingLevel.info, 'rodri userUUId:  ' + userUUId);
            system.debug(LoggingLevel.info, 'rodri pareconverstationIdntId:  ' + converstationId);

    }
}