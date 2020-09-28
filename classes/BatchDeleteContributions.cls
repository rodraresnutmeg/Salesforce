global class BatchDeleteContributions implements Database.Batchable<sobject>{
    set<Id> contributionsToDelete {get;set;}

    
    public BatchDeleteContributions () {
        contributionsToDelete = new set<id>();

    }

    global database.QueryLocator start(Database.BatchableContext bc){
        Date flag = Date.today().addDays(-21);
        Date flagReconciled = Date.today().addDays(-10);
        String status = 'succeeded';
        String query ='Select id, createdDate, Status__c, Reconciled_date__c from In_Progress_Contributions__c where ((CreatedDate <=:flag ) or (Reconciled_date__c !=null AND Reconciled_date__c <=:flagReconciled and Status__c =:status)) limit 49000';
		System.debug(LoggingLevel.INFO, '### acaaaa...');

        return database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext bc, list<In_Progress_Contributions__c> scope){
        list<In_Progress_Contributions__c> listToDelete = new list<In_Progress_Contributions__c>();
        System.debug(LoggingLevel.INFO, 'rodri  2' + scope);

        for(In_Progress_Contributions__c e: scope) {

            listToDelete.add(e);
        } 
        
        if(!listToDelete.isEmpty()){
            delete listToDelete;

        }
    } 


    
    global void finish(Database.BatchableContext bc){ 
        
    }
    public static void startBatch(){
		System.debug(LoggingLevel.INFO, '### Iniciando Cron Batch Apex...');

		BatchDeleteContributions batch = new BatchDeleteContributions();
		Id batchId = Database.executeBatch(batch, 2000);
				
		System.Debug(LoggingLevel.INFO, '>>> done! Batch ' + batchId + ' STARTED.'); 
	} 

}