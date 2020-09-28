public with sharing class GDPR_SendPDF {

    @AuraEnabled
    public static void send(String recordId) {
        sendEmail(new List<Id>{ (Id) recordId });
    }

    @InvocableMethod
    public static void sendEmail(List<Id> lstId) {
        Id recordId = lstId.get(0);
        Account acc = [
            SELECT Id, Custom_Email__pc
            FROM Account
            WHERE Id = :recordId
            LIMIT 1
        ];
        List<String> emailIds = new List<String>{ acc.Custom_Email__pc };

        PageReference ref = new PageReference('/apex/PDF_CustomerDataGDPR?Id=' + recordId);
        Blob b = ref.getContentAsPDF();
        
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();

        Messaging.EmailFileAttachment efa1 = new Messaging.EmailFileAttachment();
        efa1.setFileName('attachment_BPA.pdf');
        efa1.setBody(b);

        String addresses;
        email.setSubject('GDPR PDF' + String.valueOf(DateTime.now()));
        email.setToAddresses(emailIds);
        email.setPlainTextBody('Hey there, Thank you for Joining the Network!');
        email.setFileAttachments(new Messaging.EmailFileAttachment[] {efa1});
        Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});

    }

}