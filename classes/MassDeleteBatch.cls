global class MassDeleteBatch implements Database.Batchable<sObject> {

    String query = 'SELECT Id FROM LiveChatTranscript';// WHERE CreatedDate < TODAY';

    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext bc, List<LiveChatTranscript> scope) {
        delete scope;
    }

    global void finish(Database.BatchableContext bc) {}
}