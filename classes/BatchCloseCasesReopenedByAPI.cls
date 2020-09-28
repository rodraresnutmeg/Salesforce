global class BatchCloseCasesReopenedByAPI implements Database.Batchable<sObject>, Database.Stateful {

    private static final String CASE_ORIGIN = 'Nutmail';
    private static final String API_USER_ID = '\'' + [SELECT Id FROM User WHERE LastName = 'API USER' LIMIT 1].Id + '\'';

    String  query = 'SELECT Id, IsDeleted, CaseId, CreatedById, CreatedDate, Field, OldValue, NewValue FROM CaseHistory WHERE CreatedDate >= 2020-02-24T17:55:00.000+0000 AND CreatedDate <= 2020-02-24T18:22:00.000+0000 AND CreatedById = {0} AND Field = {1}';

    global BatchCloseCasesReopenedByAPI() {
        if (Test.isRunningTest()) {
            query = 'SELECT Id, IsDeleted, CaseId, CreatedById, CreatedDate, Field, OldValue, NewValue FROM CaseHistory WHERE CreatedDate >= 2020-02-24T17:55:00.000+0000 AND CreatedById = {0} AND Field = {1}';
        }
        this.query = String.format(query, new List<String>{ API_USER_ID, '\'Status\'' });
    }

    global Database.QueryLocator start(Database.BatchableContext bc) {
        System.debug('Query to perform: ' + this.query);
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext bc, List<CaseHistory> scope) {
        List<String> caseIds = new List<String>();
        for (CaseHistory caseHistoryItem : scope) {
            if (caseHistoryItem.OldValue == 'Closed' && caseHistoryItem.NewValue == 'Open') {
                caseIds.add(caseHistoryItem.CaseId);
            }
        }

        List<Case> casesToClose = [SELECT Id, Status FROM Case WHERE Id IN :caseIds AND Origin = :CASE_ORIGIN];

        for (Case caseItem : casesToClose) {
            caseItem.Status = 'Closed';
        }

        update casesToClose;

    }

    global void finish(Database.BatchableContext bc) {
    }

}