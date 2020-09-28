global class BatchDeleteNutmailAttachments implements Database.Batchable<SObject>, Database.Stateful, Schedulable {

    String query = '' +
        'SELECT Id, ContentDocumentId ' +
        'FROM ContentVersion ' +
        'WHERE Nutmail_Attachment__c = TRUE';

    global BatchDeleteNutmailAttachments() {}

    public void execute(SchedulableContext ctx) {
        Database.executeBatch(new BatchDeleteNutmailAttachments(), 500);
    }

    global Database.QueryLocator start(Database.BatchableContext bc) {
        System.debug('Query to perform: ' + this.query);

        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext bc, List<ContentVersion> scope) {
        Set<Id> contentDocumentIds = new Set<Id>();

        for (ContentVersion cv : scope) {
            contentDocumentIds.add(cv.ContentDocumentId);
        }

        List<ContentDocument> cdList = [
            SELECT
                Id
            FROM ContentDocument
            WHERE Id IN :contentDocumentIds
        ];

        delete cdList;
    }

    global void finish(Database.BatchableContext bc) {}

}