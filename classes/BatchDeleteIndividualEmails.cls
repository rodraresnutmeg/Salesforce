global class BatchDeleteIndividualEmails implements Database.Batchable<sobject>{
    set<Id> emailsToDelete {get;set;}

    
    public BatchDeleteIndividualEmails () {
        emailsToDelete = new set<id>();

    }

    global database.QueryLocator start(Database.BatchableContext bc){
        Date flag = Date.today().addDays(-182);

        String status = 'succeeded';
        String query ='Select id from et4ae5__IndividualEmailResult__c where CreatedDate <=:flag limit 49000';
		System.debug(LoggingLevel.INFO, '### acaaaa...');

        return database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext bc, list<et4ae5__IndividualEmailResult__c> scope){
        list<et4ae5__IndividualEmailResult__c> listToDelete = new list<et4ae5__IndividualEmailResult__c>();
        System.debug(LoggingLevel.INFO, 'rodri  2' + scope);

        for(et4ae5__IndividualEmailResult__c e: scope) {

            listToDelete.add(e);
        } 
        
        if(!listToDelete.isEmpty()){
            delete listToDelete;
 
        }
    } 


    
    global void finish(Database.BatchableContext bc){ 
        
    }
    public static void startBatch(){
		System.debug(LoggingLevel.INFO, '### Iniciando Cron Batch Apex... et4ae5__IndividualEmailResult__c');

		BatchDeleteIndividualEmails batch = new BatchDeleteIndividualEmails();
		Id batchId = Database.executeBatch(batch, 2000);
				
		System.Debug(LoggingLevel.INFO, '>>> done! Batch ' + batchId + ' STARTED.'); 
	} 

}