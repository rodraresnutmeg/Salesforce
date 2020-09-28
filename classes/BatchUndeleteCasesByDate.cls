global class BatchUndeleteCasesByDate implements Database.Batchable<SObject>, Database.Stateful {

    private Date startDate = Date.newInstance(2020, 4, 15);

    String query = '' +
        'SELECT Id ' +
        'FROM Case ' +
        'WHERE LastModifiedDate > :startDate AND isDeleted = TRUE ' +
        'ALL ROWS';

    global BatchUndeleteCasesByDate() {}

    global BatchUndeleteCasesByDate(Date startDate) {
        this.startDate = startDate;
    }

    global Database.QueryLocator start(Database.BatchableContext bc) {
        System.debug('Query to perform: ' + this.query);
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext bc, List<Case> scope) {
        System.debug('Batch');
        System.debug(scope);
        undelete scope;
    }

    global void finish(Database.BatchableContext bc) {
    }

}